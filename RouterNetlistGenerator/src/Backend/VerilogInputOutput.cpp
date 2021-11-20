/*
 * VerilogInputOutput.cpp
 *
 *  Created on: 20-Nov-2021
 *      Author: madhur
 */

#include "VerilogInputOutput.h"

VerilogInputOutput::VerilogInputOutput() {
	// TODO Auto-generated constructor stub
	inputOutputBlock = "";
}

VerilogInputOutput::VerilogInputOutput(std::string moduleName, std::string instanceName, std::string inputOutputBlock) {
	// TODO Auto-generated constructor stub
	this->moduleName = moduleName;
	this->instanceName = instanceName;
	this->inputOutputBlock = inputOutputBlock;
	parseInputOutputBlock();
}

VerilogInputOutput::~VerilogInputOutput() {
	// TODO Auto-generated destructor stub
}

void VerilogInputOutput::printInputOutput(){
	std::cout << "Inputs:" << std::endl;
	for(auto iter : inputList)
		iter->printInput();
	std::cout << "\nOutputs:" << std::endl;
	for(auto iter : outputList)
		iter->printOutput();
}

void VerilogInputOutput::parseInputOutputBlock(){
	inputOutputBlock = trim(inputOutputBlock);
	inputOutputBlock = substring(inputOutputBlock, 1, inputOutputBlock.size() - 1);

	std::vector <std::string> inputOutputBlockVector = split(inputOutputBlock, ",");

	trimVectorElements(inputOutputBlockVector);

	removeEmptyStringFromVector(inputOutputBlockVector);

	for(auto it = inputOutputBlockVector.begin(); it != inputOutputBlockVector.end(); it++){
		std::string str = (*it);
		if(str.find("input") == 0){
			Input* input = new Input(this->instanceName);//Generate Input object for this instance of verilog module
			input->inputPortParser(str);//Parse the input declaration string
			inputList.push_back(input);
		} else if(str.find("output") == 0){
			Output* output = new Output(this->instanceName);
			output->outputPortParser(str);//Generate Output object for this instance of verilog module
			outputList.push_back(output);//Parse the output declaration string
		}
	}
}
