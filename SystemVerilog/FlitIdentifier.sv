module FlitIdentifier
	#(
	parameter DATA_WIDTH = 32,
	parameter TYPE_WIDTH = 2
	)
	(
	input [DATA_WIDTH - 1 : 0] Flit,
	output reg [TYPE_WIDTH - 1 : 0] FlitType = 0
	);

	//For this design, the flit identifiers are in the first two (MSBs) of the Flit

	localparam HeadIdentifier = 1, PayLoadIdentifier = 2, TailIdentifier = 3;//These are the first two MSB of Flit
	
	localparam DEFAULT = 0, HEAD = 1, PAYLOAD = 2, TAIL = 3;//These will be sent as the flit identity.
	
	always_comb begin
		case(Flit[DATA_WIDTH - 1 -: TYPE_WIDTH])
			HeadIdentifier : FlitType = HEAD;
			PayLoadIdentifier : FlitType = PAYLOAD;
			TailIdentifier : FlitType = TAIL;
			default : FlitType = DEFAULT;
		endcase
	end

endmodule
