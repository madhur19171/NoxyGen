//This module multiplexes outputs from VC Buffers
//To send them to Switch

module SwitchControlMux 
	#(
		parameter VC = 4,
		parameter INPUTS = 4,
		parameter OUTPUTS = 4,
		parameter REQUEST_WIDTH = 2
	)
	(
		//VC control Signals
		input [VC : 0] VCPlaneSelector,//Selects the currently active VC Plane
		
		//To Switch
		output [OUTPUTS * REQUEST_WIDTH - 1 : 0]routeSelect,
		output [OUTPUTS - 1 : 0] outputBusy,
		output [INPUTS - 1 : 0] PortReserved,
		
		//To HFB
		output [INPUTS - 1 : 0] routeReserveStatus,
		
		
		//From SwitchControl
		input [VC * OUTPUTS * REQUEST_WIDTH - 1 : 0] routeSelectVC,
		input [VC * OUTPUTS - 1 : 0] outputBusyVC,
		input [VC * INPUTS - 1 : 0] PortReservedVC,
		input [VC * INPUTS - 1 : 0] routeReserveStatusVC
	);
	
	assign routeSelect = routeSelectVC[VCPlaneSelector * OUTPUTS * REQUEST_WIDTH +: OUTPUTS * REQUEST_WIDTH];
	assign outputBusy = outputBusyVC[VCPlaneSelector * OUTPUTS +: OUTPUTS];
	assign PortReserved = PortReservedVC[VCPlaneSelector * INPUTS +: INPUTS];
	assign routeReserveStatus = routeReserveStatusVC[VCPlaneSelector * INPUTS +: INPUTS];
	
endmodule
