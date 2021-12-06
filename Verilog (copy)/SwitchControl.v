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
	
	//integer i, j;
	
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
	
	integer i0;
	//State Transition for all Output Ports
	always @(posedge clk)begin
		for(i0 = INPUTS - 1; i0 >= 0; i0 = i0 - 1)
			if(rst)
				switchState[i0 * STATE_WIDTH +: STATE_WIDTH] <= UnRouted;
			else 
				switchState[i0 * STATE_WIDTH +: STATE_WIDTH] <= switchState_next[i0 * STATE_WIDTH +: STATE_WIDTH];
	end
	
	integer i1;
	//Next state logic for all Output Ports
	always @(*)begin
		for(i1 = INPUTS - 1; i1 >= 0; i1 = i1 - 1)
			case(switchState[i1 * STATE_WIDTH +: STATE_WIDTH])
				UnRouted : switchState_next[i1 * STATE_WIDTH +: STATE_WIDTH] = routeReserveRequestValid[i1] ? Check : UnRouted;
				Check : switchState_next[i1 * STATE_WIDTH +: STATE_WIDTH] = PortBusy[i1] ? Check : Conflict[i1] ? Arbitrate : PathReserved1;
				Arbitrate :  switchState_next[i1 * STATE_WIDTH +: STATE_WIDTH] = ~Conflict[i1] & ~PortBusy[i1] ? PathReserved1 : Arbitrate;
				PathReserved1 : switchState_next[i1 * STATE_WIDTH +: STATE_WIDTH] = PathReserved0;
				PathReserved0 : switchState_next[i1 * STATE_WIDTH +: STATE_WIDTH] = ~routeRelieve[i1] ? PathReserved0 : UnRouted;
				default : switchState_next[i1 * STATE_WIDTH +: STATE_WIDTH] = UnRouted;
			endcase
	end
	
	integer i2;
	//Port Busy Signal
	always @(*)
		for(i2 = INPUTS - 1; i2 >= 0; i2 = i2 - 1)
			PortBusy[i2] = outputBusy[routeReserveRequest[i2 * REQUEST_WIDTH +: REQUEST_WIDTH]];
	

	integer i3;
	//PortReserved Signal
	always @(*)
		for(i3 = INPUTS - 1; i3 >= 0; i3 = i3 - 1)
			PortReserved[i3] = switchState[i3 * STATE_WIDTH +: STATE_WIDTH] == PathReserved0;
	

	integer i4, j4;
	//Conflict Signal
	//If conflict is high, this means that two inputs are racing for the same output port
	always @(*)
		for(i4 = INPUTS - 1; i4 >= 0; i4 = i4 - 1)begin//i = 0 will always be dispatched in case if it is in a conflict
			Conflict[i4] = 1'b0;
			for(j4 = i4 - 1; j4 >= 0; j4 = j4 - 1)
				// If there is a conflict in the port, it will not be reported for
				//the lower index. This way we ensure that atleast one conflicted signal 
				//reserves a path.
				Conflict[i4] = Conflict[i4] | 
					((routeReserveRequest[j4 * REQUEST_WIDTH +: REQUEST_WIDTH] == routeReserveRequest[i4 * REQUEST_WIDTH +: REQUEST_WIDTH]) & routeReserveRequestValid[i4] & routeReserveRequestValid[j4]
					 & (switchState[i4 * STATE_WIDTH +: STATE_WIDTH] != UnRouted));//switchState needs to be checked so that a conflicted signal can be dispatched after other signal has finished
		end
				
	integer i5;
	//routeReserveStatus Signal
	always @(*)
		for(i5 = INPUTS - 1; i5 >= 0; i5 = i5 - 1)
			routeReserveStatus[i5] = switchState[i5 * STATE_WIDTH +: STATE_WIDTH] == PathReserved1;
	
	integer i6;
	always @(posedge clk)begin
		for(i6 = OUTPUTS - 1; i6 >= 0; i6 = i6 - 1)begin
			if(rst) 
				outputBusy[i6] <= 0;
			else 
			if(outputRelieve[i6])
				outputBusy[i6] <= 0;
			else
			//Input with lower i6 is given more priority
			if(~outputBusy[i6] & switchRequest[i6])//If the output is not busy and there is a switch request
				outputBusy[i6] <= 1;		
		end
	end

	integer i7, j7;
	always @(posedge clk)begin
		if(rst)
			routeSelect = 0;
		else
		for(i7 = OUTPUTS - 1; i7 >= 0; i7 = i7 - 1)begin
		//Keep the previous route reserve request until it is overwritten.
			//routeSelect[i * REQUEST_WIDTH +: REQUEST_WIDTH] = 0;
			for(j7 = INPUTS - 1; j7 >= 0; j7 = j7 - 1)
				if(routeReserveRequest[j7 * REQUEST_WIDTH +: REQUEST_WIDTH] == i7 & switchState[j7 * STATE_WIDTH +: STATE_WIDTH] == PathReserved1)
					routeSelect[i7 * REQUEST_WIDTH +: REQUEST_WIDTH] = j7;
		end
	end
	
	integer i8, j8;
	always @(*)begin
		for(i8 = OUTPUTS - 1; i8 >= 0; i8 = i8 - 1)begin
			switchRequest[i8] = 0;
			for(j8 = INPUTS - 1; j8 >= 0; j8 = j8 - 1)//To be generated when the path is actually reserved.
				switchRequest[i8] = switchRequest[i8] | (routeReserveRequest[j8 * REQUEST_WIDTH +: REQUEST_WIDTH] == i8 & (~PortBusy[j8] | Conflict[j8])) & (switchState[j8* STATE_WIDTH +: STATE_WIDTH] == PathReserved1);
		end
	end
	
	integer i9, j9;
	always @(*)begin
		for(i9 = OUTPUTS - 1; i9 >= 0; i9 = i9 - 1)begin
			outputRelieve[i9] = 0;
			for(j9 = INPUTS - 1; j9 >= 0; j9 = j9 - 1)
				outputRelieve[i9] = outputRelieve[i9] | (routeReserveRequest[j9 * REQUEST_WIDTH +: REQUEST_WIDTH] == i9 & routeRelieve[j9]);
		end
	end
	
endmodule

