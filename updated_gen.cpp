#include <iostream>
#include <fstream>
#include <dirent.h>
#include <string.h>
#include <sstream>
#include <math.h>
using namespace std;

/*
	Format:
	argv[1]: Directory in which traffic files are present
	argv[2]: flitsPerPacket
	argv[3]: packetsPerNode
	argv[4]: Number Of Virtual Channels
	argv[5]: Debug Level --> d0: Dump All Signals; d1: Dump only Test Bench Signals
*/

int main(int argc,char** argv)
{
  // Create and open a text file
  
  //Input file Directory
  std::string directory = argv[1];
  int flitsPerPacket = stoi(argv[2]);
  int packetsPerNode = stoi(argv[3]);
  int VC = stoi(argv[4]);
  std::string debugLevel = argv[5];//Debug level d0 means dump all the signals. d1 means dump only the Testbench signals.
  char direc[256]="";
  cout<<argv[1];
  strcat(direc,argv[1]); 
  ofstream MyFile("NoC_TB.v");
  DIR *dp;
  int num_of_files = 0;
  struct dirent *ep;
  dp = opendir(direc);

  if (dp != NULL)
  {
  	std::cout << "Opened Input Stimulus Directory" << std::endl;
    while (ep = readdir(dp))
      num_of_files++;

    (void)closedir(dp);
    
    num_of_files = num_of_files - 2; //Linux specific as linux directories have pointers to current and previous directories.
  }
  else
    perror("Couldn't open the directory");

  printf("There are %d files in the current directory.\n", num_of_files);

  string names[num_of_files] = {"Node0.dat", "Node1.dat", "Node2.dat", "Node3.dat", "Node4.dat", "Node5.dat", "Node6.dat", "Node7.dat", "Node8.dat"};
  string delays[num_of_files] = {"delay0.dat", "delay1.dat", "delay2.dat", "delay3.dat", "delay4.dat", "delay5.dat", "delay6.dat", "delay7.dat", "delay8.dat"};
  // Write to the file
  MyFile << "module NoC_TB;"
         << "\n"
         << "\treg clk;\n\treg rst;\n";

  /*reg [31 : 0]Node0_data_in = 0;
	reg Node0_valid_in = 0;
	wire Node0_ready_in;
    */
  //num_of_files=6;
  int param_data_width = 31;
  int num_of_nodes = num_of_files / 2;	//Half of them are delay files and half are traffic files
  for (int i = 0; i < num_of_nodes; i++)
  {
    
    MyFile << "\n\n\n\twire [" << param_data_width << " : 0] Node" << i << "_data_in;";
    MyFile << "\n\twire Node" << i << "_valid_in;";
    MyFile << "\n\twire Node" << i << "_ready_in;";

    MyFile << "\n\n\twire [" << param_data_width << " : 0] Node" << i << "_data_out;";
    MyFile << "\n\twire Node" << i << "_valid_out;";
    MyFile << "\n\twire Node" << i << "_ready_out;";
    string ss = "";
    //names[i];
    //sprintf(ss,"/sim/sim/INPUT_VECTORS/%s",names[i]);
    
    //$readmemh("ex1.mem", ex1_memory);
  }

  MyFile << "\n\n\tMesh" << ceil(sqrt(num_of_nodes)) << ceil(sqrt(num_of_nodes)) << " NoC (.clk(clk), .rst(rst),\n";

  for (int i = 0; i < num_of_nodes - 1; i++)
  {
    MyFile << "\t.Node" << i << "_data_in(Node" << i << "_data_in),.Node" << i << "_valid_in(Node" << i << "_valid_in), .Node" << i << "_ready_in(Node" << i << "_ready_in),\n";
    MyFile << "\t.Node" << i << "_data_out(Node" << i << "_data_out),.Node" << i << "_valid_out(Node" << i << "_valid_out), .Node" << i << "_ready_out(Node" << i << "_ready_out),\n";
    MyFile << "\n";
  }
  //last port does not have comma
  MyFile << "\t.Node" << num_of_nodes - 1 << "_data_in(Node" << num_of_nodes - 1 << "_data_in),.Node" << num_of_nodes - 1 << "_valid_in(Node" << num_of_nodes - 1 << "_valid_in), .Node" << num_of_nodes - 1 << "_ready_in(Node" << num_of_nodes - 1 << "_ready_in),\n";
  MyFile << "\t.Node" << num_of_nodes - 1 << "_data_out(Node" << num_of_nodes - 1 << "_data_out),.Node" << num_of_nodes - 1 << "_valid_out(Node" << num_of_nodes - 1 << "_valid_out), .Node" << num_of_nodes - 1 << "_ready_out(Node" << num_of_nodes - 1 << "_ready_out)\n";
  MyFile << "\n";
  
  MyFile << "\t);\n\n\n";
  int clk_period = 5;
  //MyFile << "\talways #" << clk_period << " clk = ~clk;\n\n";
  

  int path_nodes[] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
  int num_of_messages[] = {0,0,0,0,0, 0, 0, 0, 0}; //If each router sends different data, thn this is the same as teh number of directories in the folder of .dat files
  int path_nodes_num = sizeof(path_nodes) / sizeof(path_nodes[0]);
  cout << "Path Nodes Number: " << path_nodes_num << endl;
  //MyFile << "\n\tinitial\n\tbegin";
  //MyFile << "\n\t\tclk=1;\n\t\trst=1;\n\n";
  //for (int i = 0; i < num_of_nodes; i++){
    //MyFile << "\t\tfd"<<i<<"=$fopen(\"output"<<i<<".dat\",\"w\");\n";

 // }
  
  
  int wait_time = 45;
//  std::cout << "reached here" << std::endl;
  for (int i = 0; i < num_of_nodes; i++)
  {
    int k = i;
   MyFile << "\tNodeVerifier #(.ID("<<k<<"), .N(" << num_of_nodes << "), .VC(" << VC << "),\n";
   MyFile<<"\t.dataInputFilePath(\"" << directory << "Node"<<k<<".dat\"),\n";
   MyFile<<"\t.delayInputFilePath(\"" << directory << "delay"<<k<<".dat\"),\n"; 
   MyFile<<"\t.outputFilePath(\"output"<<k<<".dat\"), .FlitsPerPacket(" << flitsPerPacket << "), .numberOfPackets(" << packetsPerNode << ")) nodeVerifier"<<k<<"\n";
		
		MyFile<<"\t(.clk(clk), .rst(rst),\n"; 
		MyFile<<"\t.data_in(Node"<<k<<"_data_in), .valid_in(Node"<<k<<"_valid_in), .ready_in(Node"<<k<<"_ready_in),\n";
		MyFile<<"\t.data_out(Node"<<k<<"_data_out), .valid_out(Node"<<k<<"_valid_out), .ready_out(Node"<<k<<"_ready_out)\n";
		MyFile<<"\t);\n\n";
  }
  
  MyFile << "\n\n\n\n";
  
  
  MyFile<<"	always #10 clk = ~clk;\n";

MyFile<<"	initial begin\n";
MyFile<<"		clk=1;\n";
MyFile<<"		rst=1;\n";

MyFile<<"		#20 rst=0;\n";
MyFile<<"	end\n";

MyFile << "	initial begin\n";
MyFile << "		$dumpfile(\"NoC.vcd\");\n";
if(debugLevel == "d0")
	MyFile << "		$dumpvars(0,NoC_TB); // Dump all the signals\n";
else if(debugLevel == "d1")
	MyFile << "		$dumpvars(1,NoC_TB); // Dump only the Test Bench signals\n";
MyFile << "		#1000 $finish;\n";
MyFile << "	end\n";
  MyFile << "endmodule";
  // Close the file
  MyFile.close();
}
