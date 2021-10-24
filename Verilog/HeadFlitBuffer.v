module HeadFlitBuffer #(
			parameter N = 4,	//Number of nodes in the network
			parameter INDEX = 1,	//This identifies the Node number for Routing Table
			parameter DATA_WIDTH = 8,
			parameter PhitPerFlit = 2,
			parameter REQUEST_WIDTH = 2
			)
	(	
	input clk,
	input rst,
	//From FIFO
	input Handshake,
	input [DATA_WIDTH - 1 : 0] Head_Phit,
	//From Control FSM
	input headFlitValid,
	input [$clog2(PhitPerFlit) : 0] phitCounter,//Not needed if we are triggering route reserve request as soon as we receive the head flit
	input reserveRoute,// Not needed if we are triggering route reserve request as soon as we receive the head flit
	output routeReserveStatus_CFSM,
	output headFlitStatus,
	//To Switch
	output routeReserveRequestValid,
	output[REQUEST_WIDTH - 1 : 0] routeReserveRequest,
	input routeReserveStatus_Switch
	);
	
	reg [DATA_WIDTH * PhitPerFlit - 1 : 0] headBuffer = 0;
	reg headFlitValidStatus = 0;
	

//--------------------------------------HeadBuffer Begins------------------------------
	always @(posedge clk)begin
		if(rst)
			headBuffer <= 0;
		else 
		if(Handshake & ~headFlitValidStatus & headFlitValid)
			headBuffer[DATA_WIDTH * phitCounter +: DATA_WIDTH] <= Head_Phit;
	end
//--------------------------------------HeadBuffer Ends------------------------------

//--------------------------------------HeadFlitValidStatus Begins------------------------------
//headFlitStatus 0 means that the head flit buffer is empty and new head flit can be stored in it.
	always @(posedge clk)begin
		if(rst)
			headFlitValidStatus <= 0;
		else
		if(routeReserveStatus_Switch)
			headFlitValidStatus <= 0;
		else
		if(headFlitValid)
			headFlitValidStatus <= 1;
	end
//--------------------------------------HeadFlitValidStatus Ends------------------------------

    //Right Now, All ports use their own Head FLit Decoder even though the routing information remains the same for all ports in a router
    //This should ideally become a unified Decoder which can serve all ports. However, this will lead to arbitration in case of request coming at the same time.
    //This is also latency sensitive and must serve the request as soon as it is received. Design should be changed to make it latency insensitive.
    //This will allow implementation of flexible custom routing algorithms by just changing HeadFlitDecoder as a black box for the rest of the design.
	HeadFlitDecoder #(.N(N), .INDEX(INDEX), .DATA_WIDTH(DATA_WIDTH), .PhitPerFlit(PhitPerFlit), .REQUEST_WIDTH(REQUEST_WIDTH)) headFlitDecoder
		(
		.HeadFlit(headBuffer),
		.RequestMessage(routeReserveRequest)
		);

	//As soon as valid head flit is received, a request will be sent
	//The request will be valid until it is accepted by the switch and routeReserveStatus is made high
	assign routeReserveRequestValid = headFlitValidStatus;

	//A simple forwarding of this signal to the CFSM
	assign routeReserveStatus_CFSM = routeReserveStatus_Switch;

endmodule
