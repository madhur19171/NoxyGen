//Demux acts as an interface between VC FIFOs and ControlFSM
//It demultiplexes all FIFO signals like Data, Valid, Ready, Push, Pop, Empty and Full
//based on the VCPlaneSelector signal

module SwitchControlDemux 
	#(
		parameter VC = 4,
		parameter INPUTS = 4,
		parameter OUTPUTS = 4,
		parameter REQUEST_WIDTH = 2
	)
	(
		//VC control Signals
		input [VC : 0] VCPlaneSelector,//Selects the currently active VC Plane
	
		//To SwitchController from HFB
		input [INPUTS - 1 : 0] routeReserveRequestValid,
		input [INPUTS * REQUEST_WIDTH - 1 : 0] routeReserveRequest,
		input [INPUTS - 1 : 0] routeRelieve,

	
	//VC:
		//To SwitchController from this
		output reg [VC * INPUTS - 1 : 0] routeReserveRequestValidVC = 0,
		output [VC * INPUTS * REQUEST_WIDTH - 1 : 0] routeReserveRequestVC,
		output reg  [VC * INPUTS - 1 : 0] routeRelieveVC = 0

	);
	
	
	integer i1;
	always @(*)begin
		routeReserveRequestValidVC = 0;
		for(i1 = 0; i1 < VC; i1 = i1 + 1)begin
			if(VCPlaneSelector == i1)
				routeReserveRequestValidVC[i1 * INPUTS +: INPUTS] = routeReserveRequestValid;
			else 
				routeReserveRequestValidVC[i1 * INPUTS +: INPUTS] = 0;
		end
	end
	
	integer i2;
	always @(*)begin
		routeRelieveVC = 0;
		for(i2 = 0; i2 < VC; i2 = i2 + 1)begin
			if(VCPlaneSelector == i2)
				routeRelieveVC[i2 * INPUTS +: INPUTS] = routeRelieve;
			else 
				routeRelieveVC[i2 * INPUTS +: INPUTS] = 0;
		end
	end
	
	assign routeReserveRequestVC = {VC{routeReserveRequest}};
	
endmodule
