module Router #(
	parameter N = 100,
	parameter INDEX = 1,
	parameter VC = 4,
	parameter INPUTS = 4,
	parameter OUTPUTS = 4,
	parameter DATA_WIDTH = 32,
	parameter TYPE_WIDTH = 2,
	parameter REQUEST_WIDTH = $clog2(OUTPUTS),
	parameter FlitPerPacket = 6,
	parameter PhitPerFlit = 1,
	parameter HFBDepth = 4,
	parameter FIFO_DEPTH = 32
	) 
	
	(
	input clk,
	input rst,
	//Input Controls
	input [INPUTS * DATA_WIDTH - 1 : 0] data_in_bus,
	input [INPUTS - 1 : 0]valid_in_bus,
	output [INPUTS - 1 : 0]ready_in_bus,
	//Output Controls
	output [OUTPUTS * DATA_WIDTH - 1 : 0] data_out_bus,
	output [OUTPUTS - 1 : 0]valid_out_bus,
	input [OUTPUTS - 1 : 0]ready_out_bus
	);
	
	wire [VC : 0]VCPlaneSelector;
	
	wire [VC * INPUTS * DATA_WIDTH - 1 : 0] data_in_busVC;
	wire [VC * INPUTS - 1 : 0]valid_in_busVC;
	wire [VC * INPUTS - 1 : 0]ready_in_busVC;
	
	wire [VC * OUTPUTS * DATA_WIDTH - 1 : 0] data_out_portVC;
	wire [VC * OUTPUTS - 1 : 0]valid_out_portVC;
	wire [VC * OUTPUTS - 1 : 0]ready_out_portVC;
	
	wire [VC * OUTPUTS * REQUEST_WIDTH - 1 : 0]routeSelectVC;
	wire [VC * OUTPUTS - 1 : 0] outputBusyVC;
	wire [VC * INPUTS - 1 : 0] PortReservedVC;
	
	wire [DATA_WIDTH * INPUTS - 1 : 0]data_in_switch;
	wire [INPUTS - 1 : 0]valid_in_switch;
	wire [INPUTS - 1 : 0]ready_in_switch;
	
	wire [OUTPUTS * REQUEST_WIDTH - 1 : 0]routeSelect;
	wire [OUTPUTS - 1 : 0] outputBusy;
	wire [INPUTS - 1 : 0] PortReserved;
	
	VCDemux #(.VC(VC), .INPUTS(INPUTS), .OUTPUTS(OUTPUTS), .DATA_WIDTH(DATA_WIDTH))vcDemux
	(.VCPlaneSelector(VCPlaneSelector),
	.data_in_bus(data_in_bus),
	.valid_in_bus(valid_in_bus),
	.ready_in_bus(ready_in_bus),
	
	.data_in_busVC(data_in_busVC),
	.valid_in_busVC(valid_in_busVC),
	.ready_in_busVC(ready_in_busVC));
	
	genvar i;
	for(i = 0; i < VC; i = i + 1)
		RouterPipeline 
		#(.N(N), 
		.INDEX(INDEX),
		.VC(VC),
		.AssignedVC(i),
		.INPUTS(INPUTS),
		.OUTPUTS(OUTPUTS),
		.DATA_WIDTH(DATA_WIDTH),
		.TYPE_WIDTH(TYPE_WIDTH),
		.REQUEST_WIDTH(REQUEST_WIDTH),
		.FlitPerPacket(FlitPerPacket),
		.PhitPerFlit(PhitPerFlit),
		.HFBDepth(HFBDepth),
		.FIFO_DEPTH(FIFO_DEPTH)) routerPipeline
		(
		.clk(clk), .rst(rst),
		.VCPlaneSelector(VCPlaneSelector),
		
		.data_in_bus(data_in_busVC[i * INPUTS * DATA_WIDTH +: INPUTS * DATA_WIDTH]), 
		.valid_in_bus(valid_in_busVC[i * INPUTS +: INPUTS]), 
		.ready_in_bus(ready_in_busVC[i * INPUTS +: INPUTS]),
		
		.data_out_port(data_out_portVC[i * OUTPUTS * DATA_WIDTH +: OUTPUTS * DATA_WIDTH]), 
		.valid_out_port(valid_out_portVC[i * OUTPUTS +: OUTPUTS]), 
		.ready_out_port(ready_out_portVC[i * OUTPUTS +: OUTPUTS]),
		
		.routeSelect(routeSelectVC[i * OUTPUTS * REQUEST_WIDTH +: OUTPUTS * REQUEST_WIDTH]), 
		.outputBusy(outputBusyVC[i * OUTPUTS +: OUTPUTS]), 
		.PortReserved(PortReservedVC[i * INPUTS +: INPUTS])
		);
	
	
	VCMux #(.VC(VC), .INPUTS(INPUTS), .OUTPUTS(OUTPUTS), .DATA_WIDTH(DATA_WIDTH), .REQUEST_WIDTH(REQUEST_WIDTH))vcMux
	(.VCPlaneSelector(VCPlaneSelector),
	.data_out_portVC(data_out_portVC),
	.valid_out_portVC(valid_out_portVC),
	.ready_out_portVC(ready_out_portVC),
	
	.routeSelectVC(routeSelectVC),
	.outputBusyVC(outputBusyVC), 
	.PortReservedVC(PortReservedVC),
	
	.data_in_switch(data_in_switch),
	.valid_in_switch(valid_in_switch), 
	.ready_in_switch(ready_in_switch),
	
	.routeSelect(routeSelect),
	.outputBusy(outputBusy),
	.PortReserved(PortReserved));
	
	
	MuxSwitch
	#(.INPUTS(INPUTS),
	.OUTPUTS(OUTPUTS),
	.DATA_WIDTH(DATA_WIDTH),
	.REQUEST_WIDTH(REQUEST_WIDTH)) muxSwitch
	(.routeSelect(routeSelect),
	.outputBusy(outputBusy),
	.PortReserved(PortReserved),
	
	.data_in(data_in_switch),
	.valid_in(valid_in_switch),
	.ready_in(ready_in_switch),
	
	.data_out(data_out_bus),
	.valid_out(valid_out_bus),
	.ready_out(ready_out_bus)
	);
	
	VCPlaneController #(.VC(VC)) vcplanecontroller
	(.clk(clk), .rst(rst),
	.VCPlaneSelectorCFSM(VCPlaneSelector));

endmodule
