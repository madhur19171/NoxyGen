/*
 * ModuleFrame.h
 *
 *  Created on: 24-Nov-2021
 *      Author: madhur
 */

#ifndef SRC_GUI_MODULEFRAME_H_
#define SRC_GUI_MODULEFRAME_H_

#include <gtkmm/box.h>
#include <gtkmm/frame.h>
#include <gtkmm/buttonbox.h>
#include <gtkmm/button.h>
#include <glibmm/ustring.h>
#include <vector>

#include "ModuleButtonFrame.h"

//Backend Includes:
#include "../Backend/VerilogInputOutput.h"
#include "../Backend/Input.h"
#include "../Backend/Output.h"

/* Module Frame is responsible for generating a frame that constitutes
 * of Inputs and Outputs of the Verilog module.
 * Title is the instance name of the module.
 * verilogInputOutput is the VerilogInputOutput object
 * of the module that we are creating a frame for.
 * This verilogInputOutput object is responsible for providing
 * inputs and outputs information so that buttons can be made for
 * those inputs and outputs
 */

class ModuleFrame : public Gtk::Frame {
public:
	ModuleFrame(const Glib::ustring& title, VerilogInputOutput *verilogInputOutput);
	virtual ~ModuleFrame();

	//Backend elements
	VerilogInputOutput *verilogInputOutput;
private:

	Gtk::Box *inputOutputBox;
	ModuleInputButtonFrame *inputButtonFrame;
	ModuleOutputButtonFrame *outputButtonFrame;

	//Backend Elements
	int numOfInputs;
	int numOfOutputs;
};

#endif /* SRC_GUI_MODULEFRAME_H_ */
