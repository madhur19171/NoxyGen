/*
 * Checker.cpp
 *
 *  Created on: 05-Dec-2021
 *      Author: madhur
 */

#include "Checker.h"

Checker::Checker() {
	// TODO Auto-generated constructor stub
	this->N = 0;
	this->topologyType = UNDEFINED_TOPOLOGY;
}

Checker::Checker(int N, TopologyType topologyType, std::string inputDirectoryPath, std::string outputDirectoryPath) {
	// TODO Auto-generated constructor stub
	this->N = N;
	this->topologyType = topologyType;
	this->inputDirectoryPath = inputDirectoryPath;
	this->outputDirectoryPath = outputDirectoryPath;

	for(int i = 0; i < N; i++){
		std::ifstream inputFile(inputDirectoryPath + "Node" + std::to_string(i) + ".dat");
		std::string inputTraffic;
		std::ostringstream inputTrafficStream;

		inputTrafficStream << inputFile.rdbuf();
		inputTraffic = inputTrafficStream.str();

		inputTrafficList.push_back(inputTraffic);
	}

	for(int i = 0; i < N; i++){
		std::ifstream outputFile(outputDirectoryPath + "output" + std::to_string(i) + ".dat");
		std::string outputTraffic;
		std::ostringstream outputTrafficStream;

		outputTrafficStream << outputFile.rdbuf();
		outputTraffic = outputTrafficStream.str();

		outputTrafficList.push_back(outputTraffic);
	}
}

Checker::~Checker() {
	// TODO Auto-generated destructor stub
}

void Checker::check(){
	switch(topologyType){
	case MESH:
		checkMesh();
		break;
	default:return;
	}
}

void Checker::checkMesh(){

	int dimX, dimY;
	dimX = floor(sqrt(N));
	dimY = dimX;

	for(int i = 0; i < N; i++){
		bool nodeFailed = false;
		std::stringstream inputTrafficStream;
		inputTrafficStream << inputTrafficList[i];
		int flit;
		//		std::cout << inputTrafficList[i] << std::endl;
		while(!inputTrafficStream.eof()){
			std::string flitString;
			inputTrafficStream >> flitString;
			if(flitString.size() != 10){
				continue;
			}
//			std::cout << flitString << std::endl;
			flit = std::stoul(flitString, nullptr, 16);
			//			int srcX, srcY;

			int destX, destY;
			if(((flit >> 30) == 1) || (flit >> 30) == -1){//Head Flit or Tail Flit
				destY = flit & 0xf;
				destX = (flit >> 4) & 0xf;
				//				srcX = (flit >> 8) & 0xf;
				//				srcY = (flit >> 12) & 0xf;
			} else{
				destY = (flit >> 4) & 0xf;
				destX = (flit >> 8) & 0xf;
				//				srcX = (flit >> 12) & 0xf;
				//				srcY = (flit >> 16) & 0xf;
			}
			int destinationNode = destX + destY * dimY;
//			std::cout << destinationNode << std::endl;
			if(outputTrafficList[destinationNode].find(flitString) == std::string::npos){
				std::cout << "Failed at Node" << i << "\tFlit:" << flitString << std::endl;
				nodeFailed = true;
			}
		}
		if(nodeFailed)
			std::cout << "Node" << i << " Failed" << std::endl;
		else
			std::cout << "Node" << i << " Passed" << std::endl;
	}
}
