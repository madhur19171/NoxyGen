module ControlFSM
	#(
	parameter DATA_WIDTH = 32,
	parameter FlitPerPacket = 4,//HBBT
	parameter PhitPerFlit = 2,
	parameter VC = 4,
	parameter REQUEST_WIDTH = 2,
	parameter TYPE_WIDTH = 2//For FlitType
	)
	(
	input clk,
	input rst,
	
	//Data In signal
	input [DATA_WIDTH - 1 : 0] data_in,
	
	//VC control Signals
	input [VC : 0] VCPlaneSelector,//Selects the currently active VC Plane
	
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
	output [$clog2(PhitPerFlit) : 0] phitCounter,
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
	
//====================================member declarations for all VC plane elements starts=====================================

	//Only Control Path and FIFO signals have to be in compliance with VC
	
	reg[VC * 3 - 1 : 0] stateVC = 0, nextStateVC = 0;
	
	reg [VC * ($clog2(FlitPerPacket) + 1) - 1 : 0] flitCounterVC = 0;
	
	reg [VC - 1 : 0]flitValidVC = 0;
	
	reg [VC * ($clog2(PhitPerFlit) + 1) - 1 : 0] phitCounterVC = 0;
	

//====================================member declarations for all VC plane elements ends=====================================

//=====================================Change Datapath state according to VCPlaneSelector start=================================================


//=====================================Change Datapath state according to VCPlaneSelector end=================================================
	
//	reg[2 : 0] state = 0, nextState = 0;
	
	
//	reg [$clog2(FlitPerPacket) : 0] flitCounter = 0;
	
	
	wire TailReceived;

//	reg flitValid = 0;

//	reg pushBuffer_state = 0;//Depreciated
	
//--------------------------------------Handshake Begins------------------------------

	assign #0.5 Handshake = valid_in & ready_in;

//--------------------------------------Handshake Ends------------------------------	
	
//--------------------------------------FSM Begins------------------------------
	always @(posedge clk)begin
			if(rst)
				stateVC[(VCPlaneSelector) * 3 +: 3] <= #0.75 UnRouted;
			else stateVC[(VCPlaneSelector) * 3 +: 3] <= #1.25 nextStateVC[(VCPlaneSelector) * 3 +: 3];//Sequential + Combinational delay
	end
	
	always @(*)begin
		nextStateVC = 0;
		case(stateVC[(VCPlaneSelector) * 3 +: 3])
			UnRouted: nextStateVC[(VCPlaneSelector) * 3 +: 3] = Handshake ? HeadFlit : UnRouted;
			//After the first flit is received, ready must go down until the route is 
			//reserved for this request.
			HeadFlit: nextStateVC[(VCPlaneSelector) * 3 +: 3] = ReservePath;
			ReservePath: nextStateVC[(VCPlaneSelector) * 3 +: 3] = routeReserveStatus ? Route : ReservePath;
			Route: nextStateVC[(VCPlaneSelector) * 3 +: 3] = TailReceived ? TailFlit : Route;
			TailFlit: nextStateVC[(VCPlaneSelector) * 3 +: 3] = UnRouted;
			default: nextStateVC[(VCPlaneSelector) * 3 +: 3] = UnRouted;
		endcase
	end
//--------------------------------------FSM Ends------------------------------

//-----------------------------------------Route Reserving Logic begins------------------------

	assign #0.5 reserveRoute = stateVC[(VCPlaneSelector) * 3 +: 3] == ReservePath;//the flit to be sent is a tail flit and it is going to be popped.

//-----------------------------------------Route Reserving Logic ends------------------------



//-----------------------------------------Route Relieving Logic begins------------------------
//Route Will be relieved only after the last tail packet has been successfully sent

	assign #0.5 routeRelieve = FlitType == TAIL & popBuffer;//the flit to be sent is a tail flit and it is going to be popped.

//-----------------------------------------Route Relieving Logic ends------------------------


//--------------------------------------PhitCounter Begins(Mealy: flitValid --> TODO: Try to make Moore for better clock period)------------------------------
	/*always @(posedge clk)begin
		if(rst)
			phitCounter <= #0.75 0;
		else
		if(phitCounter == PhitPerFlit)
			if(valid_in & ready_in)
				phitCounter <= #0.75 1;//New incoming phit will be part of new flit
			else phitCounter <= #0.75 0;//No new incoming phit so flit counter is 0
		else
		if(Handshake)
			phitCounter <= #0.75 phitCounter + 1;
	end
	*/
	
	//phitCounter remains 0 for PhitPerFlit = 1
	
	//Since flitValid is made high on the same clock cycle as the last phit is captured,
	//by the time Unrouted->HeadFlit, there is an extra phit captured in the buffer.
	//Either received 1 flit, or about to receive the last phit of the flit.
/* verilator lint_off WIDTH */
    always @(*)begin
    	//#0.1;
    	flitValidVC = 0;
        if((phitCounterVC[VCPlaneSelector * ($clog2(PhitPerFlit) + 1) +: ($clog2(PhitPerFlit) + 1)] == (PhitPerFlit - 1) & Handshake))//if(phitCounter == PhitPerFlit | (phitCounter == (PhitPerFlit - 1) & Handshake))
            flitValidVC[VCPlaneSelector] = #0.5 1;
        else 
            flitValidVC[VCPlaneSelector] = #0.5 0;
    end
    
    
    assign phitCounter = phitCounterVC[VCPlaneSelector * ($clog2(PhitPerFlit) + 1) +: ($clog2(PhitPerFlit) + 1)];
    	
//--------------------------------------PhitCounter Ends------------------------------

//--------------------------------------headFlitValid Begins------------------------------
	//Once headFlit is valid, HFB will ignore any other flits
	//A valid status register will be made high in HFB and it will go low after
	//the tail signal is received.
	assign #0.5 headFlitValid = (stateVC[(VCPlaneSelector) * 3 +: 3] == UnRouted) & Handshake;

//--------------------------------------headFlitValid Ends------------------------------


//--------------------------------------FlitCounter Begins(Mealy: TailReceived --> TODO: Try to make Moore for better clock period))------------------------------
//Right now, it is doing the work of FlitType signal. It should be made to serve some other purpose.
	//Since state is itself generated by a sequential logic, flitCounter will be 1 cycle late
	always @(posedge clk)begin
		if(rst)
			flitCounterVC[VCPlaneSelector * ($clog2(FlitPerPacket) + 1) +: ($clog2(FlitPerPacket) + 1)]  <= #0.75 0;
		else
		if(flitCounterVC[VCPlaneSelector * ($clog2(FlitPerPacket) + 1) +: ($clog2(FlitPerPacket) + 1)] == FlitPerPacket)
			flitCounterVC[VCPlaneSelector * ($clog2(FlitPerPacket) + 1) +: ($clog2(FlitPerPacket) + 1)] <= #0.75 0;//This is just to reset the Counter after all the Flits in the packet are received.
					//Not doing this will probably have no impact on the functionality.
		else
		if(stateVC[(VCPlaneSelector) * 3 +: 3] == UnRouted & Handshake)//Changed for VIVADO
			flitCounterVC[VCPlaneSelector * ($clog2(FlitPerPacket) + 1) +: ($clog2(FlitPerPacket) + 1)] <= #0.75 1;
		else
		if(Handshake & stateVC[(VCPlaneSelector) * 3 +: 3] == Route)
			flitCounterVC[VCPlaneSelector * ($clog2(FlitPerPacket) + 1) +: ($clog2(FlitPerPacket) + 1)] <= #0.75 flitCounterVC[VCPlaneSelector * ($clog2(FlitPerPacket) + 1) +: ($clog2(FlitPerPacket) + 1)] + 1;
	end
	
	/*This can be made by reading off the FlitType signal*/
	//Either all FlitPerPacket packets have been received or the last flit of the packet is about to be received in the Route state
	assign #1 TailReceived = (flitCounterVC[VCPlaneSelector * ($clog2(FlitPerPacket) + 1) +: ($clog2(FlitPerPacket) + 1)] == (FlitPerPacket)) 
				| (flitCounterVC[VCPlaneSelector * ($clog2(FlitPerPacket) + 1) +: ($clog2(FlitPerPacket) + 1)] == (FlitPerPacket - 1) & Handshake & stateVC[(VCPlaneSelector) * 3 +: 3] == Route);//As head is received
	//assign #0.5 TailReceived = routeRelieve;//Using this signal, the CMSM and HFB become non-pipelined

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

	//pushBuffer_state is depreciated.
	//It was kept so that another packet may not enter HFB unless the current packet is routed
	//However, it will no longer be a problem since the switchControl will not give up the route unless the
	//previous packet has sent a releiving signal.
	/*always @(posedge clk)begin
		if(rst)
			pushBuffer_state <= #0.75 0;
		else if(state == UnRouted)
			pushBuffer_state <= #0.75 1;
		else if(state == ReservePath & routeReserveStatus)//Just going to Route state
			pushBuffer_state <= #0.75 1;
		else if(TailReceived)//Stop receiving any buffers as soon you receive the Tail
			pushBuffer_state <= #0.75 1;	
	end*/

	assign #0.5 pushBuffer = Handshake;

//--------------------------------------pushBuffer Ends------------------------------

//--------------------------------------popBuffer Begins------------------------------
	//pop the new value after the handshake for the current data has happened.
	assign #0.5 popBuffer = valid_out & ready_out;

//--------------------------------------popBuffer Ends------------------------------	

//--------------------------------------ready_in Begins------------------------------

	//There should be space in the FIFO buffer
	//valid_in should be high before ready_in is made high
	//State should be UnRouted to receive Head Flit or it should be Route while routing the packets
	//after the path has been set up.
	//Update: ready_in_temp was needed to fix Vivado Simulations
	//It is no longer needed after giving combinational path delays
	reg ready_in_temp = 0;
	
	/*always @(negedge clk)begin
	   ready_in_temp <= 0;
	   if(~full & valid_in & (state == UnRouted | state == Route)
				| full & valid_in & (state == Route) & valid_out & ready_out)
	   ready_in_temp <= 1;
	end
	*/
				//If state is in Route, then it is sure that the port has reserved its path in the switch
				//So we can safely buffer one more packet in the input buffer given that it does not try to 
				//send routing request until the current packet is done routing.
				//If we try to decode head of next packet before the current packet has actually received a route reserve status,
				//the new packet may overwrite the request. This is why the new packets are not even received until the current packet
				//has successfully reserved a path in the switch.
	assign #1 ready_in = ~full & valid_in & ((stateVC[(VCPlaneSelector) * 3 +: 3] == UnRouted & data_in[31 : 30] == 1) //If we are receiving Head Flit
				| (stateVC[(VCPlaneSelector) * 3 +: 3] == Route & (data_in[31 : 30] == 2 | data_in[31 : 30] == 3)));//If we are receiving Body/Tail flit when the router is routing
				
				//| full & valid_in & (stateVC[(VCPlaneSelector) * 3 +: 3] == Route) & valid_out & ready_out | ready_in_temp;//Comment out if setup violation happens. This line will 
				//make the ready go high if the next link is available and fifo is full. It is like a simulataneous read and write.
				//But it will lead to setup time viloations because now, the entire ready path is combinatonal without any buffers
				//ready is anded in all paths.
				
				//ready_in can also be high when incoming data is directly forwarded to the output and 
				//and the receiver is ready to accept the handshake in route state.

//--------------------------------------ready_in Ends------------------------------	


//--------------------------------------valid_out Begins------------------------------
	//If buffer is not empty, it is ready to send out data
	assign #0.5 valid_out = ~empty;//empty is already multiplexed by VCG

//--------------------------------------valid_out Ends------------------------------	



endmodule

