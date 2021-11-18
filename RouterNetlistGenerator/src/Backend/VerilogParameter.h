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
	std::map<std::string, std::string> parameterMap;

	VerilogParameter();//Default Constructor
	VerilogParameter(std::string parameterBlock);
	virtual ~VerilogParameter();

	void printParameters();

private:
	void parseParameterBlock();
};

#endif /* SRC_BACKEND_VERILOGPARAMETER_H_ */
