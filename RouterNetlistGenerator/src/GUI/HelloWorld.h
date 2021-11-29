/*
 * HelloWorld.h
 *
 *  Created on: 17-Nov-2021
 *      Author: madhur
 */

#ifndef SRC_GUI_HELLOWORLD_H_
#define SRC_GUI_HELLOWORLD_H_

#include <gtkmm/button.h>
#include <gtkmm/window.h>
#include <gtkmm/filechoosernative.h>
#include <gtkmm/dialog.h>
#include <gtkmm/box.h>
#include <gtkmm/object.h>
#include <glibmm/ustring.h>
#include <gtkmm/messagedialog.h>
#include <gtkmm/entry.h>

#include "../Backend/VerilogFile.h"
#include "../Backend/VerilogParameter.h"
#include "../Backend/VerilogInputOutput.h"

#include "ModuleFrame.h"
#include "InputOutputButton.h"

class HelloWorld : public Gtk::Window
{

public:
	HelloWorld();
	virtual ~HelloWorld();

	/* This function is called
	 * when any Input/Output signal button is clicked
	 * then it handles what needs to be done.
	 */
	static void inputButtonClicked(InputButton *clickedButton);
	static void outputButtonClicked(OutputButton *clickedButton);

	static std::vector<InputButton*> clickedInputButtonList;//A list of input buttons that have been clicked
	static std::vector<OutputButton*> clickedOutputButtonList;//A list of output buttons that have been clicked

protected:
	//Signal handlers:
	void on_button_clicked();

	//Member widgets:
	Gtk::Button m_button;

	Gtk::Box VBox;
	std::vector<Gtk::Frame*> moduleFrameList;

private:
	static bool inputClicked;
	static bool outputClicked;

	Gtk::Box* TextEntryBox;
	Gtk::Entry TextEntry;
	std::string enteredText;
	void textEntryHandler();

	VerilogFile *currentVerilogFile;
	void addModuleFrame(VerilogFile *verilogFile);
};

#endif /* SRC_GUI_HELLOWORLD_H_ */
