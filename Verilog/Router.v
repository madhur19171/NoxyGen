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
	
	wire [DATA_WIDTH * INPUTS - 1 : 0]data_in_switch, data_out_port;
	wire [INPUTS - 1 : 0]valid_in_switch, valid_out_port;
	wire [INPUTS - 1 : 0]ready_in_switch, ready_out_port;

	wire [INPUTS - 1 : 0]routeRelieve;
	wire [INPUTS - 1 : 0]routeReserveRequestValid;
	wire [INPUTS * REQUEST_WIDTH - 1 : 0] routeReserveRequest;
	wire [INPUTS - 1 : 0]routeReserveStatus;
	
	wire [VC : 0] VCPlaneSelectorCFSM, VCPlaneSelectorHFB, VCPlaneSelectorVCG, VCPlaneSelectorSwitchControl;
	
	assign data_in_switch = data_out_port;
	assign valid_in_switch = valid_out_port;
	assign ready_out_port = ready_in_switch;
	
	genvar i;
	generate
		for(i = 0; i < INPUTS; i = i + 1)begin
			Port
			#(.N(N),
			.INDEX(INDEX),
			.VC(VC),
			.DATA_WIDTH(DATA_WIDTH),
			.TYPE_WIDTH(TYPE_WIDTH),
			.REQUEST_WIDTH(REQUEST_WIDTH),
			.FlitPerPacket(FlitPerPacket),
			.PhitPerFlit(PhitPerFlit),
			.FIFO_DEPTH(FIFO_DEPTH)
			) port
			(
			.clk(clk),
			.rst(rst),
			//All Ports share the same VCPlanes
			.VCPlaneSelectorCFSM(VCPlaneSelectorCFSM),
			.VCPlaneSelectorHFB(VCPlaneSelectorHFB),
			.VCPlaneSelectorVCG(VCPlaneSelectorVCG),
			.data_in(data_in_bus[i * DATA_WIDTH +: DATA_WIDTH]),
			.valid_in(valid_in_bus[i]),
			.ready_in(ready_in_bus[i]),
			.data_out(data_out_port[i * DATA_WIDTH +: DATA_WIDTH]),
			.valid_out(valid_out_port[i]),
			.ready_out(ready_out_port[i]),
		
			.routeRelieve(routeRelieve[i]),
			.routeReserveRequestValid(routeReserveRequestValid[i]),
			.routeReserveRequest(routeReserveRequest[i * REQUEST_WIDTH +: REQUEST_WIDTH]),
			.routeReserveStatus(routeReserveStatus[i])
			);
		end
	endgenerate
	

	Switch
	#(.N(N),
	.VC(VC),
	.INPUTS(INPUTS),
	.OUTPUTS(OUTPUTS),
	.DATA_WIDTH(DATA_WIDTH),
	.REQUEST_WIDTH(REQUEST_WIDTH)
	) switch
	(.clk(clk),
	.rst(rst),
	.VCPlaneSelectorSwitchControl(VCPlaneSelectorSwitchControl),
	.routeReserveRequestValid(routeReserveRequestValid),
	.routeReserveRequest(routeReserveRequest),
	.routeRelieve(routeRelieve),
	.routeReserveStatus(routeReserveStatus),
	
	.data_in(data_in_switch),
	.valid_in(valid_in_switch),
	.ready_in(ready_in_switch),
	.data_out(data_out_bus),
	.valid_out(valid_out_bus),
	.ready_out(ready_out_bus)
	);
	
	VCPlaneController #(.VC(VC)) vcplanecontroller
		(.clk(clk), .rst(rst),
		.VCPlaneSelectorCFSM(VCPlaneSelectorCFSM),
		.VCPlaneSelectorHFB(VCPlaneSelectorHFB),
		.VCPlaneSelectorVCG(VCPlaneSelectorVCG),
		.VCPlaneSelectorSwitchControl(VCPlaneSelectorSwitchControl));
	
endmodule
