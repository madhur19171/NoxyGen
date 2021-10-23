//FIFO_DEPTH should always be in a power of two
module FIFO #(parameter DATA_WIDTH = 32,
		parameter FIFO_DEPTH = 32)
		
	(
		input clk,
		input rst,
		
		output empty,
		input rd_en,
		output reg [DATA_WIDTH - 1 : 0]dout = 0,
		
		output full,
		input wr_en,
		input [DATA_WIDTH - 1 : 0]din
	);
	
	localparam ADDRESS_WIDTH = $clog2(FIFO_DEPTH);
	
	wire [ADDRESS_WIDTH - 1 : 0] head_tail;
	
	reg [ADDRESS_WIDTH - 1 : 0] head = 0, tail = 0;
	
	assign empty = head == tail;
	assign head_tail = head - tail;
	assign full = head_tail == FIFO_DEPTH - 1;
	
	reg [DATA_WIDTH - 1 : 0] RAM [0 : FIFO_DEPTH - 1];
	
	integer i;
	initial begin
		for(i = 0; i < FIFO_DEPTH; i = i + 1)begin
			RAM[i] = 0;
		end
	end
	
	always @(posedge clk)begin
		if(rst)begin
			head <= 0;
		end
		else if(wr_en & ~full)
			head <= head + 1;
	end
	
	always @(posedge clk)begin
		if(rst)begin
			tail <= 0;
		end
		else if(rd_en & ~empty)
			tail <= tail + 1;
	end
	
	always @(posedge clk)begin
		if(wr_en & ~full)
			RAM[head] <= din;
	end
	
	always @(posedge clk)begin
		if(rst)begin
			dout <= 0;
		end
		else if(rd_en & ~empty)
			dout <= RAM[tail];
	end
	
endmodule
