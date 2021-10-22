module Router #(
	parameter N = 2,
	parameter INDEX = 1,
	parameter INPUTS = 4,
	parameter OUTPUTS = 4,
	parameter DATA_WIDTH = 32,
	parameter TYPE_WIDTH = 2,
	parameter REQUEST_WIDTH = 1,
	parameter FlitPerPacket = 6,
	parameter PhitPerFlit = 1,
	parameter FIFO_DEPTH = 32
	) 
	
	(
	input clk,
	input rst,
	//Input Controls
	input [INPUTS * DATA_WIDTH - 1 : 0] data_in,
	input [INPUTS - 1 : 0]valid_in,
	output [INPUTS - 1 : 0]ready_in,
	//Output Controls
	output [OUTPUTS * DATA_WIDTH - 1 : 0] data_out,
	output [OUTPUTS - 1 : 0]valid_out,
	input [OUTPUTS - 1 : 0]ready_out
	);
	
	wire [DATA_WIDTH * INPUTS - 1 : 0]data_in_switch, data_out_port;
	wire [INPUTS - 1 : 0]valid_in_switch, valid_out_port;
	wire [INPUTS - 1 : 0]ready_in_switch, ready_out_port;

	wire [INPUTS - 1 : 0]routeRelieve;
	wire [INPUTS - 1 : 0]routeReserveRequestValid;
	wire [INPUTS * REQUEST_WIDTH - 1 : 0] routeReserveRequest;
	wire [INPUTS - 1 : 0]routeReserveStatus;
	
	assign data_in_switch = data_out_port;
	assign valid_in_switch = valid_out_port;
	assign ready_out_port = ready_in_switch;
	
	genvar i;
	generate
		for(i = 0; i < INPUTS; i = i + 1)begin
			Port
			#(.N(N),
			.INDEX(INDEX),
			.DATA_WIDTH(DATA_WIDTH),
			.TYPE_WIDTH(TYPE_WIDTH),
			.REQUEST_WIDTH(REQUEST_WIDTH),
			.FlitPerPacket(FlitPerPacket),
			.PhitPerFlit(PhitPerFlit),
			.FIFO_DEPTH(FIFO_DEPTH)
			) porter
			(
			.clk(clk),
			.rst(rst),
			.data_in(data_in[i * DATA_WIDTH +: DATA_WIDTH]),
			.valid_in(valid_in[i]),
			.ready_in(ready_in[i]),
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
	.INPUTS(INPUTS),
	.OUTPUTS(OUTPUTS),
	.DATA_WIDTH(DATA_WIDTH),
	.REQUEST_WIDTH(REQUEST_WIDTH)
	) switch
	(.clk(clk),
	.rst(rst),
	
	.routeReserveRequestValid(routeReserveRequestValid),
	.routeReserveRequest(routeReserveRequest),
	.routeRelieve(routeRelieve),
	.routeReserveStatus(routeReserveStatus),
	
	.data_in(data_in_switch),
	.valid_in(valid_in_switch),
	.ready_in(ready_in_switch),
	.data_out(data_out),
	.valid_out(valid_out),
	.ready_out(ready_out)
	);
	
	
endmodule
