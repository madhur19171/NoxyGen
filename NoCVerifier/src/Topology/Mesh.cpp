/*
 * Mesh.cpp
 *
 *  Created on: 04-Dec-2021
 *      Author: madhur
 */

#include "Mesh.h"

Mesh::Mesh() {
	// TODO Auto-generated constructor stub
	this->dimX = floor(sqrt(N));
	this->dimY = floor(sqrt(N));
	this->topologyType = MESH;
	this->connected = true;//A rigular Mesh will always be connected
}

Mesh::Mesh(int N) : Topology(N){
	this->dimX = floor(sqrt(N));
	this->dimY = floor(sqrt(N));
	this->topologyType = MESH;
	this->connected = true;//A rigular Mesh will always be connected
}

Mesh::Mesh(int N, std::vector<std::string> nodeList, int flitsPerPacket, int phitsPerFlit, int VC) :
																								Topology(N, nodeList, flitsPerPacket, phitsPerFlit, VC){
	this->dimX = floor(sqrt(N));
	this->dimY = floor(sqrt(N));
	this->topologyType = MESH;
	this->connected = true;//A rigular Mesh will always be connected
}

Mesh::~Mesh() {
	// TODO Auto-generated destructor stub
}

//4D vector: VECTOR[NODE][VC][PACKET][FLIT]
std::vector<std::vector<std::vector<std::vector<std::string>>>> Mesh::generateTraffic(int numberOfPacketsPerNode, TrafficType trafficType, int flag){
	std::vector<std::vector<std::vector<std::vector<std::string>>>> ret;
	if(flag == 0)
		ret = this->generateVCSeparatedMixedCriticalTraffic(numberOfPacketsPerNode, trafficType);
	return ret;
}

//4D vector: VECTOR[NODE][VC][PACKET][FLIT]
std::vector<std::vector<std::vector<std::vector<std::string>>>> Mesh::generateVCSeparatedMixedCriticalTraffic(int numberOfPacketsPerNode, TrafficType trafficType){
	std::vector<std::vector<std::vector<std::vector<std::string>>>> ret;

	srand(time(0));

	int source, srcX, srcY;
	int destination, destX, destY;
	int flit = 0;

	for(int i = 0; i < N; i++){
		std::vector<std::vector<std::vector<std::string>>> nodeTraffic;//Stores the traffic of a particular Node
		source = i;
		destination = -1;

		//Creating a generating function
		unsigned seed = std::chrono::system_clock::now().time_since_epoch().count();
		std::default_random_engine generator (seed);

		//Creating Random Destination Generator for each Node
		//		std::uniform_int_distribution<int> destinationDistribution(0, N - 1);
		std::normal_distribution<double> destinationDistribution(N / 2.0 , 1.0);
		auto randomDestinationGenerator = std::bind ( destinationDistribution, generator );

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
					destination = int(randomDestinationGenerator());//Find a random destination
				} while (destination == source || (destination < 0 || destination >= N));//Destination should not be same as the source

				//Find X and Y cordinates of Source and Destination Nodes
				srcX = source % dimX;
				srcY = source / dimY;
				destX = destination % dimX;
				destY = destination / dimY;

				/*
				 * Packet Format:
				 * Head: <01>.......<Message Number> <Source X, Source Y> <Destination X, Destination Y>
				 * Body: <10>.......<Message Number> <Source X, Source Y> <Destination X, Destination Y> <Flit Number>
				 * Tail: <11>.......<Message Number> <Source X, Source Y> <Destination X, Destination Y>
				 * At max, 16 flits can be sent per message
				 * At max, 256 messages can be sent per node
				 */

				int numberOfFlits = randomNumberOfFlitsPerPacketGenerator();
				//Priority will be stored only in the head flit in 29 and 28th bits of the flit(starting from 0)
				int priority = numberOfFlits <= 5 ? 1 : 0;//Higher number means a higher priority

				//Packet Generation
				for(int k = 0; k < numberOfFlits; k++){
					flit = 0;//Empty flit

					if(k == 0){//Head Flit Generation
						flit |= destY;
						flit |= destX << 4;
						flit |= srcY << 8;
						flit |= srcX << 12;
						flit |= (j + (vc * numberOfPacketsPerNode / this->VC)) << 16;//Message Number: It is not alloted on a per VC basis, rather on a Per Node basis
						flit |= priority << 28;
						flit |= 1 << 30;//Head Flit Identifier
					} else if(k == numberOfFlits - 1){//Tail Flit Generation
						flit |= destY;
						flit |= destX << 4;
						flit |= srcY << 8;
						flit |= srcX << 12;
						flit |= (j + (vc * numberOfPacketsPerNode / this->VC)) << 16;//Message Number: It is not alloted on a per VC basis, rather on a Per Node basis
						flit |= 3 << 30;//Tail Flit Identifier
					} else{//Body Flit Generation
						flit |= k;
						flit |= destY << 4;
						flit |= destX << 8;
						flit |= srcY << 12;
						flit |= srcX << 16;
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
