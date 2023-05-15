/*
 * MessageStats.cpp
 *
 *  Created on: 14-May-2023
 *      Author: madhur
 */

#include "MessageStats.h"

MessageStats::MessageStats() {
	// TODO Auto-generated constructor stub
	this->source = -1;
	this->destination = -1;
	this->messageNumber = -1;
	this->injectionTime = -1;
	this->departureTime = -1;
	this->arrivalTime = -1;
	this->VC = -1;
	this->bufferWaitingTime = -1;
	this->messageRoutingTime = -1;

}

MessageStats::~MessageStats() {
	// TODO Auto-generated destructor stub
}

MessageStats::MessageStats(int source, int destiantion, int messageNumber, int injectinTime, int departureTime, int arrivalTime, int VC){
	this->source = source;
	this->destination = destination;
	this->messageNumber = messageNumber;
	this->injectionTime = injectionTime;
	this->departureTime = departureTime;
	this->arrivalTime = arrivalTime;
	this->VC = VC;

	this->bufferWaitingTime = -1;
	this->messageRoutingTime = -1;
}

void MessageStats::setArrivalTime(int arrivalTime){
	this->arrivalTime = arrivalTime;
}

void MessageStats::calculateMessageStatistics(){
	this->bufferWaitingTime = this->departureTime - this->injectionTime;
	this->messageRoutingTime = this->arrivalTime - this->departureTime;
}

void MessageStats::printMessageStats(){
	std::cout 	<< "Source: " 				<< this->source
				<< "\tDestination: " 		<< this->destination
				<< "\tMessage Number: " 	<< this->messageNumber
				<< "\tInjection Time: " 	<< this->injectionTime
				<< "\tDeparture Time: " 	<< this->departureTime
				<< "\tArrival Time: " 		<< this->arrivalTime
				<< "\tVC: " 				<< this->VC
				<< std::endl;
}



