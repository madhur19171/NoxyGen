//Design for Mesh Based NoC with each switch having 4 Inputs and 4 Outputs
//Switching control logic will be in a separate unit.
module ControlLogic
	#(
	parameter N = 4,
	parameter DATA_WIDTH = 8,
	parameter FlitInPacket = 4
	) (
	input clk,
	input rst,
	//Input Controls
	input [N - 1 : 0] valid_in,
	output [N - 1 : 0] ready_in,
	//Output Controls
	output [N - 1 : 0] valid_out,
	input [N - 1 : 0] ready_out,
	//Switch Control
	output [N * $clog2(N) - 1 : 0] sel,//This signal selects the input using the first $clog2(N) bits and assigns the output to the last $clog2(N) bit address output.
	//Buffer State
	output [N - 1 : 0]read_en,
	output [N - 1 : 0]write_en,
	input [N - 1 : 0] buffer_full//Signals that the buffer is full for now so, do not accept data.
	);
	
	//Direction Encoding for Mesh based switches:
	//0 : North	1 : South	2 : West	3 : East
	
	//The protocol will be:
	//The Sender will send a valid signal as soon as its data is ready w/o waiting for ready signal.
	//The receiver will be waiting for the valid signal to become 1. After the valid is 1, sender sends a ready 1.
	//This way the handshake happens and when both valid and ready are 1.
	
	
	genvar i;
	
	generate 
		for(i = 0; i < N; i = i + 1)begin : Handshake
			HandshakeProtocol handshakeProtocol
				(.clk(clk), .rst(rst),
				.valid_in(valid_in[i]), .ready_in(ready_in[i]),
				.valid_out(valid_out[i]), .ready_out(ready_out[i]),
				.read_en(read_en[i]), .write_en(write_en[i]));
		end
	endgenerate
	
endmodule

module ControlFSM
	#(
	parameter FlitPerPacket = 4,//HBBT
	parameter PhitPerFlit = 2)
	(
	input clk,
	input rst,
	
	//Handshake Signals
	input valid_in,
	output ready_in,
	
	output valid_out,
	input ready_out,
	
	//Head Flit Buffer Signals
	output reserveRoute,
	input routeReserveStatus,
	
	output headFlitValid,
	output reg [$clog2(PhitPerFlit) : 0] phitCounter = 0,
	input headFlitStatus,
	
	//FIFO Signals
	output reg popBuffer = 0,
	output pushBuffer,
	output Handshake,
	input full
	);
		
	localparam UnRouted = 0, HeadFlit = 1, ReservePath = 2, Wait = 3, Route = 4, TailFlit = 5;
	
	reg[2 : 0] state = 0, nextState = 0;
	
	reg [$clog2(FlitPerPacket) : 0] flitCounter = 0;
	
	
	wire TailReceived;
	wire Success;
	wire Failure;
	wire PathFree;
	
	reg pushBuffer_state = 0;
	
	
	assign Success = reservePathStatus;
	assign reservePath = state == ReservePath;
	assign route = state == Route;
	
//--------------------------------------Handshake Begins------------------------------

	assign Handshake = valid_in & ready_in;

//--------------------------------------Handshake Ends------------------------------	
	
//--------------------------------------FSM Begins------------------------------
	always @(posedge clk)begin
		if(rst)
			state <= UnRouted;
		else state <= nextState;
	end
	
	always @(*)begin
		case(state)
			UnRouted: nextState = flitValid ? HeadFlit : UnRouted;
			HeadFlit: nextState = ReservePath;
			ReservePath: nextState = Success ? Route : Wait;
			Route: nextState = TailReceived ? TailFlit : Route;
			TailFlit: nextState = UnRouted;
			default: nextState = UnRouted;
		endcase
	end
//--------------------------------------FSM Ends------------------------------


//--------------------------------------PhitCounter Begins------------------------------
	always @(posedge clk)begin
		if(rst)
			phitCounter <= 0;
		else
		if(phitCounter == PhitPerFlit)
			if(valid_in & ready_in)
				phitCounter <= 1;//New incoming phit will be part of new flit
			else phitCounter <= 0;//No new incoming phit so flit counter is 0
		else
		if(valid_in & ready_in)
			phitCounter <= phitCounter + 1;
	end
	
	assign flitValid = phitCounter == PhitPerFlit;
//--------------------------------------PhitCounter Ends------------------------------

//--------------------------------------headFlitValid Begins------------------------------
	//Once headFlit is valid, HFB will ignore any other flits
	//A valid status register will be made high in HFB and it will go low after
	//the tail signal is received.
	assign headFlitValid = state == UnRouted & flitValid & Handshake

//--------------------------------------headFlitValid Ends------------------------------


//--------------------------------------FlitCounter Begins------------------------------
	always @(posedge clk)begin
		if(rst)
			flitCounter <= 0;
		else
		if(flitValid & state == HeadFlit)
			flitCounter <= 1;
		else
		if(flitValid & state == Route)
			flitCounter <= flitCounter + 1;
	end
	
	assign TailReceived = flitCounter == FlitPerPacket;
//--------------------------------------FlitCounter Ends------------------------------


//--------------------------------------pushBuffer Begins------------------------------
	always @(posedge clk)begin
		if(rst)
			pushBuffer_state <= 0;
		else
		if(TailReceived)
			pushBuffer_state = 0;
		else if(state == UnRouted)
			
	end
//--------------------------------------pushBuffer Ends------------------------------


endmodule


module HeadFlitBuffer #(
			parameter DATA_WIDTH = 8,
			parameter PhitPerFlit = 2
			)
	(	
	input clk,
	input rst,
	//From FIFO
	input Handshake,
	input [DATA_WIDTH - 1 : 0] Head_Phit,
	//From Control FSM
	input headFlitValid,
	input [$clog2(PhitPerFlit) : 0] phitCounter,
	input reserveRoute,
	output routeReserveStatus_CFSM,
	output headFlitStatus,
	//To Switch
	output routeReserveRequestValid,
	output routeReserveRequest,
	input routeReserveStatus_Switch
	);
	
	reg [DATA_WIDTH * PhitPerFlit - 1 : 0] headBuffer = 0;
	reg headFlitValidStatus = 0;
	

//--------------------------------------HeadBuffer Begins------------------------------
	always @(posedge clk)begin
		if(rst)
			headBuffer <= 0;
		else 
		if(Handshake & ~headFlitValidStatus & ~headFlitValid)
			headBuffer[DATA_WIDTH * phitCounter +: DATA_WIDTH] <= Head_Phit;
	end
//--------------------------------------HeadBuffer Ends------------------------------

//--------------------------------------HeadFlitValidStatus Begins------------------------------
	always @(posedge clk)begin
		if(rst)
			headFlitValidStatus <= 0;
		else
		if(routeReserveStatus_Switch)
			headFlitValidStatus <= 0;
		else
		if(headFlitValid)
			headFlitValidStatus <= 1;
	end
//--------------------------------------HeadFlitValidStatus Ends------------------------------

//As soon as valid head flit is received, a request will be sent
//The request will be valid until it is accepted by the switch and routeReserveStatus is made high
assign routeReserveRequestValid = headFlitValidStatus;

endmodule
/*

module HandshakeProtocol 
	(
	input clk,
	input rst,
	
	input valid_in,
	output reg ready_in = 0,
	
	output reg valid_out = 0,
	input ready_out,
	
	output reg read_en = 0,
	output reg write_en = 0
	);
	
	localparam EMPTY = 0, FULL = 1, SEND = 2;
	
	reg [1 : 0] state = 0, nextState = 0;
	
	//Next state Assignment
	always @(posedge clk)begin
		if(rst)
			state <= EMPTY;
		else
			state <= nextState;
	end
	
	//Next State Logic
	always @(*)begin
		case(state)
			EMPTY : nextState = valid_in ? FULL : EMPTY;
			FULL : nextState = SEND;
			SEND : nextState = ready_out ? EMPTY : SEND;
			default : nextState = EMPTY;
		endcase
	end
	
	//Output Logic:
	always @(*)begin
		if(state == SEND)
			valid_out = 1;
		else valid_out = 0;
			
		if(state == EMPTY && valid_in == 1)
			ready_in = 1;
		else ready_in = 0;
		
		if(valid_in == 1 && ready_in == 1)
			write_en = 1;
		else write_en = 0;
		
		if(state == FULL)
			read_en = 1;
		else read_en = 0;
	end
	

endmodule
*/
