/*
 * ModuleButtonFrame.cpp
 *
 *  Created on: 21-Nov-2021
 *      Author: madhur
 */

#include "ModuleButtonFrame.h"


ModuleButtonFrame::ModuleButtonFrame(bool horizontal,
		const Glib::ustring& title,
		gint spacing,
		Gtk::ButtonBoxStyle layout)
: Gtk::Frame(title)
{
	this->N = 0;
	bbox = nullptr;

	if(horizontal)
		bbox = Gtk::make_managed<Gtk::ButtonBox>(Gtk::ORIENTATION_HORIZONTAL);
	else
		bbox = Gtk::make_managed<Gtk::ButtonBox>(Gtk::ORIENTATION_VERTICAL);

	bbox->set_border_width(5);

	add(*bbox);

	/* Set the appearance of the Button Box */
	bbox->set_layout(layout);
	bbox->set_spacing(spacing);
}



ModuleInputButtonFrame::ModuleInputButtonFrame(bool horizontal,
		const Glib::ustring& title,
		gint spacing,
		Gtk::ButtonBoxStyle layout)
: ModuleButtonFrame(horizontal, title, spacing, layout){

}

void ModuleInputButtonFrame::addButton(const Glib::ustring& label, Input *input){
	N++;
	InputButton *button = new InputButton(label, input);
	inputButtonList.push_back(button);
	bbox->add(*button);
}



ModuleOutputButtonFrame::ModuleOutputButtonFrame(bool horizontal,
		const Glib::ustring& title,
		gint spacing,
		Gtk::ButtonBoxStyle layout)
: ModuleButtonFrame(horizontal, title, spacing, layout){

}

void ModuleOutputButtonFrame::addButton(const Glib::ustring& label, Output *output){
	N++;
	OutputButton *button = new OutputButton(label, output);
	outputButtonList.push_back(button);
	bbox->add(*button);
}
