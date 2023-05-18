#include <typeinfo>

// For std::unique_ptr
#include <memory>

#include <verilated.h>
#include "verilated_vcd_c.h"
//#include "verilated_fst_c.h"
#include <iostream>
#include <fstream>
#include <stdint.h>
#include <cstdio>
#include "VNoC_TB.h" // Defines common routines
// Need std::cout
// From Verilating "top.v"

using namespace std;

VNoC_TB *NoC_TB; // Instantiation of model
vluint64_t main_time = 0;
unsigned int clockCycles = 0;


// Current simulation time
// This is a 64-bit integer to reduce wrap over issues and
// allow modulus. This is in units of the timeprecision
// used in Verilog (or from --timescale-override)


double sc_time_stamp() {
	return main_time;
	// Called by $time in Verilog
	// converts to double, to match
	// what SystemC does
}

int main(int argc, char** argv) {
	Verilated::commandArgs(argc, argv);
	// Remember args
	
	NoC_TB = new VNoC_TB; // Create model
	
	int sim_time = 50000;
	
	bool trace = false;
	
	std::string attribute, key, value;
	for(int i = 1; i < argc; i++){
		attribute = argv[i];
		key = attribute.substr(0, attribute.find("="));
		value = attribute.substr(attribute.find("=") + 1);
		
		if(key == "TRACE"){
			trace = std::stoi(value) != 0;
		}
	}
	

	Verilated::traceEverOn(trace);
	VerilatedVcdC* traceFilePointer = new VerilatedVcdC;
	if(trace){
		NoC_TB->trace(traceFilePointer, 2);
		traceFilePointer->open("NoC_TB.vcd");
	}

	
	//VerilatedFstC* traceFilePointer = new VerilatedFstC;
	//VerilatedVcdC* traceFilePointer = new VerilatedVcdC;
	//NoC_TB->trace(traceFilePointer, 2);
	//traceFilePointer->open("NoC_TB.vcd");


	Verilated::gotFinish();
	
	NoC_TB->rst = 0;
	NoC_TB->clk = 1;
	while (!Verilated::gotFinish()) {
		if (main_time > 10) {
			NoC_TB->rst = 0;
			// Deassert reset
		}
		if ((main_time % 10) == 1) {
			NoC_TB->clk = 1;
			// Toggle clock
			clockCycles++;
		}
		if ((main_time % 10) == 6) {
			NoC_TB->clk = 0;
		}

		NoC_TB->eval();
		
		if(trace)
			traceFilePointer->dump(main_time);
		
		// Time passes...
		main_time++;
	}
	
	NoC_TB->final();
	
	if(trace)
		traceFilePointer->close();

	// Done simulating
	//
	// (Though this example doesn't get here)
	delete NoC_TB;
	
	return 0;
}

