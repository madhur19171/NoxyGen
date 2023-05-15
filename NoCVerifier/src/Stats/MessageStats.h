/*
 * MessageStats.h
 *
 *  Created on: 14-May-2023
 *      Author: madhur
 */

#ifndef SRC_STATS_MESSAGESTATS_H_
#define SRC_STATS_MESSAGESTATS_H_

#include <iostream>

class MessageStats {
public:

	int source;
	int destination;
	int messageNumber;
	int injectionTime;
	int departureTime;
	int arrivalTime;
	int VC;

	// Put Message Statistics to be calculated here
	// These statistics are calculated using the stats defined above
	int bufferWaitingTime;
	int messageRoutingTime;

	MessageStats();
	MessageStats(int source, int destiantion, int messageNumber, int injectinTime, int departureTime, int arrivalTime, int VC);
	virtual ~MessageStats();

	void setArrivalTime(int arrivalTime);

	void calculateMessageStatistics();

	void printMessageStats();
};

#endif /* SRC_STATS_MESSAGESTATS_H_ */
