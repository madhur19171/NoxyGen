/*
 * TrafficAnalyzer.h
 *
 *  Created on: 21-Jan-2022
 *      Author: madhur
 */

#ifndef SRC_TRAFFICANALYZER_H_
#define SRC_TRAFFICANALYZER_H_

#include <string>

class TrafficFileAnalyzer{
public:
	std::string trafficFileName;
	TrafficFileAnalyzer(std::string trafficFileName);
	~TrafficFileAnalyzer();


};


#endif /* SRC_TRAFFICANALYZER_H_ */
