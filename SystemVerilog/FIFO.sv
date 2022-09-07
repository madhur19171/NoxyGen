//FIFO_DEPTH should always be in a power of two
module FIFO #(parameter DATA_WIDTH = 32,
		parameter FIFO_DEPTH = 32)
		
	(
		input clk,
		input rst,
		
		output empty,
		input rd_en,//popBuffer
		output reg [DATA_WIDTH - 1 : 0]dout = 0,
		
		output full,
		input wr_en,//pushBuffer
		input [DATA_WIDTH - 1 : 0]din,
		
		output [$clog2(FIFO_DEPTH) - 1 : 0] FIFOoccupancy
	);
	
	localparam ADDRESS_WIDTH = $clog2(FIFO_DEPTH);
	
	wire [ADDRESS_WIDTH - 1 : 0] head_tail;
	
	reg [ADDRESS_WIDTH - 1 : 0] head = 0, tail = 0;
	
	assign #0.5 empty = head == tail;
	assign #0.5 full = ((head + 1) % FIFO_DEPTH == tail);
	assign #0.5 FIFOoccupancy = head - tail + 1;
	
	//To be implemented as Xilinx Distributed RAM
	reg [DATA_WIDTH - 1 : 0] RAM [0 : FIFO_DEPTH - 1];
	
	integer i;
	initial begin
		for(i = 0; i < FIFO_DEPTH; i = i + 1)begin
			RAM[i] = 0;
		end
	end
	
	always_ff @(posedge clk)begin
		if(rst)begin
			head <= #0.75 0;
		end
		else if(wr_en & ~full | wr_en & rd_en & full)
			head <= #0.75 ((head + 1) % FIFO_DEPTH);
	end
	
	always_ff @(posedge clk)begin
		if(rst)begin
			tail <= #0.75 0;
		end
		else if(rd_en & ~empty | rd_en & wr_en & empty)
			tail <= #0.75 ((tail + 1) % FIFO_DEPTH);
	end
	
	always_ff @(posedge clk)begin
		if(wr_en & ~full | wr_en & rd_en & full)
			RAM[head] <= #0.75 din;
			
			
	end
	
//	always @(posedge clk)begin
//		if(rst)begin
//			dout <= 0;
//		end
//		else if(rd_en & ~empty)
//			dout <= RAM[tail];
//	end

	//To be implemented as Xilinx Distributed RAM, Asynchronous Read and Synchronous Write
	/*always_comb begin
		if(rst)begin
			dout = #0.75 0;
		end
		else if(~empty)
			dout = #0.75 RAM[tail];
	end*/
	
	always @(*) begin
		if(rst)begin
			dout = 0;
		end
		else if(~empty)
			dout = RAM[tail];
	end
	
endmodule
