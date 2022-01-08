/*
 * Topology.cpp
 *
 *  Created on: 04-Dec-2021
 *      Author: madhur
 */

#include "Topology.h"

Topology::Topology() {
	// TODO Auto-generated constructor stub
	topologyType = UNDEFINED_TOPOLOGY;
	N = 0;
	flitsPerPacket = 0;//This is the maximum flits alowed in a packet
	phitsPerFlit = 0;
	connected = false;
}

Topology::Topology(int N) {
	// TODO Auto-generated constructor stub
	this->topologyType = UNDEFINED_TOPOLOGY;
	this->N = N;
	flitsPerPacket = 0;//This is the maximum flits alowed in a packet
	phitsPerFlit = 0;
	this->connected = false;
}

Topology::Topology(int N, std::vector<std::string> nodeList, int flitsPerPacket, int phitsPerFlit) {
	// TODO Auto-generated constructor stub
	this->topologyType = UNDEFINED_TOPOLOGY;
	this->N = N;
	this->flitsPerPacket = flitsPerPacket;//This is the maximum flits alowed in a packet
	this->phitsPerFlit = phitsPerFlit;
	this->connected = false;
	this->nodeList = nodeList;
}

Topology::~Topology() {
	// TODO Auto-generated destructor stub
}

std::vector<std::vector<std::vector<std::string>>> Topology::generateTraffic(int numberOfPacketsPerNode, TrafficType trafficType){
	std::vector<std::vector<std::vector<std::string>>> ret;
	return ret;
}

//Number of delays will depend on the actual number of flits generated
//traffic variable should be set before delays are generated.
//Delays are generated for each flit separately, so the number of flits needs to be known
//beforehand.
//Delay generated is independent of the Topology, so it is defined in the superclass
std::vector<std::vector<std::vector<std::string>>> Topology::generateDelay(int numberOfPacketsPerNode, int maxDelay){
	std::vector<std::vector<std::vector<std::string>>> ret;

	srand(time(0));

	for(int i = 0; i < this->traffic.size(); i++){
		std::vector<std::vector<std::string>> nodeDelay;
		for(int j = 0; j < this->traffic[i].size(); j++){
			std::vector<std::string> packetDelay;
			for(int k = 0; k < this->traffic[i][j].size(); k++){
				packetDelay.push_back(std::to_string((rand() % maxDelay)));
			}
			nodeDelay.push_back(packetDelay);
		}
		ret.push_back(nodeDelay);
	}
	return ret;
}


void Topology::generateTrafficFiles(int numberOfPacketsPerNode, TrafficType trafficType, int maxDelay){
	//generateTraffic neds to be called before generateDelay
	this->traffic = generateTraffic(numberOfPacketsPerNode, trafficType);
	this->delay = generateDelay(numberOfPacketsPerNode, maxDelay);

	for(int i = 0; i < N; i++){
		std::ofstream flitTrafficFile("Node" + std::to_string(i) + ".dat");
		std::ofstream delayTrafficFile("delay" + std::to_string(i) + ".dat");

		for(int j = 0; j < this->traffic[i].size(); j++)
			for(int k = 0; k < this->traffic[i][j].size(); k++){
				flitTrafficFile << this->traffic[i][j][k] << std::endl;
				delayTrafficFile << this->delay[i][j][k] << std::endl;
			}
		flitTrafficFile.close();
		delayTrafficFile.close();
	}
}

