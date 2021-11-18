/*
 * InputOutput.h
 *
 *  Created on: 14-Nov-2021
 *      Author: madhur
 */

#ifndef INPUTOUTPUT_H_
#define INPUTOUTPUT_H_

#include <iostream>
#include <string>
#include <vector>
#include <utility>
#include <map>

class InputOutput{
	public:
	std::string instanceName;//Name of module of which this input is a part of
	std::string portName;//Name of Input Port
	bool parameterized;//tells if the port width is Parameterized or not
	std::string vector_string;//Stores the parameterized vector string
	bool vector;//whether input port is a vector or a single wire

	InputOutput();//Default Constructor
	InputOutput(std::string instanceName);
	virtual ~InputOutput(){}

	std::string generateConnectingWire();//Returns Verilog statement declaring a wire that can be connected to this IO port

	std::string getInstancePortName();//Generates the unique port name by appending instance name before the port name

};

#endif /* INPUTOUTPUT_H_ */
