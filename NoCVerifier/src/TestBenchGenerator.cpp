/*
 * TestBenchGenerator.h
 *
 *  Created on: 12-May-2023
 *      Author: madhur
 */

#include <fstream>
#include "TestBenchGenerator.h"

TestBenchGenerator::TestBenchGenerator(){
	this->N = 1;
	this->DATA_WIDTH = 32;
	this->flitsPerPacket = 16;
	this->VC = 1;
	this->numberOfPacketsPerNode = 128;
	this->simulator = "";
}

TestBenchGenerator::TestBenchGenerator(int N, int DATA_WIDTH, int flitsPerPacket, int VC, int numberOfPacketsPerNode, std::string simulator){
	this->N = N;
	this->DATA_WIDTH = DATA_WIDTH;
	this->flitsPerPacket = flitsPerPacket;
	this->VC = VC;
	this->numberOfPacketsPerNode = numberOfPacketsPerNode;
	this->simulator = simulator;
}

TestBenchGenerator::~TestBenchGenerator(){

}

std::string TestBenchGenerator::generateModuleName(std::string testBenchName){
	if(this->simulator != "verilator")
		return "module " + testBenchName + ";\n";
	else
		return "module " + testBenchName + "(input clk, input rst);\n";
}

std::string TestBenchGenerator::generateClkRstBookKeepers(){
	std::string ret = "";
	
	if(this->simulator != "verilator"){
		ret += "\tlogic clk;\n";
		ret += "\tlogic rst;\n";
	}

	ret += "\twire [" + std::to_string(this->N) + " - 1 : 0] allFlitsInjected;\n";
	ret += "\tint totalPacketsInjected [" + std::to_string(this->N) + " - 1 : 0];\n" ;
	ret += "\tint totalPacketsEjected [" + std::to_string(this->N) + " - 1 : 0];\n" ;
	ret += "\tint packetsInjectedAllNodes, packetsEjectedAllNodes;\n";

	ret += "\n\n";

	return ret;
}

std::string TestBenchGenerator::generateConnectingWire(int node){
	std::string ret = "";

	ret += "\twire [" + std::to_string(this->DATA_WIDTH) + " - 1 : 0] Node" + std::to_string(node) + "_data_in;\n";
	ret += "\twire Node" + std::to_string(node) + "_valid_in;\n";
	ret += "\twire Node" + std::to_string(node) + "_ready_in;\n";

	ret += "\n";

	ret += "\twire [" + std::to_string(this->DATA_WIDTH) + " - 1 : 0] Node" + std::to_string(node) + "_data_out;\n";
	ret += "\twire Node" + std::to_string(node) + "_valid_out;\n";
	ret += "\twire Node" + std::to_string(node) + "_ready_out;\n";

	ret += "\n\n";

	return ret;
}

std::string TestBenchGenerator::instantiateDUT(std::string DUTName){
	std::string ret = "";

	ret += "\t" +  DUTName + " " + DUTName + "_tb (\n";

	ret += "\t.clk(clk), .rst(rst),\n\n";

	for(int i = 0; i < this->N; i++){
		std::string nodeName = "Node" + std::to_string(i);

		std::string dataIn = nodeName + "_data_in";
		std::string dataOut = nodeName + "_data_out";
		std::string validIn = nodeName + "_valid_in";
		std::string validOut = nodeName + "_valid_out";
		std::string readyIn = nodeName + "_ready_in";
		std::string readyOut = nodeName + "_ready_out";

		ret += "\t";
		ret += "." + dataIn + "(" + dataIn + "), ";
		ret += "." + validIn + "(" + validIn + "), "; 
		ret += "." + readyIn + "(" + readyIn + "),\n"; 

		ret += "\t";
		ret += "." + dataOut + "(" + dataOut + "), ";
		ret += "." + validOut + "(" + validOut + "), "; 
		if(i == this->N - 1)
			ret += "." + readyOut + "(" + readyOut + ")\n\n";
		else
			ret += "." + readyOut + "(" + readyOut + "),\n\n";
	}

	ret += "\t);\n\n";

	return ret;
}

std::string TestBenchGenerator::instantiateNodeVerifier(int node, std::string inputVectorPath, std::string outputVectorPath){
	std::string ret = "";

	ret += "\tNodeVerifier ";
	ret += "#(.INDEX(" + std::to_string(node) + "), .N(" + std::to_string(this->N) + "), .VC(" + std::to_string(this->VC) + "), .IDENTIFIER_BITS(2), \n";
	ret += "\t.FLITS_PER_PACKET(" + std::to_string(this->flitsPerPacket) + "), \n" ;
	ret += "\t.PACKETS_PER_NODE(" + std::to_string(this->numberOfPacketsPerNode) + "), \n" ;
	ret += "\t.INPUT_TRAFFIC_FILE(\"" + inputVectorPath + "input" + std::to_string(node) + "\"), \n" ;
	ret += "\t.INPUT_DELAY_FILE(\"" + inputVectorPath + "delay" + std::to_string(node) + "\"), \n" ;
	ret += "\t.OUTPUT_FILE(\"" + outputVectorPath + "output" + std::to_string(node) + "\")) \n" ;
	
	ret += "\tnodeVerifier" + std::to_string(node) + "\n";

	ret += "\t(.clk(clk), .rst(rst), \n";
	
	std::string nodeName = "Node" + std::to_string(node);

	ret += "\t.data_out(" + nodeName + "_data_in), "; 
	ret += ".valid_out(" + nodeName + "_valid_in), "; 
	ret += ".ready_out(" + nodeName + "_ready_in), \n"; 

	ret += "\t.data_in(" + nodeName + "_data_out), "; 
	ret += ".valid_in(" + nodeName + "_valid_out), "; 
	ret += ".ready_in(" + nodeName + "_ready_out), \n"; 

	ret += "\t.allFlitsInjected(allFlitsInjected[" + std::to_string(node) + "]), \n";
	ret += "\t.totalPacketsInjected(totalPacketsInjected[" + std::to_string(node) + "]), \n";
	ret += "\t.totalPacketsEjected(totalPacketsEjected[" + std::to_string(node) + "]) \n";

	ret += "\t);\n\n";

	return ret;
}

std::string TestBenchGenerator::generateAlwaysClock(){
	return "\talways #5 clk = ~clk;\n";
}

std::string TestBenchGenerator::generateInitial(){
	std::string ret = "\tinitial begin\n"
		"\t\tclk = 0;\n"
		"\t\trst = 1;\n"
		"\t\t#10 rst = 0;\n"
	"\tend\n\n";

	return ret;
}

std::string TestBenchGenerator::generateFinishBlock(){
	std::string ret = "\tint N = " + std::to_string(this->N) + ";\n";

	ret += "\talways_ff @(posedge clk) begin\n"
		"\t\tpacketsInjectedAllNodes = 0;\n"
		"\t\tpacketsEjectedAllNodes = 0;\n"
		"\t\tfor(int i = 0; i < N; i++) begin\n"
			"\t\t\tpacketsInjectedAllNodes += totalPacketsInjected[i];\n"
			"\t\t\tpacketsEjectedAllNodes += totalPacketsEjected[i];\n"
		"\t\tend\n\n"
		
		"\t\tif(&allFlitsInjected & (packetsInjectedAllNodes == packetsEjectedAllNodes))\n"
			"\t\t\t$finish;\n"
	"\t\tend\n\n";

	return ret;
}

std::string TestBenchGenerator::generateEndmodule(){
	return "endmodule";
}

void TestBenchGenerator::generateTestBench(std::string testBenchName, std::string DUTName, std::string inputVectorPath, std::string outputVectorPath){
	std::string ret = "";

	ret += generateModuleName(testBenchName);
	ret += generateClkRstBookKeepers();

	for(int i = 0; i < this->N; i++){
		ret += generateConnectingWire(i);
	}

	ret += instantiateDUT(DUTName);
	for(int i = 0; i < this->N; i++){
		ret += instantiateNodeVerifier(i, inputVectorPath, outputVectorPath);
	}
	
	if(this->simulator != "verilator"){	// Verilator doesn't need them
		ret += generateAlwaysClock();
		ret += generateInitial();
	}
	
	ret += generateFinishBlock();
	ret += generateEndmodule();

	std::ofstream testBench(testBenchName + ".sv");
	testBench << ret << std::endl;
	testBench.close();
}
