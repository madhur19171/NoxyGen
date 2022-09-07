//Design for Mesh Based NoC with each switch having 4 Inputs and 4 Outputs
//Switching control logic will be in a separate unit.
module SwitchControl
	#(
	parameter N = 4,
	parameter INPUTS = 4,
	parameter OUTPUTS = 4,
	parameter DATA_WIDTH = 8,
	parameter REQUEST_WIDTH = 2,
	parameter AssignedVC = 4,
	parameter VC = 1
	) 
	
	(
	input clk,
	input rst,
	
	//VC control Signals
	input [VC : 0] VCPlaneSelector,//Selects the currently active VC Plane
	
	//Request Signals:
	input [INPUTS - 1 : 0] routeReserveRequestValid,
	input [INPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0] routeReserveRequest,//This signal selects the input using the first $clog2(N) bits and assigns the output to the last $clog2(N) bit address output.
	input [INPUTS - 1 : 0] routeRelieve,//This bit is used to relieve the path after a transaction is complete, that is, after the tail flit has been received. 
	output [INPUTS - 1 : 0]routeReserveStatus,//Acknowledgement signal for routeReserveRequest
	
	//Switch Routing Signal
	output [OUTPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0]routeSelect,
	output [OUTPUTS - 1 : 0] outputBusy,	//Tells which input ports are currently being routed
	output [INPUTS - 1 : 0] PortReserved	//Tells which input ports have reserved an output port for routing.
	);
	
	//integer i, j;
	
//	reg [OUTPUTS - 1 : 0] outputBusy = 0;//Tells which outputs are currently busy with transaction.

	reg [OUTPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0]routeSelectVC = 0;
	reg [OUTPUTS - 1 : 0] outputBusyVC = 0;
	reg [INPUTS - 1 : 0] PortReservedVC = 0;
	reg [INPUTS - 1 : 0] routeReserveStatusVC = 0;

	reg [OUTPUTS - 1 : 0] switchRequestVC = 0;
	reg [OUTPUTS - 1 : 0] outputRelieveVC = 0;
	
	reg [INPUTS - 1 : 0] PortBusyVC = 0;
	reg [INPUTS - 1 : 0] ConflictVC = 0;
	

//This Switch Controller will transit to other states only when
//VCPlaneSelector is equal to AssignedVC. This means that the FSMs will be active 
//when the virtual plane becomes active. At other times, it will be inactive.


//----------------------------------------Switch Controller FSM begins-----------------------------
	localparam STATE_WIDTH = 3;
	localparam UnRouted = 0, Check = 1, Arbitrate = 2, PathReserved1 = 3, PathReserved0 =4;
	
	//These registers store the FSM states of all the output ports
	reg [INPUTS - 1 : 0][STATE_WIDTH - 1 : 0] switchStateVC = 0, switchState_nextVC = 0;
	
	integer i0;
	//State Transition for all Output Ports
	always_ff @(posedge clk)begin
		for(i0 = INPUTS - 1; i0 >= 0; i0 = i0 - 1)
			if(rst)
				switchStateVC[i0] <= #1.25 UnRouted;
			else //if(VCPlaneSelector == AssignedVC)
				switchStateVC[i0] <= #1.25 switchState_nextVC[i0];
	end
	
	integer i1;
	//Next state logic for all Output Ports
	always_comb begin
		switchState_nextVC = 0;
		for(i1 = INPUTS - 1; i1 >= 0; i1 = i1 - 1)
			case(switchStateVC[i1])
				UnRouted : switchState_nextVC[i1] = routeReserveRequestValid[i1] ? Check : UnRouted;
				Check : switchState_nextVC[i1] = PortBusyVC[i1] ? Check : ConflictVC[i1] ? Arbitrate : PathReserved1;
				Arbitrate :  switchState_nextVC[i1] = ~ConflictVC[i1] & ~PortBusyVC[i1] ? PathReserved1 : Arbitrate;
				PathReserved1 : switchState_nextVC[i1] = PathReserved0;
				PathReserved0 : switchState_nextVC[i1] = ~routeRelieve[i1] ? PathReserved0 : UnRouted;
				default : switchState_nextVC[i1] = UnRouted;
			endcase
	end
	
	integer i2;
	//Port Busy Signal
	always_comb begin
		PortBusyVC = 0;
		for(i2 = INPUTS - 1; i2 >= 0; i2 = i2 - 1)
			PortBusyVC[i2] = outputBusyVC[routeReserveRequest[i2]];
	end
	
	

	integer i3;
	//PortReserved Signal
	always_comb begin
		PortReservedVC = 0;
		for(i3 = INPUTS - 1; i3 >= 0; i3 = i3 - 1)
			PortReservedVC[i3] = switchStateVC[i3] == PathReserved0;
	end
	assign PortReserved = PortReservedVC[0 +: INPUTS];
	

	integer i4, j4;
	//Conflict Signal
	//If conflict is high, this means that two inputs are racing for the same output port
	always @(*) begin
		ConflictVC = 0;
		for(i4 = INPUTS - 1; i4 >= 0; i4 = i4 - 1)begin//i = 0 will always be dispatched in case if it is in a conflict
			for(j4 = i4 - 1; j4 >= 0; j4 = j4 - 1)
				// If there is a conflict in the port, it will not be reported for
				//the lower index. This way we ensure that atleast one conflicted signal 
				//reserves a path.
				ConflictVC[i4] = ConflictVC[i4] | 
					((routeReserveRequest[j4] == routeReserveRequest[i4]) 
					& routeReserveRequestValid[i4] & routeReserveRequestValid[j4]
					& (switchStateVC[i4] != UnRouted));//switchState needs to be checked so that a conflicted signal can be dispatched after other signal has finished
		end
	end
				
	integer i5;
	//routeReserveStatus Signal
	always_comb begin
		routeReserveStatusVC = 0;
		for(i5 = INPUTS - 1; i5 >= 0; i5 = i5 - 1)
			routeReserveStatusVC[i5] = (switchStateVC[i5] == PathReserved1);
	end
	assign routeReserveStatus = routeReserveStatusVC[0 +: INPUTS];
	
	integer i6;
	always_ff @(posedge clk)begin
		for(i6 = OUTPUTS - 1; i6 >= 0; i6 = i6 - 1)begin
			if(rst) 
				outputBusyVC[i6] <= #0.75 0;
			else// if(VCPlaneSelector == AssignedVC)
			if(outputRelieveVC[i6])
				outputBusyVC[i6] <= #0.75 0;
			else
			//Input with lower i6 is given more priority
			if(~outputBusyVC[i6] & switchRequestVC[i6])//If the output is not busy and there is a switch request
				outputBusyVC[i6] <= #0.75 1;		
		end
	end
	assign outputBusy = outputBusyVC[0 +: OUTPUTS];


	//There is a possibility of Hold time violation in this always block
	integer i7, j7;
	always_ff @(posedge clk)begin
		if(rst)
			routeSelectVC = 0;
		else //if(VCPlaneSelector == AssignedVC)
		for(i7 = OUTPUTS - 1; i7 >= 0; i7 = i7 - 1)begin
		//Keep the previous route reserve request until it is overwritten.
			//routeSelect[i] = 0;
			for(j7 = INPUTS - 1; j7 >= 0; j7 = j7 - 1)
				if(routeReserveRequest[j7] == i7 & switchStateVC[j7] == PathReserved1)
					routeSelectVC[i7] = j7;
		end
	end
	assign routeSelect = routeSelectVC;
	
	integer i8, j8;
	always_comb begin
		switchRequestVC = 0;
		for(i8 = OUTPUTS - 1; i8 >= 0; i8 = i8 - 1)begin
			for(j8 = INPUTS - 1; j8 >= 0; j8 = j8 - 1)//To be generated when the path is actually reserved.
				switchRequestVC[i8] = switchRequestVC[i8]
							| (routeReserveRequest[j8] == i8
							& (~PortBusyVC[j8] | ConflictVC[j8])) 
							& (switchStateVC[j8] == PathReserved1);
		end
	end
	
	/*integer i9, j9;
	always @(*)begin
		for(i9 = OUTPUTS - 1; i9 >= 0; i9 = i9 - 1)begin
			outputRelieve[i9] = 0;
			for(j9 = INPUTS - 1; j9 >= 0; j9 = j9 - 1)
				outputRelieve[i9] = outputRelieve[i9] | ((routeReserveRequest[j9] == i9 & routeRelieve[j9]));
		end
	end*/
	
	integer i9, j9;
	always_comb begin
		outputRelieveVC = 0;
		for(i9 = OUTPUTS - 1; i9 >= 0; i9 = i9 - 1)begin
			for(j9 = INPUTS - 1; j9 >= 0; j9 = j9 - 1)
				outputRelieveVC[i9] = outputRelieveVC[i9] | (routeRelieve[j9] 
							& routeSelectVC[i9] == j9 
							& outputBusyVC[i9]);
		end
	end
	
endmodule

