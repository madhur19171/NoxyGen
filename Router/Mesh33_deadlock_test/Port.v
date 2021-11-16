module Port #(
	parameter N = 4,
	parameter INDEX = 1,
	parameter DATA_WIDTH = 8,
	parameter TYPE_WIDTH = 2,
	parameter REQUEST_WIDTH = 2,
	parameter FlitPerPacket = 6,
	parameter PhitPerFlit = 1,
	parameter FIFO_DEPTH = 32
	) 
	
	(
	input clk,
	input rst,
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
	
	wire popBuffer;
	wire pushBuffer;
	wire full;
	wire empty;
	
	PortControlLogic 
	#(.N(N),
	.INDEX(INDEX),
	.DATA_WIDTH(DATA_WIDTH),
	.TYPE_WIDTH(TYPE_WIDTH),
	.REQUEST_WIDTH(REQUEST_WIDTH),
	.FlitPerPacket(FlitPerPacket),
	.PhitPerFlit(PhitPerFlit)
	) portControlLogic
	(.clk(clk),
	.rst(rst),
	.data_in(data_in),
	.valid_in(valid_in),
	.ready_in(ready_in),
	.valid_out(valid_out),
	.ready_out(ready_out),
	.Flit(data_out),//We assume that PhitPerFlit = 1 so data_out of FIFO will actually be the Flit
	.popBuffer(popBuffer),
	.pushBuffer(pushBuffer),
	.full(full),
	.empty(empty),
	.routeRelieve(routeRelieve),
	.routeReserveRequestValid(routeReserveRequestValid),
	.routeReserveRequest(routeReserveRequest),
	.routeReserveStatus(routeReserveStatus)
	);
	
	FIFO 
	#(.DATA_WIDTH(DATA_WIDTH),
	.FIFO_DEPTH(FIFO_DEPTH)) fifo
	(.clk(clk),
	.rst(rst),
	.empty(empty),
	.rd_en(popBuffer),
	.dout(data_out),
	.full(full),
	.wr_en(pushBuffer),
	.din(data_in)
	);
	
endmodule
