/*
 * Checker.cpp
 *
 *  Created on: 05-Dec-2021
 *      Author: madhur
 */

#include "Checker.h"

Checker::Checker() {
	// TODO Auto-generated constructor stub
}

Checker::Checker(Topology topology, std::string inputDirectoryPath, std::string outputDirectoryPath) {
	// TODO Auto-generated constructor stub
	this->topology = topology;
	this->inputDirectoryPath = inputDirectoryPath;
	this->outputDirectoryPath = outputDirectoryPath;

	for(int i = 0; i < topology.N; i++){
		std::vector<std::string>VCTraffic;
		for(int j = 0; j < topology.VC; j++){
			std::ifstream inputFile(inputDirectoryPath + "input_" + std::to_string(i) + "_" + std::to_string(j));
			std::string inputTraffic;
			std::ostringstream inputTrafficStream;

			inputTrafficStream << inputFile.rdbuf();
			inputTraffic = inputTrafficStream.str();

			VCTraffic.push_back(inputTraffic);
		}
		inputTrafficList.push_back(VCTraffic);
	}

	for(int i = 0; i < topology.N; i++){
		std::vector<std::string>VCTraffic;
		for(int j = 0; j < topology.VC; j++){
			std::ifstream outputFile(outputDirectoryPath + "output_" + std::to_string(i) + "_" + std::to_string(j));
			std::string outputTraffic;
			std::ostringstream outputTrafficStream;

			outputTrafficStream << outputFile.rdbuf();
			outputTraffic = outputTrafficStream.str();

			VCTraffic.push_back(outputTraffic);
		}
		outputTrafficList.push_back(VCTraffic);
	}
}

Checker::~Checker() {
	// TODO Auto-generated destructor stub
}

void Checker::check(bool verbose){
	switch(topology.topologyType){
	case MESH:
		verbose ? checkMeshVerbose() : checkMesh();
		break;
	case STAR:
		checkStar();
		break;
	default:return;
	}
}

void Checker::checkMesh(){

	int dimX, dimY;
	dimX = floor(sqrt(this->topology.N));
	dimY = dimX;

	for(int i = 0; i < this->topology.N; i++){
		bool nodeFailed = false;
		for(int j = 0; j < this->topology.VC; j++){
			std::stringstream inputTrafficStream;
			inputTrafficStream << inputTrafficList[i][j];
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
				int destinationNode = destX + destY * dimX;
				//			std::cout << destinationNode << std::endl;
				if(outputTrafficList[destinationNode][j].find(flitString) == std::string::npos){
					std::cout << "Failed at Node " << i << "\tVC: " << j << "\tFlit:" << flitString << std::endl;
					nodeFailed |= true;
				}
			}
		}
		if(nodeFailed)
			std::cout << "Node" << i << " Failed" << std::endl;
		else
			std::cout << "Node" << i << " Passed" << std::endl;
	}
}

//Bugged!
void Checker::checkMeshVerbose(){

	int dimX, dimY;
	dimX = floor(sqrt(this->topology.N));
	dimY = dimX;

	for(int i = 0; i < this->topology.N; i++){
		bool nodeFailed = false;
		for(int j = 0; j < this->topology.VC; j++){
			std::stringstream inputTrafficStream;
			inputTrafficStream << inputTrafficList[i][j];
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
				int destinationNode = destX + destY * dimX;
				int destinationVC = j;
				//			std::cout << destinationNode << std::endl;
				int foundNode = -1;
				int foundVC = -1;
				for(int k = 0; k < this->topology.N; k++){
					for(int l = 0; l < this->topology.VC; l++){
						if(outputTrafficList[k][l].find(flitString) != std::string::npos){
							foundNode = k;
							foundVC = l;
							break;
						}
					}
				}
				//				std::cout << "Destination Node: " << destinationNode << "\tDestination VC: " << destinationVC << "\tFound Node: " << foundNode << "\tFound VC: " << foundVC << std::endl;
				if(!(foundNode == destinationNode && foundVC == destinationVC)){
					if(foundNode == -1 && foundVC == -1)
						std::cout << "Flit: " << flitString << " did not reach it's destination" << std::endl;
					else
						std::cout << "Flit: " << flitString << " misrouted to Node " << foundNode << " on VC " << foundVC << std::endl;
					nodeFailed |= true;
				}
			}
		}
		if(nodeFailed)
			std::cout << "Node" << i << " Failed" << std::endl;
		else
			std::cout << "Node" << i << " Passed" << std::endl;
	}
}


void Checker::checkStar(){
	for(int i = 0; i < this->topology.N; i++){
		bool nodeFailed = false;
		for(int j = 0; j < this->topology.VC; j++){
			std::stringstream inputTrafficStream;
			inputTrafficStream << inputTrafficList[i][j];
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

				int destination;
				if(((flit >> 30) == 1) || (flit >> 30) == -1){//Head Flit or Tail Flit
					destination = flit & 0xff;
					//				srcX = (flit >> 8) & 0xf;
					//				srcY = (flit >> 12) & 0xf;
				} else{
					destination = (flit >> 4) & 0xff;
					//				srcX = (flit >> 12) & 0xf;
					//				srcY = (flit >> 16) & 0xf;
				}
				int destinationNode = destination;
				//				std::cout << destinationNode << std::endl;
				if(outputTrafficList[destinationNode][j].find(flitString) == std::string::npos){
					std::cout << "Failed at Node " << i << "\tVC: " << j << "\tFlit:" << flitString << std::endl;
					nodeFailed |= true;
					return;
				}
			}
		}
		if(nodeFailed)
			std::cout << "Node" << i << " Failed" << std::endl;
		else
			std::cout << "Node" << i << " Passed" << std::endl;
	}
}
