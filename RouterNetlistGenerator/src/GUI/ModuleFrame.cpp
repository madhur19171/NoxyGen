/*
 * ModuleFrame.cpp
 *
 *  Created on: 24-Nov-2021
 *      Author: madhur
 */

#include "ModuleFrame.h"

ModuleFrame::ModuleFrame(const Glib::ustring& title, VerilogInputOutput *verilogInputOutput)
: Gtk::Frame(title) {
	// TODO Auto-generated constructor stub
	inputOutputBox = new Gtk::Box(Gtk::ORIENTATION_VERTICAL);
	inputButtonFrame = new ModuleInputButtonFrame(true, "Inputs", 40, Gtk::BUTTONBOX_SPREAD);
	outputButtonFrame = new ModuleOutputButtonFrame(true, "Outputs", 40, Gtk::BUTTONBOX_SPREAD);

	inputOutputBox->pack_start(*inputButtonFrame);
	inputOutputBox->pack_start(*outputButtonFrame);

	this->add(*inputOutputBox);

	// Backend
	this->verilogInputOutput = verilogInputOutput;
	numOfInputs = verilogInputOutput->inputList.size();
	numOfOutputs = verilogInputOutput->outputList.size();

	for(int i = 0; i < numOfInputs; i++){
		inputButtonFrame->addButton(verilogInputOutput->inputList[i]->portName, verilogInputOutput->inputList[i]);
	}

	for(int i = 0; i < numOfOutputs; i++){
		outputButtonFrame->addButton(verilogInputOutput->outputList[i]->portName, verilogInputOutput->outputList[i]);
	}

}

ModuleFrame::~ModuleFrame() {
	// TODO Auto-generated destructor stub
}

