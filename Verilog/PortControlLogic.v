//Design for Mesh Based NoC with each switch having 4 Inputs and 4 Outputs
//Switching control logic will be in a separate unit.
module PortControlLogic
	#(
	parameter N = 4,
	parameter INDEX = 1,
	parameter VC = 4,
	parameter DATA_WIDTH = 8,
	parameter TYPE_WIDTH = 2,
	parameter REQUEST_WIDTH = 2,
	parameter FlitPerPacket = 6,
	parameter HFBDepth = 4,
	parameter PhitPerFlit = 1
	) 
	(
	input clk,
	input rst,
	
	//VC control Signals
	input [VC : 0] VCPlaneSelectorCFSM,//Selects the currently active VC Plane
	input [VC : 0] VCPlaneSelectorHFB,//Selects the currently active VC Plane
	
	//From Port data_in
	input [DATA_WIDTH - 1 : 0] data_in,//For Head Flit Buffer
	
	//Input Controls
	input valid_in,
	output ready_in,
	//Output Controls
	output valid_out,
	input ready_out,
	
	//FlitIdentifier
	input [DATA_WIDTH * PhitPerFlit - 1 : 0] Flit,
	
	//Buffer Controls
	output popBuffer,
	output pushBuffer,
	input full,
	input empty,
	
	//Switch Controls
	output routeRelieve,
	output routeReserveRequestValid,
	output [REQUEST_WIDTH - 1 : 0]routeReserveRequest,
	input routeReserveStatus
	);
	
	//Direction Encoding for Mesh based switches:
	//0 : North	1 : South	2 : West	3 : East
	
	//The protocol will be:
	//The Sender will send a valid signal as soon as its data is ready w/o waiting for ready signal.
	//The receiver will be waiting for the valid signal to become 1. After the valid is 1, sender sends a ready 1.
	//This way the handshake happens and when both valid and ready are 1.
	
	wire [TYPE_WIDTH - 1 : 0]FlitType;
	wire reserveRoute;
	wire routeReserveStatus_CFSM;
	wire [DATA_WIDTH - 1 : 0]Head_Phit;
	wire headFlitValid;
	wire [$clog2(PhitPerFlit) : 0] phitCounter;
	wire headFlitStatus;
	wire Handshake;
	
	wire HFBFull;
	wire HFBEmpty;
	wire decodeHeadFlit;
	wire headFlitDecoded;
	
	ControlFSM 
	#(.DATA_WIDTH(DATA_WIDTH),
	.VC(VC),
	.FlitPerPacket(FlitPerPacket),
	.PhitPerFlit(PhitPerFlit),
	.REQUEST_WIDTH(REQUEST_WIDTH),
	.TYPE_WIDTH(TYPE_WIDTH)) controlFSM
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
	.phitCounter(phitCounter),
	
	.HFBFull(HFBFull),
	.HFBEmpty(HFBEmpty),
	.decodeHeadFlit(decodeHeadFlit),
	.headFlitDecoded(headFlitDecoded),
	
	.popBuffer(popBuffer),
	.pushBuffer(pushBuffer),
	.Handshake(Handshake),
	.full(full),
	.empty(empty),
	.routeRelieve(routeRelieve)
	);
	
	HeadFlitBuffer
	#(.N(N),
	.INDEX(INDEX),
	.VC(VC),
	.DATA_WIDTH(DATA_WIDTH),
	.PhitPerFlit(PhitPerFlit),
	.HFBDepth(HFBDepth),
	.REQUEST_WIDTH(REQUEST_WIDTH)
	) headFlitBuffer
	(.clk(clk),
	.rst(rst),
	.VCPlaneSelector(VCPlaneSelectorHFB),
	.Handshake(Handshake),
	.Head_Phit(data_in),//From FIFO
	.headFlitValid(headFlitValid),
	.phitCounter(phitCounter),
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
	 .TYPE_WIDTH(TYPE_WIDTH),
	 .PhitPerFlit(PhitPerFlit)
	) flitIdentifier
	(
	.Flit(Flit),
	.FlitType(FlitType)
	);
	
endmodule
