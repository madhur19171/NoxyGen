/*
 * VerilogParser.cpp
 *
 *  Created on: 17-Nov-2021
 *      Author: madhur
 */



#include "VerilogFile.h"

VerilogFile::VerilogFile(){
	verilogFilePath = "";
	moduleName = "";
	parameterized = false;
	parametersBlock = "";
	inputsOutputsBlock = "";
}

VerilogFile::VerilogFile(std::string verilogFilePath){
	this->verilogFilePath = trim(verilogFilePath);
	std::ifstream verilogFile(this->verilogFilePath);
	std::string line;

	parameterized = false;

	if (verilogFile.is_open()){
		std::cout << "Verilog File \"" << this->verilogFilePath << "\" opened for reading" << std::endl;
		while(std::getline(verilogFile, line)){
			verilogCode += line + '\n';
		}
		verilogCode = trim(verilogCode);
		verilogFile.close();
	}

	verilogCode = removeComments();

	if (verilogCode.find('#') != std::string::npos)
		parameterized = true;//Verilog Parameters list starts with a # sign

	//These three read functions have to be called in this order only
	//because endIndex of one is used to determine the startIndex of
	//the following function
	moduleName = readModuleName();
	parametersBlock = readParametersBlock();
	inputsOutputsBlock = readInputsOutputsBlock();
}

std::string VerilogFile::readModuleName(){
	std::string ret;

	int moduleIndex = verilogCode.find("module") + 6;
	if(parameterized){
		int parameterStart = verilogCode.find("#");
		ret = trim(substring(verilogCode, moduleIndex, parameterStart));
	} else{
		int bracketStart = verilogCode.find("(");
		ret = trim(substring(verilogCode, moduleIndex, bracketStart));
	}

	moduleNameStartIndex = verilogCode.find(ret);
	moduleNameEndIndex = moduleNameStartIndex + ret.length() - 1;

	return ret;
}

std::string VerilogFile::readParametersBlock(){
	std::string ret = "";

	if(parameterized){
		parametersStartIndex = verilogCode.find('(', verilogCode.find("#") + 1);

		std::string parameterBlockStart = substring(verilogCode, parametersStartIndex);//First '(' after '#' marks the start of parameter block
		int endIndex = findMatchingBracket(parameterBlockStart, '(');
		ret = substring(parameterBlockStart, 0, endIndex + 1);

		parametersEndIndex = parametersStartIndex + ret.length() - 1;
	}

	return ret;
}

std::string VerilogFile::readInputsOutputsBlock(){
	std::string ret = "";

	if(parameterized)
		inputsOutputsStartIndex = verilogCode.find('(', parametersEndIndex);//First '(' after parameter block ends marks the start of Input output block
	else
		inputsOutputsStartIndex = verilogCode.find('(', moduleNameEndIndex);//First '(' after module block ends marks the start of Input output block

	std::string inputsOutputsBlockStart = substring(verilogCode, inputsOutputsStartIndex);

	int endIndex = findMatchingBracket(inputsOutputsBlockStart, '(');
	ret = substring(inputsOutputsBlockStart, 0,  endIndex + 1);

	inputsOutputsEndIndex = inputsOutputsEndIndex + ret.length() - 1;

	return ret;
}

std::string VerilogFile::removeComments(){
	std::string ret = verilogCode;

	int start = 0;
	while(ret.find("//") != std::string::npos){
		start = ret.find("//");
		if(start == 0){
			ret = substring(ret, ret.find('\n') + 1);
		} else if(ret[start - 1] == '\n'){
			ret = substring(ret, 0, start - 1) + substring(ret, ret.find('\n', start));
		} else if(ret.find('\n', start) != std::string::npos){
			ret = substring(ret, 0, start) + substring(ret, ret.find('\n', start));
		} else{
			ret = substring(ret, 0, start);
		}
	}

	return ret;
}
