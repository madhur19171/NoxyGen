/*
 * Checker.h
 *
 *  Created on: 05-Dec-2021
 *      Author: madhur
 */

#ifndef SRC_CHECKER_H_
#define SRC_CHECKER_H_

//This class compares the input and output files to verify that all the
//packets have reached their destination

#include <iostream>
#include <fstream>
#include <filesystem>
#include <string>
#include <vector>
#include <utility>
#include <sstream>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <thread>
#include "definitions.h"
#include "Topology/Topology.h"

class Checker {
public:
	std::string inputDirectoryPath;
	std::string outputDirectoryPath;

	//Topology will encapsulate all the data necessary to do verification for the given input and output traffic
	Topology topology;

	Checker();
	Checker(Topology *topology, std::string inputDirectoryPath, std::string outputDirectoryPath);
	virtual ~Checker();

	void check(bool verbose);

private:
	std::vector<std::vector<std::string>> inputTrafficList;//2D Vector of Input Traffic[Node][VC]
	std::vector<std::vector<std::string>> outputTrafficList;//2D Vector of Output Traffic[Node][VC]
	bool * nodeStatus;
	void checkMesh(bool verbose);
	void checkMeshNode(int node, bool verbose);

	void checkStar();
	void checkStarVerbose();
};

#endif /* SRC_CHECKER_H_ */
