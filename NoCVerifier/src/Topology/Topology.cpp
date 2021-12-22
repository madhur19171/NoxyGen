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
	flitsPerPacket = 0;
	phitsPerFlit = 0;
	connected = false;
}

Topology::Topology(int N) {
	// TODO Auto-generated constructor stub
	this->topologyType = UNDEFINED_TOPOLOGY;
	this->N = N;
	flitsPerPacket = 0;
	phitsPerFlit = 0;
	this->connected = false;
}

Topology::Topology(int N, std::vector<std::string> nodeList, int flitsPerPacket, int phitsPerFlit) {
	// TODO Auto-generated constructor stub
	this->topologyType = UNDEFINED_TOPOLOGY;
	this->N = N;
	this->flitsPerPacket = flitsPerPacket;
	this->phitsPerFlit = phitsPerFlit;
	this->connected = false;
	this->nodeList = nodeList;
}

Topology::~Topology() {
	// TODO Auto-generated destructor stub
}

std::vector<std::string> Topology::generateTraffic(int numberOfPacketsPerNode, TrafficType trafficType){
	std::vector<std::string> ret;
	return ret;
}

std::vector<std::string> Topology::generateDelay(int numberOfPacketsPerNode, int maxDelay){
	std::vector<std::string> ret;

	srand(time(0));

	for(int i = 0; i < N; i++){
		std::stringstream delay;
		for(int j = 0; j < numberOfPacketsPerNode; j++){
			for(int k = 0; k < flitsPerPacket; k++){
				delay << (rand() % maxDelay) << std::endl;
			}
		}
		ret.push_back(delay.str());
	}

	return ret;
}


void Topology::generateTrafficFiles(int numberOfPacketsPerNode, TrafficType trafficType, int maxDelay){
	std::vector<std::string> delay;

	traffic = generateTraffic(numberOfPacketsPerNode, trafficType);
	delay = generateDelay(numberOfPacketsPerNode, maxDelay);

	for(int i = 0; i < N; i++){
		std::ofstream flitTrafficFile("Node" + std::to_string(i) + ".dat");
		std::ofstream delayTrafficFile("delay" + std::to_string(i) + ".dat");

		flitTrafficFile << traffic[i];
		delayTrafficFile << delay[i];
		flitTrafficFile.close();
		delayTrafficFile.close();
	}
}

