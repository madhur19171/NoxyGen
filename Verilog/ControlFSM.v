module ControlFSM
	#(
	parameter FlitPerPacket = 4,//HBBT
	parameter PhitPerFlit = 2,
	parameter REQUEST_WIDTH = 2,
	parameter TYPE_WIDTH = 2//For FlitType
	)
	(
	input clk,
	input rst,
	
	//Handshake Signals
	input valid_in,
	output ready_in,
	
	output valid_out,
	input ready_out,
	
	//Flit Identifier Signals
	input [TYPE_WIDTH - 1 : 0]FlitType,
	
	//Head Flit Buffer Signals
	output reserveRoute,
	input routeReserveStatus,
	
	output headFlitValid,
	output reg [$clog2(PhitPerFlit) : 0] phitCounter = 0,
	input headFlitStatus,
	
	//FIFO Signals
	output popBuffer,
	output pushBuffer,
	output Handshake,
	input full,
	input empty,
	
	//Switch Signal
	output routeRelieve
	);
	
	//Flit Types:
	//01: Head
	//10: Payload
	//11: Tail
	
	localparam HEAD = 1, PAYLOAD = 2, TAIL = 3;
		
	localparam UnRouted = 0, HeadFlit = 1, ReservePath = 2, Route = 3, TailFlit = 4;
	
	reg[2 : 0] state = 0, nextState = 0;
	
	reg [$clog2(FlitPerPacket) : 0] flitCounter = 0;
	
	
	wire TailReceived;

	wire flitValid;
	
	reg pushBuffer_state = 0;
	
//--------------------------------------Handshake Begins------------------------------

	assign Handshake = valid_in & ready_in;

//--------------------------------------Handshake Ends------------------------------	
	
//--------------------------------------FSM Begins------------------------------
	always @(posedge clk)begin
		if(rst)
			state <= UnRouted;
		else state <= nextState;
	end
	
	always @(*)begin
		case(state)
			UnRouted: nextState = flitValid ? HeadFlit : UnRouted;
			//After the first flit is received, ready must go down until the route is 
			//reserved for this request.
			HeadFlit: nextState = ReservePath;
			ReservePath: nextState = routeReserveStatus ? Route : ReservePath;
			Route: nextState = TailReceived ? TailFlit : Route;
			TailFlit: nextState = UnRouted;
			default: nextState = UnRouted;
		endcase
	end
//--------------------------------------FSM Ends------------------------------

//-----------------------------------------Route Reserving Logic begins------------------------

	assign reserveRoute = state == ReservePath;//the flit to be sent is a tail flit and it is going to be popped.

//-----------------------------------------Route Reserving Logic ends------------------------



//-----------------------------------------Route Relieving Logic begins------------------------
//Route Will be relieved only after the last tail packet has been successfully sent

	assign routeRelieve = FlitType == TAIL & popBuffer;//the flit to be sent is a tail flit and it is going to be popped.

//-----------------------------------------Route Relieving Logic ends------------------------


//--------------------------------------PhitCounter Begins(Mealy: flitValid --> TODO: Try to make Moore for better clock period)------------------------------
	always @(posedge clk)begin
		if(rst)
			phitCounter <= 0;
		else
		if(phitCounter == PhitPerFlit)
			if(valid_in & ready_in)
				phitCounter <= 1;//New incoming phit will be part of new flit
			else phitCounter <= 0;//No new incoming phit so flit counter is 0
		else
		if(Handshake)
			phitCounter <= phitCounter + 1;
	end
	
	//Since flitValid is made high on the same clock cycle as the last phit is captured,
	//by the time Unrouted->HeadFlit, there is an extra phit captured in the buffer.
	//Either received 1 flit, or about to receive the last phit of the flit.
	assign flitValid = (phitCounter == PhitPerFlit) | (phitCounter == (PhitPerFlit - 1) & Handshake);
//--------------------------------------PhitCounter Ends------------------------------

//--------------------------------------headFlitValid Begins------------------------------
	//Once headFlit is valid, HFB will ignore any other flits
	//A valid status register will be made high in HFB and it will go low after
	//the tail signal is received.
	assign headFlitValid = state == UnRouted & flitValid & Handshake;

//--------------------------------------headFlitValid Ends------------------------------


//--------------------------------------FlitCounter Begins(Mealy: TailReceived --> TODO: Try to make Moore for better clock period))------------------------------
//Right now, it is doing the work of FlitType signal. It should be made to serve some other purpose.
	always @(posedge clk)begin
		if(rst)
			flitCounter <= 0;
		else
		if(flitCounter == FlitPerPacket)
			flitCounter <= 0;//This is just to reset the Counter after all the Flits in the packet are received.
					//Not doing this will probably have no impact on the functionality.
		else
		if(flitValid & state == HeadFlit)
			flitCounter <= 1;
		else
		if(flitValid & state == Route)
			flitCounter <= flitCounter + 1;
	end
	
	/*This can be made by reading off the FlitType signal*/
	//Either all FlitPerPacket packets have been received or the last flit of the packet is about to be received in the Route state
	assign TailReceived = (flitCounter == (FlitPerPacket)) | (flitCounter == (FlitPerPacket - 1) & flitValid & state == Route);//As head is received
//--------------------------------------FlitCounter Ends------------------------------


//--------------------------------------pushBuffer Begins(Mealy)------------------------------
//Push the data as long as you haven't got the Tail
//It is assumed for Now that the Buffer capacity is enough to store a complete Packet
//However, the data following Head is not pushed until the path has been reserved.

//	always @(posedge clk)begin
//		if(rst)
//			pushBuffer_state <= 0;
//		else if(TailReceived)
//			pushBuffer_state = 0;
//		else if(state == UnRouted)
//			pushBuffer_state <= 1;
//			
//	end

	always @(posedge clk)begin
		if(rst)
			pushBuffer_state <= 0;
		else if(state == UnRouted)
			pushBuffer_state <= 1;
		else if(state == ReservePath & routeReserveStatus)//Just going to Route state
			pushBuffer_state <= 1;
		else if(TailReceived)//Stop receiving any buffers as soon you receive the Tail
			pushBuffer_state <= 0;	
	end

	assign pushBuffer = pushBuffer_state & Handshake;

//--------------------------------------pushBuffer Ends------------------------------

//--------------------------------------popBuffer Begins------------------------------
	//pop the new value after the handshake for the current data has happened.
	assign popBuffer = valid_out & ready_out;

//--------------------------------------popBuffer Ends------------------------------	

//--------------------------------------ready_in Begins------------------------------

	//There should be space in the FIFO buffer
	//valid_in should be high before ready_in is made high
	//State should be UnRouted to receive Head Flit or it should be Route while routing the packets
	//after the path has been set up.
	assign ready_in = ~full & valid_in & (state == UnRouted | state == Route)
				| full & valid_in & (state == Route) & valid_out & ready_out;
				//ready_in can also be high when incoming data is directly forwarded to the output and 
				//and the receiver is ready to accept the handshake in route state.

//--------------------------------------ready_in Ends------------------------------	


//--------------------------------------valid_out Begins------------------------------
	//If buffer is not empty, it is ready to send out data
	assign valid_out = ~empty;

//--------------------------------------valid_out Ends------------------------------	



endmodule

