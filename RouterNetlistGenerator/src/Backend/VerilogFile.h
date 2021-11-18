/*
 * VerilogParser.h
 *
 *  Created on: 17-Nov-2021
 *      Author: madhur
 */

#ifndef SRC_BACKEND_VERILOGFILE_H_
#define SRC_BACKEND_VERILOGFILE_H_

#include <string>
#include <fstream>
#include <iostream>

#include "string_util.h"

class VerilogFile{
public:

	VerilogFile();//Default Constructor

	VerilogFile(std::string verilogFilePath);

	virtual ~VerilogFile(){}

	std::string verilogFilePath;
	std::string moduleName;
	bool parameterized;//true if the verilog module has parameters
	std::string parametersBlock;
	std::string inputsOutputsBlock;

private:

	/*These variables store the start and end
	 * index of moduleName, parameter block and input output blocks
	 * inside verilogCode string.
	 */
	int moduleNameStartIndex = -1;
	int moduleNameEndIndex = -1;

	int parametersStartIndex = -1;
	int parametersEndIndex = -1;

	int inputsOutputsStartIndex = -1;
	int inputsOutputsEndIndex = -1;

	std::string verilogCode;

	std::string readModuleName();
	std::string readParametersBlock();
	std::string readInputsOutputsBlock();

	std::string removeComments();
};

#endif /* SRC_BACKEND_VERILOGFILE_H_ */
