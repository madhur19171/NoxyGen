//Demux acts as an interface between VC FIFOs and ControlFSM
//It demultiplexes all FIFO signals like Data, Valid, Ready, Push, Pop, Empty and Full
//based on the VCPlaneSelector signal

module VCDemux 
	#(
		parameter VC = 4,
		parameter DATA_WIDTH = 32
	)
	(
		//VC control Signals
		input [VC : 0] VCPlaneSelector,//Selects the currently active VC Plane
	
		//To ControlFSM
		output  empty,
		output full,
		//From ControlFSM
		input rd_en,//popBuffer
		input wr_en,//pushBuffer
		input [DATA_WIDTH - 1 : 0]din,
		
		
		//To VC Buffers
		output [VC - 1 : 0] rd_enVC,
		output [VC - 1 : 0] wr_enVC,
		output [VC * DATA_WIDTH - 1 : 0]doutVC,
		//From VC Buffers
		input[VC - 1 : 0] emptyVC,
		input[VC - 1 : 0] fullVC
	);
	
	reg [2**VC - 1 : 0] VCPlaneSelector_onehot = 0;
	
	integer i0;
	always @(*)begin
		VCPlaneSelector_onehot = 0;
		for(i0 = 0; i0 < VC; i0 = i0 + 1)
			VCPlaneSelector_onehot[i0] = VCPlaneSelector == i0;
	end
	
	assign doutVC = {VC{din}};
	assign rd_enVC = {VC{rd_en}} & VCPlaneSelector_onehot;
	assign wr_enVC = {VC{wr_en}} & VCPlaneSelector_onehot;
	
	assign full = fullVC[VCPlaneSelector];
	assign empty = emptyVC[VCPlaneSelector];
	
endmodule
