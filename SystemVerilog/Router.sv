/*
VC_FLOW_CONTROL determines the flow control followed for that VC.
Each VC will have 8-bits which will determine the flow control at the Design Time.
Each VC can have different FLow control
The Map is given:
0: Worm Hole
1: VCT
2: SAF
*/

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
	parameter HFBDepth = 4,
	parameter FIFO_DEPTH = 32,
	
	parameter VC_FLOW_CONTROL = 0
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
	
	wire [INPUTS - 1 : 0][DATA_WIDTH - 1 : 0] data_in_busVC_input;
	wire [INPUTS - 1 : 0]valid_in_busVC_input;
	wire [INPUTS - 1 : 0]ready_in_busVC_input;
	
	wire [VC - 1 : 0][INPUTS - 1 : 0][DATA_WIDTH - 1 : 0] data_in_busVC_output;
	wire [VC - 1 : 0][INPUTS - 1 : 0]valid_in_busVC_output;
	wire [VC - 1 : 0][INPUTS - 1 : 0]ready_in_busVC_output;
	
	wire [VC - 1 : 0][OUTPUTS - 1 : 0][DATA_WIDTH - 1 : 0] data_out_portVC_input;
	wire [VC - 1 : 0][OUTPUTS - 1 : 0]valid_out_portVC_input;
	wire [VC - 1 : 0][OUTPUTS - 1 : 0]ready_out_portVC_input;
	
	wire [VC - 1 : 0][OUTPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0]routeSelectVC;
	wire [VC - 1 : 0][OUTPUTS - 1 : 0] outputBusyVC;
	wire [VC - 1 : 0][OUTPUTS - 1 : 0] PortReservedVC;
	
	wire [INPUTS - 1 : 0][DATA_WIDTH - 1 : 0]data_in_switch;
	wire [INPUTS - 1 : 0]valid_in_switch;
	wire [INPUTS - 1 : 0]ready_in_switch;
	
	wire [OUTPUTS - 1 : 0][DATA_WIDTH - 1 : 0]data_out_switch;
	wire [OUTPUTS - 1 : 0]valid_out_switch;
	wire [OUTPUTS - 1 : 0]ready_out_switch;
	
	wire [OUTPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0]routeSelect;
	wire [OUTPUTS - 1 : 0] outputBusy;
	wire [INPUTS - 1 : 0] PortReserved;
	
	genvar j;
	generate
		for(j = 0; j < INPUTS; j = j + 1) begin: INPUT_BUS_GENERATOR
			assign data_in_busVC_input[j] = data_in_bus[j * DATA_WIDTH +: DATA_WIDTH];
			assign valid_in_busVC_input[j] = valid_in_bus[j];
			assign ready_in_bus[j] = ready_in_busVC_input[j];
		end
	endgenerate
	
	genvar k;
	generate
		for(k = 0; k < OUTPUTS; k = k + 1) begin: OUTPUT_BUS_GENERATOR
			assign data_out_bus[k * DATA_WIDTH +: DATA_WIDTH] = data_out_switch[k];
			assign valid_out_bus[k] = valid_out_switch[k];
			assign ready_out_switch[k] = ready_out_bus[k];
		end
	endgenerate

	
	VCDemux #(.VC(VC), .INPUTS(INPUTS), .OUTPUTS(OUTPUTS), .DATA_WIDTH(DATA_WIDTH))vcDemux_input
	(.VCPlaneSelector(VCPlaneSelector),
	.data_in_bus(data_in_busVC_input),
	.valid_in_bus(valid_in_busVC_input),
	.ready_in_bus(ready_in_busVC_input),
	
	.data_in_busVC(data_in_busVC_output),
	.valid_in_busVC(valid_in_busVC_output),
	.ready_in_busVC(ready_in_busVC_output));
	
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
		.HFBDepth(HFBDepth),
		.FIFO_DEPTH(FIFO_DEPTH),
		.FLOW_CONTROL((VC_FLOW_CONTROL >> (8 * i) & 8'hff))
		) routerPipeline
		(
		.clk(clk), .rst(rst),
		.VCPlaneSelector(VCPlaneSelector),
		
		.data_in_bus(data_in_busVC_output[i]), 
		.valid_in_bus(valid_in_busVC_output[i]), 
		.ready_in_bus(ready_in_busVC_output[i]),
		
		.data_out_port(data_out_portVC_input[i]), 
		.valid_out_port(valid_out_portVC_input[i]), 
		.ready_out_port(ready_out_portVC_input[i]),
		
		.routeSelect(routeSelectVC[i]), 
		.outputBusy(outputBusyVC[i]), 
		.PortReserved(PortReservedVC[i])
		);
	
	
	VCMux #(.VC(VC), .INPUTS(INPUTS), .OUTPUTS(OUTPUTS), .DATA_WIDTH(DATA_WIDTH), .REQUEST_WIDTH(REQUEST_WIDTH))vcMux_input
	(.VCPlaneSelector(VCPlaneSelector),
	.data_out_portVC(data_out_portVC_input),
	.valid_out_portVC(valid_out_portVC_input),
	.ready_out_portVC(ready_out_portVC_input),
	
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
	
	.data_out(data_out_switch),
	.valid_out(valid_out_switch),
	.ready_out(ready_out_switch)
	);
	
	VCPlaneController #(.VC(VC)) vcplanecontroller
	(.clk(clk), .rst(rst),
	.VCPlaneSelectorCFSM(VCPlaneSelector));

endmodule
