/*
 * InputOutput.cpp
 *
 *  Created on: 14-Nov-2021
 *      Author: madhur
 */
#include "string_util.h"
#include "InputOutput.h"

InputOutput::InputOutput(){
	instanceName = "";
	portName = "";
	parameterized = false;
	vector = false;
	vector_string = "";
}

InputOutput::InputOutput(std::string instanceName){
	this->instanceName = instanceName;
	portName = "";
	parameterized = false;
	vector = false;
	vector_string = "";
}

std::string InputOutput::generateConnectingWire(){
	std::string ret = "";

	ret = "wire " + vector_string + " " + getInstancePortName() + ";";

	return ret;
}

std::string InputOutput::getInstancePortName(){
	return trim(instanceName + "_" + portName);
}
