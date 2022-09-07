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

int main(){

	int N = 16;
	int DATA_WIDTH = 32;
	int flitsPerPacket = 16;
	int phitsPerFlit = 1;
	int numberOfPacketsPerNode = 256;
	int maxDelay = 1;
	int VC = 4;
	bool fixedSizePackets = true;
	TrafficType trafficType = UNIFORM_RANDOM;
	//	TrafficType trafficType = HOTSPOT;
	//	TrafficType trafficType = TRANSPOSE;

	std::vector<std::string> nodeList;


	for(int i = 0; i < N; i++){
		nodeList.push_back("Node" + i);
	}

	Mesh mesh(N, DATA_WIDTH, nodeList, flitsPerPacket, phitsPerFlit, VC, fixedSizePackets);

	//	mesh.generateTrafficFiles(numberOfPacketsPerNode, trafficType, maxDelay, 0);
	//	mesh.generateTrafficFiles("/home/madhur/VECTORS/",
	//			numberOfPacketsPerNode, trafficType, maxDelay, 0);

	std::string outputDir = "/run/user/1000/gvfs/sftp:host=192.168.1.235/home/madhur/Mesh44/sim/OUTPUT_VECTORS/";
	std::string inputDir = "/run/user/1000/gvfs/sftp:host=192.168.1.235/home/madhur/Mesh44/sim/INPUT_VECTORS/";

	Checker checker(mesh, inputDir, outputDir);
	checker.check(true);

	return 0;
}

//int main(){
//
//	int N = 63;
//	int flitsPerPacket = 16;
//	int phitsPerFlit = 1;
//	int numberOfPacketsPerNode = 256;
//	int maxDelay = 1;
//	int VC = 1;
//	TrafficType trafficType = UNIFORM_RANDOM;
//	//	TrafficType trafficType = HOTSPOT;
//
//	std::vector<std::string> nodeList;
//
//	for(int i = 0; i < N; i++){
//		nodeList.push_back("Node" + i);
//	}
//
//	Star star(N, nodeList, flitsPerPacket, phitsPerFlit, VC);
//
//	star.generateTrafficFiles(numberOfPacketsPerNode, trafficType, maxDelay, 0);
//
//	//	std::string outputDir = "/run/user/1000/gvfs/sftp:host=192.168.1.235/home/madhur/Star/sim/OUTPUT_VECTORS/";
//	//	std::string inputDir = "/run/user/1000/gvfs/sftp:host=192.168.1.235/home/madhur/Star/sim/INPUT_VECTORS/";
//	//
//	//	Checker checker(star, inputDir, outputDir);
//	//	checker.check(false);
//
//	return 0;
//}
