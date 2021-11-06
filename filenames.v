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


	reg [31 : 0] Node6_data_in = 0;
	reg Node6_valid_in = 0;
	wire Node6_ready_in;

	reg [31 : 0] Node6_data_out = 0;
	reg Node6_valid_out;
	wire Node6_ready_out=0;


	reg [31 : 0] Node7_data_in = 0;
	reg Node7_valid_in = 0;
	wire Node7_ready_in;

	reg [31 : 0] Node7_data_out = 0;
	reg Node7_valid_out;
	wire Node7_ready_out=0;

	Noc noc (.clk(clk), .rst(rst),
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

	);
	always #5 clk = ~clk;


	initial
	begin
		clk=1;
		rst=1;


		Node0_valid_in = 0;
		reg [31:0] ex0_memory [0:28];
		Node2_valid_in = 0;
		reg [31:0] ex2_memory [0:28];
		Node1_valid_in = 0;
		reg [31:0] ex1_memory [0:28];
		Node4_valid_in = 0;
		reg [31:0] ex4_memory [0:28];
		Node5_valid_in = 0;
		reg [31:0] ex5_memory [0:28];

		#20 rst=0
	end

	integer i0;
	 // initial begin starts
	initial begin
		#45
		Node0_valid_in = 1; 
		$readmemh("input_q.dat",ex0_memory);
	for(j0 = 0; j0 <5; j0= j0 + 1)begin
		for(i0 = 0; i0 < 6; i0= i0 + 1)begin
			
				Node0_data_in=ex0_memory[j0*6+i0];





		end
	end


		#10 Node0_valid_in = 0;
		#15 Node0_valid_in = 1;
	 // initial begin starts
	initial begin
		#45
		Node0_valid_in = 1; 
		$readmemh("input_q.dat",ex0_memory);
	for(j0 = 0; j0 <5; j0= j0 + 1)begin
		for(i0 = 0; i0 < 6; i0= i0 + 1)begin
			
				Node0_data_in=ex0_memory[j0*6+i0];





		end
	end


		#10 Node0_valid_in = 0;
		#15 Node0_valid_in = 1;

	integer i2;
	 // initial begin starts
	initial begin
		#45
		Node2_valid_in = 1; 
		$readmemh("input_q.dat",ex2_memory);
	for(j2 = 0; j2 <5; j2= j2 + 1)begin
		for(i2 = 0; i2 < 6; i2= i2 + 1)begin
			
				Node2_data_in=ex2_memory[j2*6+i2];





		end
	end


		#10 Node2_valid_in = 0;
		#15 Node0_valid_in = 1;
	 // initial begin starts
	initial begin
		#45
		Node2_valid_in = 1; 
		$readmemh("input_q.dat",ex2_memory);
	for(j2 = 0; j2 <5; j2= j2 + 1)begin
		for(i2 = 0; i2 < 6; i2= i2 + 1)begin
			
				Node2_data_in=ex2_memory[j2*6+i2];





		end
	end


		#10 Node2_valid_in = 0;
		#15 Node0_valid_in = 1;

	integer i1;
	 // initial begin starts
	initial begin
		#45
		Node1_valid_in = 1; 
		$readmemh("input_q.dat",ex1_memory);
	for(j1 = 0; j1 <5; j1= j1 + 1)begin
		for(i1 = 0; i1 < 6; i1= i1 + 1)begin
			
				Node1_data_in=ex1_memory[j1*6+i1];





		end
	end


		#10 Node1_valid_in = 0;
		#15 Node0_valid_in = 1;
	 // initial begin starts
	initial begin
		#45
		Node1_valid_in = 1; 
		$readmemh("input_q.dat",ex1_memory);
	for(j1 = 0; j1 <5; j1= j1 + 1)begin
		for(i1 = 0; i1 < 6; i1= i1 + 1)begin
			
				Node1_data_in=ex1_memory[j1*6+i1];





		end
	end


		#10 Node1_valid_in = 0;
		#15 Node0_valid_in = 1;

	integer i4;
	 // initial begin starts
	initial begin
		#45
		Node4_valid_in = 1; 
		$readmemh("input_q.dat",ex4_memory);
	for(j4 = 0; j4 <5; j4= j4 + 1)begin
		for(i4 = 0; i4 < 6; i4= i4 + 1)begin
			
				Node4_data_in=ex4_memory[j4*6+i4];





		end
	end


		#10 Node4_valid_in = 0;
		#15 Node0_valid_in = 1;
	 // initial begin starts
	initial begin
		#45
		Node4_valid_in = 1; 
		$readmemh("input_q.dat",ex4_memory);
	for(j4 = 0; j4 <5; j4= j4 + 1)begin
		for(i4 = 0; i4 < 6; i4= i4 + 1)begin
			
				Node4_data_in=ex4_memory[j4*6+i4];





		end
	end


		#10 Node4_valid_in = 0;
		#15 Node0_valid_in = 1;

	integer i5;
	 // initial begin starts
	initial begin
		#45
		Node5_valid_in = 1; 
		$readmemh("input_q.dat",ex5_memory);
	for(j5 = 0; j5 <5; j5= j5 + 1)begin
		for(i5 = 0; i5 < 6; i5= i5 + 1)begin
			
				Node5_data_in=ex5_memory[j5*6+i5];





		end
	end


		#10 Node5_valid_in = 0;
		#15 Node0_valid_in = 1;
	 // initial begin starts
	initial begin
		#45
		Node5_valid_in = 1; 
		$readmemh("input_q.dat",ex5_memory);
	for(j5 = 0; j5 <5; j5= j5 + 1)begin
		for(i5 = 0; i5 < 6; i5= i5 + 1)begin
			
				Node5_data_in=ex5_memory[j5*6+i5];





		end
	end


		#10 Node5_valid_in = 0;
		#15 Node0_valid_in = 1;



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
