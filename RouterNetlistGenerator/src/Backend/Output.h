/*
 * Output.h
 *
 *  Created on: 14-Nov-2021
 *      Author: madhur
 */

#ifndef OUTPUT_H_
#define OUTPUT_H_

#include <iostream>
#include <string>
#include <vector>
#include <utility>
#include <map>

#include "InputOutput.h"
#include "Input.h"

class Output : public InputOutput{
public:
	bool reg;//Whether the output port is a reg type or wire type

	Output();//Default Constructor
	Output(std::string instanceName);
	virtual ~Output(){}
	void outputPortParser(std::string output);
	std::string generateOutputPortCode();//Generate Module port code for the output

	//This function should be overloaded to support variable width IO assignment
	/*
	 * This function assumes that the width of output and input are the same.
	 * This can be used for same width I O connection or single width I O connections
	 * Eg 1:
	 * wire [3:0]A, B;
	 * assign A = B;
	 *
	 * Eg 2:
	 * wire A, B;
	 * assign A = B;
	 */
	std::string generateOutputconnection(Input* input);//Returns a Verilog assign statement connecting this output to "input" passed as an argument

	/**
	 *This function will be used when assignments are done using vector part select for both input and output.
	 *Eg 1:
	 *wire [15:0] A, B;
	 *assign A[3 : 0] = B[15 : 12];
	 */
	std::string generateOutputconnection(int outputStart, int outputEnd, Input* input, int inputStart, int inputEnd);//Returns a Verilog assign statement connecting this output to "input" passed as an argument

	/**
	 *This function will be used for assignments where whole input is assigned a part of output
	 *Eg 1:
	 *wire [15:0] A;
	 *wire [3: 0] B;
	 *assign B = A[15 : 12];
	 */
	std::string generateOutputconnection(int outputStart, int outputEnd, Input* input);//Returns a Verilog assign statement connecting this output to "input" passed as an argument

	/**
	 *This function will be used for assignments where part of input is assigned whole of the output
	 *Eg 1:
	 *wire [15:0] B;
	 *wire [3: 0] A;
	 *assign B[15 : 12] = A;
	 */
	std::string generateOutputconnection(Input* input, int inputStart, int inputEnd);//Returns a Verilog assign statement connecting this output to "input" passed as an argument
};


#endif /* OUTPUT_H_ */
