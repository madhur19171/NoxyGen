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

Checker::Checker(Topology *topology, std::string inputDirectoryPath, std::string outputDirectoryPath) {
	// TODO Auto-generated constructor stub
	this->topology = *topology;
	this->inputDirectoryPath = inputDirectoryPath;
	this->outputDirectoryPath = outputDirectoryPath;

	this->nodeStatus = new bool[this->topology.N];

	for(int i = 0; i < this->topology.N; i++){
		std::vector<std::string>VCTraffic;
		this->nodeStatus[i] = true;		// Pass By Default
		for(int j = 0; j < this->topology.VC; j++){
			std::ifstream inputFile(inputDirectoryPath + "input" + std::to_string(i) + "_" + std::to_string(j));
			std::string inputTraffic;
			std::ostringstream inputTrafficStream;

			inputTrafficStream << inputFile.rdbuf();
			inputTraffic = inputTrafficStream.str();

			VCTraffic.push_back(inputTraffic);
		}
		inputTrafficList.push_back(VCTraffic);
	}

	for(int i = 0; i < this->topology.N; i++){
		std::vector<std::string>VCTraffic;
		for(int j = 0; j < this->topology.VC; j++){
			std::ifstream outputFile(outputDirectoryPath + "output" + std::to_string(i) + "_" + std::to_string(j));
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
	switch(this->topology.topologyType){
	case MESH:
		checkMesh(verbose);
		break;
	case STAR:
		checkStar();
		break;
	default:return;
	}
}

void Checker::checkMeshNode(int node, bool verbose){
	int dimX, dimY;
	dimX = floor(sqrt(this->topology.N));
	dimY = dimX;
	int REPRESENTATION_BITS = ceil(log2(dimX));

	int i = node;
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
					destY = flit & ((1 << REPRESENTATION_BITS) - 1);
					destX = (flit >> REPRESENTATION_BITS) & ((1 << REPRESENTATION_BITS) - 1);
					//				srcX = (flit >> 8) & 0xf;
					//				srcY = (flit >> 12) & 0xf;
				} else{
					destY = (flit >> 4) & ((1 << REPRESENTATION_BITS) - 1);
					destX = (flit >> (4 + REPRESENTATION_BITS)) & ((1 << REPRESENTATION_BITS) - 1);
					//				srcX = (flit >> 12) & 0xf;
					//				srcY = (flit >> 16) & 0xf;
				}
				int destinationNode = destX + destY * dimX;
				int destinationVC = j;
				//			std::cout << destinationNode << std::endl;

				if(!verbose){
					if(outputTrafficList[destinationNode][j].find(flitString) == std::string::npos){
						std::cout << "Failed at Node " << i << "\tVC: " << j << "\tFlit:" << flitString << std::endl;
						nodeFailed |= true;
						return;
					}
				}
				else{
					int foundNode = -1;
					int foundVC = -1;

					if(outputTrafficList[destinationNode][j].find(flitString) != std::string::npos){
						foundNode = destinationNode;
						foundVC = j;
					} else {
						for(int k = 0; k < this->topology.N; k++){
							for(int l = 0; l < this->topology.VC; l++){
								if(outputTrafficList[k][l].find(flitString) != std::string::npos){
									foundNode = k;
									foundVC = l;
									break;
								}
							}
						}
					}

					if(!(foundNode == destinationNode && foundVC == destinationVC)){
						if(foundNode == -1 && foundVC == -1)
							std::cout << "Flit: " << flitString << " did not reach it's destination" << std::endl;
						else
							std::cout << "Flit: " << flitString << " misrouted" << \
									"\t Source Node: " << i << "\tSource VC: " << j << \
									"\tExpected Destination: " << destinationNode << "\tExpected VC: " << destinationVC << \
									"\tFound Node: " << foundNode << "\tFound VC: " << foundVC << \
								std::endl;
						nodeFailed |= true;
					}
				}
			}
		}
		if(nodeFailed)
			this->nodeStatus[i] = false;
}

// Checking is Multithreaded!!!!!!
// Shoutout to Prof. Vivek Kumar, IIITD
void Checker::checkMesh(bool verbose){
	std::vector<std::thread> checkThreads;

	for(int i = 0; i < topology.N; i++){
		checkThreads.push_back(std::thread(&Checker::checkMeshNode, this, i, verbose));
	}

	for (auto& t: checkThreads) t.join();

	for(int i = 0; i < topology.N; i++){
		if(nodeStatus[i])
			std::cout << "Node" << i << " Passed" << std::endl;
		else
			std::cout << "Node" << i << " Failed" << std::endl;
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
