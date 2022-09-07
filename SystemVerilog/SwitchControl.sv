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

	logic [OUTPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0]routeSelectVC = 0;
	logic [OUTPUTS - 1 : 0] outputBusyVC = 0;
	logic [INPUTS - 1 : 0] PortReservedVC = 0;
	logic [INPUTS - 1 : 0] routeReserveStatusVC = 0;

	logic [OUTPUTS - 1 : 0] switchRequestVC = 0;
	logic [OUTPUTS - 1 : 0] outputRelieveVC = 0;
	
	logic [INPUTS - 1 : 0] PortBusyVC = 0;
	logic [INPUTS - 1 : 0] ConflictVC = 0;
	

//This Switch Controller will transit to other states only when
//VCPlaneSelector is equal to AssignedVC. This means that the FSMs will be active 
//when the virtual plane becomes active. At other times, it will be inactive.
	localparam STATE_WIDTH = 3;
	typedef enum logic[STATE_WIDTH - 1 : 0] {UnRouted, Check, Arbitrate, PathReserved1, PathReserved0} SwitchControlFSMState;


//----------------------------------------Switch Controller FSM begins-----------------------------
	//enum UnRouted = 0, Check = 1, Arbitrate = 2, PathReserved1 = 3, PathReserved0 =4;
	
	//These registers store the FSM states of all the output ports
	SwitchControlFSMState [INPUTS - 1 : 0] switchStateVC, switchState_nextVC;
	
	//State Transition for all Output Ports
	always_ff @(posedge clk)begin
		for(int i = INPUTS - 1; i >= 0; i--)
			if(rst)
				switchStateVC[i] <= #1.25 UnRouted;
			else //if(VCPlaneSelector == AssignedVC)
				switchStateVC[i] <= #1.25 switchState_nextVC[i];
	end
	
	//Next state logic for all Output Ports
	always_comb begin
		switchState_nextVC = 0;
		for(int i = INPUTS - 1; i >= 0; i--)
			case(switchStateVC[i])
				UnRouted : switchState_nextVC[i] = routeReserveRequestValid[i] ? Check : UnRouted;
				Check : switchState_nextVC[i] = PortBusyVC[i] ? Check : ConflictVC[i] ? Arbitrate : PathReserved1;
				Arbitrate :  switchState_nextVC[i] = ~ConflictVC[i] & ~PortBusyVC[i] ? PathReserved1 : Arbitrate;
				PathReserved1 : switchState_nextVC[i] = PathReserved0;
				PathReserved0 : switchState_nextVC[i] = ~routeRelieve[i] ? PathReserved0 : UnRouted;
				default : switchState_nextVC[i] = UnRouted;
			endcase
	end
	
	//Port Busy Signal
	always_comb begin
		PortBusyVC = 0;
		for(int i = INPUTS - 1; i >= 0; i--)
			PortBusyVC[i] = outputBusyVC[routeReserveRequest[i]];
	end
	
	
	//PortReserved Signal
	always_comb begin
		PortReservedVC = 0;
		for(int i = INPUTS - 1; i >= 0; i = i - 1)
			PortReservedVC[i] = switchStateVC[i] == PathReserved0;
	end
	assign PortReserved = PortReservedVC[0 +: INPUTS];
	

	//Conflict Signal
	//If conflict is high, this means that two inputs are racing for the same output port
	always @(*) begin
		ConflictVC = 0;
		for(int i = INPUTS - 1; i >= 0; i--)begin//i = 0 will always be dispatched in case if it is in a conflict
			for(int j = i - 1; j >= 0; j--)
				// If there is a conflict in the port, it will not be reported for
				//the lower index. This way we ensure that atleast one conflicted signal 
				//reserves a path.
				ConflictVC[i] = ConflictVC[i] | 
					((routeReserveRequest[j] == routeReserveRequest[i]) 
					& routeReserveRequestValid[i] & routeReserveRequestValid[j]
					& (switchStateVC[i] != UnRouted));//switchState needs to be checked so that a conflicted signal can be dispatched after other signal has finished
		end
	end
				
	//routeReserveStatus Signal
	always_comb begin
		routeReserveStatusVC = 0;
		for(int i = INPUTS - 1; i >= 0; i--)
			routeReserveStatusVC[i] = (switchStateVC[i] == PathReserved1);
	end
	assign routeReserveStatus = routeReserveStatusVC[0 +: INPUTS];
	
	
	always_ff @(posedge clk)begin
		for(int i = OUTPUTS - 1; i >= 0; i--)begin
			if(rst) 
				outputBusyVC[i] <= #0.75 0;
			else// if(VCPlaneSelector == AssignedVC)
			if(outputRelieveVC[i])
				outputBusyVC[i] <= #0.75 0;
			else
			//Input with lower i is given more priority
			if(~outputBusyVC[i] & switchRequestVC[i])//If the output is not busy and there is a switch request
				outputBusyVC[i] <= #0.75 1;		
		end
	end
	assign outputBusy = outputBusyVC[0 +: OUTPUTS];


	//There is a possibility of Hold time violation in this always block
	always_ff @(posedge clk)begin
		if(rst)
			routeSelectVC = 0;
		else //if(VCPlaneSelector == AssignedVC)
		for(int i = OUTPUTS - 1; i >= 0; i--)begin
		//Keep the previous route reserve request until it is overwritten.
			//routeSelect[i] = 0;
			for(int j = INPUTS - 1; j >= 0; j--)
				if(routeReserveRequest[j] == i & switchStateVC[j] == PathReserved1)
					routeSelectVC[i] = j;
		end
	end
	assign routeSelect = routeSelectVC;

	always_comb begin
		switchRequestVC = 0;
		for(int i = OUTPUTS - 1; i >= 0; i--)begin
			for(int j = INPUTS - 1; j >= 0; j--)//To be generated when the path is actually reserved.
				switchRequestVC[i] = switchRequestVC[i]
							| (routeReserveRequest[j] == i
							& (~PortBusyVC[j] | ConflictVC[j])) 
							& (switchStateVC[j] == PathReserved1);
		end
	end
	
	/*integer i, j;
	always @(*)begin
		for(i = OUTPUTS - 1; i >= 0; i = i - 1)begin
			outputRelieve[i] = 0;
			for(j = INPUTS - 1; j >= 0; j = j - 1)
				outputRelieve[i] = outputRelieve[i] | ((routeReserveRequest[j] == i & routeRelieve[j]));
		end
	end*/
	
	always_comb begin
		outputRelieveVC = 0;
		for(int i = OUTPUTS - 1; i >= 0; i--)begin
			for(int j = INPUTS - 1; j >= 0; j--)
				outputRelieveVC[i] = outputRelieveVC[i] | (routeRelieve[j] 
							& routeSelectVC[i] == j 
							& outputBusyVC[i]);
		end
	end
	
endmodule

