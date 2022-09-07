module Port #(
	parameter N = 4,
	parameter INDEX = 1,
	parameter VC = 4,
	parameter AssignedVC = 0,
	parameter DATA_WIDTH = 8,
	parameter TYPE_WIDTH = 2,
	parameter REQUEST_WIDTH = 2,
	parameter FlitPerPacket = 6,
	parameter HFBDepth = 4,
	parameter FIFO_DEPTH = 32,
	parameter FLOW_CONTROL = 0
	) 
	
	(
	input clk,
	input rst,
	
	//VC control Signals
	input [VC : 0] VCPlaneSelectorCFSM,//Selects the currently active VC Plane
	input [VC : 0] VCPlaneSelectorHFB,//Selects the currently active VC Plane
	input [VC : 0] VCPlaneSelectorVCG,//Selects the currently active VC Plane
	
	//Input Controls
	input [DATA_WIDTH - 1 : 0] data_in,
	input valid_in,
	output ready_in,
	//Output Controls
	output [DATA_WIDTH - 1 : 0] data_out,
	output valid_out,
	input ready_out,
	
	//Switch Controls
	output routeRelieve,
	output routeReserveRequestValid,
	output [REQUEST_WIDTH - 1 : 0] routeReserveRequest,
	input routeReserveStatus
	);
	
	//The protocol will be:
	//The Sender will send a valid signal as soon as its data is ready w/o waiting for ready signal.
	//The receiver will be waiting for the valid signal to become 1. After the valid is 1, sender sends a ready 1.
	//This way the handshake happens and when both valid and ready are 1.
	
	wire popBuffer;
	wire pushBuffer;
	wire full;
	wire empty;
	wire [$clog2(FIFO_DEPTH) - 1 : 0] FIFOoccupancy;

	
	wire [TYPE_WIDTH - 1 : 0]FlitType;
	wire reserveRoute;
	wire routeReserveStatus_CFSM;
	wire headFlitValid;
	
	wire HFBFull;
	wire HFBEmpty;
	wire decodeHeadFlit;
	wire headFlitDecoded;
	
	generate
		case(FLOW_CONTROL)
			0 : 
				ControlFSM_WH
				#(.DATA_WIDTH(DATA_WIDTH),
				.VC(VC),
				.FlitPerPacket(FlitPerPacket),
				.REQUEST_WIDTH(REQUEST_WIDTH),
				.TYPE_WIDTH(TYPE_WIDTH),
				.FIFO_DEPTH(FIFO_DEPTH)) controlFSM
				(.clk(clk),
				.rst(rst),
				.data_in(data_in),
				.VCPlaneSelector(VCPlaneSelectorCFSM),
				.valid_in(valid_in),
				.ready_in(ready_in),
				.valid_out(valid_out),
				.ready_out(ready_out),
				
				.FlitType(FlitType),
				.reserveRoute(reserveRoute),
				.routeReserveStatus(routeReserveStatus_CFSM),
				.headFlitValid(headFlitValid),
				
				.HFBFull(HFBFull),
				.HFBEmpty(HFBEmpty),
				.decodeHeadFlit(decodeHeadFlit),
				.headFlitDecoded(headFlitDecoded),
				
				.popBuffer(popBuffer),
				.pushBuffer(pushBuffer),
				.Handshake(Handshake),
				.full(full),
				.empty(empty),
				.FIFOoccupancy(FIFOoccupancy),
				.routeRelieve(routeRelieve)
				);
			1 : 
				ControlFSM_VCT
				#(.DATA_WIDTH(DATA_WIDTH),
				.VC(VC),
				.FlitPerPacket(FlitPerPacket),
				.REQUEST_WIDTH(REQUEST_WIDTH),
				.TYPE_WIDTH(TYPE_WIDTH),
				.FIFO_DEPTH(FIFO_DEPTH)) controlFSM
				(.clk(clk),
				.rst(rst),
				.data_in(data_in),
				.VCPlaneSelector(VCPlaneSelectorCFSM),
				.valid_in(valid_in),
				.ready_in(ready_in),
				.valid_out(valid_out),
				.ready_out(ready_out),
				
				.FlitType(FlitType),
				.reserveRoute(reserveRoute),
				.routeReserveStatus(routeReserveStatus_CFSM),
				.headFlitValid(headFlitValid),
				
				.HFBFull(HFBFull),
				.HFBEmpty(HFBEmpty),
				.decodeHeadFlit(decodeHeadFlit),
				.headFlitDecoded(headFlitDecoded),
				
				.popBuffer(popBuffer),
				.pushBuffer(pushBuffer),
				.Handshake(Handshake),
				.full(full),
				.empty(empty),
				.FIFOoccupancy(FIFOoccupancy),
				.routeRelieve(routeRelieve)
				);
			default : 
				ControlFSM_WH
				#(.DATA_WIDTH(DATA_WIDTH),
				.VC(VC),
				.FlitPerPacket(FlitPerPacket),
				.REQUEST_WIDTH(REQUEST_WIDTH),
				.TYPE_WIDTH(TYPE_WIDTH),
				.FIFO_DEPTH(FIFO_DEPTH)) controlFSM
				(.clk(clk),
				.rst(rst),
				.data_in(data_in),
				.VCPlaneSelector(VCPlaneSelectorCFSM),
				.valid_in(valid_in),
				.ready_in(ready_in),
				.valid_out(valid_out),
				.ready_out(ready_out),
				
				.FlitType(FlitType),
				.reserveRoute(reserveRoute),
				.routeReserveStatus(routeReserveStatus_CFSM),
				.headFlitValid(headFlitValid),
				
				.HFBFull(HFBFull),
				.HFBEmpty(HFBEmpty),
				.decodeHeadFlit(decodeHeadFlit),
				.headFlitDecoded(headFlitDecoded),
				
				.popBuffer(popBuffer),
				.pushBuffer(pushBuffer),
				.Handshake(Handshake),
				.full(full),
				.empty(empty),
				.FIFOoccupancy(FIFOoccupancy),
				.routeRelieve(routeRelieve)
				);
		endcase
	endgenerate
	
	
	HeadFlitBuffer
	#(.N(N),
	.INDEX(INDEX),
	.VC(VC),
	.AssignedVC(AssignedVC),
	.DATA_WIDTH(DATA_WIDTH),
	.HFBDepth(HFBDepth),
	.REQUEST_WIDTH(REQUEST_WIDTH)
	) headFlitBuffer
	(.clk(clk),
	.rst(rst),
	.VCPlaneSelector(VCPlaneSelectorHFB),
	.Handshake(Handshake),
	.headFlit(data_in),//From FIFO
	.headFlitValid(headFlitValid),
	.routeRelieve(routeRelieve),
	.reserveRoute(reserveRoute),
	.routeReserveStatus_CFSM(routeReserveStatus_CFSM),
	
	.HFBFull(HFBFull),
	.HFBEmpty(HFBEmpty),
	.decodeHeadFlit(decodeHeadFlit),
	.headFlitDecoded(headFlitDecoded),
	
	.routeReserveRequestValid(routeReserveRequestValid),
	.routeReserveRequest(routeReserveRequest),
	.routeReserveStatus_Switch(routeReserveStatus)
	);
	
	
	FlitIdentifier
	#(
	 .DATA_WIDTH(DATA_WIDTH),
	 .TYPE_WIDTH(TYPE_WIDTH)
	) flitIdentifier
	(
	.Flit(data_out),
	.FlitType(FlitType)
	);
	
	
	FIFO 
	#(.DATA_WIDTH(DATA_WIDTH),
	.FIFO_DEPTH(FIFO_DEPTH)) fifo
	(.clk(clk),
	.rst(rst),
	.FIFOoccupancy(FIFOoccupancy),
	.empty(empty),
	.rd_en(popBuffer),
	.dout(data_out),
	.full(full),
	.wr_en(pushBuffer),
	.din(data_in)
	);
	
endmodule
