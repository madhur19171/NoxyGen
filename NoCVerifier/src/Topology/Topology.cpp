/*
 * Topology.cpp
 *
 *  Created on: 04-Dec-2021
 *      Author: madhur
 */

#include "Topology.h"

Topology::Topology() {
	// TODO Auto-generated constructor stub
	this->topologyType = UNDEFINED_TOPOLOGY;
	this->DATA_WIDTH = 64;
	this->N = 0;
	this->flitsPerPacket = 0;//This is the maximum flits alowed in a packet
	this->VC = 0;
	this->connected = false;
	this->fixedSizePackets = false;
}

Topology::Topology(int N) {
	// TODO Auto-generated constructor stub
	this->topologyType = UNDEFINED_TOPOLOGY;
	this->N = N;
	this->DATA_WIDTH = 64;
	this->flitsPerPacket = 0;//This is the maximum flits alowed in a packet
	this->VC = 0;
	this->connected = false;
	this->fixedSizePackets = false;
}

Topology::Topology(int N, int DATA_WIDTH, std::vector<std::string> nodeList, int flitsPerPacket, int VC, bool fixedSizePackets) {
	// TODO Auto-generated constructor stub
	this->topologyType = UNDEFINED_TOPOLOGY;
	this->N = N;
	this->DATA_WIDTH = DATA_WIDTH;
	this->flitsPerPacket = flitsPerPacket;//This is the maximum flits alowed in a packet
	this->connected = false;
	this->VC = VC;
	this->nodeList = nodeList;
	this->fixedSizePackets = fixedSizePackets;
}

Topology::~Topology() {
	// TODO Auto-generated destructor stub
}

//4D vector: VECTOR[NODE][VC][PACKET][FLIT]
std::vector<std::vector<std::vector<std::vector<std::string>>>> Topology::generateTraffic(int numberOfPacketsPerNode, TrafficType trafficType, int flag){
	std::vector<std::vector<std::vector<std::vector<std::string>>>> ret;//4D vector: VECTOR[NODE][VC][PACKET][FLIT]
	return ret;
}

//Number of delays will depend on the actual number of flits generated
//traffic variable should be set before delays are generated.
//Delays are generated for each flit separately, so the number of flits needs to be known
//beforehand.
//Delay generated is independent of the Topology, so it is defined in the superclass
std::vector<std::vector<std::vector<std::vector<std::string>>>> Topology::generateDelay(int numberOfPacketsPerNode, int maxDelay){
	std::vector<std::vector<std::vector<std::vector<std::string>>>> ret;//4D vector: VECTOR[NODE][VC][PACKET][FLIT]

	srand(time(0));

	for(unsigned int i = 0; i < this->traffic.size(); i++){
		std::vector<std::vector<std::vector<std::string>>> nodeDelay;
		for(unsigned int j = 0; j < this->traffic[i].size(); j++){
			std::vector<std::vector<std::string>> VCDelay;
			for(unsigned int k = 0; k < this->traffic[i][j].size(); k++){
				std::vector<std::string> packetDelay;
				for(unsigned int l = 0; l < this->traffic[i][j][k].size(); l++){
					if(l == 0){
						packetDelay.push_back(std::to_string((rand() % maxDelay)));
						//packetDelay.push_back(std::to_string(maxDelay));
					} else {
						packetDelay.push_back(std::to_string(0));
					}
				}
				VCDelay.push_back(packetDelay);
			}
			nodeDelay.push_back(VCDelay);
		}
		ret.push_back(nodeDelay);
	}
	return ret;
}


void Topology::generateTrafficFiles(int numberOfPacketsPerNode, TrafficType trafficType, int maxDelay, int flag){
	//generateTraffic neds to be called before generateDelay
	this->traffic = generateTraffic(numberOfPacketsPerNode, trafficType, flag);
	this->delay = generateDelay(numberOfPacketsPerNode, maxDelay);

	for(int i = 0; i < N; i++){//Node
		for(unsigned int j = 0; j < this->traffic[i].size(); j++){//VC: Different Files will be created for Each Node and VC

			std::ofstream flitTrafficFile("input" + std::to_string(i) + "_" + std::to_string(j));
			std::ofstream delayTrafficFile("delay" + std::to_string(i) + "_" + std::to_string(j));

			for(unsigned int k = 0; k < this->traffic[i][j].size(); k++){//Packet
				for(unsigned int l = 0; l < this->traffic[i][j][k].size(); l++){
					flitTrafficFile << this->traffic[i][j][k][l] << std::endl;
					delayTrafficFile << this->delay[i][j][k][l] << std::endl;
				}
			}
			flitTrafficFile.close();
			delayTrafficFile.close();
		}
	}
}

void Topology::generateTrafficFiles(std::string path, int numberOfPacketsPerNode, TrafficType trafficType, int maxDelay, int flag){
	//generateTraffic neds to be called before generateDelay
	this->traffic = generateTraffic(numberOfPacketsPerNode, trafficType, flag);
	this->delay = generateDelay(numberOfPacketsPerNode, maxDelay);

	for(int i = 0; i < N; i++){//Node
		for(unsigned int j = 0; j < this->traffic[i].size(); j++){//VC: Different Files will be created for Each Node and VC

			std::ofstream flitTrafficFile(path + "input" + std::to_string(i) + "_" + std::to_string(j));
			std::ofstream delayTrafficFile(path + "delay" + std::to_string(i) + "_" + std::to_string(j));

			for(unsigned int k = 0; k < this->traffic[i][j].size(); k++){//Packet
				for(unsigned int l = 0; l < this->traffic[i][j][k].size(); l++){
					flitTrafficFile << this->traffic[i][j][k][l] << std::endl;
					delayTrafficFile << this->delay[i][j][k][l] << std::endl;
				}
			}
			flitTrafficFile.close();
			delayTrafficFile.close();
		}
	}
}

