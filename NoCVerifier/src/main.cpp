/*
 * main.cpp
 *
 *  Created on: 05-Dec-2021
 *      Author: madhur
 */

#include "Topology/Topology.h"
#include "Topology/Mesh.h"
#include "TrafficGenerator.h"
#include "Checker.h"

int main(){

	int N = 9;
	int flitsPerPacket = 16;
	int phitsPerFlit = 1;
	int numberOfPacketsPerNode = 128;
	int maxDelay = 1;

	std::vector<std::string> nodeList;


	for(int i = 0; i < N; i++){
		nodeList.push_back("Node" + i);
	}

	Mesh mesh(N, nodeList, flitsPerPacket, phitsPerFlit);

	mesh.generateTrafficFiles(numberOfPacketsPerNode, UNIFORM_RANDOM, maxDelay);

	std::string outputDir = "/media/madhur/CommonSpace/Work/SystemSimulators/NoC Simulator/Mesh33_deadlock_test_160_VC/";
	std::string inputDir = "/media/madhur/CommonSpace/Work/SystemSimulators/NoC Simulator/Mesh33_deadlock_test_160_VC/sim/sim/INPUT_VECTORS/";

	Checker checker(N, mesh.topologyType, inputDir, outputDir);
	checker.check();

	return 0;
}
