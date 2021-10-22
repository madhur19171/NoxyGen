// Mux based switch design
//This is just a mux with Select lines, Data Inputs and Data Outputs.
//It is the job of Switch Control Logic to do the arbitration and prevent race conditions.

//This module has been designed so that different number of Inputs and outputs are possible.
module MuxSwitch
	#(
	parameter INPUTS = 4,
	parameter OUTPUTS = 4,
	parameter DATA_WIDTH = 8,
	parameter REQUEST_WIDTH = 32
	) 
	
	(
	
	//Routing Signals
	//For each output, there is an input. Other way round may lead to multiple driver on same ports.
	//One to many or Many to one not allowed in MUX
	input [OUTPUTS * REQUEST_WIDTH - 1 : 0] routeSelect,
	input [OUTPUTS - 1 : 0] outputBusy,
	input [INPUTS - 1 : 0] PortReserved,
	
	//Data Input
	input [INPUTS * DATA_WIDTH - 1 : 0] data_in,
	input [INPUTS - 1 : 0] valid_in,
	output reg [INPUTS - 1 : 0] ready_in = 0,
	
	//Data Output
	output reg [OUTPUTS * DATA_WIDTH - 1 : 0] data_out = 0,
	output reg [OUTPUTS - 1 : 0] valid_out = 0,
	input [OUTPUTS - 1 : 0] ready_out
	);
	
	integer i, j;

	
	//Direction Encoding for Mesh based switches:
	//0 : North	1 : South	2 : West	3 : East
	
	//Data Mux
	always @(*)begin
		data_out = 0;
		//Lower i inputs will be given prority with this design
		for(i = OUTPUTS - 1; i >= 0; i = i - 1)begin
			for(j = INPUTS - 1; j >= 0; j = j - 1)
				if(routeSelect[i * REQUEST_WIDTH +: REQUEST_WIDTH] == j & PortReserved[j])//Port that feeds the output should be reserved.
					data_out[i * DATA_WIDTH +: DATA_WIDTH] = data_in[j * DATA_WIDTH +: DATA_WIDTH];
			end
	end
	
	//Priority Valid Mux
	always @(*)begin
		valid_out = 0;
		//Lower i inputs will be given prority with this design
		for(i = OUTPUTS - 1; i >= 0; i = i - 1)begin
			for(j = INPUTS - 1; j >= 0; j = j - 1)
				if(routeSelect[i * REQUEST_WIDTH +: REQUEST_WIDTH] == j & PortReserved[j])//Port that feeds the output should be reserved.
					valid_out[i] = valid_in[j] & outputBusy[i];
			//Send valid_out only when the output port is routed otherwise the next router may unintentionally receive high valid_in
		end
	end
	
	//Priority Ready Mux
	always @(*)begin
		//Lower i inputs will be given prority with this design
		for(i = INPUTS - 1; i >= 0; i = i - 1)begin
			ready_in[i] = 0;
			for(j = OUTPUTS - 1; j >= 0; j = j - 1)
				if(routeSelect[j * REQUEST_WIDTH +: REQUEST_WIDTH] == i & outputBusy[j])
					ready_in[i] = ready_out[j] & PortReserved[i];
					//Relay the ready_in signal only for those inputs for which the path has actually been reserved.
		end
	end
	
endmodule
