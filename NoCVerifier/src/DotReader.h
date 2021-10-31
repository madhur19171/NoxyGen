/*
 * DotReader.h
 *
 *  Created on: 01-Nov-2021
 *      Author: madhur
 */

#ifndef SRC_DOTREADER_H_
#define SRC_DOTREADER_H_

#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <math.h>
#include <string>

class DotReader{
public:
	DotReader();
	void readDot(std::string fileName);
};



#endif /* SRC_DOTREADER_H_ */
