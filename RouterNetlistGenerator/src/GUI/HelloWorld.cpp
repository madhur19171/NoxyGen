/*
 * HelloWorld.cpp
 *
 *  Created on: 17-Nov-2021
 *      Author: madhur
 */


#include "HelloWorld.h"
#include <iostream>

HelloWorld::HelloWorld()
: m_button("Hello World")   // creates a new button with label "Hello World".
{
	set_title("Verilog File Selector");

	// Sets the border width of the window.
	set_border_width(10);

	// When the button receives the "clicked" signal, it will call the
	// on_button_clicked() method defined below.
	m_button.signal_clicked().connect(sigc::mem_fun(*this,
			&HelloWorld::on_button_clicked));

	// This packs the button into the Window (a container).
	add(m_button);

	// The final step is to display this newly created widget...
	m_button.show();
}

HelloWorld::~HelloWorld()
{
}

void HelloWorld::on_button_clicked()
{

	Glib::ustring acceptLabel("Choose");
	Glib::ustring cancelLabel("Cancel");

	auto dialog = Gtk::FileChooserNative::create("Please choose a folder",
			*this,
			Gtk::FILE_CHOOSER_ACTION_OPEN,
			"Choose",
			"Cancel");

	dialog->set_transient_for(*this);
	int result = dialog->run();

	//Handle the response:
	switch(result)
	{
	case(Gtk::ResponseType::RESPONSE_ACCEPT):
		{
		std::cout << "Select clicked." << std::endl;
		std::cout << "File selected: " << dialog->get_filename() << std::endl;

		std::string verilogFilePath = dialog->get_filename();

		VerilogFile verilogFile(verilogFilePath);

//		std::cout << verilogFile.moduleName << std::endl;
//		std::cout << verilogFile.parametersBlock << std::endl;
//		std::cout << verilogFile.inputsOutputsBlock << std::endl;

		VerilogParameter verilogParameter(verilogFile.parametersBlock);
		verilogParameter.printParameters();

		break;
	    		}
	case(Gtk::ResponseType::RESPONSE_CANCEL):
	    		{
		std::cout << "Cancel clicked." << std::endl;
		break;
	    		}
	default:
	{
		std::cout << "Unexpected button clicked." << std::endl;
		break;
	}
	}
}

