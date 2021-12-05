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
#include <time.h>
#include "../definitions.h"

class Topology {
public:
	TopologyType topologyType;
	int N;
	int flitsPerPacket;
	int phitsPerFlit;
	bool connected;
	std::vector<std::string> nodeList;
	std::vector<std::string> traffic;
	Topology();
	Topology(int N);
	Topology(int N, std::vector<std::string> nodeList, int flitsPerPacket, int phitsPerFlit);
	virtual ~Topology();

	void generateTrafficFiles(int numberOfPacketsPerNode, TrafficType trafficType, int maxDelay);

protected:
	//This vector will store traffic of each Node in the vector.
	//So there will be N strings in the vector containing traffic for the
	//corresponding node.
	virtual std::vector<std::string> generateTraffic(int numberOfPacketsPerNode, TrafficType trafficType);
	//Similar to reaffic generator but it returns a vector of delays for each flit for Every Node.
	std::vector<std::string> generateDelay(int numberOfPacketsPerNode, int maxDelay);
};

#endif /* SRC_TOPOLOGY_H_ */
