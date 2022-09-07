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
	this->connected = true;//A regular Mesh will always be connected
}

Mesh::Mesh(int N) : Topology(N){
	this->dimX = floor(sqrt(N));
	this->dimY = floor(sqrt(N));
	this->topologyType = MESH;
	this->connected = true;//A regular Mesh will always be connected
}

Mesh::Mesh(int N, int DATA_WIDTH, std::vector<std::string> nodeList, int flitsPerPacket, int phitsPerFlit, int VC, bool fixedSizePackets)
		: Topology(N, DATA_WIDTH, nodeList, flitsPerPacket, phitsPerFlit, VC, fixedSizePackets){
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

	int REPRESENTATION_BITS = (int)ceil(log2(dimX));

	uint64_t flit = 0;

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

			//Find X and Y cordinates of Source Nodes
			srcX = source % dimX;
			srcY = source / dimY;

			for(int j = 0; j < numberOfPacketsPerNode / this->VC; j++){
				std::vector<std::string> packetTraffic;//Stores the traffic of a particular Packet. Stores the flits in a packet.
				do{
					switch(trafficType){
					case UNIFORM_RANDOM: destination = int(uniformDestinationDistribution(generator)); break;//Find a random destination
					case HOTSPOT: destination = int(normalDestinationDistribution(generator)); break;//Find a random destination with Gaussian probability
					case TRANSPOSE://(i, j) to (j, i) cordinates.
						if(srcX == srcY)
						{
							destX = 1;
							destY = 0;
						} else{
							destX = srcY;
							destY = srcX;
						}
						destination = destY * dimX + destX;
						break;
					default: destination = int(uniformDestinationDistribution(generator));break;//Find a random destination
					}
				} while (destination == source || (destination < 0 || destination >= N));//Destination should not be same as the source

				//Find X and Y cordinates of Destination Nodes
				destX = destination % dimX;
				destY = destination / dimY;

				/*
				 * Packet Format:
				 * Head: <01><Priority>.......<Message Number> <Source X, Source Y> <Destination X, Destination Y>
				 * Body: <10>.......<Message Number> <Source X, Source Y> <Destination X, Destination Y> <Flit Number>
				 * Tail: <11>.......<Message Number> <Source X, Source Y> <Destination X, Destination Y>
				 * At max, 16 flits can be sent per message
				 * At max, 256 messages can be sent per node
				 */

				int numberOfFlits = this->fixedSizePackets ? this->flitsPerPacket : randomNumberOfFlitsPerPacketGenerator();
				//Priority will be stored only in the head flit in 29 and 28th bits of the flit(starting from 0)
				int priority = numberOfFlits <= 4 ? 1 : 0;//Higher number means a higher priority

				//Packet Generation
				for(int k = 0; k < numberOfFlits; k++){
					flit = 0;//Empty flit

					uint64_t identifier;

					if(k == 0){//Head Flit Generation
						identifier = 1;
						flit |= destY;
						flit |= destX << REPRESENTATION_BITS;
						flit |= srcY << (2 * REPRESENTATION_BITS);
						flit |= srcX << (3 * REPRESENTATION_BITS);
						flit |= (j + (vc * numberOfPacketsPerNode / this->VC)) << (4 * REPRESENTATION_BITS);//Message Number: It is not alloted on a per VC basis, rather on a Per Node basis
						flit |= priority << (this->DATA_WIDTH - 4);
						flit |= identifier << (this->DATA_WIDTH - 2);//Head Flit Identifier
					} else if(k == numberOfFlits - 1){//Tail Flit Generation
						identifier = 3;
						flit |= destY;
						flit |= destX << REPRESENTATION_BITS;
						flit |= srcY << (2 * REPRESENTATION_BITS);
						flit |= srcX << (3 * REPRESENTATION_BITS);
						flit |= (j + (vc * numberOfPacketsPerNode / this->VC)) << (4 * REPRESENTATION_BITS);//Message Number: It is not alloted on a per VC basis, rather on a Per Node basis
						flit |= identifier << (this->DATA_WIDTH - 2);//Tail Flit Identifier
					} else{//Body Flit Generation
						identifier = 2;
						flit |= k;
						flit |= destY << 4;
						flit |= destX << (4 + REPRESENTATION_BITS);
						flit |= srcY << (4 + 2 * REPRESENTATION_BITS);
						flit |= srcX << (4 + 3 * REPRESENTATION_BITS);
						flit |= (j + (vc * numberOfPacketsPerNode / this->VC)) << (4 + 4 * REPRESENTATION_BITS);//Message Number: It is not alloted on a per VC basis, rather on a Per Node basis
						flit |= identifier << (this->DATA_WIDTH - 2);//Body Flit Identifier
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
