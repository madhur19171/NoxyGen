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

Mesh::Mesh(int N, std::vector<std::string> nodeList, int flitsPerPacket, int phitsPerFlit) :
								Topology(N, nodeList, flitsPerPacket, phitsPerFlit){
	this->dimX = floor(sqrt(N));
	this->dimY = floor(sqrt(N));
	this->topologyType = MESH;
	this->connected = true;//A rigular Mesh will always be connected
}

Mesh::~Mesh() {
	// TODO Auto-generated destructor stub
}

std::vector<std::string> Mesh::generateTraffic(int numberOfPacketsPerNode, TrafficType trafficType){
	std::vector<std::string> ret;

	srand(time(0));

	int source, srcX, srcY;
	int destination, destX, destY;
	int flit = 0;

	for(int i = 0; i < N; i++){
		std::stringstream nodePackets;//A list that appends all the packets sent by the current node
		source = i;
		destination = -1;

		for(int j = 0; j < numberOfPacketsPerNode; j++){
			do{
				destination = rand() % N;//Find a random destination
			} while (destination == source);//Destination should not be same as the source

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

			//Packet Generation
			for(int k = 0; k < flitsPerPacket; k++){
				flit = 0;//Empty flit

				if(k == 0){//Head Flit Generation
					flit |= destY;
					flit |= destX << 4;
					flit |= srcX << 8;
					flit |= srcY << 12;
					flit |= j << 16;//Message Number
					flit |= 1 << 30;//Head Flit Identifier
				} else if(k == flitsPerPacket - 1){//Tail Flit Generation
					flit |= destY;
					flit |= destX << 4;
					flit |= srcX << 8;
					flit |= srcY << 12;
					flit |= j << 16;//Message Number
					flit |= 3 << 30;//Tail Flit Identifier
				} else{//Body Flit Generation
					flit |= k;
					flit |= destY << 4;
					flit |= destX << 8;
					flit |= srcX << 12;
					flit |= srcY << 16;
					flit |= j << 20;//Message Number
					flit |= 2 << 30;//Body Flit Identifier
				}

				nodePackets << "0x" << std::hex << flit << std::endl;
			}
		}
		ret.push_back(nodePackets.str());
	}

	return ret;
}
