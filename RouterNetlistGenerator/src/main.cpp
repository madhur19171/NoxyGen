/*
 * main.cpp
 *
 *  Created on: 17-Nov-2021
 *      Author: madhur
 */

#include <iostream>
#include <string>
#include "GUI/HelloWorld.h"
#include <gtkmm/application.h>

int main (int argc, char *argv[])
{
  auto app = Gtk::Application::create(argc, argv, "org.gtkmm.example");

  HelloWorld helloworld;

  //Shows the window and returns when it is closed.
  return app->run(helloworld);
}


//int main(){
//
//	std::string verilogFilePath = "/media/madhur/CommonSpace/Work/SystemSimulators/NoC Simulator/NoC_Netlist_Generator/Verilog/ControlFSM.v";
//
//	VerilogFile verilogFile(verilogFilePath);
//
//	std::cout << verilogFile.moduleName << std::endl;
//	std::cout << verilogFile.parametersBlock << std::endl;
//	std::cout << verilogFile.inputsOutputsBlock << std::endl;
//
//	return 0;
//}


