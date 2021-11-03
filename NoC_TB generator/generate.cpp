#include <iostream>
#include <fstream>
using namespace std;

int main() {
  // Create and open a text file
  ofstream MyFile("filename.v");

  // Write to the file
  MyFile << "module No_tb;"<<"\n"<<"\treg clk;\n\treg rst;\n";

  /*reg [31 : 0]Node0_data_in = 0;
	reg Node0_valid_in = 0;
	wire Node0_ready_in;
    */
   int param_data_width=31;
   int num_of_nodes=5;
   for(int i=0;i<=num_of_nodes;i++){
       MyFile<<"\n\n\n\treg ["<<param_data_width<<" : 0] Node"<<i<<"_data_in = 0;";
       MyFile<<"\n\treg Node"<<i<<"_valid_in = 0;";
       MyFile<<"\n\twire Node"<<i<<"_ready_in;";

       MyFile<<"\n\n\treg ["<<param_data_width<<" : 0] Node"<<i<<"_data_out = 0;";
       MyFile<<"\n\treg Node"<<i<<"_valid_out;";
       MyFile<<"\n\twire Node"<<i<<"_ready_out=0;";



   }

   MyFile <<"\n\n\tNoc noc (.clk(clk), .rst(rst),\n";

for(int i=0;i<=num_of_nodes;i++)
{
        MyFile << "\t.Node"<<i<<"_data_in(Node"<<i<<"_data_in),Node"<<i<<"_valid_in(Node"<<i<<"_valid_in), .Node"<<i<<"_ready_in(Node"<<i<<"_ready_in),\n";
        MyFile << "\t.Node"<<i<<"_data_out(Node"<<i<<"_data_out),Node"<<i<<"_valid_out(Node"<<i<<"_valid_out), .Node"<<i<<"_ready_out(Node"<<i<<"_ready_out),\n";
        MyFile<<"\n";
}
MyFile<<"\t);\n";
int clk_period=5;
MyFile<<"\talways #"<<clk_period<<" clk = ~clk;\n\n";

int path_nodes[]={0,2,1,4,5};
int path_nodes_num=sizeof(path_nodes)/sizeof(path_nodes[0]);
cout<<path_nodes_num;
MyFile<<"\n\tinitial\n\tbegin";
MyFile<<"\n\t\tclk=1;\n\t\trst=1;\n\n";
for(int i=0;i<path_nodes_num;i++){
    MyFile<<"\n";
    MyFile<<"\t\tNode"<<path_nodes[i]<<"_valid_in = 0;";



}
int reset_time=20;
MyFile<<"\n\n\t\t#"<<reset_time<<" rst=0";
MyFile<<"\n\tend";
int wait_time=45;
for(int i=0;i<path_nodes_num;i++){
    int k=path_nodes[i];
MyFile<<"\n\n\tinteger i"<<path_nodes[i]<<";";
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
MyFile<<"\t\t#10 Node"<<k<<"_valid_in = 0;\n\t\t#15 Node"<<0<<"_valid_in = 1;";
MyFile<<"\n\t\tfor(i"<<path_nodes[i]<<" = 1; i"<<path_nodes[i]<<" <= 6; i"<<path_nodes[i]<<"= i"<<path_nodes[i]<<" + 1)begin";
MyFile<<"\n\t\t\t\tif(i"<<k<<" == 1)begin"<<"//Routing destination fed into head flit";
MyFile<<"\n\t\t\t\t\tNode"<<k<<"_data_in=3'd"<<4<<"\n\t\t\t\tend\n\t\t\t\telse";
MyFile<<"\n\t\t\t\t\tNode"<<k<<"_data_in = i"<<k<<" + 64;";
MyFile<<"\n\t\t\t\tif(i"<<k<<" == 1) begin"<<"\n\t\t\t\t\tNode"<<k<<"_data_in["<<param_data_width<<":"<< param_data_width-1<<"] = 2'd1;\n\t\t\t\tend";
MyFile<<"\n\t\t\t\telse if (i"<<k<<" == 6)\n\t\t\t\t\tNode"<<k<<"_data_in["<<param_data_width<<":"<<param_data_width-1<<"] =2'd3;\n\t\t\t\telse";
MyFile<<"\n\t\t\t\t\tNode"<<k<<"_data_in["<<param_data_width<<":"<<param_data_width-1<<"] = 2'd2";//31 : 30] = 2'd2;"
MyFile<<"\n\t\t\t\tif(i"<<k<<" == 1)\n\t\t\t\t\t@(negedge Node"<<k<<"_ready_in);\n\t\t\t\telse wait(Node0_ready_in);";
MyFile<<"\n\t\t\t\t@(posedge clk);\n\t\t\t\t\t`ifdef VIVADO\n\t\t\t\t\t\t@(negedge clk);\n\t\t\t\t\t`endif";
MyFile<<"\n\t\t\tend";
			



}
MyFile<<"\n\n\n\n";
for(int i=0;i<=path_nodes_num;i++)
{
        MyFile<<"\t\t//Node"<<path_nodes_num<<"Output\n";
        MyFile<<"\talways @(*)begin\n";
        MyFile<<"\t\t\t Node"<<i<<"_ready_out = Node"<<i<<"_valid_out;";
        MyFile<<"\n\tend\n";
}       

MyFile<<"\tinitial begin\n";
MyFile<<"\t\t$dumpfile(\"Noc.vcd\");\n";
MyFile<<"\t\t$dumpvars(0,NoC_TB); // Dump all the signals\n";
MyFile<<"\t\t#1000 $finish;\n";
MyFile<<"\tend\n";
MyFile<<"endmodule";
  // Close the file
  MyFile.close();
}
