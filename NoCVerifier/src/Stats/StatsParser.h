/*
 * StatsParser.h
 *
 *  Created on: 14-May-2023
 *      Author: madhur
 */

#ifndef SRC_STATS_STATSPARSER_H_
#define SRC_STATS_STATSPARSER_H_

#include "MessageStats.h"
#include <string>
#include <fstream>
#include <iostream>
#include <unordered_map>

class StatsParser {
public:
	int N;
	int VC;
	std::string logFileName;

	StatsParser();
	StatsParser(std::string logFileName, int N, int VC);
	virtual ~StatsParser();

	void parseLogFile();

	void printStatistics();

private:
	std::unordered_map<int, MessageStats *> **stats;	// stats variable stores the Per Node Per VC stats in vectors
											// corresponding to each Node and VC
											// vector will be stats[Node][VC]
};

#endif /* SRC_STATS_STATSPARSER_H_ */
