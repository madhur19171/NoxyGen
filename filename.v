module No_tb;
	reg clk;
	reg rst;



	reg [31 : 0] Node0_data_in = 0;
	reg Node0_valid_in = 0;
	wire Node0_ready_in;

	reg [31 : 0] Node0_data_out = 0;
	reg Node0_valid_out;
	wire Node0_ready_out=0;


	reg [31 : 0] Node1_data_in = 0;
	reg Node1_valid_in = 0;
	wire Node1_ready_in;

	reg [31 : 0] Node1_data_out = 0;
	reg Node1_valid_out;
	wire Node1_ready_out=0;


	reg [31 : 0] Node2_data_in = 0;
	reg Node2_valid_in = 0;
	wire Node2_ready_in;

	reg [31 : 0] Node2_data_out = 0;
	reg Node2_valid_out;
	wire Node2_ready_out=0;


	reg [31 : 0] Node3_data_in = 0;
	reg Node3_valid_in = 0;
	wire Node3_ready_in;

	reg [31 : 0] Node3_data_out = 0;
	reg Node3_valid_out;
	wire Node3_ready_out=0;


	reg [31 : 0] Node4_data_in = 0;
	reg Node4_valid_in = 0;
	wire Node4_ready_in;

	reg [31 : 0] Node4_data_out = 0;
	reg Node4_valid_out;
	wire Node4_ready_out=0;


	reg [31 : 0] Node5_data_in = 0;
	reg Node5_valid_in = 0;
	wire Node5_ready_in;

	reg [31 : 0] Node5_data_out = 0;
	reg Node5_valid_out;
	wire Node5_ready_out=0;

	Noc noc (.clk(clk), .rst(rst),
	.Node0_data_in(Node0_data_in),Node0_valid_in(Node0_valid_in), .Node0_ready_in(Node0_ready_in),
	.Node0_data_out(Node0_data_out),Node0_valid_out(Node0_valid_out), .Node0_ready_out(Node0_ready_out),

	.Node1_data_in(Node1_data_in),Node1_valid_in(Node1_valid_in), .Node1_ready_in(Node1_ready_in),
	.Node1_data_out(Node1_data_out),Node1_valid_out(Node1_valid_out), .Node1_ready_out(Node1_ready_out),

	.Node2_data_in(Node2_data_in),Node2_valid_in(Node2_valid_in), .Node2_ready_in(Node2_ready_in),
	.Node2_data_out(Node2_data_out),Node2_valid_out(Node2_valid_out), .Node2_ready_out(Node2_ready_out),

	.Node3_data_in(Node3_data_in),Node3_valid_in(Node3_valid_in), .Node3_ready_in(Node3_ready_in),
	.Node3_data_out(Node3_data_out),Node3_valid_out(Node3_valid_out), .Node3_ready_out(Node3_ready_out),

	.Node4_data_in(Node4_data_in),Node4_valid_in(Node4_valid_in), .Node4_ready_in(Node4_ready_in),
	.Node4_data_out(Node4_data_out),Node4_valid_out(Node4_valid_out), .Node4_ready_out(Node4_ready_out),

	.Node5_data_in(Node5_data_in),Node5_valid_in(Node5_valid_in), .Node5_ready_in(Node5_ready_in),
	.Node5_data_out(Node5_data_out),Node5_valid_out(Node5_valid_out), .Node5_ready_out(Node5_ready_out),

	);
	always #5 clk = ~clk;


	initial
	begin
		clk=1;
		rst=1;


		Node0_valid_in = 0;
		Node2_valid_in = 0;
		Node1_valid_in = 0;
		Node4_valid_in = 0;
		Node5_valid_in = 0;

		#20 rst=0
	end

	integer i0;
	 // initial begin starts
	initial begin
		#45
		Node0_valid_in = 1;
		for(i0 = 1; i0 <= 6; i0= i0 + 1)begin
				if(i0 == 1)begin//Routing destination fed into head flit
					Node0_data_in=3'd5
				end
				else
					Node0_data_in = i0 + 16;
				if(i0 == 1) begin
					Node0_data_in[31:30] = 2'd1;
				end
				else if (i0 == 6)
					Node0_data_in[31:30] =2'd3;
				else
					Node0_data_in[31:30] = 2'd2
				if(i0 == 1)
					@(negedge Node0_ready_in);
				else wait(Node0_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end


		#10 Node0_valid_in = 0;
		#15 Node0_valid_in = 1;
		for(i0 = 1; i0 <= 6; i0= i0 + 1)begin
				if(i0 == 1)begin//Routing destination fed into head flit
					Node0_data_in=3'd4
				end
				else
					Node0_data_in = i0 + 64;
				if(i0 == 1) begin
					Node0_data_in[31:30] = 2'd1;
				end
				else if (i0 == 6)
					Node0_data_in[31:30] =2'd3;
				else
					Node0_data_in[31:30] = 2'd2
				if(i0 == 1)
					@(negedge Node0_ready_in);
				else wait(Node0_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end

	integer i2;
	 // initial begin starts
	initial begin
		#45
		Node2_valid_in = 1;
		for(i2 = 1; i2 <= 6; i2= i2 + 1)begin
				if(i2 == 1)begin//Routing destination fed into head flit
					Node2_data_in=3'd5
				end
				else
					Node2_data_in = i2 + 16;
				if(i2 == 1) begin
					Node2_data_in[31:30] = 2'd1;
				end
				else if (i2 == 6)
					Node2_data_in[31:30] =2'd3;
				else
					Node2_data_in[31:30] = 2'd2
				if(i2 == 1)
					@(negedge Node2_ready_in);
				else wait(Node0_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end


		#10 Node2_valid_in = 0;
		#15 Node0_valid_in = 1;
		for(i2 = 1; i2 <= 6; i2= i2 + 1)begin
				if(i2 == 1)begin//Routing destination fed into head flit
					Node2_data_in=3'd4
				end
				else
					Node2_data_in = i2 + 64;
				if(i2 == 1) begin
					Node2_data_in[31:30] = 2'd1;
				end
				else if (i2 == 6)
					Node2_data_in[31:30] =2'd3;
				else
					Node2_data_in[31:30] = 2'd2
				if(i2 == 1)
					@(negedge Node2_ready_in);
				else wait(Node0_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end

	integer i1;
	 // initial begin starts
	initial begin
		#45
		Node1_valid_in = 1;
		for(i1 = 1; i1 <= 6; i1= i1 + 1)begin
				if(i1 == 1)begin//Routing destination fed into head flit
					Node1_data_in=3'd5
				end
				else
					Node1_data_in = i1 + 16;
				if(i1 == 1) begin
					Node1_data_in[31:30] = 2'd1;
				end
				else if (i1 == 6)
					Node1_data_in[31:30] =2'd3;
				else
					Node1_data_in[31:30] = 2'd2
				if(i1 == 1)
					@(negedge Node1_ready_in);
				else wait(Node0_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end


		#10 Node1_valid_in = 0;
		#15 Node0_valid_in = 1;
		for(i1 = 1; i1 <= 6; i1= i1 + 1)begin
				if(i1 == 1)begin//Routing destination fed into head flit
					Node1_data_in=3'd4
				end
				else
					Node1_data_in = i1 + 64;
				if(i1 == 1) begin
					Node1_data_in[31:30] = 2'd1;
				end
				else if (i1 == 6)
					Node1_data_in[31:30] =2'd3;
				else
					Node1_data_in[31:30] = 2'd2
				if(i1 == 1)
					@(negedge Node1_ready_in);
				else wait(Node0_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end

	integer i4;
	 // initial begin starts
	initial begin
		#45
		Node4_valid_in = 1;
		for(i4 = 1; i4 <= 6; i4= i4 + 1)begin
				if(i4 == 1)begin//Routing destination fed into head flit
					Node4_data_in=3'd5
				end
				else
					Node4_data_in = i4 + 16;
				if(i4 == 1) begin
					Node4_data_in[31:30] = 2'd1;
				end
				else if (i4 == 6)
					Node4_data_in[31:30] =2'd3;
				else
					Node4_data_in[31:30] = 2'd2
				if(i4 == 1)
					@(negedge Node4_ready_in);
				else wait(Node0_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end


		#10 Node4_valid_in = 0;
		#15 Node0_valid_in = 1;
		for(i4 = 1; i4 <= 6; i4= i4 + 1)begin
				if(i4 == 1)begin//Routing destination fed into head flit
					Node4_data_in=3'd4
				end
				else
					Node4_data_in = i4 + 64;
				if(i4 == 1) begin
					Node4_data_in[31:30] = 2'd1;
				end
				else if (i4 == 6)
					Node4_data_in[31:30] =2'd3;
				else
					Node4_data_in[31:30] = 2'd2
				if(i4 == 1)
					@(negedge Node4_ready_in);
				else wait(Node0_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end

	integer i5;
	 // initial begin starts
	initial begin
		#45
		Node5_valid_in = 1;
		for(i5 = 1; i5 <= 6; i5= i5 + 1)begin
				if(i5 == 1)begin//Routing destination fed into head flit
					Node5_data_in=3'd5
				end
				else
					Node5_data_in = i5 + 16;
				if(i5 == 1) begin
					Node5_data_in[31:30] = 2'd1;
				end
				else if (i5 == 6)
					Node5_data_in[31:30] =2'd3;
				else
					Node5_data_in[31:30] = 2'd2
				if(i5 == 1)
					@(negedge Node5_ready_in);
				else wait(Node0_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end


		#10 Node5_valid_in = 0;
		#15 Node0_valid_in = 1;
		for(i5 = 1; i5 <= 6; i5= i5 + 1)begin
				if(i5 == 1)begin//Routing destination fed into head flit
					Node5_data_in=3'd4
				end
				else
					Node5_data_in = i5 + 64;
				if(i5 == 1) begin
					Node5_data_in[31:30] = 2'd1;
				end
				else if (i5 == 6)
					Node5_data_in[31:30] =2'd3;
				else
					Node5_data_in[31:30] = 2'd2
				if(i5 == 1)
					@(negedge Node5_ready_in);
				else wait(Node0_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end



		//Node5Output
	always @(*)begin
			 Node0_ready_out = Node0_valid_out;
	end
		//Node5Output
	always @(*)begin
			 Node1_ready_out = Node1_valid_out;
	end
		//Node5Output
	always @(*)begin
			 Node2_ready_out = Node2_valid_out;
	end
		//Node5Output
	always @(*)begin
			 Node3_ready_out = Node3_valid_out;
	end
		//Node5Output
	always @(*)begin
			 Node4_ready_out = Node4_valid_out;
	end
		//Node5Output
	always @(*)begin
			 Node5_ready_out = Node5_valid_out;
	end
	initial begin
		$dumpfile("Noc.vcd");
		$dumpvars(0,NoC_TB); // Dump all the signals
		#1000 $finish;
	end
endmodule