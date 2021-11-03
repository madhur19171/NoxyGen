#include <iostream>
#include <fstream>
#include <dirent.h>
#include <string.h>
using namespace std;

int main()
{
  // Create and open a text file
  ofstream MyFile("filename.v");
  DIR *dp;
  int num_of_files = 0;
  struct dirent *ep;
  dp = opendir("./sim/sim/INPUT_VECTORS");

  if (dp != NULL)
  {
    while (ep = readdir(dp))
      num_of_files++;

    (void)closedir(dp);
  }
  else
    perror("Couldn't open the directory");

  printf("There's %d files in the current directory.\n", num_of_files - 2);

  string names[] = {"input_A.dat", "input_p.dat", "input_q.dat", "input_r.dat", "input_s.dat"};
  // Write to the file
  MyFile << "module No_tb;"
         << "\n"
         << "\treg clk;\n\treg rst;\n";

  /*reg [31 : 0]Node0_data_in = 0;
	reg Node0_valid_in = 0;
	wire Node0_ready_in;
    */
  int param_data_width = 31;
  int num_of_nodes = num_of_files;
  for (int i = 0; i <= num_of_nodes; i++)
  {
    
    MyFile << "\n\n\n\treg [" << param_data_width << " : 0] Node" << i << "_data_in = 0;";
    MyFile << "\n\treg Node" << i << "_valid_in = 0;";
    MyFile << "\n\twire Node" << i << "_ready_in;";

    MyFile << "\n\n\treg [" << param_data_width << " : 0] Node" << i << "_data_out = 0;";
    MyFile << "\n\treg Node" << i << "_valid_out;";
    MyFile << "\n\twire Node" << i << "_ready_out=0;";
    string ss = "";
    //names[i];
    //sprintf(ss,"/sim/sim/INPUT_VECTORS/%s",names[i]);
    
    //$readmemh("ex1.mem", ex1_memory);
  }

  MyFile << "\n\n\tNoc noc (.clk(clk), .rst(rst),\n";

  for (int i = 0; i <= num_of_nodes; i++)
  {
    MyFile << "\t.Node" << i << "_data_in(Node" << i << "_data_in),Node" << i << "_valid_in(Node" << i << "_valid_in), .Node" << i << "_ready_in(Node" << i << "_ready_in),\n";
    MyFile << "\t.Node" << i << "_data_out(Node" << i << "_data_out),Node" << i << "_valid_out(Node" << i << "_valid_out), .Node" << i << "_ready_out(Node" << i << "_ready_out),\n";
    MyFile << "\n";
  }
  MyFile << "\t);\n";
  int clk_period = 5;
  MyFile << "\talways #" << clk_period << " clk = ~clk;\n\n";

  int path_nodes[] = {0, 2, 1, 4, 5};
  int line_count[] = {0,0,0,0,0}; //If each router sends different data, thn this is the same as teh number of directories in the folder of .dat files
  int path_nodes_num = sizeof(path_nodes) / sizeof(path_nodes[0]);
  cout << path_nodes_num;
  MyFile << "\n\tinitial\n\tbegin";
  MyFile << "\n\t\tclk=1;\n\t\trst=1;\n\n";
  

  for (int i = 0; i < path_nodes_num; i++)
  {
    MyFile << "\n";
    MyFile << "\t\tNode" << path_nodes[i] << "_valid_in = 0;";
    FILE *fp;
    fp = fopen("input_A.dat", "r");
    int count = 1;
    char c;
    // Check if file exists
    if (fp == NULL)
    {
      printf("Could not open file %s", "input_A.dat");
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
    cout << count;
    line_count[i]=(count)/6;
    fclose(fp);
    MyFile << "\n\t\treg [" << 31 << ":0] ex" << path_nodes[i] << "_memory [0:" << count - 2<< "];";
  }
  int reset_time = 20;
  MyFile << "\n\n\t\t#" << reset_time << " rst=0";
  MyFile << "\n\tend";
  int wait_time = 45;
  for (int i = 0; i < path_nodes_num; i++)
  {
    int k = path_nodes[i];
    MyFile << "\n\n\tinteger i" << path_nodes[i] << ";";
    //$readmemh("ex1.mem", ex1_memory);
    int num_of_messages = 2;

    //This part is constant, we need to change the below portion into a loop//
    for (int j = 0; j < num_of_messages; j++)
    {

      MyFile << "\n\t "
             << "// initial begin starts"
             << "\n\tinitial begin";
      MyFile << "\n\t\t#" << wait_time;
      MyFile << "\n\t\tNode" << path_nodes[i] << "_valid_in = 1;";
      MyFile<< " \n\t\t$readmemh(\"input_q.dat\",ex"<<path_nodes[i]<<"_memory);";
      //int line_count=(count-1)/6;
      MyFile << "\n\tfor(j" << path_nodes[i] << " = 0; j" << path_nodes[i] << " <"<<line_count[i]<<"; j" << path_nodes[i] << "= j" << path_nodes[i] << " + 1)begin";
      MyFile << "\n\t\tfor(i" << path_nodes[i] << " = 0; i" << path_nodes[i] << " < 6; i" << path_nodes[i] << "= i" << path_nodes[i] << " + 1)begin";
      MyFile << "\n\t\t\t";
      MyFile << "\n\t\t\t\tNode" << k << "_data_in=ex"<<path_nodes[i]<<"_memory[j"<<path_nodes[i]<<"*6+i"<<path_nodes[i]<<"];\n\n\n\n\n";
      /*MyFile << "\n\t\t\t\tif(i" << k << " == 1)begin"
             << "//Routing destination fed into head flit";
      MyFile << "\n\t\t\t\t\tNode" << k << "_data_in=3'd" << i + 1 << ";\n\t\t\t\tend\n\t\t\t\telse";
      MyFile << "\n\t\t\t\t\tNode" << k << "_data_in = i" << k << " + " << 16 * i << ";";
      MyFile << "\n\t\t\t\tif(i" << k << " == 1) begin"
             << "\n\t\t\t\t\tNode" << k << "_data_in[" << param_data_width << ":" << param_data_width - 1 << "] = 2'd1;\n\t\t\t\tend";
      MyFile << "\n\t\t\t\telse if (i" << k << " == 6)\n\t\t\t\t\tNode" << k << "_data_in[" << param_data_width << ":" << param_data_width - 1 << "] =2'd3;\n\t\t\t\telse";
      MyFile << "\n\t\t\t\t\tNode" << k << "_data_in[" << param_data_width << ":" << param_data_width - 1 << "] = 2'd2"; //31 : 30] = 2'd2;"*/
      /*MyFile << "\n\t\t\t\tif(i" << k << " == 1)\n\t\t\t\t\t@(negedge Node" << k << "_ready_in);\n\t\t\t\telse wait(Node0_ready_in);";
      MyFile << "\n\t\t\t\t@(posedge clk);\n\t\t\t\t\t`ifdef VIVADO\n\t\t\t\t\t\t@(negedge clk);\n\t\t\t\t\t`endif";
      */
      
      MyFile << "\n\t\tend";
      MyFile << "\n\tend";


      MyFile << "\n\n\n";
      MyFile << "\t\t#10 Node" << k << "_valid_in = 0;\n\t\t#15 Node" << 0 << "_valid_in = 1;";
    }

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
  for (int i = 0; i <= path_nodes_num; i++)
  {
    MyFile << "\t\t//Node" << path_nodes_num << "Output\n";
    MyFile << "\talways @(*)begin\n";
    MyFile << "\t\t\t Node" << i << "_ready_out = Node" << i << "_valid_out;";
    MyFile << "\n\tend\n";
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
