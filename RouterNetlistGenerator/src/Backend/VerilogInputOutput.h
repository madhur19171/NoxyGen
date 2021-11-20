/*
 * VerilogInputOutput.h
 *
 *  Created on: 20-Nov-2021
 *      Author: madhur
 */

#ifndef SRC_BACKEND_VERILOGINPUTOUTPUT_H_
#define SRC_BACKEND_VERILOGINPUTOUTPUT_H_

#include <iostream>
#include <vector>
#include <string>
#include <map>
#include <utility>

#include "string_util.h"
#include "Input.h"
#include "Output.h"

class VerilogInputOutput {
public:
	std::string moduleName;//Name of module
	std::string instanceName;//Name of the module instance

	std::string inputOutputBlock;

	std::vector<Input*> inputList;
	std::vector<Output*> outputList;

	VerilogInputOutput();
	VerilogInputOutput(std::string moduleName, std::string instanceName, std::string inputOutputBlock);
	virtual ~VerilogInputOutput();

	void printInputOutput();

private:
	void parseInputOutputBlock();
};

#endif /* SRC_BACKEND_VERILOGINPUTOUTPUT_H_ */
