/*
 * StatsParser.cpp
 *
 *  Created on: 14-May-2023
 *      Author: madhur
 */

#include "StatsParser.h"

StatsParser::StatsParser() {
	// TODO Auto-generated constructor stub
	this->N = -1;
	this->VC = -1;
	this->logFileName = "";

	this->stats = NULL;
}

StatsParser::StatsParser(std::string logFileName, int N, int VC){
	this->N = N;
	this->VC = VC;
	this->logFileName = logFileName;

	this->stats = new std::unordered_map<int, MessageStats *> * [N];
	for(int i = 0; i < N; i++){
		stats[i] = new std::unordered_map<int, MessageStats *> [VC];
	}
}

StatsParser::~StatsParser() {
	// TODO Auto-generated destructor stub
}

void StatsParser::parseLogFile(){
	std::ifstream logFile(this->logFileName);

	std::cout << this->logFileName << std::endl;

	std::string buffer;
	while(!logFile.eof()){
		MessageStats *messageStats = new MessageStats;
		int node = -1;
		logFile >> buffer;
		if(buffer.substr(0, 4) == "Node"){	// This line contains either Departure or Arrival Stats
			node = std::stoi(buffer.substr(4, buffer.find(':')));

			logFile >> buffer;
			if(buffer == "Message:"){
				logFile >> messageStats->messageNumber;

				logFile >> buffer;
				if(buffer == "Destination:"){
					messageStats->source = node;
					logFile >> messageStats->destination;

					logFile >> buffer;
					logFile >> messageStats->injectionTime;

					logFile >> buffer;
					logFile >> messageStats->departureTime;

					logFile >> buffer;
					logFile >> messageStats->VC;

					stats[messageStats->source][messageStats->VC][messageStats->messageNumber] = messageStats;

				} else if(buffer == "Source:"){ // For arrivals, use the stats already created by the departure block
					messageStats->destination = node;
					logFile >> messageStats->source;

					logFile >> buffer;
					logFile >> messageStats->arrivalTime;

					logFile >> buffer;
					logFile >> messageStats->VC;

					stats[messageStats->source][messageStats->VC][messageStats->messageNumber]->arrivalTime = messageStats->arrivalTime;

				}
			}
		}
	}

	logFile.close();
}

void StatsParser::printStatistics(){
	// Calculating message Statistics
	for(int i = 0; i < this->N; i++){
		for(int j = 0; j < this->VC; j++){
			for(auto &it : stats[i][j]){
				it.second->calculateMessageStatistics();
			}
		}
	}

	// Printing Number of Messages
	int totalMessages = 0;
	int totalVCMessages[this->VC];
	for(int j = 0; j < this->VC; j++){
		totalVCMessages[j] = 0;
		for(int i = 0; i < this->N; i++){
			totalVCMessages[j] += stats[i][j].size();
		}
		std::cout << "Total Messages VC " << j << ": " << totalVCMessages[j] << std::endl;
		totalMessages += totalVCMessages[j];
	}
	std::cout << "Total Messages: " << totalMessages << std::endl;


	// Printing Latency
	int totalLatency = 0;
	int totalVCLatency[this->VC];
	for(int j = 0; j < this->VC; j++){
		totalVCLatency[j] = 0;
		for(int i = 0; i < this->N; i++){
			for(auto &it : stats[i][j]){
				totalVCLatency[j] += it.second->messageRoutingTime;
			}
		}
		std::cout << "Total Latency VC " << j << ": " << totalVCLatency[j] << std::endl;
		std::cout << "Average Latency VC " << j << ": " << 1.0 * totalVCLatency[j] / totalVCMessages[j] << std::endl;
		totalLatency += totalVCLatency[j];
	}
	std::cout << "Total Latency: " << totalLatency << std::endl;
	std::cout << "Average Latency: " << 1.0 * totalLatency / totalMessages << std::endl;


	// Printing Queuing Delay
	int totalQueueDelay = 0;
	int totalVCQueueDelay[this->VC];
	for(int j = 0; j < this->VC; j++){
		totalVCQueueDelay[j] = 0;
		for(int i = 0; i < this->N; i++){
			for(auto &it : stats[i][j]){
				totalVCQueueDelay[j] += it.second->bufferWaitingTime;
			}
		}
		std::cout << "Total Queuing Delay VC " << j << ": " << totalVCQueueDelay[j] << std::endl;
		std::cout << "Average Queuing Delay VC " << j << ": " << 1.0 * totalVCQueueDelay[j] / totalVCMessages[j] << std::endl;
		totalQueueDelay += totalVCQueueDelay[j];
	}
	std::cout << "Total Queuing Delay: " << totalQueueDelay << std::endl;
	std::cout << "Average Queuing Delay: " << 1.0 * totalQueueDelay / totalMessages << std::endl;
}




