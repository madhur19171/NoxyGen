/*
 * VerilogModule.h
 *
 *  Created on: 18-Nov-2021
 *      Author: madhur
 */

#ifndef SRC_BACKEND_VERILOGMODULE_H_
#define SRC_BACKEND_VERILOGMODULE_H_

#include <string>

class VerilogModule {
public:

	std::string moduleName;

	VerilogModule();
	virtual ~VerilogModule();
};

#endif /* SRC_BACKEND_VERILOGMODULE_H_ */
