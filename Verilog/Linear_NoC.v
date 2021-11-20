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
	input Node1_ready_out,

	input [31 : 0]Node2_data_in,
	input Node2_valid_in,
	output Node2_ready_in,

	output [31 : 0]Node2_data_out,
	output Node2_valid_out,
	input Node2_ready_out,

	input [31 : 0]Node3_data_in,
	input Node3_valid_in,
	output Node3_ready_in,

	output [31 : 0]Node3_data_out,
	output Node3_valid_out,
	input Node3_ready_out,

	input [31 : 0]Node4_data_in,
	input Node4_valid_in,
	output Node4_ready_in,

	output [31 : 0]Node4_data_out,
	output Node4_valid_out,
	input Node4_ready_out,

	input [31 : 0]Node5_data_in,
	input Node5_valid_in,
	output Node5_ready_in,

	output [31 : 0]Node5_data_out,
	output Node5_valid_out,
	input Node5_ready_out

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
	wire [31 : 0]Node1_in2_data;
	wire Node1_in2_ready;
	wire Node1_in2_valid;
	wire [31 : 0]Node1_out0_data;
	wire Node1_out0_ready;
	wire Node1_out0_valid;
	wire [31 : 0]Node1_out1_data;
	wire Node1_out1_ready;
	wire Node1_out1_valid;
	wire [31 : 0]Node1_out2_data;
	wire Node1_out2_ready;
	wire Node1_out2_valid;

	wire Node2_clk;
	wire Node2_rst;
	wire [31 : 0]Node2_in0_data;
	wire Node2_in0_ready;
	wire Node2_in0_valid;
	wire [31 : 0]Node2_in1_data;
	wire Node2_in1_ready;
	wire Node2_in1_valid;
	wire [31 : 0]Node2_in2_data;
	wire Node2_in2_ready;
	wire Node2_in2_valid;
	wire [31 : 0]Node2_out0_data;
	wire Node2_out0_ready;
	wire Node2_out0_valid;
	wire [31 : 0]Node2_out1_data;
	wire Node2_out1_ready;
	wire Node2_out1_valid;
	wire [31 : 0]Node2_out2_data;
	wire Node2_out2_ready;
	wire Node2_out2_valid;

	wire Node3_clk;
	wire Node3_rst;
	wire [31 : 0]Node3_in0_data;
	wire Node3_in0_ready;
	wire Node3_in0_valid;
	wire [31 : 0]Node3_in1_data;
	wire Node3_in1_ready;
	wire Node3_in1_valid;
	wire [31 : 0]Node3_in2_data;
	wire Node3_in2_ready;
	wire Node3_in2_valid;
	wire [31 : 0]Node3_out0_data;
	wire Node3_out0_ready;
	wire Node3_out0_valid;
	wire [31 : 0]Node3_out1_data;
	wire Node3_out1_ready;
	wire Node3_out1_valid;
	wire [31 : 0]Node3_out2_data;
	wire Node3_out2_ready;
	wire Node3_out2_valid;

	wire Node4_clk;
	wire Node4_rst;
	wire [31 : 0]Node4_in0_data;
	wire Node4_in0_ready;
	wire Node4_in0_valid;
	wire [31 : 0]Node4_in1_data;
	wire Node4_in1_ready;
	wire Node4_in1_valid;
	wire [31 : 0]Node4_in2_data;
	wire Node4_in2_ready;
	wire Node4_in2_valid;
	wire [31 : 0]Node4_out0_data;
	wire Node4_out0_ready;
	wire Node4_out0_valid;
	wire [31 : 0]Node4_out1_data;
	wire Node4_out1_ready;
	wire Node4_out1_valid;
	wire [31 : 0]Node4_out2_data;
	wire Node4_out2_ready;
	wire Node4_out2_valid;

	wire Node5_clk;
	wire Node5_rst;
	wire [31 : 0]Node5_in0_data;
	wire Node5_in0_ready;
	wire Node5_in0_valid;
	wire [31 : 0]Node5_in1_data;
	wire Node5_in1_ready;
	wire Node5_in1_valid;
	wire [31 : 0]Node5_out0_data;
	wire Node5_out0_ready;
	wire Node5_out0_valid;
	wire [31 : 0]Node5_out1_data;
	wire Node5_out1_ready;
	wire Node5_out1_valid;



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
	assign Node2_in1_data = Node1_out2_data;
	assign Node2_in1_valid = Node1_out2_valid;
	assign Node1_out2_ready = Node2_in1_ready;

	assign Node2_clk = clk;
	assign Node2_rst = rst;
	assign Node2_in0_data = Node2_data_in;
	assign Node2_in0_valid = Node2_valid_in;
	assign Node2_ready_in = Node2_in0_ready;
	assign Node2_data_out = Node2_out0_data;
	assign Node2_valid_out = Node2_out0_valid;
	assign Node2_out0_ready = Node2_ready_out;
	assign Node1_in2_data = Node2_out1_data;
	assign Node1_in2_valid = Node2_out1_valid;
	assign Node2_out1_ready = Node1_in2_ready;
	assign Node3_in1_data = Node2_out2_data;
	assign Node3_in1_valid = Node2_out2_valid;
	assign Node2_out2_ready = Node3_in1_ready;

	assign Node3_clk = clk;
	assign Node3_rst = rst;
	assign Node3_in0_data = Node3_data_in;
	assign Node3_in0_valid = Node3_valid_in;
	assign Node3_ready_in = Node3_in0_ready;
	assign Node3_data_out = Node3_out0_data;
	assign Node3_valid_out = Node3_out0_valid;
	assign Node3_out0_ready = Node3_ready_out;
	assign Node2_in2_data = Node3_out1_data;
	assign Node2_in2_valid = Node3_out1_valid;
	assign Node3_out1_ready = Node2_in2_ready;
	assign Node4_in1_data = Node3_out2_data;
	assign Node4_in1_valid = Node3_out2_valid;
	assign Node3_out2_ready = Node4_in1_ready;

	assign Node4_clk = clk;
	assign Node4_rst = rst;
	assign Node4_in0_data = Node4_data_in;
	assign Node4_in0_valid = Node4_valid_in;
	assign Node4_ready_in = Node4_in0_ready;
	assign Node4_data_out = Node4_out0_data;
	assign Node4_valid_out = Node4_out0_valid;
	assign Node4_out0_ready = Node4_ready_out;
	assign Node3_in2_data = Node4_out1_data;
	assign Node3_in2_valid = Node4_out1_valid;
	assign Node4_out1_ready = Node3_in2_ready;
	assign Node5_in1_data = Node4_out2_data;
	assign Node5_in1_valid = Node4_out2_valid;
	assign Node4_out2_ready = Node5_in1_ready;

	assign Node5_clk = clk;
	assign Node5_rst = rst;
	assign Node5_in0_data = Node5_data_in;
	assign Node5_in0_valid = Node5_valid_in;
	assign Node5_ready_in = Node5_in0_ready;
	assign Node5_data_out = Node5_out0_data;
	assign Node5_valid_out = Node5_out0_valid;
	assign Node5_out0_ready = Node5_ready_out;
	assign Node4_in2_data = Node5_out1_data;
	assign Node4_in2_valid = Node5_out1_valid;
	assign Node5_out1_ready = Node4_in2_ready;

	Router #(.N(6), .INDEX(0), .INPUTS(2), .OUTPUTS(2), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(2)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(16)) Router_Node0
		(.clk(Node0_clk), .rst(Node0_rst),
		.data_in_bus({Node0_in1_data, Node0_in0_data}), .valid_in_bus({Node0_in1_valid, Node0_in0_valid}), .ready_in_bus({Node0_in1_ready, Node0_in0_ready}), 
		.data_out_bus({Node0_out1_data, Node0_out0_data}), .valid_out_bus({Node0_out1_valid, Node0_out0_valid}), .ready_out_bus({Node0_out1_ready, Node0_out0_ready}));

	Router #(.N(6), .INDEX(1), .INPUTS(3), .OUTPUTS(3), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(3)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(16)) Router_Node1
		(.clk(Node1_clk), .rst(Node1_rst),
		.data_in_bus({Node1_in2_data, Node1_in1_data, Node1_in0_data}), .valid_in_bus({Node1_in2_valid, Node1_in1_valid, Node1_in0_valid}), .ready_in_bus({Node1_in2_ready, Node1_in1_ready, Node1_in0_ready}), 
		.data_out_bus({Node1_out2_data, Node1_out1_data, Node1_out0_data}), .valid_out_bus({Node1_out2_valid, Node1_out1_valid, Node1_out0_valid}), .ready_out_bus({Node1_out2_ready, Node1_out1_ready, Node1_out0_ready}));

	Router #(.N(6), .INDEX(2), .INPUTS(3), .OUTPUTS(3), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(3)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(16)) Router_Node2
		(.clk(Node2_clk), .rst(Node2_rst),
		.data_in_bus({Node2_in2_data, Node2_in1_data, Node2_in0_data}), .valid_in_bus({Node2_in2_valid, Node2_in1_valid, Node2_in0_valid}), .ready_in_bus({Node2_in2_ready, Node2_in1_ready, Node2_in0_ready}), 
		.data_out_bus({Node2_out2_data, Node2_out1_data, Node2_out0_data}), .valid_out_bus({Node2_out2_valid, Node2_out1_valid, Node2_out0_valid}), .ready_out_bus({Node2_out2_ready, Node2_out1_ready, Node2_out0_ready}));

	Router #(.N(6), .INDEX(3), .INPUTS(3), .OUTPUTS(3), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(3)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(16)) Router_Node3
		(.clk(Node3_clk), .rst(Node3_rst),
		.data_in_bus({Node3_in2_data, Node3_in1_data, Node3_in0_data}), .valid_in_bus({Node3_in2_valid, Node3_in1_valid, Node3_in0_valid}), .ready_in_bus({Node3_in2_ready, Node3_in1_ready, Node3_in0_ready}), 
		.data_out_bus({Node3_out2_data, Node3_out1_data, Node3_out0_data}), .valid_out_bus({Node3_out2_valid, Node3_out1_valid, Node3_out0_valid}), .ready_out_bus({Node3_out2_ready, Node3_out1_ready, Node3_out0_ready}));

	Router #(.N(6), .INDEX(4), .INPUTS(3), .OUTPUTS(3), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(3)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(16)) Router_Node4
		(.clk(Node4_clk), .rst(Node4_rst),
		.data_in_bus({Node4_in2_data, Node4_in1_data, Node4_in0_data}), .valid_in_bus({Node4_in2_valid, Node4_in1_valid, Node4_in0_valid}), .ready_in_bus({Node4_in2_ready, Node4_in1_ready, Node4_in0_ready}), 
		.data_out_bus({Node4_out2_data, Node4_out1_data, Node4_out0_data}), .valid_out_bus({Node4_out2_valid, Node4_out1_valid, Node4_out0_valid}), .ready_out_bus({Node4_out2_ready, Node4_out1_ready, Node4_out0_ready}));

	Router #(.N(6), .INDEX(5), .INPUTS(2), .OUTPUTS(2), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(2)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(16)) Router_Node5
		(.clk(Node5_clk), .rst(Node5_rst),
		.data_in_bus({Node5_in1_data, Node5_in0_data}), .valid_in_bus({Node5_in1_valid, Node5_in0_valid}), .ready_in_bus({Node5_in1_ready, Node5_in0_ready}), 
		.data_out_bus({Node5_out1_data, Node5_out0_data}), .valid_out_bus({Node5_out1_valid, Node5_out0_valid}), .ready_out_bus({Node5_out1_ready, Node5_out0_ready}));

endmodule

