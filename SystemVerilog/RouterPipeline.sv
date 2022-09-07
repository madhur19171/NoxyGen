module RouterPipeline #(
	parameter N = 100,
	parameter INDEX = 1,
	parameter VC = 4,
	parameter AssignedVC = 0,
	parameter INPUTS = 4,
	parameter OUTPUTS = 4,
	parameter DATA_WIDTH = 32,
	parameter TYPE_WIDTH = 2,
	parameter REQUEST_WIDTH = $clog2(OUTPUTS),
	parameter FlitPerPacket = 6,
	parameter HFBDepth = 4,
	parameter FIFO_DEPTH = 32,
	
	parameter FLOW_CONTROL = 0
	) 
	
	(
	input clk,
	input rst,
	
	input [VC : 0]VCPlaneSelector,
	
	//Input Controls
	input [INPUTS - 1 : 0][DATA_WIDTH - 1 : 0] data_in_bus,
	input [INPUTS - 1 : 0]valid_in_bus,
	output [INPUTS - 1 : 0]ready_in_bus,
	//Output Controls
	output [OUTPUTS - 1 : 0][DATA_WIDTH - 1 : 0] data_out_port,
	output [OUTPUTS - 1 : 0]valid_out_port,
	input [OUTPUTS - 1 : 0]ready_out_port,
	
	output [OUTPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0]routeSelect,
	output [OUTPUTS - 1 : 0] outputBusy,
	output [INPUTS - 1 : 0] PortReserved
	);

	wire [INPUTS - 1 : 0]routeRelieve;
	wire [INPUTS - 1 : 0]routeReserveRequestValid;
	wire [INPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0] routeReserveRequest;
	wire [INPUTS - 1 : 0]routeReserveStatus;
	
	genvar i;
	generate
		for(i = 0; i < INPUTS; i = i + 1)begin
			Port
			#(.N(N),
			.INDEX(INDEX),
			.VC(VC),
			.AssignedVC(AssignedVC),
			.DATA_WIDTH(DATA_WIDTH),
			.TYPE_WIDTH(TYPE_WIDTH),
			.REQUEST_WIDTH(REQUEST_WIDTH),
			.FlitPerPacket(FlitPerPacket),
			.HFBDepth(HFBDepth),
			.FIFO_DEPTH(FIFO_DEPTH),
			.FLOW_CONTROL(FLOW_CONTROL)
			) port
			(
			.clk(clk),
			.rst(rst),
			//All Ports share the same VCPlanes
			.VCPlaneSelectorCFSM(VCPlaneSelector),
			.VCPlaneSelectorHFB(VCPlaneSelector),
			.VCPlaneSelectorVCG(VCPlaneSelector),
			
			.data_in(data_in_bus[i]),
			.valid_in(valid_in_bus[i]),
			.ready_in(ready_in_bus[i]),
			
			.data_out(data_out_port[i]),
			.valid_out(valid_out_port[i]),
			.ready_out(ready_out_port[i]),
		
			.routeRelieve(routeRelieve[i]),
			.routeReserveRequestValid(routeReserveRequestValid[i]),
			.routeReserveRequest(routeReserveRequest[i]),
			.routeReserveStatus(routeReserveStatus[i])
			);
		end
	endgenerate
	

	SwitchControl
	#(.N(N),
	.VC(VC),
	.INPUTS(INPUTS),
	.OUTPUTS(OUTPUTS),
	.DATA_WIDTH(DATA_WIDTH),
	.REQUEST_WIDTH(REQUEST_WIDTH),
	.AssignedVC(AssignedVC)
	) switchControl
	(.clk(clk),
	.rst(rst),
	.VCPlaneSelector(VCPlaneSelector),
	
	.routeReserveRequestValid(routeReserveRequestValid),
	.routeReserveRequest(routeReserveRequest),
	.routeRelieve(routeRelieve),
	.routeReserveStatus(routeReserveStatus),
	
	.routeSelect(routeSelect),
	.outputBusy(outputBusy),
	.PortReserved(PortReserved)
	);
	
	
endmodule
