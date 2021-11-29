/*
 * ModuleButtonBox.h
 *
 *  Created on: 21-Nov-2021
 *      Author: madhur
 */

#ifndef SRC_GUI_MODULEBUTTONFRAME_H_
#define SRC_GUI_MODULEBUTTONFRAME_H_

#include <gtkmm/box.h>
#include <gtkmm/frame.h>
#include <gtkmm/buttonbox.h>
#include <gtkmm/button.h>
#include <glibmm/ustring.h>
#include <vector>

#include "InputOutputButton.h"

class HelloWorld;

/*
 * This class holds all Input and Output buttons
 * for a particular verilog module instance
 */

class ModuleButtonFrame : public Gtk::Frame {
public:
	int N;//N is the number of buttons to be present in this button Box
	ModuleButtonFrame(bool horizontal,
			const Glib::ustring& title,
			gint spacing,
			Gtk::ButtonBoxStyle layout);

	virtual ~ModuleButtonFrame(){}

protected:
	Gtk::ButtonBox* bbox;

};

class ModuleInputButtonFrame : public ModuleButtonFrame{
public:
	ModuleInputButtonFrame(bool horizontal,
			const Glib::ustring& title,
			gint spacing,
			Gtk::ButtonBoxStyle layout);

	virtual ~ModuleInputButtonFrame(){}

	void addButton(const Glib::ustring& title, Input *input);

protected:
	std::vector <InputButton*> inputButtonList;
};

class ModuleOutputButtonFrame : public ModuleButtonFrame{
public:
	ModuleOutputButtonFrame(bool horizontal,
			const Glib::ustring& title,
			gint spacing,
			Gtk::ButtonBoxStyle layout);

	virtual ~ModuleOutputButtonFrame(){}

	void addButton(const Glib::ustring& title, Output *output);

protected:
	std::vector <OutputButton*> outputButtonList;
};

#endif /* SRC_GUI_MODULEBUTTONFRAME_H_ */
