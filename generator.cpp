#include <iostream>
#include <fstream>
#include <dirent.h>
#include <string.h>
#include <sstream>
using namespace std;

int main()
{
  // Create and open a text file
  
  //Input file Directory
  std::string directory = "./sim/sim/INPUT_VECTORS/";
  
  ofstream MyFile("NoC_TB.v");
  DIR *dp;
  int num_of_files = 0;
  struct dirent *ep;
  dp = opendir("./sim/sim/INPUT_VECTORS");

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
  int num_of_nodes = num_of_files;
  for (int i = 0; i < num_of_nodes; i++)
  {
    
    MyFile << "\n\n\n\treg [" << param_data_width << " : 0] Node" << i << "_data_in = 0;";
    MyFile << "\n\treg Node" << i << "_valid_in = 0;";
    MyFile << "\n\twire Node" << i << "_ready_in;";

    MyFile << "\n\n\twire [" << param_data_width << " : 0] Node" << i << "_data_out;";
    MyFile << "\n\twire Node" << i << "_valid_out;";
    MyFile << "\n\treg Node" << i << "_ready_out = 0;";
    string ss = "";
    //names[i];
    //sprintf(ss,"/sim/sim/INPUT_VECTORS/%s",names[i]);
    
    //$readmemh("ex1.mem", ex1_memory);
  }

  MyFile << "\n\n\tNoc noc (.clk(clk), .rst(rst),\n";

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
  
  MyFile << "\t);\n";
  int clk_period = 5;
  MyFile << "\talways #" << clk_period << " clk = ~clk;\n\n";
  

  int path_nodes[] = {0, 1, 2, 3, 4, 5, 6, 7, 8};
  int num_of_messages[] = {0,0,0,0,0, 0, 0, 0, 0}; //If each router sends different data, thn this is the same as teh number of directories in the folder of .dat files
  int path_nodes_num = sizeof(path_nodes) / sizeof(path_nodes[0]);
  cout << "Path Nodes Number: " << path_nodes_num << endl;
  MyFile << "\n\tinitial\n\tbegin";
  MyFile << "\n\t\tclk=1;\n\t\trst=1;\n\n";
  for (int i = 0; i < num_of_nodes; i++){
    MyFile << "\t\tfd"<<i<<"=$fopen(\"output"<<i<<".dat\",\"w\");\n";

  }
  
  std::stringstream memory_instance;

  for (int i = 0; i < path_nodes_num; i++)
  {
    MyFile << "\n";
    MyFile << "\t\tNode" << path_nodes[i] << "_valid_in = 0;";
    FILE *fp;
    
    //std::stridirectory += names[i];
    fp = fopen((directory + names[i]).c_str(), "r");
    int count = 0;
    char c;
    // Check if file exists
    if (fp == NULL)
    {
      printf("Could not open file %s\n", names[i].c_str());
      return 0;
    }

    // Extract characters from file and store in character c
    for (c = getc(fp); c != EOF; c = getc(fp))
    {
      if (c == '\n' && c != ' ')
      { // Increment count if this character is newline
        count = count + 1;
        cout << count << "\nsdsds";
      }
    }
    // Close the file
    cout << count << endl;
    num_of_messages[i]=(count)/6;
    fclose(fp);
    memory_instance << "\n\t\treg [" << 31 << ":0] ex" << path_nodes[i] << "_memory [0:" << count - 1<< "];";
  }
  int reset_time = 20;
  MyFile << "\n\n\t\t#" << reset_time << " rst=0;";
  MyFile << "\n\tend";
  
  MyFile << memory_instance.str();//Memory Instantiation
  
  int wait_time = 45;
//  std::cout << "reached here" << std::endl;
  for (int i = 0; i < path_nodes_num; i++)
  {
    int k = path_nodes[i];
    MyFile << "\n\n\tinteger i" << path_nodes[i] << ", j" << path_nodes[i] << ";";
    //$readmemh("ex1.mem", ex1_memory);

      MyFile << "\n\t "
             << "// initial begin starts"
             << "\n\tinitial begin";
      MyFile << "\n\t\t#" << wait_time;
      MyFile<< " \n\t\t$readmemh(\"" << directory << names[i] << "\",ex"<<path_nodes[i]<<"_memory);";
      //int num_of_messages=(count-1)/6;
      MyFile << "\n\t\tfor(j" << path_nodes[i] << " = 0; j" << path_nodes[i] << " < "<< num_of_messages[i]<<"; j" << path_nodes[i] << " = j" << path_nodes[i] << " + 1)begin";
      MyFile << "\n\t\t\tNode" << path_nodes[i] << "_valid_in = 1;";
      MyFile << "\n\t\t\tfor(i" << path_nodes[i] << " = 0; i" << path_nodes[i] << " < 6; i" << path_nodes[i] << " = i" << path_nodes[i] << " + 1)begin";
      MyFile << "\n\t\t\t\tNode" << k << "_data_in=ex"<<path_nodes[i]<<"_memory[j"<<path_nodes[i]<<"*6+i"<<path_nodes[i]<<"];\n";
      /*MyFile << "\n\t\t\t\tif(i" << k << " == 1)begin"
             << "//Routing destination fed into head flit";
      MyFile << "\n\t\t\t\t\tNode" << k << "_data_in=3'd" << i + 1 << ";\n\t\t\t\tend\n\t\t\t\telse";
      MyFile << "\n\t\t\t\t\tNode" << k << "_data_in = i" << k << " + " << 16 * i << ";";
      MyFile << "\n\t\t\t\tif(i" << k << " == 1) begin"
             << "\n\t\t\t\t\tNode" << k << "_data_in[" << param_data_width << ":" << param_data_width - 1 << "] = 2'd1;\n\t\t\t\tend";
      MyFile << "\n\t\t\t\telse if (i" << k << " == 6)\n\t\t\t\t\tNode" << k << "_data_in[" << param_data_width << ":" << param_data_width - 1 << "] =2'd3;\n\t\t\t\telse";
      MyFile << "\n\t\t\t\t\tNode" << k << "_data_in[" << param_data_width << ":" << param_data_width - 1 << "] = 2'd2"; //31 : 30] = 2'd2;"*/
      MyFile << "\t\t\t\tif(i" << k << " == 0) begin\n";
      MyFile << "\t\t\t\t\t$display(\"Node" << path_nodes[i] << ": Message: %d	Destination: %d\", (j" << path_nodes[i] << " + 1), Node" << path_nodes[i] << "_data_in[3:0]);\n";
      MyFile << "\t\t\t\t\t@(negedge Node" << k << "_ready_in);\n";
      MyFile << "\t\t\t\tend\n";
      MyFile << "\t\t\t\telse wait(Node"<<k<<"_ready_in);\n";
      MyFile << "\t\t\t\t@(posedge clk);\n\t\t\t\t\t`ifdef VIVADO\n\t\t\t\t\t\t@(negedge clk);\n\t\t\t\t\t`endif";
      
      MyFile << "\n\t\t\tend";//Inner Loop End


      MyFile << "\n\t\t\t#5 Node" << k << "_valid_in = 0;";
      
      MyFile << "\n\t\tend";//Outer Loop End
      
      MyFile << "\n\tend";//Initial End
      MyFile << "\n\n";//Lines between two initial blocks

    /*
MyFile<<"\n\t "<<"// initial begin starts"<<"\n\tinitial begin";
MyFile<<"\n\t\t#"<<wait_time;
MyFile<<"\n\t\tNode"<<path_nodes[i]<<"_valid_in = 1;";
MyFile<<"\n\t\tfor(i"<<path_nodes[i]<<" = 1; i"<<path_nodes[i]<<" <= 6; i"<<path_nodes[i]<<"= i"<<path_nodes[i]<<" + 1)begin";
MyFile<<"\n\t\t\t\tif(i"<<k<<" == 1)begin"<<"//Routing destination fed into head flit";
MyFile<<"\n\t\t\t\t\tNode"<<k<<"_data_in=3'd"<<5<<"\n\t\t\t\tend\n\t\t\t\telse";
MyFile<<"\n\t\t\t\t\tNode"<<k<<"_data_in = i"<<k<<" + 16;";
MyFile<<"\n\t\t\t\tif(i"<<k<<" == 1) begin"<<"\n\t\t\t\t\tNode"<<k<<"_data_in["<<param_data_width<<":"<< param_data_width-1<<"] = 2'd1;\n\t\t\t\tend";
MyFile<<"\n\t\t\t\telse if (i"<<k<<" == 6)\n\t\t\t\t\tNode"<<k<<"_data_in["<<param_data_width<<":"<<param_data_width-1<<"] =2'd3;\n\t\t\t\telse";
MyFile<<"\n\t\t\t\t\tNode"<<k<<"_data_in["<<param_data_width<<":"<<param_data_width-1<<"] = 2'd2";//31 : 30] = 2'd2;"
MyFile<<"\n\t\t\t\tif(i"<<k<<" == 1)\n\t\t\t\t\t@(negedge Node"<<k<<"_ready_in);\n\t\t\t\telse wait(Node0_ready_in);";
MyFile<<"\n\t\t\t\t@(posedge clk);\n\t\t\t\t\t`ifdef VIVADO\n\t\t\t\t\t\t@(negedge clk);\n\t\t\t\t\t`endif";
MyFile<<"\n\t\t\tend";

MyFile<<"\n\n\n";
MyFile<<"\t\t#10 Node"<<k<<"_valid_in = 0;\n\t\t#15 Node"<<0<<"_valid_in = 1;";*/

    /*MyFile<<"\n\t\tfor(i"<<path_nodes[i]<<" = 1; i"<<path_nodes[i]<<" <= 6; i"<<path_nodes[i]<<"= i"<<path_nodes[i]<<" + 1)begin";
MyFile<<"\n\t\t\t\tif(i"<<k<<" == 1)begin"<<"//Routing destination fed into head flit";
MyFile<<"\n\t\t\t\t\tNode"<<k<<"_data_in=3'd"<<4<<"\n\t\t\t\tend\n\t\t\t\telse";
MyFile<<"\n\t\t\t\t\tNode"<<k<<"_data_in = i"<<k<<" + 64;";
MyFile<<"\n\t\t\t\tif(i"<<k<<" == 1) begin"<<"\n\t\t\t\t\tNode"<<k<<"_data_in["<<param_data_width<<":"<< param_data_width-1<<"] = 2'd1;\n\t\t\t\tend";
MyFile<<"\n\t\t\t\telse if (i"<<k<<" == 6)\n\t\t\t\t\tNode"<<k<<"_data_in["<<param_data_width<<":"<<param_data_width-1<<"] =2'd3;\n\t\t\t\telse";
MyFile<<"\n\t\t\t\t\tNode"<<k<<"_data_in["<<param_data_width<<":"<<param_data_width-1<<"] = 2'd2";//31 : 30] = 2'd2;"
MyFile<<"\n\t\t\t\tif(i"<<k<<" == 1)\n\t\t\t\t\t@(negedge Node"<<k<<"_ready_in);\n\t\t\t\telse wait(Node0_ready_in);";
MyFile<<"\n\t\t\t\t@(posedge clk);\n\t\t\t\t\t`ifdef VIVADO\n\t\t\t\t\t\t@(negedge clk);\n\t\t\t\t\t`endif";
MyFile<<"\n\t\t\tend";
			
*/
  }
  
  MyFile << "\n\n\n\n";
  for (int i = 0; i < path_nodes_num; i++)
  {
    MyFile << "\t\t//Node" << path_nodes_num << "Output\n";
    MyFile << "\talways @(*)begin\n";
    MyFile << "\t\t\t Node" << i << "_ready_out = Node" << i << "_valid_out;";
    MyFile << "\n\tend\n";
    MyFile << "\talways @(posedge clk) begin\n";
    MyFile << "\t\tif(Node"<<i<<"_valid_out==1)begin\n";
    MyFile << "\t\t\t$fwriteh(fd"<<i<<",Node"<<0<<"_data_out);\n";
    MyFile << "\t\t\t$fwriteh(fd,\"\\n\");\n";
    MyFile << "\t\tend\n";
    MyFile << "\tend\n\n";


  }

  MyFile << "\tinitial begin\n";
  MyFile << "\t\t$dumpfile(\"Noc.vcd\");\n";
  MyFile << "\t\t$dumpvars(0,NoC_TB); // Dump all the signals\n";
  MyFile << "\t\t#1000 $finish;\n";
  MyFile << "\tend\n";
  MyFile << "endmodule";
  // Close the file
  MyFile.close();
}