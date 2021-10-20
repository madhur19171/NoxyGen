module ControlLogic_TB;
	reg clk;
	reg rst;

	parameter N = 4;
	parameter DATA_WIDTH = 32;
	parameter FlitPerPacket = 6;//Head + 4Payloads + Tail
	parameter PhitPerFlit = 1;
	parameter REQUEST_WIDTH = 2;
	parameter TYPE_WIDTH = 2;

	reg valid_in;
	wire ready_in;
	
	wire valid_out;
	reg ready_out;

	reg [TYPE_WIDTH - 1 : 0] Flit_Type;

	wire reserveRoute;
	reg routeReserveStatus;
	
	wire headFlitValid;
	wire [$clog2(PhitPerFlit) : 0] phitCounter;
	reg headFlitStatus;
	
	wire popBuffer;
	wire pushBuffer;
	wire Handshake;
	reg full;

	wire routeRelieve;
	

	ControlFSM #(.FlitPerPacket(FlitPerPacket),
		.PhitPerFlit(PhitPerFlit),
		.REQUEST_WIDTH(REQUEST_WIDTH),
		.TYPE_WIDTH(TYPE_WIDTH)) controlFSM
	(
	.clk(clk),
	.rst(rst),
	.valid_in(valid_in),
	.ready_in(ready_in),
	.valid_out(valid_out),
	.ready_out(ready_out),
	.FlitType(FlitType),
	.reserveRoute(reserveRoute),
	.routeReserveStatus(routeReserveStatus),
	.headFlitValid(headFlitValid),
	.phitCounter(phitCounter),
	.headFlitStatus(headFlitStatus),
	.popBuffer(popBuffer),
	.pushBuffer(pushBuffer),
	.Handshake(Handshake),
	.full(full),
	.routeRelieve(routeRelieve)
	);

	always #5 clk = ~clk;

	initial begin
		clk = 0;
		rst = 1;

		valid_in = 0;
		ready_out = 0;
		
		Flit_Type = 0;

		routeReserveStatus = 0;

		headFlitStatus = 0;

		full = 0;
	end

	initial begin
		#10 rst = 0;

		#20 valid_in = 1;
		

		wait(reserveRoute);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		#5 routeReserveStatus = 1;
		#10 routeReserveStatus = 0;
		
		#30;

		wait(reserveRoute);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		@(posedge clk);
		#5 routeReserveStatus = 1;
		#10 routeReserveStatus = 0;

		#40 valid_in = 0;
		#30 $finish;
	end

	
endmodule
