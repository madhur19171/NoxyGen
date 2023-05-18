/*
 * Topology.h
 *
 *  Created on: 04-Dec-2021
 *      Author: madhur
 */

#ifndef SRC_TOPOLOGY_H_
#define SRC_TOPOLOGY_H_

#include <iostream>
#include <fstream>
#include <string>
#include <vector>
#include <utility>
#include <sstream>
#include <stdlib.h>
#include <math.h>
#include <random>
#include <chrono>
#include <functional>
#include <time.h>
#include "../definitions.h"

class Topology {
public:
	TopologyType topologyType;
	int N;
	int DATA_WIDTH;
	int flitsPerPacket;
	int VC;
	bool fixedSizePackets;
	bool connected;
	std::vector<std::string> nodeList;
	std::vector<std::vector<std::vector<std::vector<std::string>>>> traffic;//4D vector: VECTOR[NODE][VC][PACKET][FLIT]
	std::vector<std::vector<std::vector<std::vector<std::string>>>> delay;//4D vector: VECTOR[NODE][VC][PACKET][FLIT]
	Topology();
	Topology(int N);
	Topology(int N, int DATA_WIDTH, std::vector<std::string> nodeList, int flitsPerPacket, int VC, bool fixedSizePackets);
	virtual ~Topology();

	//flag is used for extra information about the type of traffic like Mixed Critical or Hybrid-Switched
	void generateTrafficFiles(int numberOfPacketsPerNode, TrafficType trafficType, int maxDelay, int flag);
	void generateTrafficFiles(std::string path, int numberOfPacketsPerNode, TrafficType trafficType, int maxDelay, int flag);

protected:
	//This vector will store traffic of each Node in the vector.
	//So there will be N strings in the vector containing traffic for the
	//corresponding node.
	//flag is used for extra information about the type of traffic like Mixed Critical or Hybrid-Switched
	virtual std::vector<std::vector<std::vector<std::vector<std::string>>>> generateTraffic(int numberOfPacketsPerNode, TrafficType trafficType, int flag);
	//Similar to reaffic generator but it returns a vector of delays for each flit for Every Node.
	std::vector<std::vector<std::vector<std::vector<std::string>>>> generateDelay(int numberOfPacketsPerNode, int maxDelay);
};

#endif /* SRC_TOPOLOGY_H_ */
