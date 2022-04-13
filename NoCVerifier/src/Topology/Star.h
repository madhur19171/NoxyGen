/*
 * Star.h
 *
 *  Created on: 24-Feb-2022
 *      Author: madhur
 */

#ifndef SRC_TOPOLOGY_STAR_H_
#define SRC_TOPOLOGY_STAR_H_


#include "Topology.h"

class Star : public Topology {
public:
	int concentration;//Number of nodes connected to the central Node
	Star();
	Star(int N);
	Star(int N, std::vector<std::string> nodeList, int flitsPerPacket, int phitsPerFlit, int VC);
	virtual ~Star();
private:
	//TODO: different traffic types to be added
	//4D vector: VECTOR[NODE][VC][PACKET][FLIT]
	//flag is used for extra information about the type of traffic like Mixed Critical or Hybrid-Switched
	std::vector<std::vector<std::vector<std::vector<std::string>>>> generateTraffic(int numberOfPacketsPerNode, TrafficType trafficType, int flag);
	std::vector<std::vector<std::vector<std::vector<std::string>>>> generateVCSeparatedMixedCriticalTraffic(int numberOfPacketsPerNode, TrafficType trafficType);
};


#endif /* SRC_TOPOLOGY_STAR_H_ */
