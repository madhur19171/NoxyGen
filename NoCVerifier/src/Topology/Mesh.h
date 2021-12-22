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
	Mesh(int N, std::vector<std::string> nodeList, int flitsPerPacket, int phitsPerFlit);
	virtual ~Mesh();
private:
	//TODO: different traffic types to be added
	std::vector<std::string> generateTraffic(int numberOfPacketsPerNode, TrafficType trafficType);
};

#endif /* SRC_TOPOLOGY_MESH_H_ */
