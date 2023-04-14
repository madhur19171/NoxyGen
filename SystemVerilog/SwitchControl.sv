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
	input [INPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0] routeReserveRequest,//This signal selects the input using the first $clog2(N) bits and assigns the output to the last $clog2(N) bit address output.
	input [INPUTS - 1 : 0] routeRelieve,//This bit is used to relieve the path after a transaction is complete, that is, after the tail flit has been received. 
	output logic [INPUTS - 1 : 0]routeReserveStatus = 0,//Acknowledgement signal for routeReserveRequest
	
	//Switch Routing Signal
	output logic [OUTPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0] routeSelect,
	output logic [OUTPUTS - 1 : 0] outputBusy,	//Tells which input ports are currently being routed
	output logic [INPUTS - 1 : 0] PortReserved	//Tells which input ports have reserved an output port for routing.
	);
	
	//integer i, j;
	
//	reg [OUTPUTS - 1 : 0] outputBusy = 0;//Tells which outputs are currently busy with transaction.

	logic [OUTPUTS - 1 : 0] switchRequest = 0;
	logic [OUTPUTS - 1 : 0] outputRelieve = 0;
	
	logic [INPUTS - 1 : 0] PortBusy = 0;
	logic [INPUTS - 1 : 0] Conflict = 0;
	

//This Switch Controller will transit to other states only when
//VCPlaneSelector is equal to AssignedVC. This means that the FSMs will be active 
//when the virtual plane becomes active. At other times, it will be inactive.
	localparam STATE_WIDTH = 3;
	typedef enum logic[STATE_WIDTH - 1 : 0] {UnRouted, Check, Arbitrate, PathReserved1, PathReserved0} SwitchControlFSMState;


//----------------------------------------Switch Controller FSM begins-----------------------------
	//enum UnRouted = 0, Check = 1, Arbitrate = 2, PathReserved1 = 3, PathReserved0 =4;
	
	//These registers store the FSM states of all the output ports
	SwitchControlFSMState [INPUTS - 1 : 0] switchState, switchState_next;
	
	//State Transition for all Output Ports
	always_ff @(posedge clk)begin
		for(int i = INPUTS - 1; i >= 0; i--)
			if(rst)
				switchState[i] <= #1.25 UnRouted;
			else
				switchState[i] <= #1.25 switchState_next[i];
	end
	
	//Next state logic for all Output Ports
	always_comb begin
		switchState_next = 0;
		for(int i = INPUTS - 1; i >= 0; i--)
			case(switchState[i])
				UnRouted : switchState_next[i] = routeReserveRequestValid[i] ? Check : UnRouted;
				Check : switchState_next[i] = PortBusy[i] ? Check : Conflict[i] ? Arbitrate : PathReserved1;
				Arbitrate :  switchState_next[i] = ~Conflict[i] & ~PortBusy[i] ? PathReserved1 : Arbitrate;
				PathReserved1 : switchState_next[i] = PathReserved0;
				PathReserved0 : switchState_next[i] = ~routeRelieve[i] ? PathReserved0 : UnRouted;
				default : switchState_next[i] = UnRouted;
			endcase
	end
	
	//Port Busy Signal
	always_comb begin
		PortBusy = 0;
		for(int i = INPUTS - 1; i >= 0; i--)
			PortBusy[i] = outputBusy[routeReserveRequest[i]];
	end
	
	
	//PortReserved Signal
	always_comb begin
		PortReserved = 0;
		for(int i = INPUTS - 1; i >= 0; i = i - 1)
			PortReserved[i] = switchState[i] == PathReserved0;
	end
	

	//Conflict Signal
	//If conflict is high, this means that two inputs are racing for the same output port
	always @(*) begin
		Conflict = 0;
		for(int i = INPUTS - 1; i >= 0; i--)begin//i = 0 will always be dispatched in case if it is in a conflict
			for(int j = i - 1; j >= 0; j--)
				// If there is a conflict in the port, it will not be reported for
				//the lower index. This way we ensure that atleast one conflicted signal 
				//reserves a path.
				Conflict[i] = Conflict[i] | 
					((routeReserveRequest[j] == routeReserveRequest[i]) 
					& routeReserveRequestValid[i] & routeReserveRequestValid[j]
					& (switchState[i] != UnRouted));//switchState needs to be checked so that a conflicted signal can be dispatched after other signal has finished
		end
	end
				
	//routeReserveStatus Signal
	always_comb begin
		routeReserveStatus = 0;
		for(int i = INPUTS - 1; i >= 0; i--)
			routeReserveStatus[i] = (switchState[i] == PathReserved1);
	end
	
	
	always_ff @(posedge clk)begin
		for(int i = OUTPUTS - 1; i >= 0; i--)begin
			if(rst) 
				outputBusy[i] <= #0.75 0;
			else
			if(outputRelieve[i])
				outputBusy[i] <= #0.75 0;
			else
			//Input with lower i is given more priority
			if(~outputBusy[i] & switchRequest[i])//If the output is not busy and there is a switch request
				outputBusy[i] <= #0.75 1;		
		end
	end


	//There is a possibility of Hold time violation in this always block
	always_ff @(posedge clk)begin
		if(rst)
			routeSelect = 0;
		else 
		for(int i = OUTPUTS - 1; i >= 0; i--)begin
		//Keep the previous route reserve request until it is overwritten.
			for(int j = INPUTS - 1; j >= 0; j--)
				if(routeReserveRequest[j] == i & switchState[j] == PathReserved1)
					routeSelect[i] = j;
		end
	end

	always_comb begin
		switchRequest = 0;
		for(int i = OUTPUTS - 1; i >= 0; i--)begin
			for(int j = INPUTS - 1; j >= 0; j--)//To be generated when the path is actually reserved.
				switchRequest[i] = switchRequest[i]
							| (routeReserveRequest[j] == i
							& (~PortBusy[j] | Conflict[j])) 
							& (switchState[j] == PathReserved1);
		end
	end
	
	
	always_comb begin
		outputRelieve = 0;
		for(int i = OUTPUTS - 1; i >= 0; i--)begin
			for(int j = INPUTS - 1; j >= 0; j--)
				outputRelieve[i] = outputRelieve[i] | (routeRelieve[j] 
							& routeSelect[i] == j 
							& outputBusy[i]);
		end
	end
	
endmodule

