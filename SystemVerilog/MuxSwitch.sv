// Mux based switch design
//This is just a mux with Select lines, Data Inputs and Data Outputs.
//It is the job of Switch Control Logic to do the arbitration and prevent race conditions.

//This module has been designed so that different number of Inputs and outputs are possible.

//Note: High Resource utilization(LUTs) in MuxSwitch!!
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
	input [OUTPUTS - 1 : 0][REQUEST_WIDTH - 1 : 0] routeSelect,
	input [OUTPUTS - 1 : 0] outputBusy,
	input [INPUTS - 1 : 0] PortReserved,
	
	//Data Input
	input [INPUTS - 1 : 0][DATA_WIDTH - 1 : 0] data_in,
	input [INPUTS - 1 : 0] valid_in,
	output reg [INPUTS - 1 : 0] ready_in = 0,
	
	//Data Output
	output reg [OUTPUTS - 1 : 0][DATA_WIDTH - 1 : 0] data_out = 0,
	output reg [OUTPUTS - 1 : 0] valid_out = 0,
	input [OUTPUTS - 1 : 0] ready_out
	);
	
	//integer i, j;

	
	//Direction Encoding for Mesh based switches:
	//0 : North	1 : South	2 : West	3 : East
	
	integer i1, j1;
	//Data Mux
	always @(*)begin
		data_out = 0;
		//Lower i inputs will be given prority with this design
		for(i1 = OUTPUTS - 1; i1 >= 0; i1 = i1 - 1)begin
			for(j1 = INPUTS - 1; j1 >= 0; j1 = j1 - 1)
				if(routeSelect[i1] == j1 & PortReserved[j1] & outputBusy[i1])//Port that feeds the output should be reserved.
					data_out[i1] = data_in[j1];
			end
	end
	
	integer i2, j2;
	//Priority Valid Mux
	always @(*)begin
		valid_out = 0;
		//Lower i inputs will be given prority with this design
		for(i2 = OUTPUTS - 1; i2 >= 0; i2 = i2 - 1)begin
			for(j2 = INPUTS - 1; j2 >= 0; j2 = j2 - 1)
				if(routeSelect[i2] == j2 & PortReserved[j2] & outputBusy[i2])//Port that feeds the output should be reserved.
					valid_out[i2] = valid_in[j2];
			//Send valid_out only when the output port is routed otherwise the next router may unintentionally receive high valid_in
		end
	end
	
	integer i3, j3;
	//Priority Ready Mux
	always @(*)begin
		//Lower i inputs will be given prority with this design
		for(i3 = INPUTS - 1; i3 >= 0; i3 = i3 - 1)begin
			ready_in[i3] = 0;
			for(j3 = OUTPUTS - 1; j3 >= 0; j3 = j3 - 1)
				if(routeSelect[j3] == i3 & outputBusy[j3] & PortReserved[i3])
					ready_in[i3] = ready_out[j3];
					//Relay the ready_in signal only for those inputs for which the path has actually been reserved.
		end
	end
	
endmodule
