//Generates VCPlaneSelector Signals for all 
module VCPlaneController 
	#(
		parameter VC = 4
	)
	(
		input clk,
		input rst,
		
		//VC control Signals
		output [VC : 0] VCPlaneSelectorCFSM,//Selects the currently active VC Plane
		output [VC : 0] VCPlaneSelectorHFB,//Selects the currently active VC Plane
		output [VC : 0] VCPlaneSelectorVCG,//Selects the currently active VC Plane
		output [VC : 0] VCPlaneSelectorSwitchControl//Selects the currently active VC Plane
	);
	
	reg [VC - 1 : 0] counter = 0, counterNext = 0;
	
	always @(posedge clk, posedge rst)begin
		if(rst)begin
			counter <= #0.75 0;
		end
		
		else begin
			counter <= #1.25 counterNext;
		end
	end
	
	always @(*)begin
		if(counter == VC - 1)
			counterNext = 0;
		else
			counterNext = counter + 1;
	end
	
	assign VCPlaneSelectorCFSM = {32'b0, counter};
	assign VCPlaneSelectorHFB = {32'b0, counter};
	assign VCPlaneSelectorVCG = {32'b0, counter};
	assign VCPlaneSelectorSwitchControl = {32'b0, counter};
	
endmodule
