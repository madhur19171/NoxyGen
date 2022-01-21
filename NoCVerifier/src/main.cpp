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

	int N = 16;
	int flitsPerPacket = 8;
	int phitsPerFlit = 1;
	int numberOfPacketsPerNode = 64;
	int maxDelay = 1;
	int VC = 4;

	std::vector<std::string> nodeList;


	for(int i = 0; i < N; i++){
		nodeList.push_back("Node" + i);
	}

	Mesh mesh(N, nodeList, flitsPerPacket, phitsPerFlit, VC);

//	mesh.generateTrafficFiles(numberOfPacketsPerNode, UNIFORM_RANDOM, maxDelay, 0);

		std::string outputDir = "/media/madhur/CommonSpace/Work/SystemSimulators/NoC Simulator/Mesh_44_Priority/sim/OUTPUT_VECTORS/";
		std::string inputDir = "/media/madhur/CommonSpace/Work/SystemSimulators/NoC Simulator/Mesh_44_Priority/sim/INPUT_VECTORS/";

		Checker checker(mesh, inputDir, outputDir);
		checker.check(true);

	return 0;
}
