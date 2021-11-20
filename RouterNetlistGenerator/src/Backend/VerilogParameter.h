/*
 * VerilogParameter.h
 *
 *  Created on: 18-Nov-2021
 *      Author: madhur
 */

#ifndef SRC_BACKEND_VERILOGPARAMETER_H_
#define SRC_BACKEND_VERILOGPARAMETER_H_

#include <iostream>
#include <vector>
#include <string>
#include <map>
#include <utility>

#include "string_util.h"

class VerilogParameter {
public:

	std::string parameterBlock;
	/*
	 * parameterMap stores a map of parameter name and their default value, if present
	 * The format is:
	 * {<ParameterName>, <Default Value>}
	 * In case no default value is provided for the parameter,
	 * empty string is used as the default value.
	 */
	std::map<std::string, std::string> parameterMap;

	VerilogParameter();//Default Constructor
	VerilogParameter(std::string parameterBlock);
	virtual ~VerilogParameter();

	//Prints the parameters and their default values
	void printParameters();

private:
	/*
	 * This function takes in parameterBlock and parses it's contents.
	 * There are two types of parameters: With default value and without default value
	 * parameterMap stores these parameters along with their default values.
	 * The first element of the map stores the name of the parameter
	 * The second element is the default value of the parameter
	 * If the parameter does not have a default value, empty string is stored
	 * in the second element.
	 * Eg.
	 * (parameter N = 32,
	 * parameter DATA_WIDTH = 32,
	 * 			 FIFO_DEPTH = 16,
	 *			 WIRE_DEPTH)
	 * parameterMap = [	{"N", "32"},
	 *					{"DATA_WIDTH", "32"},
	 * 					{"FIFO_DEPTH", "16"},
	 * 					{"WIRE_DEPTH", ""} ]
	 */
	void parseParameterBlock();
};

#endif /* SRC_BACKEND_VERILOGPARAMETER_H_ */
