/*
 * VerilogNetlistParser.cpp
 *
 *  Created on: 14-Nov-2021
 *      Author: madhur
 */

#include <iostream>
#include <fstream>
#include <vector>
#include <map>
#include <utility>
#include <string>
#include <stdlib.h>
#include <string>

#include "VerilogNetlist.h"
#include "Input.h"
#include "Output.h"

//int main(){
//	std::string instance1, instance2, inputString, outputString;
//
//	instance1 = "adder0";
//	instance2 = "adder1";
//
//	Input input1(instance1);
//	Output output2(instance2);
//
//	inputString = "input [DATA_WIDTH - 1 : 0] data_in";
//	outputString = "output reg [DATA_WIDTH - 1 : 0] data_out";
//
//	input1.inputPortParser(inputString);
//	output2.outputPortParser(outputString);
//
//	std::cout << input1.generateInputPortCode() << std::endl;
//	std::cout << output2.generateOutputPortCode() << std::endl;
//	std::cout << output2.generateOutputconnection(&input1) << std::endl;
//}
//
