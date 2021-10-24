module NoC_TB;
	reg clk;
	reg rst;

	parameter N = 6;
	parameter INPUTS = 3;
	parameter OUTPUTS = 3;
	parameter DATA_WIDTH = 32;
	parameter REQUEST_WIDTH = 2;
	parameter TYPE_WIDTH = 2;
	parameter FlitPerPacket = 6;//Head + 4Payloads + Tail
	parameter PhitPerFlit = 1;
	parameter FIFO_DEPTH = 16;
	
	reg [31 : 0]Node0_data_in = 0;
	reg Node0_valid_in = 0;
	wire Node0_ready_in;

	wire [31 : 0]Node0_data_out;
	wire Node0_valid_out;
	reg Node0_ready_out = 0;

	reg [31 : 0]Node1_data_in = 0;
	reg Node1_valid_in = 0;
	wire Node1_ready_in;

	wire [31 : 0]Node1_data_out;
	wire Node1_valid_out;
	reg Node1_ready_out = 0;

	reg [31 : 0]Node2_data_in = 0;
	reg Node2_valid_in = 0;
	wire Node2_ready_in;

	wire [31 : 0]Node2_data_out;
	wire Node2_valid_out;
	reg Node2_ready_out = 0;

	reg [31 : 0]Node3_data_in = 0;
	reg Node3_valid_in = 0;
	wire Node3_ready_in;

	wire [31 : 0]Node3_data_out;
	wire Node3_valid_out;
	reg Node3_ready_out = 0;

	reg [31 : 0]Node4_data_in = 0;
	reg Node4_valid_in = 0;
	wire Node4_ready_in;

	wire [31 : 0]Node4_data_out;
	wire Node4_valid_out;
	reg Node4_ready_out = 0;

	reg [31 : 0]Node5_data_in = 0;
	reg Node5_valid_in = 0;
	wire Node5_ready_in;

	wire [31 : 0]Node5_data_out;
	wire Node5_valid_out;
	reg Node5_ready_out = 0;
	
	NoC noc (.clk(clk), .rst(rst),
	.Node0_data_in(Node0_data_in), .Node0_valid_in(Node0_valid_in), .Node0_ready_in(Node0_ready_in),
	.Node0_data_out(Node0_data_out), .Node0_valid_out(Node0_valid_out), .Node0_ready_out(Node0_ready_out),
	
	.Node1_data_in(Node1_data_in), .Node1_valid_in(Node1_valid_in), .Node1_ready_in(Node1_ready_in),
	.Node1_data_out(Node1_data_out), .Node1_valid_out(Node1_valid_out), .Node1_ready_out(Node1_ready_out),
	
	.Node2_data_in(Node2_data_in), .Node2_valid_in(Node2_valid_in), .Node2_ready_in(Node2_ready_in),
	.Node2_data_out(Node2_data_out), .Node2_valid_out(Node2_valid_out), .Node2_ready_out(Node2_ready_out),
	
	.Node3_data_in(Node3_data_in), .Node3_valid_in(Node3_valid_in), .Node3_ready_in(Node3_ready_in),
	.Node3_data_out(Node3_data_out), .Node3_valid_out(Node3_valid_out), .Node3_ready_out(Node3_ready_out),
	
	.Node4_data_in(Node4_data_in), .Node4_valid_in(Node4_valid_in), .Node4_ready_in(Node4_ready_in),
	.Node4_data_out(Node4_data_out), .Node4_valid_out(Node4_valid_out), .Node4_ready_out(Node4_ready_out),
	
	.Node5_data_in(Node5_data_in), .Node5_valid_in(Node5_valid_in), .Node5_ready_in(Node5_ready_in),
	.Node5_data_out(Node5_data_out), .Node5_valid_out(Node5_valid_out), .Node5_ready_out(Node5_ready_out)
	);

/*
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
	
	*/


	always #5 clk = ~clk;

	initial begin

		clk = 1;
		rst = 1;

		Node0_valid_in = 0;
		Node1_valid_in = 0;
		
		#20 rst = 0;

	end

	integer i0;
	//Node0 Input Starts
	initial begin:Node0Input
		#20;
		#20;

		//#5;
		Node0_valid_in = 1;
		
		for(i0 = 1; i0 <= 6; i0 = i0 + 1)begin
			if(i0 == 1)begin//Routing destination fed into head flit
				Node0_data_in = 3'd5;
			end
			else 
				Node0_data_in = i0 + 16;

			if(i0 == 1)begin
				Node0_data_in[31 : 30] = 2'd1;
				
			end
			else if(i0 == 6)
				Node0_data_in[31 : 30] = 2'd3;
			else 
				Node0_data_in[31 : 30] = 2'd2;
			
			if(i0 == 1)
				@(negedge Node0_ready_in);
			else wait(Node0_ready_in);
			@(posedge clk);
		end

		#10 Node0_valid_in = 0;
	end


	integer i1;
	//Node1 Input Starts
	initial begin
		#20;
		#20;

		//#5;
		Node1_valid_in = 1;
		
		for(i1 = 1; i1 <= 6; i1 = i1 + 1)begin
			if(i1 == 1)begin//Routing destination fed into head flit
				Node1_data_in = 3'd4;
			end
			else 
				Node1_data_in = i1 + 32;

			if(i1 == 1)begin
				Node1_data_in[31 : 30] = 2'd1;
				
			end
			else if(i1 == 6)
				Node1_data_in[31 : 30] = 2'd3;
			else 
				Node1_data_in[31 : 30] = 2'd2;
			
			if(i1 == 1)
				@(negedge Node1_ready_in);
			else wait(Node1_ready_in);
			@(posedge clk);
		end

		#10 Node1_valid_in = 0;
	end
	
	//Node4 Output
	always @(*)begin
		Node4_ready_out = Node4_valid_out;
	end

	//Node5 Output
	always @(*)begin
		Node5_ready_out = Node5_valid_out;
	end

	
endmodule
