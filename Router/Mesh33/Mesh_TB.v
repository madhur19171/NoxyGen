`define VIVADO

module NoC_TB;
	reg clk;
	reg rst;
	
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

	reg [31 : 0]Node6_data_in = 0;
	reg Node6_valid_in = 0;
	wire Node6_ready_in;

	wire [31 : 0]Node6_data_out;
	wire Node6_valid_out;
	reg Node6_ready_out = 0;

	reg [31 : 0]Node7_data_in = 0;
	reg Node7_valid_in = 0;
	wire Node7_ready_in;

	wire [31 : 0]Node7_data_out;
	wire Node7_valid_out;
	reg Node7_ready_out = 0;

	reg [31 : 0]Node8_data_in = 0;
	reg Node8_valid_in = 0;
	wire Node8_ready_in;

	wire [31 : 0]Node8_data_out;
	wire Node8_valid_out;
	reg Node8_ready_out = 0;

	
	Mesh33 noc (.clk(clk), .rst(rst),
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
	.Node5_data_out(Node5_data_out), .Node5_valid_out(Node5_valid_out), .Node5_ready_out(Node5_ready_out),
	
	.Node6_data_in(Node6_data_in), .Node6_valid_in(Node6_valid_in), .Node6_ready_in(Node6_ready_in),
	.Node6_data_out(Node6_data_out), .Node6_valid_out(Node6_valid_out), .Node6_ready_out(Node6_ready_out),

	.Node7_data_in(Node7_data_in), .Node7_valid_in(Node7_valid_in), .Node7_ready_in(Node7_ready_in),
	.Node7_data_out(Node7_data_out), .Node7_valid_out(Node7_valid_out), .Node7_ready_out(Node7_ready_out),

	.Node8_data_in(Node8_data_in), .Node8_valid_in(Node8_valid_in), .Node8_ready_in(Node8_ready_in),
	.Node8_data_out(Node8_data_out), .Node8_valid_out(Node8_valid_out), .Node8_ready_out(Node8_ready_out)

	);

	always #5 clk = ~clk;

	initial begin

		clk = 1;
		rst = 1;

		Node0_valid_in = 0;
		Node1_valid_in = 0;
		Node5_valid_in = 0;
		Node8_valid_in = 0;
		
		#20 rst = 0;

	end

	integer src = 0, dest = 0;
	integer i0;
	//Node0 Input Starts
	initial begin
		#20;
		#20;

		#5;
		Node0_valid_in = 1;
		
		for(i0 = 1; i0 <= 6; i0 = i0 + 1)begin
			if(i0 == 1)begin//Routing destination fed into head flit
				dest = 7;
				src = 0;
				Node0_data_in = (src << 4) | dest;//Source Destination in Head Flit
				
			end
			else 
				Node0_data_in = i0 + 16;//Payload data generation

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
//			`ifdef VIVADO
//			     @(negedge clk);//Vivado has some problem in scheduling data change at posedge trigger, so we provide new data at negedge
//					//so that Vivado has enough time to setup the data.
//			`endif
		end

		#10 Node0_valid_in = 0;
		
		#15 Node0_valid_in = 1;
		
		for(i0 = 1; i0 <= 6; i0 = i0 + 1)begin
			if(i0 == 1)begin//Routing destination fed into head flit
				dest = 5;
				src = 0;
				Node0_data_in = (src << 4) | dest;//Source Destination in Head Flit
			end
			else 
				Node0_data_in = i0 + 32;

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
//			`ifdef VIVADO
//			     @(negedge clk);//Vivado has some problem in scheduling data change at posedge trigger, so we provide new data at negedge
//					//so that Vivado has enough time to setup the data.
//			`endif
		end
		
		#10 Node0_valid_in = 0;
	end


	integer i1;
	//Node1 Input Starts
	initial begin
		#20;
		#20;

		#5;
		Node1_valid_in = 1;
		
		for(i1 = 1; i1 <= 6; i1 = i1 + 1)begin
			if(i1 == 1)begin//Routing destination fed into head flit
				dest = 8;
				src = 1;
				Node1_data_in = (src << 4) | dest;//Source Destination in Head Flit
			end
			else 
				Node1_data_in = i1 + 48;

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
//			`ifdef VIVADO
//			     @(negedge clk);//Vivado has some problem in scheduling data change at posedge trigger, so we provide new data at negedge
//					//so that Vivado has enough time to setup the data.
//			`endif
		end

		#10 Node1_valid_in = 0;
	end
	
	
	integer i5;
	//Node5 Input Starts
	initial begin
		#20;
		#20;

		#5;
		Node5_valid_in = 1;
		
		for(i5 = 1; i5 <= 6; i5 = i5 + 1)begin
			if(i5 == 1)begin//Routing destination fed into head flit
				dest = 2;
				src = 5;
				Node5_data_in = (src << 4) | dest;//Source Destination in Head Flit
			end
			else 
				Node5_data_in = i5 + 64;

			if(i5 == 1)begin
				Node5_data_in[31 : 30] = 2'd1;
				
			end
			else if(i5 == 6)
				Node5_data_in[31 : 30] = 2'd3;
			else 
				Node5_data_in[31 : 30] = 2'd2;
			
			if(i5 == 1)
				@(negedge Node5_ready_in);
			else wait(Node5_ready_in);
			@(posedge clk);
//			`ifdef VIVADO
//			     @(negedge clk);//Vivado has some problem in scheduling data change at posedge trigger, so we provide new data at negedge
//					//so that Vivado has enough time to setup the data.
//			`endif
		end

		#10 Node5_valid_in = 0;
	end
	
	integer i8;
	//Node5 Input Starts
	initial begin
		#20;
		#20;

		#5;
		Node8_valid_in = 1;
		
		for(i8 = 1; i8 <= 6; i8 = i8 + 1)begin
			if(i8 == 1)begin//Routing destination fed into head flit
				dest = 3;
				src = 8;
				Node8_data_in = (src << 4) | dest;//Source Destination in Head Flit
			end
			else 
				Node8_data_in = i8 + 80;

			if(i8 == 1)begin
				Node8_data_in[31 : 30] = 2'd1;
				
			end
			else if(i8 == 6)
				Node8_data_in[31 : 30] = 2'd3;
			else 
				Node8_data_in[31 : 30] = 2'd2;
			
			if(i8 == 1)
				@(negedge Node8_ready_in);
			else wait(Node8_ready_in);
			@(posedge clk);
//			`ifdef VIVADO
//			     @(negedge clk);//Vivado has some problem in scheduling data change at posedge trigger, so we provide new data at negedge
//					//so that Vivado has enough time to setup the data.
//			`endif
		end

		#10 Node8_valid_in = 0;
	end
	
	
	//Node0 Output
	always @(*)begin
		Node0_ready_out = Node0_valid_out;
	end
	
	//Node1 Output
	always @(*)begin
		Node1_ready_out = Node1_valid_out;
	end
	
	//Node2 Output
	always @(*)begin
		Node2_ready_out = Node2_valid_out;
	end
	
	//Node3 Output
	always @(*)begin
		Node3_ready_out = Node3_valid_out;
	end
	
	//Node4 Output
	always @(*)begin
		Node4_ready_out = Node4_valid_out;
	end

	//Node5 Output
	always @(*)begin
		Node5_ready_out = Node5_valid_out;
	end
	
	//Node6 Output
	always @(*)begin
		Node6_ready_out = Node6_valid_out;
	end
	
	//Node7 Output
	always @(*)begin
		Node7_ready_out = Node7_valid_out;
	end

	//Node8 Output
	always @(*)begin
		Node8_ready_out = Node8_valid_out;
	end
	

	initial begin
		$dumpfile("NoC.vcd");
		$dumpvars(0, NoC_TB);//Dump all the signals
		#300 $finish;
	end
	
endmodule
