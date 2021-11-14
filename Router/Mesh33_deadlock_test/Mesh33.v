module Mesh33(
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
	input Node5_ready_out,

	input [31 : 0]Node6_data_in,
	input Node6_valid_in,
	output Node6_ready_in,

	output [31 : 0]Node6_data_out,
	output Node6_valid_out,
	input Node6_ready_out,

	input [31 : 0]Node7_data_in,
	input Node7_valid_in,
	output Node7_ready_in,

	output [31 : 0]Node7_data_out,
	output Node7_valid_out,
	input Node7_ready_out,

	input [31 : 0]Node8_data_in,
	input Node8_valid_in,
	output Node8_ready_in,

	output [31 : 0]Node8_data_out,
	output Node8_valid_out,
	input Node8_ready_out

);

	wire Node0_clk;
	wire Node0_rst;
	wire [31 : 0]Node0_in0_data;
	wire Node0_in0_ready;
	wire Node0_in0_valid;
	wire [31 : 0]Node0_in1_data;
	wire Node0_in1_ready;
	wire Node0_in1_valid;
	wire [31 : 0]Node0_in2_data;
	wire Node0_in2_ready;
	wire Node0_in2_valid;
	wire [31 : 0]Node0_out0_data;
	wire Node0_out0_ready;
	wire Node0_out0_valid;
	wire [31 : 0]Node0_out1_data;
	wire Node0_out1_ready;
	wire Node0_out1_valid;
	wire [31 : 0]Node0_out2_data;
	wire Node0_out2_ready;
	wire Node0_out2_valid;

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
	wire [31 : 0]Node1_in3_data;
	wire Node1_in3_ready;
	wire Node1_in3_valid;
	wire [31 : 0]Node1_out0_data;
	wire Node1_out0_ready;
	wire Node1_out0_valid;
	wire [31 : 0]Node1_out1_data;
	wire Node1_out1_ready;
	wire Node1_out1_valid;
	wire [31 : 0]Node1_out2_data;
	wire Node1_out2_ready;
	wire Node1_out2_valid;
	wire [31 : 0]Node1_out3_data;
	wire Node1_out3_ready;
	wire Node1_out3_valid;

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
	wire [31 : 0]Node3_in3_data;
	wire Node3_in3_ready;
	wire Node3_in3_valid;
	wire [31 : 0]Node3_out0_data;
	wire Node3_out0_ready;
	wire Node3_out0_valid;
	wire [31 : 0]Node3_out1_data;
	wire Node3_out1_ready;
	wire Node3_out1_valid;
	wire [31 : 0]Node3_out2_data;
	wire Node3_out2_ready;
	wire Node3_out2_valid;
	wire [31 : 0]Node3_out3_data;
	wire Node3_out3_ready;
	wire Node3_out3_valid;

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
	wire [31 : 0]Node4_in3_data;
	wire Node4_in3_ready;
	wire Node4_in3_valid;
	wire [31 : 0]Node4_in4_data;
	wire Node4_in4_ready;
	wire Node4_in4_valid;
	wire [31 : 0]Node4_out0_data;
	wire Node4_out0_ready;
	wire Node4_out0_valid;
	wire [31 : 0]Node4_out1_data;
	wire Node4_out1_ready;
	wire Node4_out1_valid;
	wire [31 : 0]Node4_out2_data;
	wire Node4_out2_ready;
	wire Node4_out2_valid;
	wire [31 : 0]Node4_out3_data;
	wire Node4_out3_ready;
	wire Node4_out3_valid;
	wire [31 : 0]Node4_out4_data;
	wire Node4_out4_ready;
	wire Node4_out4_valid;

	wire Node5_clk;
	wire Node5_rst;
	wire [31 : 0]Node5_in0_data;
	wire Node5_in0_ready;
	wire Node5_in0_valid;
	wire [31 : 0]Node5_in1_data;
	wire Node5_in1_ready;
	wire Node5_in1_valid;
	wire [31 : 0]Node5_in2_data;
	wire Node5_in2_ready;
	wire Node5_in2_valid;
	wire [31 : 0]Node5_in3_data;
	wire Node5_in3_ready;
	wire Node5_in3_valid;
	wire [31 : 0]Node5_out0_data;
	wire Node5_out0_ready;
	wire Node5_out0_valid;
	wire [31 : 0]Node5_out1_data;
	wire Node5_out1_ready;
	wire Node5_out1_valid;
	wire [31 : 0]Node5_out2_data;
	wire Node5_out2_ready;
	wire Node5_out2_valid;
	wire [31 : 0]Node5_out3_data;
	wire Node5_out3_ready;
	wire Node5_out3_valid;

	wire Node6_clk;
	wire Node6_rst;
	wire [31 : 0]Node6_in0_data;
	wire Node6_in0_ready;
	wire Node6_in0_valid;
	wire [31 : 0]Node6_in1_data;
	wire Node6_in1_ready;
	wire Node6_in1_valid;
	wire [31 : 0]Node6_in2_data;
	wire Node6_in2_ready;
	wire Node6_in2_valid;
	wire [31 : 0]Node6_out0_data;
	wire Node6_out0_ready;
	wire Node6_out0_valid;
	wire [31 : 0]Node6_out1_data;
	wire Node6_out1_ready;
	wire Node6_out1_valid;
	wire [31 : 0]Node6_out2_data;
	wire Node6_out2_ready;
	wire Node6_out2_valid;

	wire Node7_clk;
	wire Node7_rst;
	wire [31 : 0]Node7_in0_data;
	wire Node7_in0_ready;
	wire Node7_in0_valid;
	wire [31 : 0]Node7_in1_data;
	wire Node7_in1_ready;
	wire Node7_in1_valid;
	wire [31 : 0]Node7_in2_data;
	wire Node7_in2_ready;
	wire Node7_in2_valid;
	wire [31 : 0]Node7_in3_data;
	wire Node7_in3_ready;
	wire Node7_in3_valid;
	wire [31 : 0]Node7_out0_data;
	wire Node7_out0_ready;
	wire Node7_out0_valid;
	wire [31 : 0]Node7_out1_data;
	wire Node7_out1_ready;
	wire Node7_out1_valid;
	wire [31 : 0]Node7_out2_data;
	wire Node7_out2_ready;
	wire Node7_out2_valid;
	wire [31 : 0]Node7_out3_data;
	wire Node7_out3_ready;
	wire Node7_out3_valid;

	wire Node8_clk;
	wire Node8_rst;
	wire [31 : 0]Node8_in0_data;
	wire Node8_in0_ready;
	wire Node8_in0_valid;
	wire [31 : 0]Node8_in1_data;
	wire Node8_in1_ready;
	wire Node8_in1_valid;
	wire [31 : 0]Node8_in2_data;
	wire Node8_in2_ready;
	wire Node8_in2_valid;
	wire [31 : 0]Node8_out0_data;
	wire Node8_out0_ready;
	wire Node8_out0_valid;
	wire [31 : 0]Node8_out1_data;
	wire Node8_out1_ready;
	wire Node8_out1_valid;
	wire [31 : 0]Node8_out2_data;
	wire Node8_out2_ready;
	wire Node8_out2_valid;



	assign Node0_clk = clk;
	assign Node0_rst = rst;
	assign Node0_in0_data = Node0_data_in;
	assign Node0_in0_valid = Node0_valid_in;
	assign Node0_ready_in = Node0_in0_ready;
	assign Node0_data_out = Node0_out0_data;
	assign Node0_valid_out = Node0_out0_valid;
	assign Node0_out0_ready = Node0_ready_out;
	assign Node1_in3_data = Node0_out1_data;
	assign Node1_in3_valid = Node0_out1_valid;
	assign Node0_out1_ready = Node1_in3_ready;
	assign Node3_in3_data = Node0_out2_data;
	assign Node3_in3_valid = Node0_out2_valid;
	assign Node0_out2_ready = Node3_in3_ready;

	assign Node1_clk = clk;
	assign Node1_rst = rst;
	assign Node1_in0_data = Node1_data_in;
	assign Node1_in0_valid = Node1_valid_in;
	assign Node1_ready_in = Node1_in0_ready;
	assign Node1_data_out = Node1_out0_data;
	assign Node1_valid_out = Node1_out0_valid;
	assign Node1_out0_ready = Node1_ready_out;
	assign Node2_in1_data = Node1_out1_data;
	assign Node2_in1_valid = Node1_out1_valid;
	assign Node1_out1_ready = Node2_in1_ready;
	assign Node4_in4_data = Node1_out2_data;
	assign Node4_in4_valid = Node1_out2_valid;
	assign Node1_out2_ready = Node4_in4_ready;
	assign Node0_in1_data = Node1_out3_data;
	assign Node0_in1_valid = Node1_out3_valid;
	assign Node1_out3_ready = Node0_in1_ready;

	assign Node2_clk = clk;
	assign Node2_rst = rst;
	assign Node2_in0_data = Node2_data_in;
	assign Node2_in0_valid = Node2_valid_in;
	assign Node2_ready_in = Node2_in0_ready;
	assign Node2_data_out = Node2_out0_data;
	assign Node2_valid_out = Node2_out0_valid;
	assign Node2_out0_ready = Node2_ready_out;
	assign Node1_in1_data = Node2_out1_data;
	assign Node1_in1_valid = Node2_out1_valid;
	assign Node2_out1_ready = Node1_in1_ready;
	assign Node5_in3_data = Node2_out2_data;
	assign Node5_in3_valid = Node2_out2_valid;
	assign Node2_out2_ready = Node5_in3_ready;

	assign Node3_clk = clk;
	assign Node3_rst = rst;
	assign Node3_in0_data = Node3_data_in;
	assign Node3_in0_valid = Node3_valid_in;
	assign Node3_ready_in = Node3_in0_ready;
	assign Node3_data_out = Node3_out0_data;
	assign Node3_valid_out = Node3_out0_valid;
	assign Node3_out0_ready = Node3_ready_out;
	assign Node4_in3_data = Node3_out1_data;
	assign Node4_in3_valid = Node3_out1_valid;
	assign Node3_out1_ready = Node4_in3_ready;
	assign Node6_in2_data = Node3_out2_data;
	assign Node6_in2_valid = Node3_out2_valid;
	assign Node3_out2_ready = Node6_in2_ready;
	assign Node0_in2_data = Node3_out3_data;
	assign Node0_in2_valid = Node3_out3_valid;
	assign Node3_out3_ready = Node0_in2_ready;

	assign Node4_clk = clk;
	assign Node4_rst = rst;
	assign Node4_in0_data = Node4_data_in;
	assign Node4_in0_valid = Node4_valid_in;
	assign Node4_ready_in = Node4_in0_ready;
	assign Node4_data_out = Node4_out0_data;
	assign Node4_valid_out = Node4_out0_valid;
	assign Node4_out0_ready = Node4_ready_out;
	assign Node5_in1_data = Node4_out1_data;
	assign Node5_in1_valid = Node4_out1_valid;
	assign Node4_out1_ready = Node5_in1_ready;
	assign Node7_in2_data = Node4_out2_data;
	assign Node7_in2_valid = Node4_out2_valid;
	assign Node4_out2_ready = Node7_in2_ready;
	assign Node3_in1_data = Node4_out3_data;
	assign Node3_in1_valid = Node4_out3_valid;
	assign Node4_out3_ready = Node3_in1_ready;
	assign Node1_in2_data = Node4_out4_data;
	assign Node1_in2_valid = Node4_out4_valid;
	assign Node4_out4_ready = Node1_in2_ready;

	assign Node5_clk = clk;
	assign Node5_rst = rst;
	assign Node5_in0_data = Node5_data_in;
	assign Node5_in0_valid = Node5_valid_in;
	assign Node5_ready_in = Node5_in0_ready;
	assign Node5_data_out = Node5_out0_data;
	assign Node5_valid_out = Node5_out0_valid;
	assign Node5_out0_ready = Node5_ready_out;
	assign Node4_in1_data = Node5_out1_data;
	assign Node4_in1_valid = Node5_out1_valid;
	assign Node5_out1_ready = Node4_in1_ready;
	assign Node8_in2_data = Node5_out2_data;
	assign Node8_in2_valid = Node5_out2_valid;
	assign Node5_out2_ready = Node8_in2_ready;
	assign Node2_in2_data = Node5_out3_data;
	assign Node2_in2_valid = Node5_out3_valid;
	assign Node5_out3_ready = Node2_in2_ready;

	assign Node6_clk = clk;
	assign Node6_rst = rst;
	assign Node6_in0_data = Node6_data_in;
	assign Node6_in0_valid = Node6_valid_in;
	assign Node6_ready_in = Node6_in0_ready;
	assign Node6_data_out = Node6_out0_data;
	assign Node6_valid_out = Node6_out0_valid;
	assign Node6_out0_ready = Node6_ready_out;
	assign Node7_in3_data = Node6_out1_data;
	assign Node7_in3_valid = Node6_out1_valid;
	assign Node6_out1_ready = Node7_in3_ready;
	assign Node3_in2_data = Node6_out2_data;
	assign Node3_in2_valid = Node6_out2_valid;
	assign Node6_out2_ready = Node3_in2_ready;

	assign Node7_clk = clk;
	assign Node7_rst = rst;
	assign Node7_in0_data = Node7_data_in;
	assign Node7_in0_valid = Node7_valid_in;
	assign Node7_ready_in = Node7_in0_ready;
	assign Node7_data_out = Node7_out0_data;
	assign Node7_valid_out = Node7_out0_valid;
	assign Node7_out0_ready = Node7_ready_out;
	assign Node8_in1_data = Node7_out1_data;
	assign Node8_in1_valid = Node7_out1_valid;
	assign Node7_out1_ready = Node8_in1_ready;
	assign Node4_in2_data = Node7_out2_data;
	assign Node4_in2_valid = Node7_out2_valid;
	assign Node7_out2_ready = Node4_in2_ready;
	assign Node6_in1_data = Node7_out3_data;
	assign Node6_in1_valid = Node7_out3_valid;
	assign Node7_out3_ready = Node6_in1_ready;

	assign Node8_clk = clk;
	assign Node8_rst = rst;
	assign Node8_in0_data = Node8_data_in;
	assign Node8_in0_valid = Node8_valid_in;
	assign Node8_ready_in = Node8_in0_ready;
	assign Node8_data_out = Node8_out0_data;
	assign Node8_valid_out = Node8_out0_valid;
	assign Node8_out0_ready = Node8_ready_out;
	assign Node7_in1_data = Node8_out1_data;
	assign Node7_in1_valid = Node8_out1_valid;
	assign Node8_out1_ready = Node7_in1_ready;
	assign Node5_in2_data = Node8_out2_data;
	assign Node5_in2_valid = Node8_out2_valid;
	assign Node8_out2_ready = Node5_in2_ready;

	Router #(.N(9), .INDEX(0), .INPUTS(3), .OUTPUTS(3), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(3)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(1600)) Router_Node0
		(.clk(Node0_clk), .rst(Node0_rst),
		.data_in_bus({Node0_in2_data, Node0_in1_data, Node0_in0_data}), .valid_in_bus({Node0_in2_valid, Node0_in1_valid, Node0_in0_valid}), .ready_in_bus({Node0_in2_ready, Node0_in1_ready, Node0_in0_ready}), 
		.data_out_bus({Node0_out2_data, Node0_out1_data, Node0_out0_data}), .valid_out_bus({Node0_out2_valid, Node0_out1_valid, Node0_out0_valid}), .ready_out_bus({Node0_out2_ready, Node0_out1_ready, Node0_out0_ready}));

	Router #(.N(9), .INDEX(1), .INPUTS(4), .OUTPUTS(4), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(4)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(1600)) Router_Node1
		(.clk(Node1_clk), .rst(Node1_rst),
		.data_in_bus({Node1_in3_data, Node1_in2_data, Node1_in1_data, Node1_in0_data}), .valid_in_bus({Node1_in3_valid, Node1_in2_valid, Node1_in1_valid, Node1_in0_valid}), .ready_in_bus({Node1_in3_ready, Node1_in2_ready, Node1_in1_ready, Node1_in0_ready}), 
		.data_out_bus({Node1_out3_data, Node1_out2_data, Node1_out1_data, Node1_out0_data}), .valid_out_bus({Node1_out3_valid, Node1_out2_valid, Node1_out1_valid, Node1_out0_valid}), .ready_out_bus({Node1_out3_ready, Node1_out2_ready, Node1_out1_ready, Node1_out0_ready}));

	Router #(.N(9), .INDEX(2), .INPUTS(3), .OUTPUTS(3), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(3)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(1600)) Router_Node2
		(.clk(Node2_clk), .rst(Node2_rst),
		.data_in_bus({Node2_in2_data, Node2_in1_data, Node2_in0_data}), .valid_in_bus({Node2_in2_valid, Node2_in1_valid, Node2_in0_valid}), .ready_in_bus({Node2_in2_ready, Node2_in1_ready, Node2_in0_ready}), 
		.data_out_bus({Node2_out2_data, Node2_out1_data, Node2_out0_data}), .valid_out_bus({Node2_out2_valid, Node2_out1_valid, Node2_out0_valid}), .ready_out_bus({Node2_out2_ready, Node2_out1_ready, Node2_out0_ready}));

	Router #(.N(9), .INDEX(3), .INPUTS(4), .OUTPUTS(4), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(4)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(1600)) Router_Node3
		(.clk(Node3_clk), .rst(Node3_rst),
		.data_in_bus({Node3_in3_data, Node3_in2_data, Node3_in1_data, Node3_in0_data}), .valid_in_bus({Node3_in3_valid, Node3_in2_valid, Node3_in1_valid, Node3_in0_valid}), .ready_in_bus({Node3_in3_ready, Node3_in2_ready, Node3_in1_ready, Node3_in0_ready}), 
		.data_out_bus({Node3_out3_data, Node3_out2_data, Node3_out1_data, Node3_out0_data}), .valid_out_bus({Node3_out3_valid, Node3_out2_valid, Node3_out1_valid, Node3_out0_valid}), .ready_out_bus({Node3_out3_ready, Node3_out2_ready, Node3_out1_ready, Node3_out0_ready}));

	Router #(.N(9), .INDEX(4), .INPUTS(5), .OUTPUTS(5), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(5)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(1600)) Router_Node4
		(.clk(Node4_clk), .rst(Node4_rst),
		.data_in_bus({Node4_in4_data, Node4_in3_data, Node4_in2_data, Node4_in1_data, Node4_in0_data}), .valid_in_bus({Node4_in4_valid, Node4_in3_valid, Node4_in2_valid, Node4_in1_valid, Node4_in0_valid}), .ready_in_bus({Node4_in4_ready, Node4_in3_ready, Node4_in2_ready, Node4_in1_ready, Node4_in0_ready}), 
		.data_out_bus({Node4_out4_data, Node4_out3_data, Node4_out2_data, Node4_out1_data, Node4_out0_data}), .valid_out_bus({Node4_out4_valid, Node4_out3_valid, Node4_out2_valid, Node4_out1_valid, Node4_out0_valid}), .ready_out_bus({Node4_out4_ready, Node4_out3_ready, Node4_out2_ready, Node4_out1_ready, Node4_out0_ready}));

	Router #(.N(9), .INDEX(5), .INPUTS(4), .OUTPUTS(4), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(4)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(1600)) Router_Node5
		(.clk(Node5_clk), .rst(Node5_rst),
		.data_in_bus({Node5_in3_data, Node5_in2_data, Node5_in1_data, Node5_in0_data}), .valid_in_bus({Node5_in3_valid, Node5_in2_valid, Node5_in1_valid, Node5_in0_valid}), .ready_in_bus({Node5_in3_ready, Node5_in2_ready, Node5_in1_ready, Node5_in0_ready}), 
		.data_out_bus({Node5_out3_data, Node5_out2_data, Node5_out1_data, Node5_out0_data}), .valid_out_bus({Node5_out3_valid, Node5_out2_valid, Node5_out1_valid, Node5_out0_valid}), .ready_out_bus({Node5_out3_ready, Node5_out2_ready, Node5_out1_ready, Node5_out0_ready}));

	Router #(.N(9), .INDEX(6), .INPUTS(3), .OUTPUTS(3), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(3)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(1600)) Router_Node6
		(.clk(Node6_clk), .rst(Node6_rst),
		.data_in_bus({Node6_in2_data, Node6_in1_data, Node6_in0_data}), .valid_in_bus({Node6_in2_valid, Node6_in1_valid, Node6_in0_valid}), .ready_in_bus({Node6_in2_ready, Node6_in1_ready, Node6_in0_ready}), 
		.data_out_bus({Node6_out2_data, Node6_out1_data, Node6_out0_data}), .valid_out_bus({Node6_out2_valid, Node6_out1_valid, Node6_out0_valid}), .ready_out_bus({Node6_out2_ready, Node6_out1_ready, Node6_out0_ready}));

	Router #(.N(9), .INDEX(7), .INPUTS(4), .OUTPUTS(4), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(4)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(1600)) Router_Node7
		(.clk(Node7_clk), .rst(Node7_rst),
		.data_in_bus({Node7_in3_data, Node7_in2_data, Node7_in1_data, Node7_in0_data}), .valid_in_bus({Node7_in3_valid, Node7_in2_valid, Node7_in1_valid, Node7_in0_valid}), .ready_in_bus({Node7_in3_ready, Node7_in2_ready, Node7_in1_ready, Node7_in0_ready}), 
		.data_out_bus({Node7_out3_data, Node7_out2_data, Node7_out1_data, Node7_out0_data}), .valid_out_bus({Node7_out3_valid, Node7_out2_valid, Node7_out1_valid, Node7_out0_valid}), .ready_out_bus({Node7_out3_ready, Node7_out2_ready, Node7_out1_ready, Node7_out0_ready}));

	Router #(.N(9), .INDEX(8), .INPUTS(3), .OUTPUTS(3), .DATA_WIDTH(32), .TYPE_WIDTH(2), .REQUEST_WIDTH($clog2(3)), .FlitPerPacket(6), .PhitPerFlit(1), .FIFO_DEPTH(1600)) Router_Node8
		(.clk(Node8_clk), .rst(Node8_rst),
		.data_in_bus({Node8_in2_data, Node8_in1_data, Node8_in0_data}), .valid_in_bus({Node8_in2_valid, Node8_in1_valid, Node8_in0_valid}), .ready_in_bus({Node8_in2_ready, Node8_in1_ready, Node8_in0_ready}), 
		.data_out_bus({Node8_out2_data, Node8_out1_data, Node8_out0_data}), .valid_out_bus({Node8_out2_valid, Node8_out1_valid, Node8_out0_valid}), .ready_out_bus({Node8_out2_ready, Node8_out1_ready, Node8_out0_ready}));

endmodule

