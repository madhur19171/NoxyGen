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
		
		input [VC * OUTPUTS * DATA_WIDTH - 1 : 0] data_out_portVC,
		input [VC * OUTPUTS - 1 : 0]valid_out_portVC,
		output reg [VC * OUTPUTS - 1 : 0]ready_out_portVC = 0,
		
		input [VC * OUTPUTS * REQUEST_WIDTH - 1 : 0]routeSelectVC,
		input [VC * OUTPUTS - 1 : 0] outputBusyVC,
		input [VC * INPUTS - 1 : 0] PortReservedVC,
		
		
		output [DATA_WIDTH * INPUTS - 1 : 0]data_in_switch,
		output [INPUTS - 1 : 0]valid_in_switch,
		input [INPUTS - 1 : 0]ready_in_switch,
		
		output [OUTPUTS * REQUEST_WIDTH - 1 : 0]routeSelect,
		output [OUTPUTS - 1 : 0] outputBusy,
		output [INPUTS - 1 : 0] PortReserved
	);
	
	integer i;
	always @(*)begin
		ready_out_portVC = 0;
		for(i = 0; i < VC; i = i + 1)begin
			if(VCPlaneSelector == i)
				ready_out_portVC[i * OUTPUTS +: OUTPUTS] = ready_in_switch;
		end
	end
	
	assign data_in_switch = data_out_portVC[VCPlaneSelector * OUTPUTS * DATA_WIDTH +: OUTPUTS * DATA_WIDTH];   
	assign valid_in_switch = valid_out_portVC[VCPlaneSelector * OUTPUTS +: OUTPUTS];
	//assign ready_out_portVC = {VC{ready_in_switch}};//Low Confidence
	
	assign routeSelect = routeSelectVC[VCPlaneSelector * OUTPUTS * REQUEST_WIDTH +: OUTPUTS * REQUEST_WIDTH];
	assign outputBusy = outputBusyVC[VCPlaneSelector * OUTPUTS +: OUTPUTS];
	assign PortReserved = PortReservedVC[VCPlaneSelector * INPUTS +: INPUTS];
	
endmodule
