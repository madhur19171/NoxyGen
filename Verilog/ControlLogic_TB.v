module ControlLogic_TB;
	reg clk;
	reg rst;

	parameter N = 2;
	parameter INPUTS = 2;
	parameter OUTPUTS = 2;
	parameter DATA_WIDTH = 32;
	parameter REQUEST_WIDTH = 1;
	parameter TYPE_WIDTH = 2;
	parameter FlitPerPacket = 6;//Head + 4Payloads + Tail
	parameter PhitPerFlit = 1;
	parameter FIFO_DEPTH = 32;

	integer i;

	wire [DATA_WIDTH - 1 : 0] data_out00, data_out01, data_out11, data_out10, data_in01, data_in11;
	reg [DATA_WIDTH - 1 : 0] data_in00 = 0, data_in10 = 0;

	wire valid_out00, valid_out01, valid_out11, valid_out10, valid_in01, valid_in11;
	reg valid_in00 = 0, valid_in10 = 0;	

	wire ready_in00, ready_in01, ready_in11, ready_in10, ready_out01, ready_out11;
	reg ready_out00 = 0, ready_out10 = 0;

	assign data_in11 = data_out01;
	assign data_in01 = data_out11;

	assign valid_in11 = valid_out01;
	assign valid_in01 = valid_out11;

	assign ready_out11 = ready_in01;
	assign ready_out01 = ready_in11;

	Router 
	#(.N(N), 
	.INDEX(0),
	.INPUTS(INPUTS),
	.OUTPUTS(OUTPUTS),
	.DATA_WIDTH(DATA_WIDTH),
	.TYPE_WIDTH(TYPE_WIDTH),
	.REQUEST_WIDTH(REQUEST_WIDTH),
	.FlitPerPacket(FlitPerPacket),
	.PhitPerFlit(PhitPerFlit),
	.FIFO_DEPTH(FIFO_DEPTH)
	) router0

	(.clk(clk),
	.rst(rst),

	.data_in({data_in01, data_in00}),
	.valid_in({valid_in01, valid_in00}),
	.ready_in({ready_in01, ready_in00}),

	.data_out({data_out01, data_out00}),
	.valid_out({valid_out01, valid_out00}),
	.ready_out({ready_out01, ready_out00})
	);


	Router 
	#(.N(N), 
	.INDEX(1),
	.INPUTS(INPUTS),
	.OUTPUTS(OUTPUTS),
	.DATA_WIDTH(DATA_WIDTH),
	.TYPE_WIDTH(TYPE_WIDTH),
	.REQUEST_WIDTH(REQUEST_WIDTH),
	.FlitPerPacket(FlitPerPacket),
	.PhitPerFlit(PhitPerFlit),
	.FIFO_DEPTH(FIFO_DEPTH)
	) router1

	(.clk(clk),
	.rst(rst),

	.data_in({data_in11, data_in10}),
	.valid_in({valid_in11, valid_in10}),
	.ready_in({ready_in11, ready_in10}),

	.data_out({data_out11, data_out10}),
	.valid_out({valid_out11, valid_out10}),
	.ready_out({ready_out11, ready_out10})
	);


	always #5 clk = ~clk;

	initial begin

		clk = 1;
		rst = 1;

		valid_in00 = 0;
		valid_in10 = 0;

		ready_out00 = 1;
		ready_out10 = 1;

	end

	initial begin
		#20 rst = 0;

		#20;

		valid_in00 = 1;
		#5;
		
		for(i = 1; i <= 6; i = i + 1)begin
			data_in00 = i;

			if(i == 1)
				data_in00[31 : 30] = 2'd1;
			else if(i == 6)
				data_in00[31 : 30] = 2'd3;
			else 
				data_in00[31 : 30] = 2'd2;

			wait(ready_in00);
			@(posedge clk);
		end

		#100 $finish;
	end

	
endmodule
