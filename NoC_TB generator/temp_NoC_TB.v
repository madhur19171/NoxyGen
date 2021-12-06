module NoC_TB;
	reg clk;
	reg rst;



	reg [31 : 0] Node0_data_in = 0;
	reg Node0_valid_in = 0;
	wire Node0_ready_in;

	wire [31 : 0] Node0_data_out;
	wire Node0_valid_out;
	reg Node0_ready_out = 0;


	reg [31 : 0] Node1_data_in = 0;
	reg Node1_valid_in = 0;
	wire Node1_ready_in;

	wire [31 : 0] Node1_data_out;
	wire Node1_valid_out;
	reg Node1_ready_out = 0;


	reg [31 : 0] Node2_data_in = 0;
	reg Node2_valid_in = 0;
	wire Node2_ready_in;

	wire [31 : 0] Node2_data_out;
	wire Node2_valid_out;
	reg Node2_ready_out = 0;


	reg [31 : 0] Node3_data_in = 0;
	reg Node3_valid_in = 0;
	wire Node3_ready_in;

	wire [31 : 0] Node3_data_out;
	wire Node3_valid_out;
	reg Node3_ready_out = 0;


	reg [31 : 0] Node4_data_in = 0;
	reg Node4_valid_in = 0;
	wire Node4_ready_in;

	wire [31 : 0] Node4_data_out;
	wire Node4_valid_out;
	reg Node4_ready_out = 0;


	reg [31 : 0] Node5_data_in = 0;
	reg Node5_valid_in = 0;
	wire Node5_ready_in;

	wire [31 : 0] Node5_data_out;
	wire Node5_valid_out;
	reg Node5_ready_out = 0;


	reg [31 : 0] Node6_data_in = 0;
	reg Node6_valid_in = 0;
	wire Node6_ready_in;

	wire [31 : 0] Node6_data_out;
	wire Node6_valid_out;
	reg Node6_ready_out = 0;


	reg [31 : 0] Node7_data_in = 0;
	reg Node7_valid_in = 0;
	wire Node7_ready_in;

	wire [31 : 0] Node7_data_out;
	wire Node7_valid_out;
	reg Node7_ready_out = 0;


	reg [31 : 0] Node8_data_in = 0;
	reg Node8_valid_in = 0;
	wire Node8_ready_in;

	wire [31 : 0] Node8_data_out;
	wire Node8_valid_out;
	reg Node8_ready_out = 0;


	reg [31 : 0] Node9_data_in = 0;
	reg Node9_valid_in = 0;
	wire Node9_ready_in;

	wire [31 : 0] Node9_data_out;
	wire Node9_valid_out;
	reg Node9_ready_out = 0;


	reg [31 : 0] Node10_data_in = 0;
	reg Node10_valid_in = 0;
	wire Node10_ready_in;

	wire [31 : 0] Node10_data_out;
	wire Node10_valid_out;
	reg Node10_ready_out = 0;


	reg [31 : 0] Node11_data_in = 0;
	reg Node11_valid_in = 0;
	wire Node11_ready_in;

	wire [31 : 0] Node11_data_out;
	wire Node11_valid_out;
	reg Node11_ready_out = 0;

	NoC noc (.clk(clk), .rst(rst),
	.Node0_data_in(Node0_data_in),.Node0_valid_in(Node0_valid_in), .Node0_ready_in(Node0_ready_in),
	.Node0_data_out(Node0_data_out),.Node0_valid_out(Node0_valid_out), .Node0_ready_out(Node0_ready_out),

	.Node1_data_in(Node1_data_in),.Node1_valid_in(Node1_valid_in), .Node1_ready_in(Node1_ready_in),
	.Node1_data_out(Node1_data_out),.Node1_valid_out(Node1_valid_out), .Node1_ready_out(Node1_ready_out),

	.Node2_data_in(Node2_data_in),.Node2_valid_in(Node2_valid_in), .Node2_ready_in(Node2_ready_in),
	.Node2_data_out(Node2_data_out),.Node2_valid_out(Node2_valid_out), .Node2_ready_out(Node2_ready_out),

	.Node3_data_in(Node3_data_in),.Node3_valid_in(Node3_valid_in), .Node3_ready_in(Node3_ready_in),
	.Node3_data_out(Node3_data_out),.Node3_valid_out(Node3_valid_out), .Node3_ready_out(Node3_ready_out),

	.Node4_data_in(Node4_data_in),.Node4_valid_in(Node4_valid_in), .Node4_ready_in(Node4_ready_in),
	.Node4_data_out(Node4_data_out),.Node4_valid_out(Node4_valid_out), .Node4_ready_out(Node4_ready_out),

	.Node5_data_in(Node5_data_in),.Node5_valid_in(Node5_valid_in), .Node5_ready_in(Node5_ready_in),
	.Node5_data_out(Node5_data_out),.Node5_valid_out(Node5_valid_out), .Node5_ready_out(Node5_ready_out),

	.Node6_data_in(Node6_data_in),.Node6_valid_in(Node6_valid_in), .Node6_ready_in(Node6_ready_in),
	.Node6_data_out(Node6_data_out),.Node6_valid_out(Node6_valid_out), .Node6_ready_out(Node6_ready_out),

	.Node7_data_in(Node7_data_in),.Node7_valid_in(Node7_valid_in), .Node7_ready_in(Node7_ready_in),
	.Node7_data_out(Node7_data_out),.Node7_valid_out(Node7_valid_out), .Node7_ready_out(Node7_ready_out),

	.Node8_data_in(Node8_data_in),.Node8_valid_in(Node8_valid_in), .Node8_ready_in(Node8_ready_in),
	.Node8_data_out(Node8_data_out),.Node8_valid_out(Node8_valid_out), .Node8_ready_out(Node8_ready_out),

	.Node9_data_in(Node9_data_in),.Node9_valid_in(Node9_valid_in), .Node9_ready_in(Node9_ready_in),
	.Node9_data_out(Node9_data_out),.Node9_valid_out(Node9_valid_out), .Node9_ready_out(Node9_ready_out),

	.Node10_data_in(Node10_data_in),.Node10_valid_in(Node10_valid_in), .Node10_ready_in(Node10_ready_in),
	.Node10_data_out(Node10_data_out),.Node10_valid_out(Node10_valid_out), .Node10_ready_out(Node10_ready_out),

	.Node11_data_in(Node11_data_in),.Node11_valid_in(Node11_valid_in), .Node11_ready_in(Node11_ready_in),
	.Node11_data_out(Node11_data_out),.Node11_valid_out(Node11_valid_out), .Node11_ready_out(Node11_ready_out)

	);
	always #5 clk = ~clk;


	initial
	begin
		clk=1;
		rst=1;

		fd0=$fopen("output0.dat","w");
		fd1=$fopen("output1.dat","w");
		fd2=$fopen("output2.dat","w");
		fd3=$fopen("output3.dat","w");
		fd4=$fopen("output4.dat","w");
		fd5=$fopen("output5.dat","w");
		fd6=$fopen("output6.dat","w");
		fd7=$fopen("output7.dat","w");
		fd8=$fopen("output8.dat","w");
		fd9=$fopen("output9.dat","w");
		fd10=$fopen("output10.dat","w");
		fd11=$fopen("output11.dat","w");

		Node0_valid_in = 0;
		Node1_valid_in = 0;
		Node2_valid_in = 0;
		Node3_valid_in = 0;
		Node4_valid_in = 0;
		Node5_valid_in = 0;
		Node6_valid_in = 0;
		Node7_valid_in = 0;
		Node8_valid_in = 0;

		#20 rst=0;
	end
		reg [31:0] ex0_memory [0:5];
		reg [31:0] delay0_memory [0:5];
		reg [31:0] ex1_memory [0:5];
		reg [31:0] delay1_memory [0:5];
		reg [31:0] ex2_memory [0:5];
		reg [31:0] delay2_memory [0:5];
		reg [31:0] ex3_memory [0:5];
		reg [31:0] delay3_memory [0:5];
		reg [31:0] ex4_memory [0:5];
		reg [31:0] delay4_memory [0:5];
		reg [31:0] ex5_memory [0:5];
		reg [31:0] delay5_memory [0:5];
		reg [31:0] ex6_memory [0:5];
		reg [31:0] delay6_memory [0:5];
		reg [31:0] ex7_memory [0:5];
		reg [31:0] delay7_memory [0:5];
		reg [31:0] ex8_memory [0:5];
		reg [31:0] delay8_memory [0:5];

	integer i0, j0;
	 // initial begin starts
	initial begin
		#45 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/Node0.dat",ex0_memory); 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/delay0.dat",delay0_memory);
		for(j0 = 0; j0 < 1; j0 = j0 + 1)begin
			Node0_valid_in = 1;
			for(i0 = 0; i0 < 6; i0 = i0 + 1)begin
				Node0_data_in=ex0_memory[j0*6+i0];

				for(k0 = 0; k0 < delay0_memory[i0]; k0 = k0 + 1)begin
					#1
				end
				if(i0 == 0) begin
					$display("Node0: Message: %d	Destination: %d", (j0 + 1), Node0_data_in[3:0]);
					@(negedge Node0_ready_in);
				end
				else wait(Node0_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end
			#5 Node0_valid_in = 0;
		end
	end



	integer i1, j1;
	 // initial begin starts
	initial begin
		#45 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/Node1.dat",ex1_memory); 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/delay1.dat",delay1_memory);
		for(j1 = 0; j1 < 1; j1 = j1 + 1)begin
			Node1_valid_in = 1;
			for(i1 = 0; i1 < 6; i1 = i1 + 1)begin
				Node1_data_in=ex1_memory[j1*6+i1];

				for(k1 = 0; k1 < delay1_memory[i1]; k1 = k1 + 1)begin
					#1
				end
				if(i1 == 0) begin
					$display("Node1: Message: %d	Destination: %d", (j1 + 1), Node1_data_in[3:0]);
					@(negedge Node1_ready_in);
				end
				else wait(Node1_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end
			#5 Node1_valid_in = 0;
		end
	end



	integer i2, j2;
	 // initial begin starts
	initial begin
		#45 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/Node2.dat",ex2_memory); 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/delay2.dat",delay2_memory);
		for(j2 = 0; j2 < 1; j2 = j2 + 1)begin
			Node2_valid_in = 1;
			for(i2 = 0; i2 < 6; i2 = i2 + 1)begin
				Node2_data_in=ex2_memory[j2*6+i2];

				for(k2 = 0; k2 < delay2_memory[i2]; k2 = k2 + 1)begin
					#1
				end
				if(i2 == 0) begin
					$display("Node2: Message: %d	Destination: %d", (j2 + 1), Node2_data_in[3:0]);
					@(negedge Node2_ready_in);
				end
				else wait(Node2_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end
			#5 Node2_valid_in = 0;
		end
	end



	integer i3, j3;
	 // initial begin starts
	initial begin
		#45 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/Node3.dat",ex3_memory); 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/delay3.dat",delay3_memory);
		for(j3 = 0; j3 < 1; j3 = j3 + 1)begin
			Node3_valid_in = 1;
			for(i3 = 0; i3 < 6; i3 = i3 + 1)begin
				Node3_data_in=ex3_memory[j3*6+i3];

				for(k3 = 0; k3 < delay3_memory[i3]; k3 = k3 + 1)begin
					#1
				end
				if(i3 == 0) begin
					$display("Node3: Message: %d	Destination: %d", (j3 + 1), Node3_data_in[3:0]);
					@(negedge Node3_ready_in);
				end
				else wait(Node3_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end
			#5 Node3_valid_in = 0;
		end
	end



	integer i4, j4;
	 // initial begin starts
	initial begin
		#45 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/Node4.dat",ex4_memory); 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/delay4.dat",delay4_memory);
		for(j4 = 0; j4 < 1; j4 = j4 + 1)begin
			Node4_valid_in = 1;
			for(i4 = 0; i4 < 6; i4 = i4 + 1)begin
				Node4_data_in=ex4_memory[j4*6+i4];

				for(k4 = 0; k4 < delay4_memory[i4]; k4 = k4 + 1)begin
					#1
				end
				if(i4 == 0) begin
					$display("Node4: Message: %d	Destination: %d", (j4 + 1), Node4_data_in[3:0]);
					@(negedge Node4_ready_in);
				end
				else wait(Node4_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end
			#5 Node4_valid_in = 0;
		end
	end



	integer i5, j5;
	 // initial begin starts
	initial begin
		#45 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/Node5.dat",ex5_memory); 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/delay5.dat",delay5_memory);
		for(j5 = 0; j5 < 1; j5 = j5 + 1)begin
			Node5_valid_in = 1;
			for(i5 = 0; i5 < 6; i5 = i5 + 1)begin
				Node5_data_in=ex5_memory[j5*6+i5];

				for(k5 = 0; k5 < delay5_memory[i5]; k5 = k5 + 1)begin
					#1
				end
				if(i5 == 0) begin
					$display("Node5: Message: %d	Destination: %d", (j5 + 1), Node5_data_in[3:0]);
					@(negedge Node5_ready_in);
				end
				else wait(Node5_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end
			#5 Node5_valid_in = 0;
		end
	end



	integer i6, j6;
	 // initial begin starts
	initial begin
		#45 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/Node6.dat",ex6_memory); 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/delay6.dat",delay6_memory);
		for(j6 = 0; j6 < 1; j6 = j6 + 1)begin
			Node6_valid_in = 1;
			for(i6 = 0; i6 < 6; i6 = i6 + 1)begin
				Node6_data_in=ex6_memory[j6*6+i6];

				for(k6 = 0; k6 < delay6_memory[i6]; k6 = k6 + 1)begin
					#1
				end
				if(i6 == 0) begin
					$display("Node6: Message: %d	Destination: %d", (j6 + 1), Node6_data_in[3:0]);
					@(negedge Node6_ready_in);
				end
				else wait(Node6_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end
			#5 Node6_valid_in = 0;
		end
	end



	integer i7, j7;
	 // initial begin starts
	initial begin
		#45 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/Node7.dat",ex7_memory); 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/delay7.dat",delay7_memory);
		for(j7 = 0; j7 < 1; j7 = j7 + 1)begin
			Node7_valid_in = 1;
			for(i7 = 0; i7 < 6; i7 = i7 + 1)begin
				Node7_data_in=ex7_memory[j7*6+i7];

				for(k7 = 0; k7 < delay7_memory[i7]; k7 = k7 + 1)begin
					#1
				end
				if(i7 == 0) begin
					$display("Node7: Message: %d	Destination: %d", (j7 + 1), Node7_data_in[3:0]);
					@(negedge Node7_ready_in);
				end
				else wait(Node7_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end
			#5 Node7_valid_in = 0;
		end
	end



	integer i8, j8;
	 // initial begin starts
	initial begin
		#45 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/Node8.dat",ex8_memory); 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/delay8.dat",delay8_memory);
		for(j8 = 0; j8 < 1; j8 = j8 + 1)begin
			Node8_valid_in = 1;
			for(i8 = 0; i8 < 6; i8 = i8 + 1)begin
				Node8_data_in=ex8_memory[j8*6+i8];

				for(k8 = 0; k8 < delay8_memory[i8]; k8 = k8 + 1)begin
					#1
				end
				if(i8 == 0) begin
					$display("Node8: Message: %d	Destination: %d", (j8 + 1), Node8_data_in[3:0]);
					@(negedge Node8_ready_in);
				end
				else wait(Node8_ready_in);
				@(posedge clk);
					`ifdef VIVADO
						@(negedge clk);
					`endif
			end
			#5 Node8_valid_in = 0;
		end
	end





		//Node9Output
	always @(*)begin
			 Node0_ready_out = Node0_valid_out;
	end
	always @(posedge clk) begin
		if(Node0_valid_out==1)begin
			$fwriteh(fd0,Node0_data_out);
			$fwriteh(fd,"\n");
		end
	end

		//Node9Output
	always @(*)begin
			 Node1_ready_out = Node1_valid_out;
	end
	always @(posedge clk) begin
		if(Node1_valid_out==1)begin
			$fwriteh(fd1,Node0_data_out);
			$fwriteh(fd,"\n");
		end
	end

		//Node9Output
	always @(*)begin
			 Node2_ready_out = Node2_valid_out;
	end
	always @(posedge clk) begin
		if(Node2_valid_out==1)begin
			$fwriteh(fd2,Node0_data_out);
			$fwriteh(fd,"\n");
		end
	end

		//Node9Output
	always @(*)begin
			 Node3_ready_out = Node3_valid_out;
	end
	always @(posedge clk) begin
		if(Node3_valid_out==1)begin
			$fwriteh(fd3,Node0_data_out);
			$fwriteh(fd,"\n");
		end
	end

		//Node9Output
	always @(*)begin
			 Node4_ready_out = Node4_valid_out;
	end
	always @(posedge clk) begin
		if(Node4_valid_out==1)begin
			$fwriteh(fd4,Node0_data_out);
			$fwriteh(fd,"\n");
		end
	end

		//Node9Output
	always @(*)begin
			 Node5_ready_out = Node5_valid_out;
	end
	always @(posedge clk) begin
		if(Node5_valid_out==1)begin
			$fwriteh(fd5,Node0_data_out);
			$fwriteh(fd,"\n");
		end
	end

		//Node9Output
	always @(*)begin
			 Node6_ready_out = Node6_valid_out;
	end
	always @(posedge clk) begin
		if(Node6_valid_out==1)begin
			$fwriteh(fd6,Node0_data_out);
			$fwriteh(fd,"\n");
		end
	end

		//Node9Output
	always @(*)begin
			 Node7_ready_out = Node7_valid_out;
	end
	always @(posedge clk) begin
		if(Node7_valid_out==1)begin
			$fwriteh(fd7,Node0_data_out);
			$fwriteh(fd,"\n");
		end
	end

		//Node9Output
	always @(*)begin
			 Node8_ready_out = Node8_valid_out;
	end
	always @(posedge clk) begin
		if(Node8_valid_out==1)begin
			$fwriteh(fd8,Node0_data_out);
			$fwriteh(fd,"\n");
		end
	end

	initial begin
		$dumpfile("Noc.vcd");
		$dumpvars(0,NoC_TB); // Dump all the signals
		#1000 $finish;
	end
endmodule
