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
#include <glibmm/ustring.h>

#include "../Backend/VerilogFile.h"
#include "../Backend/VerilogParameter.h"

class HelloWorld : public Gtk::Window
{

public:
	HelloWorld();
	virtual ~HelloWorld();

protected:
	//Signal handlers:
	void on_button_clicked();

	//Member widgets:
	Gtk::Button m_button;
};

#endif /* SRC_GUI_HELLOWORLD_H_ */
