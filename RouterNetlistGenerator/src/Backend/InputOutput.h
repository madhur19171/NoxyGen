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
	std::string instanceName;//Name of module of which this input/output is a part of
	std::string portName;//Name of Input/Output Port(initialized by subclass)
	bool parameterized;//tells if the port width is Parameterized or not(initialized by subclass)
	std::string vector_string;//Stores the parameterized vector string(initialized by subclass)
	bool vector;//whether input/output port is a vector or a single wire(initialized by subclass)

	InputOutput();//Default Constructor
	InputOutput(std::string instanceName);
	virtual ~InputOutput(){}

	std::string generateConnectingWire();//Returns Verilog statement declaring a wire that can be connected to this IO port

	std::string getInstancePortName();//Generates the unique port name by appending instance name before the port name

};

#endif /* INPUTOUTPUT_H_ */
