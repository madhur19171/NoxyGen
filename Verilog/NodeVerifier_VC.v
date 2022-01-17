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
	
	reg [31 : 0] ex_memory_flat [0 : numberOfPackets * FlitsPerPacket - 1];
	reg [31 : 0] delay_memory_flat [0 : numberOfPackets * FlitsPerPacket - 1];
	
	reg [31 : 0]  ex_memory[VC - 1 : 0][0 : numberOfPackets * FlitsPerPacket - 1];
	reg [31 : 0] delay_memory[VC - 1 : 0][0 : numberOfPackets * FlitsPerPacket - 1];
	
	reg [31 : 0] data_in_0 = 0, data_in_1 = 0, data_in_2 = 0, data_in_3 = 0;
	reg valid_in_0 = 0, valid_in_1 = 0, valid_in_2 = 0, valid_in_3 = 0;
	wire ready_in_0, ready_in_1, ready_in_2, ready_in_3; 
	
	wire [32 * 4 - 1 : 0] data_in_vec;
	wire [3 : 0] valid_in_vec;
	
	reg [63 : 0] timeCounter = 0; 
	
	reg [2:0]counter = 0;
	
	wire [VC : 0] VCPlaneSelector;
	
	VCPlaneController #(.VC(VC)) vcPlaneController (.clk(clk), .rst(rst), .VCPlaneSelectorVerifier(VCPlaneSelector));
	
	assign data_in_vec = {data_in_3, data_in_2, data_in_1, data_in_0};
	assign valid_in_vec = {valid_in_3, valid_in_2, valid_in_1, valid_in_0};
	
	assign data_in = data_in_vec[VCPlaneSelector * 32 +: 32];
	assign valid_in = valid_in_vec[VCPlaneSelector];
	
	assign ready_in_0 = ready_in & VCPlaneSelector == 0;
	assign ready_in_1 = ready_in & VCPlaneSelector == 1;
	assign ready_in_2 = ready_in & VCPlaneSelector == 2;
	assign ready_in_3 = ready_in & VCPlaneSelector == 3;
	
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
	
	integer i, j, k, flag;
	reg [31 : 0] VC_counter [0 : VC - 1];
	initial begin
		
		for(i = 0; i < numberOfPackets * FlitsPerPacket; i = i + 1)begin
			ex_memory_flat[i] = 0;
			delay_memory_flat[i] = 0;
		end
		
		for(j = 0; j < VC; j = j + 1)
			for(i = 0; i < numberOfPackets * FlitsPerPacket; i = i + 1)begin
				ex_memory[j][i] = 0;
				delay_memory[j][i] = 0;
		end
		
		$readmemh(dataInputFilePath, ex_memory_flat); 
		$readmemh(delayInputFilePath, delay_memory_flat);
		fd=$fopen(outputFilePath,"w");
	
		i = 0;
		k = 0;
		flag = 0;
		
		for(j = 0; j < VC; j = j + 1)
			VC_counter[j] = 0;
		
		for(j = 0; j < numberOfPackets; j = j + 1)begin
			flag = 0;
			if(ex_memory_flat[i][31 : 28] == 4'b0101)//Flit with High Priority
				k = 0;
			else
				k = j % (VC - 1) + 1;//VC selection
			while(flag != 1)begin
				ex_memory[k][VC_counter[k]] = ex_memory_flat[i];
				//$write("%0d ", ex_memory[k][VC_counter[k]]);
				delay_memory[k][VC_counter[k]] = delay_memory_flat[i];
				if(ex_memory_flat[i][31 : 30] == 2'b11)//If tail is seen
					flag = 1;
				VC_counter[k] = VC_counter[k] + 1;
				i = i + 1;
			end
		end
	end
	
	integer i0, j0, k0, flag0;
	
	reg t0 = 0;
	wire tw0;
	assign #1 tw0 = t0 & clk;
	always @(posedge clk)begin
		t0 <= 0;
		if(valid_in_0 & ready_in_0)
			t0 <= 1;
	end
	
	initial begin
		#65;
		i0 = 0;
		while(ex_memory[0][i0] != 0)begin
			flag0 = 0;
			#1 valid_in_0 = 1;
			while(flag0 != 1)begin
				#1 data_in_0 = ex_memory[0][i0];
				
				if(data_in_0[31 : 30] == 2'b11)
					flag0 = 1;//Flag is set when tail is sent
				
				valid_in_0 = 1;
				if(data_in_0[31 : 30] == 2'b01) begin
					$display("Node%0d: Message: %0d Destination: %0d Departure_Time: %0d Priority: %0d", ID, (data_in_0[27 : 16] + 1), data_in_0[3:0] * DIM + data_in_0[7 : 4], timeCounter, data_in_0[29 : 28]);
				end
				
				#1;
				
				wait(tw0);
				
				#1 valid_in_0= 0;

				for(k0 = 0; k0 < delay_memory[0][i0]; k0 = k0 + 1)begin
					#1;
				end
				@(negedge clk);
				i0 = i0 + 1;
			end
		end
	end
	
	integer i1, j1, k1, flag1;
	reg t1 = 0;
	wire tw1;
	assign #1 tw1 = t1 & clk;
	always @(posedge clk)begin
		t1 <= 0;
		if(valid_in_1 & ready_in_1)
			t1 <= 1;
	end


	initial begin
		#65;
		i1 = 0;
		while(ex_memory[1][i1] != 0)begin
			flag1 = 0;
			#1 valid_in_1 = 1;
			while(flag1 != 1)begin
				#1 data_in_1 = ex_memory[1][i1];
				
				if(data_in_1[31 : 30] == 2'b11)
					flag1 = 1;//Flag is set when tail is sent
				
				valid_in_1 = 1;
				if(data_in_1[31 : 30] == 2'b01) begin
					$display("Node%0d: Message: %0d Destination: %0d Departure_Time: %0d Priority: %0d", ID, (data_in_1[27 : 16] + 1), data_in_1[3:0] * DIM + data_in_1[7 : 4], timeCounter, data_in_1[29 : 28]);
				end
				
				#1;
				
				wait(tw1);
				
				#1 valid_in_1 = 0;

				for(k1 = 0; k1 < delay_memory[1][i1]; k1 = k1 + 1)begin
					#1;
				end
				@(negedge clk);
				i1 = i1 + 1;
			end
		end
	end
	
	integer i2, j2, k2, flag2;
	reg t2 = 0;
	wire tw2;
	assign #1 tw2 = t2 & clk;
	always @(posedge clk)begin
		t2 <= 0;
		if(valid_in_2 & ready_in_2)
			t2 <= 1;
	end
	
	initial begin
		#65;
		i2 = 0;
		while(ex_memory[2][i2] != 0)begin
			flag2 = 0;
			#1 valid_in_2 = 1;
			while(flag2 != 1)begin
				#1 data_in_2 = ex_memory[2][i2];
				
				if(data_in_2[31 : 30] == 2'b11)
					flag2 = 1;//Flag is set when tail is sent
				
				valid_in_2 = 1;
				if(data_in_2[31 : 30] == 2'b01) begin
					$display("Node%0d: Message: %0d Destination: %0d Departure_Time: %0d Priority: %0d", ID, (data_in_2[27 : 16] + 1), data_in_2[3:0] * DIM + data_in_2[7 : 4], timeCounter, data_in_2[29 : 28]);
				end
				
				#1;
				
				wait(tw2);
				
				#1 valid_in_2 = 0;

				for(k2 = 0; k2 < delay_memory[2][i2]; k2 = k2 + 1)begin
					#1;
				end
				@(negedge clk);
				i2 = i2 + 1;
			end
		end
	end
	
	integer i3, j3, k3, flag3;
	reg t3 = 0;
	wire tw3;
	assign #1 tw3 = t3 & clk;
	always @(posedge clk)begin
		t3 <= 0;
		if(valid_in_3 & ready_in_3)
			t3 <= 1;
	end
	
	initial begin
		#65;
		i3 = 0;
		while(ex_memory[3][i3] != 0)begin
			flag3 = 0;
			#1 valid_in_3 = 1;
			while(flag3 != 1)begin
				#1 data_in_3 = ex_memory[3][i3];
				
				if(data_in_3[31 : 30] == 2'b11)
					flag3 = 1;//Flag is set when tail is sent
				
				valid_in_3 = 1;
				if(data_in_3[31 : 30] == 2'b01) begin
					$display("Node%0d: Message: %0d Destination: %0d Departure_Time: %0d Priority: %0d", ID, (data_in_3[27 : 16] + 1), data_in_3[3:0] * DIM + data_in_3[7 : 4], timeCounter, data_in_3[29 : 28]);
				end
				
				#1;
				
				wait(tw3);
				
				#1 valid_in_3 = 0;

				for(k3 = 0; k3 < delay_memory[3][i3]; k3 = k3 + 1)begin
					#1;
				end
				@(negedge clk);
				i3 = i3 + 1;
			end
		end
	end
	
	
	always @(*)
		ready_out = valid_out;
	
	always @(posedge clk) begin
		if(valid_out & ready_out)begin
			if(data_out[31 : 30] == 2'b11)
				$display("Node%0d: Message: %0d Source: %0d Arrival_Time: %0d", ID, (data_out[27 : 16] + 1), data_out[11:8] * DIM + data_out[15 : 12], timeCounter);
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
	
	
	integer i, j, k, flag;
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
		i = 0;
		for(j = 0; j < numberOfPackets; j = j + 1)begin
			flag = 0;
			#1 valid_in = 1;
			while(flag != 1)begin
				#1 data_in = ex_memory[i];
				
				if(data_in[31 : 30] == 2'b11)
					flag = 1;//Flag is set when tail is sent
				
				valid_in = 1;
				if(data_in[31 : 30] == 2'b01) begin
					$display("Node%0d: Message: %0d Destination: %0d Departure_Time: %0d", ID, (data_in[29 : 16] + 1), data_in[3:0] * DIM + data_in[7 : 4], timeCounter);
				end
				
				#1;
				
				wait(tw);
				
				#1 valid_in= 0;

				for(k = 0; k < delay_memory[i]; k = k + 1)begin
					#1;
				end
				@(negedge clk);
				i = i + 1;
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
