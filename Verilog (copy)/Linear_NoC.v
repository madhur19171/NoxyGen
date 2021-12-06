module NoC(
	input clk,
	input rst,

	input [31 : 0]Node0_data_in,
	input Node0_valid_in,
	output Node0_ready_in,

	output [31 : 0]Node0_data_out,
	output Node0_valid_out,
	input Node0_ready_out,

	input [31 : 0]Node1_data_in,
	input Node1_valid_in,
	output Node1_ready_in,

	output [31 : 0]Node1_data_out,
	output Node1_valid_out,
	input Node1_ready_out

	

);

	wire Node0_clk;
	wire Node0_rst;
	wire [31 : 0]Node0_in0_data;
	wire Node0_in0_ready;
	wire Node0_in0_valid;
	wire [31 : 0]Node0_in1_data;
	wire Node0_in1_ready;
	wire Node0_in1_valid;
	wire [31 : 0]Node0_out0_data;
	wire Node0_out0_ready;
	wire Node0_out0_valid;
	wire [31 : 0]Node0_out1_data;
	wire Node0_out1_ready;
	wire Node0_out1_valid;

	wire Node1_clk;
	wire Node1_rst;
	wire [31 : 0]Node1_in0_data;
	wire Node1_in0_ready;
	wire Node1_in0_valid;
	wire [31 : 0]Node1_in1_data;
	wire Node1_in1_ready;
	wire Node1_in1_valid;
	wire [31 : 0]Node1_out0_data;
	wire Node1_out0_ready;
	wire Node1_out0_valid;
	wire [31 : 0]Node1_out1_data;
	wire Node1_out1_ready;
	wire Node1_out1_valid;



	assign Node0_clk = clk;
	assign Node0_rst = rst;
	assign Node0_in0_data = Node0_data_in;
	assign Node0_in0_valid = Node0_valid_in;
	assign Node0_ready_in = Node0_in0_ready;
	assign Node0_data_out = Node0_out0_data;
	assign Node0_valid_out = Node0_out0_valid;
	assign Node0_out0_ready = Node0_ready_out;
	assign Node1_in1_data = Node0_out1_data;
	assign Node1_in1_valid = Node0_out1_valid;
	assign Node0_out1_ready = Node1_in1_ready;

	assign Node1_clk = clk;
	assign Node1_rst = rst;
	assign Node1_in0_data = Node1_data_in;
	assign Node1_in0_valid = Node1_valid_in;
	assign Node1_ready_in = Node1_in0_ready;
	assign Node1_data_out = Node1_out0_data;
	assign Node1_valid_out = Node1_out0_valid;
	assign Node1_out0_ready = Node1_ready_out;
	assign Node0_in1_data = Node1_out1_data;
	assign Node0_in1_valid = Node1_out1_valid;
	assign Node1_out1_ready = Node0_in1_ready;
	

	Router #(.N(6), .INDEX(0), .INPUTS(2), .OUTPUTS(2), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(2)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(16)) Router_Node0
		(.clk(Node0_clk), .rst(Node0_rst),
		.data_in_bus({Node0_in1_data, Node0_in0_data}), .valid_in_bus({Node0_in1_valid, Node0_in0_valid}), .ready_in_bus({Node0_in1_ready, Node0_in0_ready}), 
		.data_out_bus({Node0_out1_data, Node0_out0_data}), .valid_out_bus({Node0_out1_valid, Node0_out0_valid}), .ready_out_bus({Node0_out1_ready, Node0_out0_ready}));


endmodule

