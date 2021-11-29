/*
 * HelloWorld.cpp
 *
 *  Created on: 17-Nov-2021
 *      Author: madhur
 */


#include "HelloWorld.h"
#include <iostream>

HelloWorld::HelloWorld()
: VBox(Gtk::ORIENTATION_VERTICAL),
  m_button("Hello World")   // creates a new button with label "Hello World".
{
	set_title("Verilog File Selector");

	// Sets the border width of the window.
	set_border_width(10);

	// When the button receives the "clicked" signal, it will call the
	// on_button_clicked() method defined below.
	m_button.signal_clicked().connect(sigc::mem_fun(*this,
			&HelloWorld::on_button_clicked));

	add(VBox);

	VBox.add(m_button);

	//Inserting a TextBox for taking instance name input
	TextEntryBox = Gtk::make_managed<Gtk::Box>(Gtk::ORIENTATION_HORIZONTAL);
	TextEntry.set_max_length(50);
	TextEntry.set_text("Enter Instance Name");
	TextEntry.select_region(0, TextEntry.get_text_length());

	Gtk::Button *textEntryButton = Gtk::make_managed<Gtk::Button>("OK");
	textEntryButton->signal_clicked().connect(sigc::mem_fun(*this,
			&HelloWorld::textEntryHandler));

	TextEntryBox->pack_start(TextEntry);
	TextEntryBox->pack_start(*textEntryButton);
	VBox.add(*TextEntryBox);

	show_all_children();
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

		currentVerilogFile = new VerilogFile(verilogFilePath);

		//		VerilogParameter verilogParameter(verilogFile.parametersBlock);
		//		verilogParameter.printParameters();

		//		std::string instanceName0 = verilogFile.moduleName + "0";
		//		std::string instanceName1 = verilogFile.moduleName + "1";
		//
		//		//		std::cout << verilogFile.moduleName << std::endl;
		//		//		std::cout << verilogFile.parametersBlock << std::endl;
		//		//		std::cout << verilogFile.inputsOutputsBlock << std::endl;
		//
		//		VerilogInputOutput verilogInputOutput0(verilogFile.moduleName, instanceName0, verilogFile.inputsOutputsBlock);
		//		verilogInputOutput0.printInputOutput();
		//
		//		VerilogInputOutput verilogInputOutput1(verilogFile.moduleName, instanceName1, verilogFile.inputsOutputsBlock);
		//		verilogInputOutput1.printInputOutput();
		//
		//		std::cout << verilogInputOutput1.outputList[0]->generateOutputconnection(verilogInputOutput0.inputList[3]) << std::endl;
		//		std::cout << verilogInputOutput1.outputList[1]->generateOutputconnection(verilogInputOutput0.inputList[2]) << std::endl;
//		show_all_children();

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

void HelloWorld::inputButtonClicked(InputButton *clickedButton){

	if(!outputClicked){
		Gtk::Window *window = new Gtk::Window();
		Gtk::MessageDialog dialog(*window, "Select and Output first",
				false /* use_markup */, Gtk::MESSAGE_QUESTION,
				Gtk::BUTTONS_CLOSE);
		dialog.run();
		return;
	}

	inputClicked = true;

	clickedInputButtonList.push_back(clickedButton);
	std::cout << "Input Clicked" << std::endl;

	std::string connectionString = clickedOutputButtonList.at(0)->output->generateOutputconnection(clickedInputButtonList.at(0)->input);

	std::cout << connectionString << std::endl;

	clickedOutputButtonList.clear();
	clickedInputButtonList.clear();

	outputClicked = false;
}

void HelloWorld::outputButtonClicked(OutputButton *clickedButton){

	if(outputClicked){
		Gtk::Window *window = new Gtk::Window();
		Gtk::MessageDialog dialog(*window, "Output already selected\nSelect an Input",
				false /* use_markup */, Gtk::MESSAGE_QUESTION,
				Gtk::BUTTONS_CLOSE);
		dialog.run();
		return;
	}


	outputClicked = true;

	clickedOutputButtonList.push_back(clickedButton);
	std::cout << "Output Clicked" << std::endl;
}

void HelloWorld::textEntryHandler(){
	enteredText = std::string(TextEntry.get_text());
	addModuleFrame(currentVerilogFile);
	std::cout << "Hi" << std::endl;
}

void HelloWorld::addModuleFrame(VerilogFile *verilogFile){
	std::cout << "Hi" << std::endl;

	std::string instanceName = verilogFile->moduleName + enteredText;
	std::cout << "Hi" << std::endl;
	//Backend Processing Starts
	VerilogInputOutput *verilogInputOutput = new VerilogInputOutput(verilogFile->moduleName, instanceName, verilogFile->inputsOutputsBlock);
	verilogInputOutput->printInputOutput();
	//Backend Processing Ends

	std::cout << "Hi" << std::endl;
	ModuleFrame *moduleFrame = new ModuleFrame(instanceName, verilogInputOutput);

	VBox.add(*moduleFrame);
	show_all_children();
}

//Static members need to be initialized before use
std::vector<InputButton*> HelloWorld::clickedInputButtonList(0);
std::vector<OutputButton*> HelloWorld::clickedOutputButtonList(0);
bool HelloWorld::inputClicked = false;
bool HelloWorld::outputClicked = false;

