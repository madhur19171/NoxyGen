/*!
@file
@brief Definition of the VCDFileParser class
*/
#include <string.h>
#include <iomanip>
#include <math.h>
#include "VCDFileParser.hpp"
#include "/home/ubuntu/Desktop/NoC_Netlist_Generator/verilog-vcd-parser/src/VCDValue.hpp"
using std::hex;
/*!
@brief Standalone test function to allow testing of the VCD file parser.
*/
int main(int argc, char **argv)
{
    int inp_state=0;
    double inp_timestamp=0;
    if(argc==2)
    {
        //output default print style.
    }
    else if (argc>2)
    {
        if(strcmp(argv[2],"-n")==0)
        {
            //output for dump file
            inp_state=1;
        }
        else if(strcmp(argv[2],"-i")==0)
        {
            inp_state=2;
            inp_timestamp=atof(argv[3]);
        }
    }

    std::string infile(argv[1]);

    std::cout << "Parsing " << infile << std::endl;

    VCDFileParser parser;

    VCDFile *trace = parser.parse_file(infile);
/*
    if (trace)
    {
        std::cout << "Parse successful." << std::endl;
        std::cout << "Version:       " << trace->version << std::endl;
        std::cout << "Date:          " << trace->date << std::endl;
        std::cout << "Signal count:  " << trace->get_signals()->size() << std::endl;
        for(int i=0 ;i < trace->get_timestamps()->size();i++)
        {
        std::cout << "Times Recorded:" << trace->get_timestamps()->at(i) << std::endl;
        }
        std::cout << "hello";
        // Print out every signal in every scope.
        for (VCDScope *scope : *trace->get_scopes())
        {
            std::cout << "Scope: " << scope->name << std::endl;
            for (VCDSignal *signal : scope->signals)
            {
                std::cout << "\t" << signal->hash << "\t"
                          << signal->reference;
                std::cout<<trace->get_signal_value_at(signal->hash,trace->get_timestamps()->at(1),false);
                if (signal->size > 1)
                {
                    std::cout << " [" << signal->size << ":0]";
                }
                std::cout << std::endl;
            }
        }
        delete trace;
        return 0;
    }
    else
    {
        std::cout << "Parse Failed." << std::endl;
        return 1;
    }*/
if(inp_state==0)
{
    if(trace == nullptr) {
    // Something went wrong.
    } 
    else {

    for(VCDScope * scope : *trace -> get_scopes()) {

        std::cout << "Scope: "  << scope ->  name  << std::endl;

        for(VCDSignal * signal : scope -> signals) {

            std::cout << "\t" << signal -> hash << "\t" 
                      << signal -> reference;

            if(signal -> size > 1) {
                std::cout << " [" << signal -> size << ":0]";
            }
            
            std::cout << std::endl;

        }
    }

}
}
else if(inp_state==1)
{
    for (VCDScope *scope : *trace->get_scopes())
{
    //std::cout << "Scope: " << scope->name << std::endl;
    //char[256] s1="";
    //strcpy(s1,scope->name);
    std::string s1=scope->name;
    std::string s2="port";
    //std::cout<<s1;
    if(s1.compare(s2)==0){
        std::cout<<scope->name<<"__________________________________________________________________________________________________________________________________________________________________________________________________";
        for (VCDSignal * mysignal : scope->signals){
            //std::cout<<"\n";
            //std::cout << mysignal -> reference << " = ";
            std::string s11=mysignal->reference;
            std::string s12="data_in";
            std::string s13="ready_in";
            std::string s14="valid_in";
            std::string s15="data_out";
            std::string s16="ready_out";
            std::string s17="valid_out";
            if(!s11.compare(s12)||!s11.compare(s13)||!s11.compare(s14)||!s11.compare(s15)||!s11.compare(s16)||!s11.compare(s17)){
        
        for (VCDTime time : *trace -> get_timestamps()) {

    VCDValue * val = trace -> get_signal_value_at( mysignal -> hash, time);

    std::cout << "t = " << time
              << ", "   << mysignal -> reference
              << " = ";
    
    // Assumes val is not nullptr!
    switch(val -> get_type()) {
        case (VCD_SCALAR):
        {
            std::cout << VCDValue::VCDBit2Char(val -> get_value_bit());
            break;
        }
        case (VCD_VECTOR):
        {   std::string str3;
            VCDBitVector * vecval = val -> get_value_vector();
            for(auto it = vecval -> begin();
                     it != vecval -> end();
                     ++it) {
                str3=str3+VCDValue::VCDBit2Char(*it);        
                //std::cout << VCDValue::VCDBit2Char(*it);
                

            }
            //std::cout <<str3;
             /*
            long int longint=0;
                int len=str3.size();
                for(int i=0;i<len;i++)
                {
                longint+=( str3[len-i-1]-48) * pow(2,i);
                


                }*/
                if(str3.length()==1){
                    str3="00000000000000000000000000000000";
                    std::cout<<str3;
                }
                else{
                std::cout<<str3;}
                //std::cout<<longint;}
            break;
    }
        case (VCD_REAL):
        {
            std::cout << val -> get_value_real();
        }
        default:
        {
            break;
        }
    }

    std::cout << std::endl;
        }

    }}
    
    //for (VCDSignal * mysignal : scope->signals){
//VCDSignal * mysignal = trace -> get_scope("nodeVerifier0") -> signals[1];


// Print the value of this signal at every time step.
//std::cout<<"size "<<mysignal -> size<<"\n";


    //VCDTime time=inp_timestamp;
    //VCDValue * val = trace -> get_signal_value_at( mysignal -> hash, time);
    //std::cout<<"\n";
    //std::cout << mysignal -> reference
              //<< " = ";
    
    // Assumes val is not nullptr!
    
    /*switch(val -> get_type()) {
        case (VCD_SCALAR):
        {
            std::cout << VCDValue::VCDBit2Char(val -> get_value_bit());
            break;
        }
        case (VCD_VECTOR):
        {   std::string str3;
            VCDBitVector * vecval = val -> get_value_vector();
            for(auto it = vecval -> begin();
                     it != vecval -> end();
                     ++it) {
                str3=str3+VCDValue::VCDBit2Char(*it);        
                //std::cout << VCDValue::VCDBit2Char(*it);
                
            }
            //std::cout <<str3;
            
            long int longint=0;
                int len=str3.size();
                for(int i=0;i<len;i++)
                {
                longint+=( str3[len-i-1]-48) * pow(2,i);
                }
                if(str3.length()==1){
                    str3="00000000000000000000000000000000";
                    std::cout<<str3;
                }
                else{
                std::cout<<str3;}
                //std::cout<<longint;}
            break;
    }
        case (VCD_REAL):
        {
            std::cout << val -> get_value_real();
        }
        default:
        {
            break;
        }
    }
    
    std::cout << std::endl;
*/
}
}}






    //add your code...

else if(inp_state==2)
{

for (VCDScope *scope : *trace->get_scopes())
{
    std::cout << "Scope: " << scope->name << std::endl;
    for (VCDSignal * mysignal : scope->signals){
//VCDSignal * mysignal = trace -> get_scope("nodeVerifier0") -> signals[1];


// Print the value of this signal at every time step.
std::cout<<"size "<<mysignal -> size<<"\n";


    VCDTime time=inp_timestamp;
    VCDValue * val = trace -> get_signal_value_at( mysignal -> hash, time);
    
    std::cout << mysignal -> reference
              << " = ";
    
    // Assumes val is not nullptr!
    
    switch(val -> get_type()) {
        case (VCD_SCALAR):
        {
            std::cout << VCDValue::VCDBit2Char(val -> get_value_bit());
            break;
        }
        case (VCD_VECTOR):

        {   std::string str3;
            VCDBitVector * vecval = val -> get_value_vector();
            for(auto it = vecval -> begin();
                     it != vecval -> end();
                     ++it) {
                str3=str3+VCDValue::VCDBit2Char(*it);        
                //std::cout << VCDValue::VCDBit2Char(*it);
                

            }
            //std::cout <<str3;
            
            long int longint=0;
                int len=str3.size();
                for(int i=0;i<len;i++)
                {
                longint+=( str3[len-i-1]-48) * pow(2,i);


                }
                if(str3.length()==1){
                    str3="00000000000000000000000000000000";
                    std::cout<<str3;
                }
                else{
                std::cout<<str3;}
                //std::cout<<longint;}
            break;
    }
        case (VCD_REAL):
        {
            std::cout << val -> get_value_real();
        }
        default:
        {
            break;
        }
    }
    

    std::cout << std::endl;

}
}
}
}