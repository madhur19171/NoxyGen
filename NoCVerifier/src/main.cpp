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
#include "Stats/StatsParser.h"

#include <string>

int main(int argc, char *argv[]){
	int N = 64;
	int DATA_WIDTH = 32;
	int flitsPerPacket = 16;
	int numberOfPacketsPerNode = 128;
	int maxDelay = 1;
	int VC = 4;
	bool fixedSizePackets = true;
	
	TopologyType topologyType = UNDEFINED_TOPOLOGY;
	std::string tbName = "NoC_TB";
	std::string designName = "DUT";
	std::string inputVectorDir = "";
	std::string outputVectorDir = "";
	std::string simulator = "";
	
	std::string statsFilePath = "";
	
	TrafficType trafficType = UNDEFINED_TRAFFIC;
	bool generateTestBench = true;
	bool generateTrafficFiles = false;
	bool check = false; bool deepCheck = false;
	bool parseStats = false;
	
	std::string argument, key, value;
	for(int i = 1; i < argc; i++){
		argument = argv[i];
		key = argument.substr(0, argument.find("="));
		value = argument.substr(argument.find("=") + 1);
		//std::cout << "Key: " << key << "\tValue: " << value << std::endl;
		if(key == "TASK"){
			generateTestBench = 	value == "GEN_TB";
			generateTrafficFiles =	value == "GEN_TV";
			check = 		value == "CHK";
			parseStats = 		value == "PARSE_STATS";
		}
		
		if(key == "TOPOLOGY"){
			if(value == "MESH"){
				topologyType = MESH;
			} else if(value == "STAR"){
				topologyType = STAR;
			} else
				topologyType = IRREGULAR;
		}
		
		if(key == "SIMULATOR"){
			simulator = value;
		}
		
		if(key == "N"){
			N = std::stoi(value);
		}
		
		if(key == "DATA_WIDTH"){
			DATA_WIDTH = std::stoi(value);
		}
		
		if(key == "FlitsPerPacket"){
			flitsPerPacket = std::stoi(value);
		}
		
		if(key == "VC"){
			VC = std::stoi(value);
		}
		
		if(key == "PacketsPerNode"){
			numberOfPacketsPerNode = std::stoi(value);
		}
		
		if(key == "FixPacketSize"){
			fixedSizePackets = std::stoi(value) == 1;
		}
		
		if(key == "TB_NAME"){
			tbName = value;
		}
		
		if(key == "DESIGN_NAME"){
			designName = value;
		}
		
		if(key == "IV_DIR"){
			inputVectorDir = value;
		}
		
		if(key == "OV_DIR"){
			outputVectorDir = value;
		}
		
		if(key == "TRAFFIC"){
			if(value == "UNIFORM")
				trafficType = UNIFORM_RANDOM;
			else if(value == "HOTSPOT")
				trafficType = HOTSPOT;
			else if(value == "TRANSPOSE")
				trafficType = TRANSPOSE;
			else
				trafficType = UNIFORM_RANDOM;
		}
		
		if(key == "MAX_DELAY"){
			maxDelay = std::stoi(value);
		}
		
		if(key == "DEEP_CHK"){
			deepCheck = std::stoi(value) == 1;
		}
		
		if(key == "STATS_FILE"){
			statsFilePath = value;
		}
	}

	std::vector<std::string> nodeList;
	for(int i = 0; i < N; i++){
		nodeList.push_back("Node" + i);
	}
	
	Topology *topology;
	if(topologyType == MESH){
		topology = new Mesh(N, DATA_WIDTH, nodeList, flitsPerPacket, VC, fixedSizePackets);
	}

	TestBenchGenerator testBenchGenerator (N, DATA_WIDTH, flitsPerPacket, VC, numberOfPacketsPerNode, simulator);

	if(generateTestBench){
		testBenchGenerator.generateTestBench(tbName, designName, inputVectorDir, outputVectorDir);
	}

	if(generateTrafficFiles){
		if(topologyType == MESH){	// TODO: Add other topologies as well!
			Mesh *mesh = (Mesh *) topology;
			mesh->generateTrafficFiles(inputVectorDir,
					numberOfPacketsPerNode, trafficType, maxDelay, 0);
		}
	}

	if(check){
		Checker checker(topology, inputVectorDir, outputVectorDir);
		checker.check(deepCheck);
	}

	if(parseStats){
		StatsParser statsParser(statsFilePath, N, VC);
		statsParser.parseLogFile();
		statsParser.printStatistics();
	}

	return 0;
}
