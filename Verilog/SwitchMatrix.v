//Design for Mesh Based NoC with each switch having 4 Inputs and 4 Outputs
//Switching control logic will be in a separate unit.
module SwitchMatrix
	#(
	parameter N = 4,
	parameter DATA_WIDTH = 8,
	parameter REQUEST_WIDTH = 32
	) 
	
	(
	//Request Signals:
	input [N - 1] routeReserveRequestValid,
	input [N * $clog2(N) - 1 : 0] routeReserveRequest,//This signal selects the input using the first $clog2(N) bits and assigns the output to the last $clog2(N) bit address output.
	output [N - 1]routeReserveStatus,
	
	//Data Input
	input [N * DATA_WIDTH - 1 : 0] data_in,
	//Data Output
	output reg [N * DATA_WIDTH - 1 : 0] data_out = 0,
	);
	
	integer i;
	
	reg [N * $clog2(N) - 1 : 0] switchState = 0;
	reg [N - 1 : 0] switchBusy = 0, switchRequest = 0;
	
	always @(posedge clk)begin
		if(rst)
			switchState <= 0;
		else 
		if(route)
	end
	
	always @(posedge clk)begin
		if(rst) 
			switchBusy <= 0;
		else 
		for(i = N - 1; i >= 0; i = i - 1)begin
			if(~switchBusy[i] & switchRequest[i])begin
				switchBusy[i] <= 1;
			end
				
		end
	end
	
	//Direction Encoding for Mesh based switches:
	//0 : North	1 : South	2 : West	3 : East
	
	always @(*)begin
		data_out = 0;
		for(i = N - 1; i >= 0; i = i - 1)begin
			data_out[switchState[i * $clog2(N) +: $clog2(N)] * DATA_WIDTH +: DATA_WIDTH] = data_in[i * DATA_WIDTH +: DATA_WIDTH];
		end
	end
	
endmodule
