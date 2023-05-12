/*
 * TestBenchGenerator.h
 *
 *  Created on: 04-Dec-2021
 *      Author: madhur
 */

#ifndef SRC_TOPOLOGY_TESTBENCHGENERATOR_H_
#define SRC_TOPOLOGY_TESTBENCHGENERATOR_H_

#include <string>

class TestBenchGenerator {
public:
	int N;
	int DATA_WIDTH;
	int flitsPerPacket;
	int phitsPerFlit;
	int VC;
	int numberOfPacketsPerNode;

	TestBenchGenerator();
	TestBenchGenerator(int N, int DATA_WIDTH, int flitsPerPacket, int phitsPerFlit, int VC, int numberOfPacketsPerNode);
	virtual ~TestBenchGenerator();

	void generateTestBench(std::string testBenchName, std::string DUTName, std::string inputVectorPath, std::string outputVectorPath);

private:
	std::string generateModuleName(std::string testBenchName);
	std::string generateClkRstBookKeepers();
	std::string generateConnectingWire(int node);
	std::string instantiateDUT(std::string DUTName);
	std::string instantiateNodeVerifier(int node, std::string inputVectorPath, std::string outputVectorPath);
	std::string generateAlwaysClock();
	std::string generateInitial();
	std::string generateFinishBlock();
	std::string generateEndmodule();
};

#endif /* SRC_TOPOLOGY_TESTBENCHGENERATOR_H_ */
