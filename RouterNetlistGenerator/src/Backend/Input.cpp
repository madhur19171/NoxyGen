/*
 * Input.cpp
 *
 *  Created on: 14-Nov-2021
 *      Author: madhur
 */

#include "string_util.h"
#include "Input.h"


Input::Input(){
	instanceName = "";
	portName = "";
	parameterized = false;
	vector = false;
	vector_string = "";
}

Input::Input(std::string instanceName) : InputOutput(instanceName){
	this->instanceName = instanceName;
	portName = "";
	parameterized = false;
	vector = false;
	vector_string = "";
}

void Input::printInput(){
	std::cout << "Instance Name: " << instanceName
			<< "\tPortName: " << portName
			<< (vector ? ("\tVector: " + vector_string) : "")
			<< std::endl;
}

void Input::inputPortParser(std::string input){
	vector = input.find("[") != std::string::npos;
	if(vector){
		vector_string = trim(substring(input, input.find("["), input.find("]") + 1));
		portName = trim(substring(input, input.find("]") + 1));
	} else
		portName = trim(substring(input, input.find("input") + 5));
}

std::string Input::generateInputPortCode(){
	std::string ret = "";
	ret += "input " + vector_string + getInstancePortName();
	return ret;
}
