//Generates VCPlaneSelector Signals for all 
/*module VCPlaneController 
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
		output [VC : 0] VCPlaneSelectorSwitchControl,//Selects the currently active VC Plane
		output [VC : 0] VCPlaneSelectorVerifier
	);
	//0, 1, 2, 3, 4, 5
	//3 Clock Cycles to Plane 0: Critical and 1 clock cycle each to other VCs
	integer counter = 0, counterNext = 0;
	
	reg [VC : 0] state = 0;
	
	always @(posedge clk, posedge rst)begin
		if(rst)begin
			counter <= #0.75 0;
		end
		
		else begin
			counter <= #1.25 counterNext;
		end
	end
	
	always @(*)begin
		if(counter == 5)
			counterNext = 0;
		else
			counterNext = counter + 1;
	end
	
	always @(*)begin
		case(counter)
			0 : state = 0;
			1 : state = 0;
			2 : state = 0;
			3 : state = 1;
			4 : state = 2;
			5 : state = 3;
			default : state = 0;
		endcase
	end
	
	assign VCPlaneSelectorCFSM = {32'b0, state};
	assign VCPlaneSelectorHFB = {32'b0, state};
	assign VCPlaneSelectorVCG = {32'b0, state};
	assign VCPlaneSelectorSwitchControl = {32'b0, state};
	assign VCPlaneSelectorVerifier = {32'b0, state};
	
endmodule*/


//Generates VCPlaneSelector Signals for all 
module VCPlaneController 
	#(
		parameter VC = 4,
		parameter INIT = 0
	)
	(
		input clk,
		input rst,
		
		//VC control Signals
		output [VC : 0] VCPlaneSelectorCFSM,//Selects the currently active VC Plane
		output [VC : 0] VCPlaneSelectorHFB,//Selects the currently active VC Plane
		output [VC : 0] VCPlaneSelectorVCG,//Selects the currently active VC Plane
		output [VC : 0] VCPlaneSelectorSwitchControl,//Selects the currently active VC Plane
		output [VC : 0] VCPlaneSelectorVerifier
	);
	//0, 1, 2, 3, 4, 5
	//3 Clock Cycles to Plane 0: Critical and 1 clock cycle each to other VCs
	logic [31 : 0] counter = INIT, counterNext = 0;
	
	reg [VC : 0] state = 0;
	
	always_ff @(posedge clk)begin
		if(rst)begin
			counter <= INIT;
		end
		
		else begin
			counter <= counterNext;
		end
	end
	
	always_comb begin
		if(counter == (VC - 1))
			counterNext = 0;
		else
			counterNext = counter + 1;
	end
	
	always_comb begin
		case(counter)
			0 : state = 0;
			1 : state = 1;
			2 : state = 2;
			3 : state = 3;
			default : state = 0;
		endcase
	end
	
	assign VCPlaneSelectorCFSM = {32'b0, state};
	assign VCPlaneSelectorHFB = {32'b0, state};
	assign VCPlaneSelectorVCG = {32'b0, state};
	assign VCPlaneSelectorSwitchControl = {32'b0, state};
	assign VCPlaneSelectorVerifier = {32'b0, state};
	
endmodule

