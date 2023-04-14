module HeadFlitUpdater #(
	parameter DATA_WIDTH = 32,
	parameter TYPE_WIDTH = 2
) (
	input [DATA_WIDTH - 1 : 0] flit_in,
	input [TYPE_WIDTH - 1 : 0] flitType,
	input updateHeadFlit,	// Tells whether the update is actually needed to the head flit or not
	input [DATA_WIDTH - 1 : 0] newHeadFlit,

	output logic [DATA_WIDTH - 1 : 0] flit_out
);

	always_comb begin
		if (flitType == 2'b01 & updateHeadFlit) begin
			flit_out = newHeadFlit;
		end

		else begin
			flit_out = flit_in;
		end
	end
	
endmodule