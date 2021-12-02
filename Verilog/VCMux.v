//This module multiplexes outputs from VC Buffers
//To send them to Switch

module VCMux 
	#(
		parameter VC = 4,
		parameter DATA_WIDTH = 32
	)
	(
		//VC control Signals
		input [VC : 0] VCPlaneSelector,//Selects the currently active VC Plane
		
		//From VC Buffers
		input [VC * DATA_WIDTH - 1 : 0]dinVC,
		
		//To Switch
		output [DATA_WIDTH - 1 : 0] dout
	);
	
	assign dout = dinVC[VCPlaneSelector * DATA_WIDTH +: DATA_WIDTH];
	
endmodule
