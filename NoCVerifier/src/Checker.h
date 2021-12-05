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
#include "definitions.h"

class Checker {
public:
	int N;
	std::string inputDirectoryPath;
	std::string outputDirectoryPath;

	TopologyType topologyType;

	Checker();
	Checker(int N, TopologyType topologyType, std::string inputDirectoryPath, std::string outputDirectoryPath);
	virtual ~Checker();

	void check();

private:
	std::vector <std::string> inputTrafficList;
	std::vector <std::string> outputTrafficList;
	void checkMesh();
};

#endif /* SRC_CHECKER_H_ */
