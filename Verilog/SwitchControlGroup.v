//Design for Mesh Based NoC with each switch having 4 Inputs and 4 Outputs
//Switching control logic will be in a separate unit.
module SwitchControlGroup
	#(
	parameter N = 4,
	parameter INPUTS = 4,
	parameter OUTPUTS = 4,
	parameter DATA_WIDTH = 8,
	parameter REQUEST_WIDTH = 2,
	parameter VC = 4
	) 
	
	(
	input clk,
	input rst,
	
	//VC control Signals
	input [VC : 0] VCPlaneSelector,//Selects the currently active VC Plane
	
	//Request Signals:
	input [INPUTS - 1 : 0] routeReserveRequestValid,
	input [INPUTS * REQUEST_WIDTH - 1 : 0] routeReserveRequest,//This signal selects the input using the first $clog2(N) bits and assigns the output to the last $clog2(N) bit address output.
	input [INPUTS - 1 : 0] routeRelieve,//This bit is used to relieve the path after a transaction is complete, that is, after the tail flit has been received. 
	output [INPUTS - 1 : 0]routeReserveStatus,//Acknowledgement signal for routeReserveRequest
	
	//Switch Routing Signal
	output [OUTPUTS * REQUEST_WIDTH - 1 : 0]routeSelect,
	output [OUTPUTS - 1 : 0] outputBusy,	//Tells which input ports are currently being routed
	output [INPUTS - 1 : 0] PortReserved	//Tells which input ports have reserved an output port for routing.
	);
	
	wire [VC * INPUTS - 1 : 0] routeReserveRequestValidVC;
	wire [VC * INPUTS * REQUEST_WIDTH - 1 : 0] routeReserveRequestVC;
	wire [VC * INPUTS - 1 : 0] routeRelieveVC;

	wire [VC * INPUTS - 1 : 0]routeReserveStatusVC;
	
	//From SwitchControl
	wire [VC * OUTPUTS * REQUEST_WIDTH - 1 : 0]routeSelectVC;
	wire [VC * OUTPUTS - 1 : 0] outputBusyVC;
	wire [VC * INPUTS - 1 : 0] PortReservedVC;
	
	SwitchControlDemux #(.VC(VC), .INPUTS(INPUTS), .OUTPUTS(OUTPUTS), .REQUEST_WIDTH(REQUEST_WIDTH)) switchControlDemux
	(.VCPlaneSelector(VCPlaneSelector),
	
	.routeReserveRequestValid(routeReserveRequestValid), 
	.routeReserveRequest(routeReserveRequest), 
	.routeRelieve(routeRelieve),
	
	.routeReserveRequestValidVC(routeReserveRequestValidVC),
	.routeReserveRequestVC(routeReserveRequestVC), 
	.routeRelieveVC(routeRelieveVC)
	);
	
	genvar i;
	generate
		for(i = 0; i < VC; i = i + 1)
			SwitchControl #(.N(N), .AssignedVC(i), .VC(VC), .INPUTS(INPUTS), .OUTPUTS(OUTPUTS), .DATA_WIDTH(DATA_WIDTH), .REQUEST_WIDTH(REQUEST_WIDTH)) switchControl
			(.clk(clk), .rst(rst),
			.VCPlaneSelector(VCPlaneSelector), 
			
			.routeReserveRequestValid(routeReserveRequestValidVC[i * INPUTS +: INPUTS]),
			.routeReserveRequest(routeReserveRequestVC[i * INPUTS * REQUEST_WIDTH +: INPUTS * REQUEST_WIDTH]),
			.routeRelieve(routeRelieveVC[i * INPUTS +: INPUTS]),
			.routeReserveStatus(routeReserveStatusVC[i * INPUTS +: INPUTS]),
			
			.routeSelect(routeSelectVC[i * OUTPUTS * REQUEST_WIDTH +: OUTPUTS * REQUEST_WIDTH]),
			.outputBusy(outputBusyVC[i * OUTPUTS +: OUTPUTS]),
			.PortReserved(PortReservedVC[i * INPUTS +: INPUTS]));
	endgenerate
	
	SwitchControlMux #(.VC(VC), .INPUTS(INPUTS), .OUTPUTS(OUTPUTS), .REQUEST_WIDTH(REQUEST_WIDTH)) switchControlMux
	(.VCPlaneSelector(VCPlaneSelector),
	
	.routeSelectVC(routeSelectVC),
	.outputBusyVC(outputBusyVC),
	.PortReservedVC(PortReservedVC),
	.routeReserveStatusVC(routeReserveStatusVC),
	
	.routeSelect(routeSelect),
	.outputBusy(outputBusy),
	.PortReserved(PortReserved),
	.routeReserveStatus(routeReserveStatus));
	
	
endmodule

