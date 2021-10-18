//Design for Mesh Based NoC with each switch having 4 Inputs and 4 Outputs
//Switching control logic will be in a separate unit.
module SwitchMatrix
	#(
	parameter N = 4,
	parameter INPUTS = 4,
	parameter OUTPUTS = 4,
	parameter DATA_WIDTH = 8,
	parameter REQUEST_WIDTH = 2
	) 
	
	(
	//Request Signals:
	input [INPUTS - 1] routeReserveRequestValid,
	input [INPUTS * REQUEST_WIDTH - 1 : 0] routeReserveRequest,//This signal selects the input using the first $clog2(N) bits and assigns the output to the last $clog2(N) bit address output.
	input [INPUTS - 1 : 0] routeRelieve,//This bit is used to relieve the path after a transaction is complete, that is, after the tail flit has been received. 
	output [INPUTS - 1]routeReserveStatus,//Acknowledgement signal for routeReserveRequest
	
	//Switch Routing Signal
	output reg [OUTPUTS * $clog2(INPUTS) - 1 : 0]routeSelect = 0 
	);
	
	integer i, j;
	
	reg [OUTPUTS - 1 : 0] outputBusy = 0;//Tells which outputs are currently busy with transaction.
	reg [OUTPUTS - 1 : 0] switchRequest = 0;
	
	reg [INPUTS - 1 : 0] PortBusy = 0;
	reg [INPUTS - 1 : 0] Conflict = 0;
	
//TODO: Handle the situation when two requests come in consecutive clock cycles.
//For this, outputBust has to be made high as soon as we know that the request will reserve the path
//This needs to be done in one clock cycle.
//----------------------------------------Switch Controller FSM begins-----------------------------
	localparam STATE_WIDTH = 2;
	localparam UnRouted = 0, Check = 1, Arbitrate = 2, PathReserved1 = 3, PathReserved0 =4;
	
	//These registers store the FSM states of all the output ports
	reg [STATE_WIDTH * INPUTS : 0] switchState = 0, switchState_next = 0;
	
	//State Transition for all Output Ports
	always @(posedge clk)begin
		for(i = INPUTS - 1; i >= 0; i = i - 1)
			if(rst)
				switchState[i * STATE_WIDTH +: STATE_WIDTH] <= UnRouted;
			else 
				switchState[i * STATE_WIDTH +: STATE_WIDTH] <= switchState_next[i * STATE_WIDTH +: STATE_WIDTH];
	end
	
	//Next state logic for all Output Ports
	always @(*)begin
		for(i = INPUTS - 1; i >= 0; i = i - 1)
			case(switchState[i * STATE_WIDTH +: STATE_WIDTH])
				UnRouted : switchState_next[i * STATE_WIDTH +: STATE_WIDTH] = routeReserveRequestValid[i] ? Check : UnRouted;
				Check : switchState_next[i * STATE_WIDTH +: STATE_WIDTH] = PortBusy[i] ? Check : Conflict[i] ? Arbitrate : PathReserved;
				Arbitrate :  switchState_next[i * STATE_WIDTH +: STATE_WIDTH] = PathReserved1;
				PathReserved1 : switchState_next[i * STATE_WIDTH +: STATE_WIDTH] = PathReserved0;
				PathReserved0 : switchState_next[i * STATE_WIDTH +: STATE_WIDTH] = ~routeRelieve[i] ? PathReserved : outstanding[i] ? Arbitrate : UnRouted;
				default : switchState_next[i * STATE_WIDTH +: STATE_WIDTH] = UnRouted;
			endcase
	end
	
	//Port Busy Signal
	always @(*)
		for(i = INPUTS - 1; i >= 0; i = i - 1)
			PortBusy[i] = outputBusy[routeReserveRequest[i * REQUEST_WIDTH +: REQUEST_WIDTH]];
	
	//Conflict Signal
	//If conflict is high, this means that two inputs are racing for the same output port
	always @(*)
		for(i = INPUTS - 1; i >= 0; i = i - 1)
			Conflict[i] = 1'b0;
			for(j = i; j >= 0; j = j - 1)
				Conflict[i] = Conflict[i] | (routeReserveRequest[j * REQUEST_WIDTH +: REQUEST_WIDTH] == routeReserveRequest[i * REQUEST_WIDTH +: REQUEST_WIDTH])
				
	
	assign routeReserveStatus = switchState == PathReserved1;
	
	always @(posedge clk)begin
		if(rst) 
			outputBusy <= 0;
		else 
		for(i = INPUTS - 1; i >= 0; i = i - 1)begin
			//Input with lower i is given more priority
			if(~outputBusy[i] & switchRequest[i])begin//If the output is not busy and there is a switch request
				outputBusy[i] <= 1;
			end
				
		end
	end
	
endmodule


// Mux based switch design
//This is just a mux with Select lines, Data Inputs and Data Outputs.
//It is the job of Switch Control Logic to do the arbitration and prevent race conditions.

//This module has been designed so that different number of Inputs and outputs are possible.
module MuxSwitch
	#(
	parameter INPUTS = 4,
	parameter OUTPUTS = 4,
	parameter DATA_WIDTH = 8,
	parameter REQUEST_WIDTH = 32
	) 
	
	(
	
	//Routing Signals
	//For each output, there is an input. Other way round may lead to multiple driver on same ports.
	//One to many or Many to one not allowed in MUX
	input [OUTPUTS * $clog2(INPUTS) - 1 : 0] routeSelect,
	
	//Data Input
	input [INPUTS * DATA_WIDTH - 1 : 0] data_in,
	input [INPUTS - 1 : 0] valid_in,
	output reg [INPUTS - 1 : 0] ready_in = 0,
	//Data Output
	output reg [OUTPUTS * DATA_WIDTH - 1 : 0] data_out = 0,
	output reg [OUTPUTS - 1 : 0] valid_out = 0,
	input [OUTPUTS - 1 : 0] ready_out
	);
	
	integer i;

	
	//Direction Encoding for Mesh based switches:
	//0 : North	1 : South	2 : West	3 : East
	
	//Data Mux
	always @(*)begin
		data_out = 0;
		//Lower i inputs will be given prority with this design
		for(i = OUTPUTS - 1; i >= 0; i = i - 1)begin
			data_out[i * DATA_WIDTH +: DATA_WIDTH] = data_in[routeSelect[i * $clog2(INPUTS) +: $clog2(INPUTS)] * DATA_WIDTH +: DATA_WIDTH];
		end
	end
	
	//Valid Mux
	always @(*)begin
		valid_out = 0;
		//Lower i inputs will be given prority with this design
		for(i = OUTPUTS - 1; i >= 0; i = i - 1)begin
			valid_out[i] = valid_in[routeSelect[i * $clog2(INPUTS) +: $clog2(INPUTS)]];
		end
	end
	
	//Ready Mux
	always @(*)begin
		ready_in = 0;
		//Lower i inputs will be given prority with this design
		for(i = INPUTS - 1; i >= 0; i = i - 1)begin
			ready_in[i] = ready_out[routeSelect[i * $clog2(INPUTS) +: $clog2(INPUTS)]];
		end
	end
	
endmodule













