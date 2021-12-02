//Combines FIFO, Mux and Demux

module VCG//VirtualChannelGroup
	#(
		parameter VC = 4,
		parameter DATA_WIDTH = 32,
		parameter FIFO_DEPTH = 32
	)
	(
		input clk,
		input rst,
		
		//VC control Signals
		input [VC : 0] VCPlaneSelector,//Selects the currently active VC Plane
	
		//To ControlFSM
		output  empty,
		output full,
		//From ControlFSM
		input rd_en,//popBuffer
		input wr_en,//pushBuffer
		input [DATA_WIDTH - 1 : 0]din,
		
		//To Switch
		output [DATA_WIDTH - 1 : 0] dout
		
	);
	
	//To VC Buffers
	wire [VC - 1 : 0] rd_enVC;
	wire [VC - 1 : 0] wr_enVC;
	wire [VC * DATA_WIDTH - 1 : 0]doutVC;
	//From VC Buffers
	wire [VC - 1 : 0] emptyVC;
	wire [VC - 1 : 0] fullVC;
	wire [VC * DATA_WIDTH - 1 : 0]dinVC;
	
	
	
	VCDemux #(.VC(VC), .DATA_WIDTH(DATA_WIDTH)) vcdemux
		(.VCPlaneSelector(VCPlaneSelector), .empty(empty), .full(full), .rd_en(rd_en), .wr_en(wr_en),
		.din(din), .rd_enVC(rd_enVC), .wr_enVC(wr_enVC), .doutVC(doutVC), .emptyVC(emptyVC), .fullVC(fullVC));
		
	genvar i;
	generate
		for(i = 0; i < VC; i = i + 1)
			FIFO #(.DATA_WIDTH(DATA_WIDTH), .FIFO_DEPTH(FIFO_DEPTH)) fifo
				(.clk(clk), .rst(rst), .empty(emptyVC[i]), .rd_en(rd_enVC[i]), .dout(dinVC[i * DATA_WIDTH +: DATA_WIDTH]),
				.full(fullVC[i]), .wr_en(wr_enVC[i]), .din(doutVC[i * DATA_WIDTH +: DATA_WIDTH]));
	endgenerate	
	
	VCMux #(.DATA_WIDTH(DATA_WIDTH), .VC(VC)) vcmux
		(.VCPlaneSelector(VCPlaneSelector), .dinVC(dinVC),
		.dout(dout));

endmodule
