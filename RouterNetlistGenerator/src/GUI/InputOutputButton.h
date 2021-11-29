/*
 * InputOutputButton.h
 *
 *  Created on: 24-Nov-2021
 *      Author: madhur
 */

#ifndef SRC_GUI_INPUTOUTPUTBUTTON_H_
#define SRC_GUI_INPUTOUTPUTBUTTON_H_

#include <gtkmm/button.h>
#include <glibmm/ustring.h>

#include "../Backend/Input.h"
#include "../Backend/Output.h"

/*
 * This class wraps Button objects with their corresponding
 * Verilog input/output object
 */


class InputButton : public Gtk::Button {
public:
	InputButton(const Glib::ustring& label, Input* input);
	virtual ~InputButton(){}

	Input* input;

protected:
	//Signal handlers:
	void on_button_clicked();
};

class OutputButton : public Gtk::Button {
public:
	OutputButton(const Glib::ustring& label, Output* output);
	virtual ~OutputButton(){}

	Output* output;

protected:
	//Signal handlers:
	void on_button_clicked();
};

#endif /* SRC_GUI_INPUTOUTPUTBUTTON_H_ */
