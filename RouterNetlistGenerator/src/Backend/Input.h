/*
 * Input.h
 *
 *  Created on: 14-Nov-2021
 *      Author: madhur
 */

#ifndef INPUT_H_
#define INPUT_H_

#include <iostream>
#include <string>
#include <vector>
#include <utility>
#include <map>

#include "InputOutput.h"

class Input : public InputOutput
{
public:
	Input();//Default Constructor
	Input(std::string instanceName);
	virtual ~Input(){}
	void inputPortParser(std::string input);
	std::string generateInputPortCode();//Generate Module port code for the input

	void printInput();
};

#endif /* INPUT_H_ */
