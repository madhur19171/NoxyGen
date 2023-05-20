module NodeVerifier #(	parameter N = 4,
			parameter INDEX = 0,//Node ID
			parameter string INPUT_TRAFFIC_FILE = "",
			parameter string INPUT_DELAY_FILE = "",
			parameter string OUTPUT_FILE = "",
			parameter DATA_WIDTH = 32,
			parameter VC = 4,
			parameter IDENTIFIER_BITS = 2,
			parameter FLITS_PER_PACKET = 16,
			parameter PACKETS_PER_NODE = 256
			)
	(input clk, input rst,
	
	input [DATA_WIDTH - 1 : 0] data_in,
	input valid_in,
	output logic ready_in,
	
	output logic [DATA_WIDTH - 1 : 0] data_out,
	output logic valid_out,
	input ready_out,
	
	output allFlitsInjected,
	output int totalPacketsInjected,
	output int totalPacketsEjected
	);
	
	parameter MAX_FLITS = FLITS_PER_PACKET * PACKETS_PER_NODE;
	logic [DATA_WIDTH - 1 : 0] messageNumberMask = 32'hfff;
	
	int clockCycles = 0;
	
	int currentSize;
	
	int fileDescriptorInputTraffic;
	int fileDescriptorInputDelay;
	logic [31 : 0] fileDescriptorOutputTraffic [VC - 1 : 0] ;
	
	string inputTrafficFileName;
	string inputDelayFileName;
	string outputTrafficFileName;
	
	logic [DATA_WIDTH - 1 : 0] readData;
	
	logic [DATA_WIDTH - 1 : 0] inputVectors [VC - 1 : 0][MAX_FLITS - 1 : 0];
	int inputDelay [VC - 1 : 0][MAX_FLITS - 1 : 0];
	
	logic [DATA_WIDTH - 1 : 0] data_out_VC[VC - 1 : 0];
	logic valid_out_VC[VC - 1 : 0];
	
	logic [VC - 1 : 0]injected;
	logic [VC - 1 : 0]injecting;
	int injectionTime [VC - 1 : 0];
	int timeSinceInjection[VC - 1 : 0];
	int flitsInjected[VC - 1 : 0];
	int flitsEjected[VC - 1 : 0];
	int totalFlitsInjected;
	int totalFlitsEjected;
	
	int totalFlits[VC - 1 : 0];
	int totalFlitsAllVC;
	
	int packetsInjected[VC - 1 : 0];
	int packetsEjected[VC - 1 : 0];
	
	logic [$clog2(VC) - 1 : 0] currentVC, previousVC;
	
	int DIM = $sqrt(N);
	int REPRESENTATION_BITS = $clog2(DIM);
	
	int destinationX [VC - 1 : 0];
	int destinationY [VC - 1 : 0];
	int messageNumberInject [VC - 1 : 0];
	int destination [VC - 1 : 0];
	int sourceX ;
	int sourceY ;
	int messageNumberEject ;
	int source ;
	
	VCPlaneController #(.VC(VC)) vcPlaneController (.clk(clk), .rst(rst), .VCPlaneSelectorCFSM(currentVC));
	
	initial begin: Initializer
	
		totalFlitsAllVC = 0;
	
		for(int i = 0; i < VC; i++) 
			for(int j = 0; j < MAX_FLITS; j++)begin
				inputDelay[i][j] = 0;
				inputVectors[i][j] = 0;
			end
		
		//Initializing File Descriptors
		for(int i = 0; i < VC; i++) begin: FileDescriptorInitializer
			//Initializing Global Variables
			injected[i] = 0;
			injecting[i] = 0;
			timeSinceInjection[i] = 0;
			injectionTime[i] = 0;
			flitsInjected[i] = 0;
			flitsEjected[i] = 0;
			packetsInjected[i] = 0;
			packetsEjected[i] = 0;
			
			//Initializing File Descriptor for Input Traffic Files
			$sformat(inputTrafficFileName, "%s_%0d", INPUT_TRAFFIC_FILE, i);
			fileDescriptorInputTraffic = $fopen(inputTrafficFileName, "r");
			if(fileDescriptorInputTraffic)
				$display("File %s was opened successfully.", inputTrafficFileName);
			else
				$display("Filed to open %s.", inputTrafficFileName);
			
			currentSize = 0;
			while(!$feof(fileDescriptorInputTraffic)) begin
				$fscanf(fileDescriptorInputTraffic, "0x%h\n", readData);
				inputVectors[i][currentSize] = readData;
				currentSize++;
			end
			totalFlits[i] = currentSize;
				
			//Initializing File Descriptor for Input Delay Files
			$sformat(inputDelayFileName, "%s_%0d", INPUT_DELAY_FILE, i);
			fileDescriptorInputDelay = $fopen(inputDelayFileName, "r");
			if(fileDescriptorInputDelay)
				$display("File %s was opened successfully.", inputDelayFileName);
			else
				$display("Filed to open %s.", inputDelayFileName);
				
			currentSize = 0;
			while(!$feof(fileDescriptorInputDelay)) begin
				$fscanf(fileDescriptorInputDelay, "%d\n", readData);
				inputDelay[i][currentSize] = readData;
				currentSize++;
			end
		
			totalFlitsAllVC += totalFlits[i];
			
			//Initializing File Descriptor for Outtput Traffic Files
			$sformat(outputTrafficFileName, "%s_%0d", OUTPUT_FILE, i);
			fileDescriptorOutputTraffic[i] = $fopen(outputTrafficFileName, "w");
			if(fileDescriptorOutputTraffic[i])
				$display("File %s was opened successfully.", outputTrafficFileName);
			else
				$display("Filed to open %s.", outputTrafficFileName);
		end

		
		$display("Total flits to be routed for Node%0d: %0d", INDEX, totalFlitsAllVC);
	end
	
	//Identifier Fucntions
	function int isHeadFlit(logic [DATA_WIDTH - 1 : 0] flit);
		if(flit[DATA_WIDTH - 1 -: IDENTIFIER_BITS] == 2'b01)
			return 1;
		else 
			return 0;
	endfunction
	
	function int isTailFlit(logic [DATA_WIDTH - 1 : 0] flit);
		if(flit[DATA_WIDTH - 1 -: IDENTIFIER_BITS] == 2'b11)
			return 1;
		else 
			return 0;
	endfunction
	
	//Injection and Ejection Functions
	function void injectTraffic();
		if(flitsInjected[currentVC] != totalFlits[currentVC]) begin
			if(injected[currentVC] == 0) begin
				if(injecting[currentVC] == 0) begin
					data_out_VC[currentVC] = inputVectors[currentVC][flitsInjected[currentVC]];
					valid_out_VC[currentVC] = 1;
					injecting[currentVC] = 1;
					if(isHeadFlit(data_out)) begin	// // Packet Injection Starts when the Head is valid to enter NI Buffer
						injectionTime[currentVC] = clockCycles;
						destinationX[currentVC] = data_out & ((1 << REPRESENTATION_BITS) - 1);
						destinationY[currentVC] = (data_out >> REPRESENTATION_BITS) & ((1 << REPRESENTATION_BITS) - 1);
						messageNumberInject[currentVC] = (data_out >> 4 * REPRESENTATION_BITS) & messageNumberMask;
						destination[currentVC] = DIM * destinationY[currentVC] + destinationX[currentVC];
					end
				end else begin 
					if(valid_out & ready_out) begin
						valid_out_VC[currentVC] = 0;	//Flit is injected
						injecting[currentVC] = 0;
						injected[currentVC] = 1;
						timeSinceInjection[currentVC] = 0;
						flitsInjected[currentVC]++;	// Here, flit level injection is taken care of
						
						if (isTailFlit(data_out)) begin	// Packet Injection Ends when the Tail enters NI Buffer
							$display("Node%0d: Message: %0d Destination: %0d Injection_Time: %0d Departure_Time: %0d VC: %0d", INDEX, messageNumberInject[currentVC], destination[currentVC], injectionTime[currentVC], clockCycles, currentVC);
							injectionTime[currentVC] = 0;
							packetsInjected[currentVC]++;
						end
					end
				end
			end
			
			for(int i = 0; i < VC; i++) begin
				//Wait for some delay before next injection
				if(injected[i] == 1) begin
					if(timeSinceInjection[i] < inputDelay[i][flitsInjected[i]])
						timeSinceInjection[i] = timeSinceInjection[i] + 1;
					else
						injected[i] = 0;
				end
			end
		end
	endfunction
	
	function void ejectTraffic();
		if(valid_in & ready_in) begin
			flitsEjected[currentVC]++;
			if(isTailFlit(data_in)) begin
				sourceX = (data_in >> 3 * REPRESENTATION_BITS) & ((1 << REPRESENTATION_BITS) - 1);
				sourceY = (data_in >> 2 * REPRESENTATION_BITS) & ((1 << REPRESENTATION_BITS) - 1);
				messageNumberEject = (data_in >> 4 * REPRESENTATION_BITS) & messageNumberMask;
				source = DIM * sourceY + sourceX;
				$display("Node%0d: Message: %0d Source: %0d Arrival_Time: %0d VC: %0d", INDEX, messageNumberEject, source, clockCycles, currentVC);
				packetsEjected[currentVC]++;
			end
			$fwrite(fileDescriptorOutputTraffic[currentVC], "0x%0h\n", data_in);
		end
	endfunction
	
	assign allFlitsInjected = totalFlitsInjected == totalFlitsAllVC;	//Finish Signal
	
	always_comb begin
		data_out = data_out_VC[currentVC];
		valid_out = valid_out_VC[currentVC];
	end
	
	always_ff @(posedge clk) begin
		injectTraffic();
	end
	
	always_ff @(posedge clk) begin
		ejectTraffic();
	end
	
	always_ff @(posedge clk) begin
		totalFlitsInjected = 0;
		totalFlitsEjected = 0;
		totalPacketsInjected = 0;
		totalPacketsEjected = 0;
		for(int i = 0; i < VC; i++) begin
			totalFlitsInjected += flitsInjected[i];
			totalFlitsEjected += flitsEjected[i];
			totalPacketsInjected += packetsInjected[i];
			totalPacketsEjected += packetsEjected[i];
		end
		
		//$display("Total Flits Injected/Ejected in Node%0d: %0d/%0d\tTotal Flits: %0d", 
		//	INDEX, totalFlitsInjected, totalFlitsEjected, totalFlitsAllVC);
	end
	
	always_ff @(posedge clk)
		clockCycles++;
	always_ff @(posedge clk)	
		if(rst)
			previousVC <= 0;
		else previousVC <= currentVC;
	
	assign ready_in = 1;
	
endmodule
