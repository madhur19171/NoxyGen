/*
 * Star.cpp
 *
 *  Created on: 24-Feb-2022
 *      Author: madhur
 */



#include "Star.h"

Star::Star() {
	// TODO Auto-generated constructor stub
	this->concentration = -1;
	this->topologyType = STAR;
	this->connected = true;//A regular Star will always be connected
}

Star::Star(int N) : Topology(N){
	this->topologyType = STAR;
	this->concentration = N - 1;
	this->connected = true;//A regular Star will always be connected
}

Star::Star(int N, std::vector<std::string> nodeList, int flitsPerPacket, int phitsPerFlit, int VC) : Topology(N, nodeList, flitsPerPacket, phitsPerFlit, VC){
	this->topologyType = STAR;
	this->concentration = N - 1;
	this->connected = true;//A rigular Star will always be connected
}

Star::~Star() {
	// TODO Auto-generated destructor stub
}

//4D vector: VECTOR[NODE][VC][PACKET][FLIT]
std::vector<std::vector<std::vector<std::vector<std::string>>>> Star::generateTraffic(int numberOfPacketsPerNode, TrafficType trafficType, int flag){
	std::vector<std::vector<std::vector<std::vector<std::string>>>> ret;
	if(flag == 0)
		ret = this->generateVCSeparatedMixedCriticalTraffic(numberOfPacketsPerNode, trafficType);
	return ret;
}

//4D vector: VECTOR[NODE][VC][PACKET][FLIT]
std::vector<std::vector<std::vector<std::vector<std::string>>>> Star::generateVCSeparatedMixedCriticalTraffic(int numberOfPacketsPerNode, TrafficType trafficType){
	std::vector<std::vector<std::vector<std::vector<std::string>>>> ret;

	srand(time(0));

	int source;
	int destination;
	int flit = 0;

	for(int i = 0; i < N; i++){
		std::vector<std::vector<std::vector<std::string>>> nodeTraffic;//Stores the traffic of a particular Node
		source = i;
		destination = -1;

		//Creating a generating function
		unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
		std::default_random_engine generator (seed);

		//Creating Random Destination Generator for each Node
		std::uniform_int_distribution<int> uniformDestinationDistribution(0, N - 1);
		//Mean of N/2 and Standard deviation of 5
		std::normal_distribution<double> normalDestinationDistribution(N / 2.0 , 10);

		for(int vc = 0; vc < this->VC; vc++){
			std::vector<std::vector<std::string>> VCTraffic;
			int minimumNumberOfFlits,maximumNumberOfFlits;

			if(vc == 0){//VC number 0 is High Priority VC and has smaller packets
				minimumNumberOfFlits = 3;
				maximumNumberOfFlits = 4;
			} else{//Rest of the VC are of equal Priority and can have medium to large packets
				minimumNumberOfFlits = 5;
				maximumNumberOfFlits =  this->flitsPerPacket;
			}

			//Creating Random "Number of Flits per Packet" Generator for each Node
			std::uniform_int_distribution<int> flitsPerPacketDistribution(minimumNumberOfFlits , maximumNumberOfFlits);//Generating atleast one body flit and at max flitsPerPacket
			auto randomNumberOfFlitsPerPacketGenerator = std::bind ( flitsPerPacketDistribution, generator );

			for(int j = 0; j < numberOfPacketsPerNode / this->VC; j++){
				std::vector<std::string> packetTraffic;//Stores the traffic of a particular Packet. Stores the flits in a packet.
				do{
					switch(trafficType){
					case UNIFORM_RANDOM: destination = int(uniformDestinationDistribution(generator)); break;//Find a random destination
					case HOTSPOT: destination = int(normalDestinationDistribution(generator)); break;//Find a random destination
					default: destination = int(uniformDestinationDistribution(generator));break;//Find a random destination
					}
				} while (destination == source || (destination < 0 || destination >= N));//Destination should not be same as the source

				//Source and destination encodings will take 8-bits.
				//There can be maximum 256 Nodes.
				/*
				 * Packet Format:
				 * Head: <01><Priority>.......<Message Number> <Source> <Destination>
				 * Body: <10>.......<Message Number> <Source> <Destination <Flit Number>
				 * Tail: <11>.......<Message Number> <Source> <Destination>
				 * At max, 16 flits can be sent per message
				 * At max, 256 messages can be sent per node
				 */

				int numberOfFlits = randomNumberOfFlitsPerPacketGenerator();
				//Priority will be stored only in the head flit in 29 and 28th bits of the flit(starting from 0)
				int priority = numberOfFlits <= 4 ? 1 : 0;//Higher number means a higher priority

				//Packet Generation
				for(int k = 0; k < numberOfFlits; k++){
					flit = 0;//Empty flit

					if(k == 0){//Head Flit Generation
						flit |= destination;
						flit |= source << 8;
						flit |= (j + (vc * numberOfPacketsPerNode / this->VC)) << 16;//Message Number: It is not alloted on a per VC basis, rather on a Per Node basis
						flit |= priority << 28;
						flit |= 1 << 30;//Head Flit Identifier
					} else if(k == numberOfFlits - 1){//Tail Flit Generation
						flit |= destination;
						flit |= source << 8;
						flit |= (j + (vc * numberOfPacketsPerNode / this->VC)) << 16;//Message Number: It is not alloted on a per VC basis, rather on a Per Node basis
						flit |= 3 << 30;//Tail Flit Identifier
					} else{//Body Flit Generation
						flit |= k;
						flit |= destination << 4;
						flit |= source << 12;
						flit |= (j + (vc * numberOfPacketsPerNode / this->VC)) << 20;//Message Number: It is not alloted on a per VC basis, rather on a Per Node basis
						flit |= 2 << 30;//Body Flit Identifier
					}
					std::stringstream flitString;
					flitString << "0x" << std::hex << flit;
					packetTraffic.push_back(flitString.str());
				}
				VCTraffic.push_back(packetTraffic);
			}
			nodeTraffic.push_back(VCTraffic);
		}
		ret.push_back(nodeTraffic);
	}

	return ret;
}
