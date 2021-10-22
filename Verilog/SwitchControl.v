//Design for Mesh Based NoC with each switch having 4 Inputs and 4 Outputs
//Switching control logic will be in a separate unit.
module SwitchControl
	#(
	parameter N = 4,
	parameter INPUTS = 4,
	parameter OUTPUTS = 4,
	parameter DATA_WIDTH = 8,
	parameter REQUEST_WIDTH = 2
	) 
	
	(
	input clk,
	input rst,
	//Request Signals:
	input [INPUTS - 1 : 0] routeReserveRequestValid,
	input [INPUTS * REQUEST_WIDTH - 1 : 0] routeReserveRequest,//This signal selects the input using the first $clog2(N) bits and assigns the output to the last $clog2(N) bit address output.
	input [INPUTS - 1 : 0] routeRelieve,//This bit is used to relieve the path after a transaction is complete, that is, after the tail flit has been received. 
	output reg [INPUTS - 1 : 0]routeReserveStatus = 0,//Acknowledgement signal for routeReserveRequest
	
	//Switch Routing Signal
	output reg [OUTPUTS * REQUEST_WIDTH - 1 : 0]routeSelect = 0,
	output reg [OUTPUTS - 1 : 0] outputBusy = 0,	//Tells which input ports are currently being routed
	output reg [INPUTS - 1 : 0] PortReserved = 0	//Tells which input ports have reserved an output port for routing.
	);
	
	integer i, j;
	
//	reg [OUTPUTS - 1 : 0] outputBusy = 0;//Tells which outputs are currently busy with transaction.
	reg [OUTPUTS - 1 : 0] switchRequest = 0;
	reg [OUTPUTS - 1 : 0] outputRelieve = 0;
	
	reg [INPUTS - 1 : 0] PortBusy = 0;
	reg [INPUTS - 1 : 0] Conflict = 0;
	
//TODO: Handle the situation when two requests come in consecutive clock cycles.
//For this, outputBusy has to be made high as soon as we know that the request will reserve the path
//This needs to be done in one clock cycle.
//Done!


//----------------------------------------Switch Controller FSM begins-----------------------------
	localparam STATE_WIDTH = 3;
	localparam UnRouted = 0, Check = 1, Arbitrate = 2, PathReserved1 = 3, PathReserved0 =4;
	
	//These registers store the FSM states of all the output ports
	reg [STATE_WIDTH * INPUTS - 1 : 0] switchState = 0, switchState_next = 0;
	
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
				Check : switchState_next[i * STATE_WIDTH +: STATE_WIDTH] = PortBusy[i] ? Check : Conflict[i] ? Arbitrate : PathReserved1;
				Arbitrate :  switchState_next[i * STATE_WIDTH +: STATE_WIDTH] = ~Conflict[i] & ~PortBusy[i] ? PathReserved1 : Arbitrate;
				PathReserved1 : switchState_next[i * STATE_WIDTH +: STATE_WIDTH] = PathReserved0;
				PathReserved0 : switchState_next[i * STATE_WIDTH +: STATE_WIDTH] = ~routeRelieve[i] ? PathReserved0 : UnRouted;
				default : switchState_next[i * STATE_WIDTH +: STATE_WIDTH] = UnRouted;
			endcase
	end
	
	//Port Busy Signal
	always @(*)
		for(i = INPUTS - 1; i >= 0; i = i - 1)
			PortBusy[i] = outputBusy[routeReserveRequest[i * REQUEST_WIDTH +: REQUEST_WIDTH]];
	

	//PortReserved Signal
	always @(*)
		for(i = INPUTS - 1; i >= 0; i = i - 1)
			PortReserved[i] = switchState[i * STATE_WIDTH +: STATE_WIDTH] == PathReserved0;
	

	//Conflict Signal
	//If conflict is high, this means that two inputs are racing for the same output port
	always @(*)
		for(i = INPUTS - 1; i >= 0; i = i - 1)begin//i = 0 will always be dispatched in case if it is in a conflict
			Conflict[i] = 1'b0;
			for(j = i - 1; j >= 0; j = j - 1)
				// If there is a conflict in the port, it will not be reported for
				//the lower index. This way we ensure that atleast one conflicted signal 
				//reserves a path.
				Conflict[i] = Conflict[i] | 
					(routeReserveRequest[j * REQUEST_WIDTH +: REQUEST_WIDTH] == routeReserveRequest[i * REQUEST_WIDTH +: REQUEST_WIDTH]
					 & (switchState[i * STATE_WIDTH +: STATE_WIDTH] != UnRouted));//switchState needs to be checked so that a conflicted signal can be dispatched after other signal has finished
		end
				
	
	//routeReserveStatus Signal
	always @(*)
		for(i = INPUTS - 1; i >= 0; i = i - 1)
			routeReserveStatus[i] = switchState[i * STATE_WIDTH +: STATE_WIDTH] == PathReserved1;
	
	always @(posedge clk)begin
		for(i = OUTPUTS - 1; i >= 0; i = i - 1)begin
			if(rst) 
				outputBusy[i] <= 0;
			else 
			if(outputRelieve[i])
				outputBusy[i] <= 0;
			else
			//Input with lower i is given more priority
			if(~outputBusy[i] & switchRequest[i])//If the output is not busy and there is a switch request
				outputBusy[i] <= 1;		
		end
	end

	always @(posedge clk)begin
		if(rst)
			routeSelect = 0;
		else
		for(i = OUTPUTS - 1; i >= 0; i = i - 1)begin
		//Keep the previous route reserve request until it is overwritten.
			//routeSelect[i * REQUEST_WIDTH +: REQUEST_WIDTH] = 0;
			for(j = INPUTS - 1; j >= 0; j = j - 1)
				if(routeReserveRequest[j * REQUEST_WIDTH +: REQUEST_WIDTH] == i & switchState[j * STATE_WIDTH +: STATE_WIDTH] == PathReserved1)
					routeSelect[i * REQUEST_WIDTH +: REQUEST_WIDTH] = j;
		end
	end
	
	always @(*)begin
		for(i = OUTPUTS - 1; i >= 0; i = i - 1)begin
			switchRequest[i] = 0;
			for(j = INPUTS - 1; j >= 0; j = j - 1)//To be generated when the path is actually reserved.
				switchRequest[i] = switchRequest[i] | (routeReserveRequest[j * REQUEST_WIDTH +: REQUEST_WIDTH] == i & (~PortBusy[j] | Conflict[j])) & (switchState[j * STATE_WIDTH +: STATE_WIDTH] == PathReserved1);
		end
	end
	
	always @(*)begin
		for(i = OUTPUTS - 1; i >= 0; i = i - 1)begin
			outputRelieve[i] = 0;
			for(j = INPUTS - 1; j >= 0; j = j - 1)
				outputRelieve[i] = outputRelieve[i] | (routeReserveRequest[j * REQUEST_WIDTH +: REQUEST_WIDTH] == i & routeRelieve[j]);
		end
	end
	
endmodule

