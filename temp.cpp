Myfile <<"Noc noc (.clk(clk), .rst(rst),\n";

for(int i=0;i<num_of_nodes;i++)
{
	Myfile << "\t.Node"<<i<<"_data_in(Node"<<i<<"_data_in),Node"<<i<<"_valid_in(Node"<<i<<"_valid_in), .Node"<<i<<"_ready_in(Node"<<i<<"_ready_in),\n";
	Myfile << "\t.Node"<<i<<"_data_out(Node"<<i<<"_data_out),Node"<<i<<"_valid_out(Node"<<i<<"_valid_out), .Node"<<i<<"_ready_out(Node"<<i<<"_ready_out),\n";


}

MyFile<<");\n";
for(int i=0;i<path_nodes_num;i++)
{
	MyFile<<"\t//Node"<<path_nodes_num<<"Output\n";
	MyFile<<"always @(*)begin\n";
	MyFile<<"\t\t Node"<<i<<"_ready_out = Node"<<i<<"_valid_out;";
	MyFile<<"\tend\n";
}

MyFile<<"\tinitial begin\n";
MyFile<<"\t\t$dumpfile(\"Noc.vcd\");\n";
MyFile<<"\t\t$dumpvars(0,NoC_TB); // Dump all the signals\n"
MyFile<<"\t\t#1000 $finish;\n";
MyFile<<"\tend\n";
MyFile<<"endmodule";
