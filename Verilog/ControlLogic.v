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
	parameter PhitPerFlit = 2,
	parameter REQUEST_WIDTH = 2)
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
			//After the first flit is received, ready must go down until the route is 
			//reserved for this request.
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
			parameter N = 4,	//Number of nodes in the network
			parameter INDEX = 1,	//This identifies the Node number for Routing Table
			parameter DATA_WIDTH = 8,
			parameter PhitPerFlit = 2,
			parameter REQUEST_WIDTH = 2
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
	input reserveRoute,// Not needed if we are triggering route reserve request as soon as we receive the head flit
	output routeReserveStatus_CFSM,
	output headFlitStatus,
	//To Switch
	output routeReserveRequestValid,
	output[REQUEST_WIDTH - 1 : 0] routeReserveRequest,
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

	HeadFlitDecoder #(.N(N), .INDEX(INDEX), .DATA_WIDTH(DATA_WIDTH), .PhitPerFlit(PhitPerFlit), .REQUEST_WIDTH(REQUEST_WIDTH)) headFlitDecoder
		(
		.HeadFlit(headBuffer),
		.RequestMessage(routeReserveRequest)
		);

	//As soon as valid head flit is received, a request will be sent
	//The request will be valid until it is accepted by the switch and routeReserveStatus is made high
	assign routeReserveRequestValid = headFlitValidStatus;

endmodule


module HeadFlitDecoder #(
			parameter N = 4,	//This is the number of nodes in the network
			parameter INDEX = 1,
			parameter DATA_WIDTH = 8,
			parameter PhitPerFlit = 2,
			parameter REQUEST_WIDTH = 2
			)
	(
	input [PhitPerFlit * DATA_WIDTH - 1 : 0] HeadFlit,
	output [REQUEST_WIDTH - 1 : 0] RequestMessage
	);
	
	//Routing Table declaration:
	//As of now it is just a huge register that will store routing info.
	//It should be implemented as a Memory(DRAM preferably) to reduce resource utilization
	reg [REQUEST_WIDTH * $clog2(N) - 1 : 0] RoutingTable;
	
	integer i;
	initial begin
	//Routing Table needs to be initialized here
		for(i = 0; i < $clog2(N); i = i + 1)
			RoutingTable[i] = 0;//We can populate Routing Table from a file as well
	end
	
	wire [$clog2(N) - 1 : 0] Destination;
	
	assign Destination = HeadFlit[0 +: $clog2(N)];
	
	//Right now, it is completely asynchronous, but when it is made using memory,
	//it will have clock as well and arbitration unit too.
	assign RequestMessage = RoutingTable[REQUEST_WIDTH * Destination +: REQUEST_WIDTH];
	
endmodule


