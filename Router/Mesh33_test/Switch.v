module Switch 
	#(parameter N = 4,
	parameter INPUTS = 4,
	parameter OUTPUTS = 4,
	parameter DATA_WIDTH = 8,
	parameter REQUEST_WIDTH = 2
	)
	(
	input clk,
	input rst,
	//Request Signals:
	input [INPUTS - 1 : 0] routeReserveRequestValid,
	input [INPUTS * REQUEST_WIDTH - 1 : 0] routeReserveRequest,//This signal selects the input using the first $clog2(N) bits and assigns the output to the last $clog2(N) bit address output.
	input [INPUTS - 1 : 0] routeRelieve,//This bit is used to relieve the path after a transaction is complete, that is, after the tail flit has been received. 
	output [INPUTS - 1 : 0]routeReserveStatus,//Acknowledgement signal for routeReserveRequest
	
	//Data Input
	input [INPUTS * DATA_WIDTH - 1 : 0] data_in,
	input [INPUTS - 1 : 0] valid_in,
	output [INPUTS - 1 : 0] ready_in,
	
	//Data Output
	output [OUTPUTS * DATA_WIDTH - 1 : 0] data_out,
	output [OUTPUTS - 1 : 0] valid_out,
	input [OUTPUTS - 1 : 0] ready_out
	);
	
	wire [OUTPUTS * $clog2(INPUTS) - 1 : 0] routeSelect;
	wire [OUTPUTS - 1 : 0] outputBusy;
	wire [INPUTS - 1 : 0] PortReserved;
	
	SwitchControl
	#(.N(N),
	.INPUTS(INPUTS),
	.OUTPUTS(OUTPUTS),
	.DATA_WIDTH(DATA_WIDTH),
	.REQUEST_WIDTH(REQUEST_WIDTH)) switchControl
	
	(.clk(clk),
	.rst(rst),
	.routeReserveRequestValid(routeReserveRequestValid),
	.routeReserveRequest(routeReserveRequest),
	.routeRelieve(routeRelieve),
	.routeReserveStatus(routeReserveStatus),
	.routeSelect(routeSelect),
	.outputBusy(outputBusy),
	.PortReserved(PortReserved)
	);
	
	MuxSwitch
	#(.INPUTS(INPUTS),
	.OUTPUTS(OUTPUTS),
	.DATA_WIDTH(DATA_WIDTH),
	.REQUEST_WIDTH(REQUEST_WIDTH)) muxSwitch
	
	(.routeSelect(routeSelect),
	.outputBusy(outputBusy),
	.PortReserved(PortReserved),
	.data_in(data_in),
	.valid_in(valid_in),
	.ready_in(ready_in),
	.data_out(data_out),
	.valid_out(valid_out),
	.ready_out(ready_out)
	);
	
endmodule
