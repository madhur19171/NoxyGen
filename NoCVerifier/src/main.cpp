/*
 * main.cpp
 *
 *  Created on: 05-Dec-2021
 *      Author: madhur
 */

#include "Topology/Topology.h"
#include "Topology/Mesh.h"
//#include "Topology/Star.h"
#include "TrafficGenerator.h"
#include "Checker.h"
#include "TestBenchGenerator.h"

int main(){

	int N = 16;
	int DATA_WIDTH = 32;
	int flitsPerPacket = 16;
	int phitsPerFlit = 1;
	int numberOfPacketsPerNode = 128;
	int maxDelay = 1;
	int VC = 1;
	bool fixedSizePackets = true;
	TrafficType trafficType = UNIFORM_RANDOM;
	//	TrafficType trafficType = HOTSPOT;
	//	TrafficType trafficType = TRANSPOSE;

	bool generateTestBench = true;
	bool generateTrafficFiles = false;
	bool check = false;

	std::vector<std::string> nodeList;
	for(int i = 0; i < N; i++){
		nodeList.push_back("Node" + i);
	}

	TestBenchGenerator testBenchGenerator (N, DATA_WIDTH, flitsPerPacket, phitsPerFlit, VC, numberOfPacketsPerNode);
	Mesh mesh(N, DATA_WIDTH, nodeList, flitsPerPacket, phitsPerFlit, VC, fixedSizePackets);

	if(generateTestBench){
		testBenchGenerator.generateTestBench("NoC_TB", "Mesh44", "/home/madhur/VECTORS/INPUT_VECTORS/", "/home/madhur/VECTORS/OUTPUT_VECTORS/");
	}

	if(generateTrafficFiles){
		mesh.generateTrafficFiles(numberOfPacketsPerNode, trafficType, maxDelay, 0);
		mesh.generateTrafficFiles("/home/madhur/VECTORS/",
				numberOfPacketsPerNode, trafficType, maxDelay, 0);
	}

	if(check){
		std::string outputDir = "/media/madhur/CommonSpace/Work/SystemSimulators/NoC Simulator/Mesh22_SV/sim/OUTPUT_VECTORS/";
		std::string inputDir = "/media/madhur/CommonSpace/Work/SystemSimulators/NoC Simulator/Mesh22_SV/sim/INPUT_VECTORS/";

		Checker checker(mesh, inputDir, outputDir);
		checker.check(true);
	}

	return 0;
}
