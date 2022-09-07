/*
 * Mesh.h
 *
 *  Created on: 04-Dec-2021
 *      Author: madhur
 */

#ifndef SRC_TOPOLOGY_MESH_H_
#define SRC_TOPOLOGY_MESH_H_

#include "Topology.h"

class Mesh : public Topology {
public:
	int dimX, dimY;
	Mesh();
	Mesh(int N);
	Mesh(int N, int DATA_WIDTH, std::vector<std::string> nodeList, int flitsPerPacket, int phitsPerFlit, int VC, bool fixedSizePackets);
	virtual ~Mesh();
private:
	//TODO: different traffic types to be added
	//4D vector: VECTOR[NODE][VC][PACKET][FLIT]
	//flag is used for extra information about the type of traffic like Mixed Critical or Hybrid-Switched
	std::vector<std::vector<std::vector<std::vector<std::string>>>> generateTraffic(int numberOfPacketsPerNode, TrafficType trafficType, int flag);
	std::vector<std::vector<std::vector<std::vector<std::string>>>> generateVCSeparatedMixedCriticalTraffic(int numberOfPacketsPerNode, TrafficType trafficType);
};

#endif /* SRC_TOPOLOGY_MESH_H_ */
