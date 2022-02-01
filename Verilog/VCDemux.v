module VCDemux 
	#(
		parameter VC = 4,
		parameter INPUTS = 4,
		parameter OUTPUTS = 4,
		parameter DATA_WIDTH = 32
	)
	(
		//VC control Signals
		input [VC : 0] VCPlaneSelector,//Selects the currently active VC Plane
		
		input [INPUTS * DATA_WIDTH - 1 : 0] data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output [INPUTS - 1 : 0]ready_in_bus,
		
		output [VC * INPUTS * DATA_WIDTH - 1 : 0] data_in_busVC,
		output reg [VC * INPUTS - 1 : 0]valid_in_busVC = 0,
		input [VC * INPUTS - 1 : 0]ready_in_busVC
		
	);
	
	integer i1;
	always @(*)begin
		valid_in_busVC = 0;
		for(i1 = 0; i1 < VC; i1 = i1 + 1)begin
			if(i1 == VCPlaneSelector)
				valid_in_busVC[i1 * INPUTS +: INPUTS] = valid_in_bus;
		end
	end
	
	assign data_in_busVC = {VC{data_in_bus}};
	
	assign ready_in_bus = ready_in_busVC[VCPlaneSelector * INPUTS +: INPUTS];
	
endmodule
