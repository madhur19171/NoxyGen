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
		
		input [INPUTS - 1 : 0][DATA_WIDTH - 1 : 0] data_in_bus,
		input [INPUTS - 1 : 0]valid_in_bus,
		output [INPUTS - 1 : 0]ready_in_bus,
		
		output reg [VC - 1 : 0][INPUTS - 1 : 0][DATA_WIDTH - 1 : 0] data_in_busVC,
		output reg [VC - 1 : 0][INPUTS - 1 : 0]valid_in_busVC = 0,
		input [VC - 1 : 0][INPUTS - 1 : 0]ready_in_busVC
		
	);
	
	integer i1;
	always_comb begin
		valid_in_busVC = 0;
		for(i1 = 0; i1 < VC; i1 = i1 + 1)begin
			if(i1 == VCPlaneSelector)
				valid_in_busVC[i1] = valid_in_bus;
		end
	end
	
	integer j;
	always_comb begin
		for(j = 0; j < VC; j = j + 1) begin
			data_in_busVC[j] = data_in_bus;
		end
	end
	
	assign ready_in_bus = ready_in_busVC[VCPlaneSelector];
	
endmodule
