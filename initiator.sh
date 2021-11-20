#!bin/bash

#script for creation of subdirectory need for compilation of dot2hdl
#place the file in root directory of the dot2hdl
mkdir bin obj
cd obj
mkdir shared Verilog VHDL
cd ..
make
