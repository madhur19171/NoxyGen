module VCMux 
	#(
		parameter VC = 4,
		parameter INPUTS = 4,
		parameter OUTPUTS = 4,
		parameter DATA_WIDTH = 32,
		parameter REQUEST_WIDTH = 32
	)
	(
		//VC control Signals
		input [VC : 0] VCPlaneSelector,//Selects the currently active VC Plane
		
		input [VC - 1 : 0][OUTPUTS - 1 : 0][DATA_WIDTH - 1 : 0] data_out_portVC,
		input [VC - 1 : 0][OUTPUTS - 1 : 0]valid_out_portVC,
		output reg [VC - 1 : 0][OUTPUTS - 1 : 0]ready_out_portVC = 0,
		
		input [VC - 1 : 0][OUTPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0]routeSelectVC,
		input [VC - 1 : 0][OUTPUTS - 1 : 0] outputBusyVC,
		input [VC - 1 : 0][INPUTS - 1 : 0] PortReservedVC,
		
		
		output [INPUTS - 1 : 0][DATA_WIDTH - 1 : 0]data_in_switch,
		output [INPUTS - 1 : 0]valid_in_switch,
		input [INPUTS - 1 : 0]ready_in_switch,
		
		output [OUTPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0]routeSelect,
		output [OUTPUTS - 1 : 0] outputBusy,
		output [INPUTS - 1 : 0] PortReserved
	);
	
	integer i;
	always_comb begin
		ready_out_portVC = 0;
		for(i = 0; i < VC; i = i + 1)begin
			if(VCPlaneSelector == i)
				ready_out_portVC[i] = ready_in_switch;
		end
	end
	
	assign data_in_switch = data_out_portVC[VCPlaneSelector];   
	assign valid_in_switch = valid_out_portVC[VCPlaneSelector];
	//assign ready_out_portVC = {VC{ready_in_switch}};//Low Confidence
	
	assign routeSelect = routeSelectVC[VCPlaneSelector];
	assign outputBusy = outputBusyVC[VCPlaneSelector];
	assign PortReserved = PortReservedVC[VCPlaneSelector];
	
endmodule
