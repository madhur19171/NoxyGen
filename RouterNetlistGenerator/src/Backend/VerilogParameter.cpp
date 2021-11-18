/*
 * VerilogParameter.cpp
 *
 *  Created on: 18-Nov-2021
 *      Author: madhur
 */

#include "VerilogParameter.h"

VerilogParameter::VerilogParameter() {
	// TODO Auto-generated constructor stub
	parameterBlock = "";
}

VerilogParameter::VerilogParameter(std::string parameterBlock) {
	// TODO Auto-generated constructor stub
	this->parameterBlock = parameterBlock;
	parseParameterBlock();
}

VerilogParameter::~VerilogParameter() {
	// TODO Auto-generated destructor stub
}

void VerilogParameter::parseParameterBlock(){
	parameterBlock = trim(parameterBlock);
	parameterBlock = substring(parameterBlock, 1, parameterBlock.size() - 1);

	std::vector <std::string> parameterBlockVector = split(parameterBlock, ",");

	eraseFromVectorElements(parameterBlockVector, "parameter");

	trimVectorElements(parameterBlockVector);

	removeEmptyStringFromVector(parameterBlockVector);

	std::vector <std::string> parameterBlockVectorWithDefaultValue, parameterBlockVectorWithoutDefaultValue;

	for(uint i = 0; i < parameterBlockVector.size(); i++){
		if(parameterBlockVector[i].find("=") == std::string::npos)
			parameterBlockVectorWithoutDefaultValue.push_back(parameterBlockVector[i]);
		else
			parameterBlockVectorWithDefaultValue.push_back(parameterBlockVector[i]);
	}

	for(auto it = parameterBlockVectorWithoutDefaultValue.begin(); it != parameterBlockVectorWithoutDefaultValue.end(); it++)
		parameterMap[(*it)] = "";

	for(auto it = parameterBlockVectorWithDefaultValue.begin(); it != parameterBlockVectorWithDefaultValue.end(); it++){
		std::vector <std::string> vector = split((*it), "=");
		trimVectorElements(vector);
		removeEmptyStringFromVector(vector);
		parameterMap[vector[0]] = vector[1];
	}
}

void VerilogParameter::printParameters(){
	for(auto it = parameterMap.begin(); it != parameterMap.end(); it++){
		std::cout << "Parameter Name: " << it->first << "\t Default Value: " << it->second << std::endl;
	}
}
