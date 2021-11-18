/*
 * Output.cpp
 *
 *  Created on: 14-Nov-2021
 *      Author: madhur
 */

#include "string_util.h"
#include "Output.h"

Output::Output(){
	instanceName = "";
	portName = "";
	parameterized = false;
	vector = false;
	reg = false;
	vector_string = "";
}

Output::Output(std::string instanceName) : InputOutput(instanceName){
	this->instanceName = instanceName;
	portName = "";
	parameterized = false;
	vector = false;
	reg = false;
	vector_string = "";
}

void Output::outputPortParser(std::string output){
	vector = output.find("[") != std::string::npos;
	if(vector){
		vector_string = trim(substring(output, output.find("["), output.find("]") + 1));
		portName = trim(substring(output, output.find("]") + 1));
	} else
		portName = trim(substring(output, output.find("output") + 6));

	reg = output.find(" reg ") != std::string::npos || output.find(" reg[") != std::string::npos;
}

std::string Output::generateOutputPortCode(){
	std::string ret = "";
	if(reg)
		ret += "output reg " + vector_string + portName;
	else
		ret += "output " + vector_string + getInstancePortName();
	return ret;
}

std::string Output::generateOutputconnection(Input* input){
	std::string ret;

	ret = "assign " + input->getInstancePortName() + " = " + this->getInstancePortName() + ";";

	return ret;
}

