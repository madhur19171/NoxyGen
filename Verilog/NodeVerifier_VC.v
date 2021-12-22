`ifdef VC
module NodeVerifier
	#(parameter ID = 0,
	parameter N = 9,
	parameter dataInputFilePath = "",
	parameter delayInputFilePath = "",
	parameter outputFilePath = "",
	parameter VC = 4,
	parameter FlitsPerPacket = 16,
	parameter numberOfPackets = 16
	)
	(
	input clk, 
	input rst,
	//This channel feeds data into to router node
	output [31 : 0]data_in, 
	output valid_in, 
	input ready_in,
	
	//This channel Reads output from router node
	input [31 : 0] data_out,
	input valid_out,
	output reg ready_out = 0
	);
	
	localparam DIM = $floor($sqrt(N));
	
	integer fd;
	reg [31 : 0] ex_memory [0 : numberOfPackets * FlitsPerPacket - 1];
	reg [31 : 0] delay_memory [0 : numberOfPackets * FlitsPerPacket - 1];
	
	reg [31 : 0] data_in_0 = 0, data_in_1 = 0, data_in_2 = 0, data_in_3 = 0;
	reg valid_in_0 = 0, valid_in_1 = 0, valid_in_2 = 0, valid_in_3 = 0;
	wire ready_in_0, ready_in_1, ready_in_2, ready_in_3; 
	
	wire [32 * 4 - 1 : 0] data_in_vec;
	wire [3 : 0] valid_in_vec;
	
	reg [63 : 0] timeCounter = 0; 
	
	reg [2:0]counter = 0;
	
	assign data_in_vec = {data_in_3, data_in_2, data_in_1, data_in_0};
	assign valid_in_vec = {valid_in_3, valid_in_2, valid_in_1, valid_in_0};
	assign data_in = data_in_vec[counter * 32 +: 32];
	assign valid_in = valid_in_vec[counter];
	
	assign ready_in_0 = ready_in & counter == 0;
	assign ready_in_1 = ready_in & counter == 1;
	assign ready_in_2 = ready_in & counter == 2;
	assign ready_in_3 = ready_in & counter == 3;
	
	always @(posedge clk, posedge rst)begin
		if(rst)
			timeCounter <= 0;
		else
			timeCounter <= timeCounter + 1;
	end
	
	always @(posedge clk, posedge rst)begin
		if(rst)
			counter <= 0;
		else if(counter == VC - 1)
			counter <= 0;
		else
			counter <= counter + 1;
	end
	
	integer i0, j0, k0;
	
	reg t0 = 0;
	wire tw0;
	assign #1 tw0 = t0 & clk;
	always @(posedge clk)begin
		t0 <= 0;
		if(valid_in_0 & ready_in_0)
			t0 <= 1;
	end
	
	 // initial begin starts
	initial begin
		#85;
		for(j0 = 0; j0 < numberOfPackets; j0 = j0 + 4)begin
			#1 valid_in_0 = 1;
			for(i0 = 0; i0 < FlitsPerPacket; i0 = i0 + 1)begin
				#1 data_in_0 = ex_memory[j0 * FlitsPerPacket + i0];
				valid_in_0 = 1;
				if(i0 == 0) begin
					$display("Node%0d: Message: %0d Destination: %0d Departure_Time: %0d", ID, (data_in_0[29 : 16] + 1), data_in_0[3:0] * DIM + data_in_0[7 : 4], timeCounter);
				end
				
				#1;
				
				wait(tw0);
				
				#1 valid_in_0 = 0;

				for(k0 = 0; k0 < delay_memory[i0]; k0 = k0 + 1)begin
					#1;
				end
				@(negedge clk);
			end
		end
	end
	
	integer i1, j1, k1;
	reg t1 = 0;
	wire tw1;
	assign #1 tw1 = t1 & clk;
	always @(posedge clk)begin
		t1 <= 0;
		if(valid_in_1 & ready_in_1)
			t1 <= 1;
	end


	 // initial begin starts
	initial begin
		#85;
		for(j1 = 1; j1 < numberOfPackets; j1 = j1 + 4)begin
			#1 valid_in_1 = 1;
			for(i1 = 0; i1 < FlitsPerPacket; i1 = i1 + 1)begin
				#1 data_in_1 = ex_memory[j1 * FlitsPerPacket + i1];
				valid_in_1 = 1;
				if(i1 == 0) begin
					$display("Node%0d: Message: %0d Destination: %0d Departure_Time: %0d", ID, (data_in_1[29 : 16] + 1), data_in_1[3:0] * DIM + data_in_1[7 : 4], timeCounter);
				end
				
				#1;
				
				wait(tw1);
				
				#1 valid_in_1 = 0;

				for(k1 = 0; k1 < delay_memory[i1]; k1 = k1 + 1)begin
					#1;
				end
				@(negedge clk);
			end
		end
	end
	
	integer i2, j2, k2;
	reg t2 = 0;
	wire tw2;
	assign #1 tw2 = t2 & clk;
	always @(posedge clk)begin
		t2 <= 0;
		if(valid_in_2 & ready_in_2)
			t2 <= 1;
	end
	
	 // initial begin starts
	initial begin
		#85;
		for(j2 = 2; j2 < numberOfPackets; j2 = j2 + 4)begin
			#1 valid_in_2 = 1;
			for(i2 = 0; i2 < FlitsPerPacket; i2 = i2 + 1)begin
				#1 data_in_2 = ex_memory[j2 * FlitsPerPacket + i2];
				valid_in_2 = 1;
				if(i2 == 0) begin
					$display("Node%0d: Message: %0d Destination: %0d Departure_Time: %0d", ID, (data_in_2[29 : 16] + 1), data_in_2[3:0] * DIM + data_in_2[7 : 4], timeCounter);
				end
				
				#1;
				
				wait(tw2);
				
				#1 valid_in_2 = 0;

				for(k2 = 0; k2 < delay_memory[i2]; k2 = k2 + 1)begin
					#1;
				end
				@(negedge clk);
			end
		end
	end
	
	integer i3, j3, k3;
	reg t3 = 0;
	wire tw3;
	assign #1 tw3 = t3 & clk;
	always @(posedge clk)begin
		t3 <= 0;
		if(valid_in_3 & ready_in_3)
			t3 <= 1;
	end
	
	 // initial begin starts
	initial begin
		#85;
		for(j3 = 3; j3 < numberOfPackets; j3 = j3 + 4)begin
			#1 valid_in_3 = 1;
			for(i3 = 0; i3 < FlitsPerPacket; i3 = i3 + 1)begin
				#1 data_in_3 = ex_memory[j3 * FlitsPerPacket + i3];
				valid_in_3 = 1;
				if(i3 == 0) begin
					$display("Node%0d: Message: %0d Destination: %0d Departure_Time: %0d", ID, (data_in_3[29 : 16] + 1), data_in_3[3:0] * DIM + data_in_3[7 : 4], timeCounter);
				end
				
				#1;
				
				wait(tw3);
				
				#1 valid_in_3 = 0;

				for(k3 = 0; k3 < delay_memory[i3]; k3 = k3 + 1)begin
					#1;
				end
				@(negedge clk);
			end
		end
	end
	
	initial begin
		$readmemh(dataInputFilePath, ex_memory); 
		$readmemh(delayInputFilePath, delay_memory);
		fd=$fopen(outputFilePath,"w");
	end
	
	always @(*)
		ready_out = valid_out;
	
	always @(posedge clk) begin
		if(valid_out & ready_out)begin
			if(data_out[31 : 30] == 2'b11)
				$display("Node%0d: Message: %0d Source: %0d Arrival_Time: %0d", ID, (data_out[29 : 16] + 1), data_out[11:8] * DIM + data_out[15 : 12], timeCounter);
			$fwrite(fd, "0x%h", data_out);
			$fwrite(fd,"\n");
		end
	end
endmodule

`elsif NO_VC
module NodeVerifier
	#(parameter ID = 0,
	parameter N = 9,
	parameter dataInputFilePath = "",
	parameter delayInputFilePath = "",
	parameter outputFilePath = "",
	parameter VC = 4,
	parameter FlitsPerPacket = 16,
	parameter numberOfPackets = 16
	)
	(
	input clk, 
	input rst,
	//This channel feeds data into to router node
	output reg [31 : 0]data_in = 0, 
	output reg valid_in = 0, 
	input ready_in,
	
	//This channel Reads output from router node
	input [31 : 0] data_out,
	input valid_out,
	output reg ready_out = 0
	);
	
	localparam DIM = $floor($sqrt(N));
	
	reg [63 : 0] timeCounter = 0; 
	integer fd;
	reg [31 : 0] ex_memory [0 : numberOfPackets * FlitsPerPacket - 1];
	reg [31 : 0] delay_memory [0 : numberOfPackets * FlitsPerPacket - 1];
	
	
	always @(posedge clk, posedge rst)begin
		if(rst)
			timeCounter <= 0;
		else
			timeCounter <= timeCounter + 1;
	end
	
	
	integer i, j, k;
	reg t = 0;
	wire tw;
	assign #1 tw = t & clk;
	always @(posedge clk)begin
		t <= 0;
		if(valid_in & ready_in)
			t <= 1;
	end
	
	 // initial begin starts
	initial begin
		#85;
		for(j = 0; j < numberOfPackets; j = j + 1)begin
			#1 valid_in = 1;
			for(i = 0; i < FlitsPerPacket; i = i + 1)begin
				#1 data_in = ex_memory[j * FlitsPerPacket + i];
				valid_in = 1;
				if(i == 0) begin
					$display("Node%0d: Message: %0d Destination: %0d Departure_Time: %0d", ID, (data_in[29 : 16] + 1), data_in[3:0] * DIM + data_in[7 : 4], timeCounter);
				end
				
				#1;
				
				wait(tw);
				
				#1 valid_in= 0;

				for(k = 0; k < delay_memory[i]; k = k + 1)begin
					#1;
				end
				@(negedge clk);
			end
		end
	end

	
	initial begin
		$readmemh(dataInputFilePath, ex_memory); 
		$readmemh(delayInputFilePath, delay_memory);
		fd=$fopen(outputFilePath,"w");
	end
	
	always @(*)
		ready_out = valid_out;
	
	always @(posedge clk) begin
		if(valid_out & ready_out)begin
		if(data_out[31 : 30] == 2'b11)
				$display("Node%0d: Message: %0d Source: %0d Arrival_Time: %0d", ID, (data_out[29 : 16] + 1), data_out[11:8] * DIM + data_out[15 : 12], timeCounter);
			$fwrite(fd, "0x%h", data_out);
			$fwrite(fd,"\n");
		end
	end
endmodule

`endif
