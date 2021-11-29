/*
 * InputOutputButton.cpp
 *
 *  Created on: 24-Nov-2021
 *      Author: madhur
 */

#include "InputOutputButton.h"
#include "HelloWorld.h"

InputButton::InputButton(const Glib::ustring& label, Input *input) : Gtk::Button(label){
	// TODO Auto-generated constructor stub
	this->input = input;

	this->signal_clicked().connect(sigc::mem_fun(*this,
			&InputButton::on_button_clicked));
}

OutputButton::OutputButton(const Glib::ustring& label, Output *output) : Gtk::Button(label){
	// TODO Auto-generated constructor stub
	this->output = output;

	this->signal_clicked().connect(sigc::mem_fun(*this,
			&OutputButton::on_button_clicked));
}

void InputButton::on_button_clicked(){
	HelloWorld::inputButtonClicked(this);
}

void OutputButton::on_button_clicked(){
	HelloWorld::outputButtonClicked(this);
}
