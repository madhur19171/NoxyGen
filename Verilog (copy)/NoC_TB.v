module NoC_TB;
	reg clk;
	reg rst;
	integer fd0,fd1,k0,k1;


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


	

	NoC noc (.clk(clk), .rst(rst),
	.Node0_data_in(Node0_data_in),.Node0_valid_in(Node0_valid_in), .Node0_ready_in(Node0_ready_in),
	.Node0_data_out(Node0_data_out),.Node0_valid_out(Node0_valid_out), .Node0_ready_out(Node0_ready_out),

	.Node1_data_in(Node1_data_in),.Node1_valid_in(Node1_valid_in), .Node1_ready_in(Node1_ready_in),
	.Node1_data_out(Node1_data_out),.Node1_valid_out(Node1_valid_out), .Node1_ready_out(Node1_ready_out)

	

	/*.Node9_data_in(Node9_data_in),.Node9_valid_in(Node9_valid_in), .Node9_ready_in(Node9_ready_in),
	.Node9_data_out(Node9_data_out),.Node9_valid_out(Node9_valid_out), .Node9_ready_out(Node9_ready_out),
	.Node10_data_in(Node10_data_in),.Node10_valid_in(Node10_valid_in), .Node10_ready_in(Node10_ready_in),
	.Node10_data_out(Node10_data_out),.Node10_valid_out(Node10_valid_out), .Node10_ready_out(Node10_ready_out),
	.Node11_data_in(Node11_data_in),.Node11_valid_in(Node11_valid_in), .Node11_ready_in(Node11_ready_in),
	.Node11_data_out(Node11_data_out),.Node11_valid_out(Node11_valid_out), .Node11_ready_out(Node11_ready_out)*/

	);
	always #5 clk = ~clk;


	initial
	begin
		clk=1;
		rst=1;

		fd0=$fopen("output0.dat","w");
		fd1=$fopen("output1.dat","w");
		
		/*fd9=$fopen("output9.dat","w");
		fd10=$fopen("output10.dat","w");
		fd11=$fopen("output11.dat","w");*/

		Node0_valid_in = 0;
		Node1_valid_in = 0;
		
		#20 rst=0;
	end
		reg [31:0] ex0_memory [0:5];
		reg [31:0] delay0_memory [0:5];
		reg [31:0] ex1_memory [0:5];
		reg [31:0] delay1_memory [0:5];
		

	integer i0, j0;
	 // initial begin starts
	initial begin
		#45 
		$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/Node0.dat",ex0_memory); 
		//$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/delay0.dat",delay0_memory);
		for(j0 = 0; j0 < 1; j0 = j0 + 1)begin
			Node0_valid_in = 1;
			for(i0 = 0; i0 < 6; i0 = i0 + 1)begin
				Node0_data_in=ex0_memory[j0*6+i0];

				/*for(k0 = 0; k0 < delay0_memory[i0]; k0 = k0 + 1)begin
					#1
				end*/
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
		//$readmemh("/home/ubuntu/Downloads/sim/INPUT_VECTORS/delay1.dat",delay1_memory);
		for(j1 = 0; j1 < 1; j1 = j1 + 1)begin
			Node1_valid_in = 1;
			for(i1 = 0; i1 < 6; i1 = i1 + 1)begin
				Node1_data_in=ex1_memory[j1*6+i1];

				/*for(k1 = 0; k1 < delay1_memory[i1]; k1 = k1 + 1)begin
					#1
				end*/
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



	





		//Node9Output
	always @(*)begin
			 Node0_ready_out = Node0_valid_out;
	end
	always @(posedge clk) begin
		if(Node0_valid_out==1)begin
			$fwriteh(fd0,Node0_data_out);
			$fwriteh(fd0,"\n");
		end
	end

		//Node9Output
	always @(*)begin
			 Node1_ready_out = Node1_valid_out;
	end
	always @(posedge clk) begin
		if(Node1_valid_out==1)begin
			$fwriteh(fd1,Node0_data_out);
			$fwriteh(fd1,"\n");
		end
	end

		//Node9Output
	

	initial begin
		$dumpfile("Noc.vcd");
		$dumpvars(0,NoC_TB); // Dump all the signals
		#1000 $finish;
	end
endmodule
