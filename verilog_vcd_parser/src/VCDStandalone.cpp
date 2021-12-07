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
    int inp_state = 0;
    double inp_timestamp = 0;
    if (argc == 2)
    {
        //output default print style.
    }
    else if (argc > 2)
    {
        if (strcmp(argv[2], "-power") == 0)
        {
            //output for dump file
            inp_state = 1;
        }
        else if (strcmp(argv[2], "-time") == 0)
        {
            inp_state = 2;
            inp_timestamp = atof(argv[3]);
        }
        else if (strcmp(argv[2], "-help") == 0)
        {
            inp_state = 3;
        }
    }

    std::string infile(argv[1]);

    //

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
    if (inp_state == 0)
    { std::cout << "Parsing " << infile << std::endl;
        if (trace == nullptr)
        {
            // Something went wrong.
        }
        else
        {

            for (VCDScope *scope : *trace->get_scopes())
            {

                std::cout << "Scope: " << scope->name << std::endl;

                for (VCDSignal *signal : scope->signals)
                {

                    std::cout << "\t" << signal->hash << "\t"
                              << signal->reference;

                    if (signal->size > 1)
                    {
                        std::cout << " [" << signal->size << ":0]";
                    }

                    std::cout << std::endl;
                }
            }
        }
    }
    else if (inp_state == 1)
    {
        int port_count = 0;
        for (VCDScope *scope : *trace->get_scopes())
        {
            //std::cout << "Scope: " << scope->name << std::endl;
            //char[256] s1="";
            //strcpy(s1,scope->name);
            std::string s1 = scope->name;
            std::string s2 = "port";
            //std::cout<<s1;
            if (s1.compare(s2) == 0)
            {
                port_count++;
                long final_din = 0;
                long final_dout = 0;
                long final_rin = 0;
                long final_rout = 0;
                long final_vin = 0;
                long final_vout = 0;
                long fin_pow = 0;
                //std::cout << scope->name << "______________________________________________";
                //std::cout << "\n";
                for (VCDSignal *mysignal : scope->signals)
                {
                    //std::cout<<"\n";
                    //std::cout << mysignal -> reference << " = ";
                    std::string s11 = mysignal->reference;
                    std::string s12 = "data_in";
                    std::string s13 = "ready_in";
                    std::string s14 = "valid_in";
                    std::string s15 = "data_out";
                    std::string s16 = "ready_out";
                    std::string s17 = "valid_out";
                    std::string str3_b = "00000000000000000000000000000000";
                    std::string str3_bo = "00000000000000000000000000000000";
                    char rin = '0';
                    char rout = '0';
                    char vin = '0';
                    char vout = '0';
                    long power_din = 0;
                    long power_dout = 0;
                    long power_rin = 0;
                    long power_rout = 0;
                    long power_vin = 0;
                    long power_vout = 0;

                    if (!s11.compare(s12))
                    {

                        for (VCDTime time : *trace->get_timestamps())
                        {

                            VCDValue *val = trace->get_signal_value_at(mysignal->hash, time);

                            //std::cout << "t = " << time << ", "   << mysignal -> reference<< " = ";
                            std::string str3;
                            VCDBitVector *vecval = val->get_value_vector();
                            for (auto it = vecval->begin(); it != vecval->end(); ++it)
                            {
                                str3 = str3 + VCDValue::VCDBit2Char(*it);
                                //std::cout << VCDValue::VCDBit2Char(*it);
                            }
                            //std::cout <<str3;
                            long int longint = 0;
                            int len = str3.size();
                            for (int i = 0; i < len; i++)
                            {
                                longint += (str3[len - i - 1] - 48) * pow(2, i);
                            }
                            if (str3.length() == 1)
                            {
                                str3 = "00000000000000000000000000000000";
                                //std::cout<<str3;
                            }

                            for (int i = 0; i < str3.length(); i++)
                            {
                                if (str3[i] != str3_b[i])
                                {
                                    power_din++;
                                }
                            }

                            str3_b = str3;
                        }

                        // std::cout << power_din * 10 << " is the power of the Data input signal at this port"
                        //<< "\n\n";
                        final_din = power_din * 10;
                    }

                    if (!s11.compare(s15))
                    {

                        for (VCDTime time : *trace->get_timestamps())
                        {

                            VCDValue *val = trace->get_signal_value_at(mysignal->hash, time);

                            //std::cout << "t = " << time << ", "   << mysignal -> reference<< " = ";
                            std::string str3;
                            VCDBitVector *vecval = val->get_value_vector();
                            for (auto it = vecval->begin(); it != vecval->end(); ++it)
                            {
                                str3 = str3 + VCDValue::VCDBit2Char(*it);
                                //std::cout << VCDValue::VCDBit2Char(*it);
                            }
                            //std::cout <<str3;
                            long int longint = 0;
                            int len = str3.size();
                            for (int i = 0; i < len; i++)
                            {
                                longint += (str3[len - i - 1] - 48) * pow(2, i);
                            }
                            if (str3.length() == 1)
                            {
                                str3 = "00000000000000000000000000000000";
                                //std::cout<<str3;
                            }

                            for (int i = 0; i < str3.length(); i++)
                            {
                                if (str3[i] != str3_b[i])
                                {
                                    power_dout++;
                                }
                            }

                            str3_bo = str3;
                        }

                        //std::cout << power_din * 10 << " is the power of the Data input signal at this port"<< "\n\n";
                        //std::cout << power_dout * 10 << " is the power of the Data output signal at this port"<< "\n\n";
                        final_dout = power_dout * 10;
                    }
                    if (!s11.compare(s13))
                    {

                        for (VCDTime time : *trace->get_timestamps())
                        {

                            VCDValue *val = trace->get_signal_value_at(mysignal->hash, time);
                            char c = VCDValue::VCDBit2Char(val->get_value_bit());
                            if (c != rin)
                            {
                                power_rin++;
                            }
                            rin = c;
                        }
                        //std::cout << power_rin * 7 << " is the power of the ready in signal at this port"<< "\n\n";
                        final_rin = power_rin * 7;
                    }

                    if (!s11.compare(s16))
                    {

                        for (VCDTime time : *trace->get_timestamps())
                        {

                            VCDValue *val = trace->get_signal_value_at(mysignal->hash, time);
                            char c = VCDValue::VCDBit2Char(val->get_value_bit());
                            if (c != rout)
                            {
                                power_rout++;
                            }
                            rout = c;
                        }
                        //std::cout << power_rout * 7 << " is the power of the ready out signal at this port"<< "\n\n";
                        final_rout = power_rout * 7;
                    }

                    if (!s11.compare(s14))
                    {

                        for (VCDTime time : *trace->get_timestamps())
                        {

                            VCDValue *val = trace->get_signal_value_at(mysignal->hash, time);
                            char c = VCDValue::VCDBit2Char(val->get_value_bit());
                            if (c != vin)
                            {
                                power_vin++;
                            }
                            vin = c;
                        }
                        //std::cout << power_vin * 7 << " is the power of the valid in signal at this port"<< "\n\n";
                        final_vin = power_vin * 7;
                    }
                    if (!s11.compare(s17))
                    {

                        for (VCDTime time : *trace->get_timestamps())
                        {

                            VCDValue *val = trace->get_signal_value_at(mysignal->hash, time);
                            char c = VCDValue::VCDBit2Char(val->get_value_bit());
                            if (c != vout)
                            {
                                power_vout++;
                            }
                            vout = c;
                        }
                        // std::cout << power_vout * 7 << " is the power of the valid out signal at this port"
                        //<< "\n\n";
                        final_vout = power_vout * 7;
                    }

                    /*if(!s11.compare(s12)||!s11.compare(s13)||!s11.compare(s14)||!s11.compare(s15)||!s11.compare(s16)||!s11.compare(s17)){
            
                for (VCDTime time : *trace -> get_timestamps()) {

                        VCDValue * val = trace -> get_signal_value_at( mysignal -> hash, time);

                        std::cout << "t = " << time << ", "   << mysignal -> reference<< " = ";
                        
                        // Assumes val is not nullptr!
                        switch(val -> get_type()) {
                            case (VCD_SCALAR):
                            {
                                std::cout << VCDValue::VCDBit2Char(val -> get_value_bit());
                                break;
                            }
                            case (VCD_VECTOR):
                            {   
                                std::string str3;
                                VCDBitVector * vecval = val -> get_value_vector();
                                for(auto it = vecval -> begin();it != vecval -> end();++it) {
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

        }*/
                }

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
                fin_pow = final_din + final_dout + final_vin + final_vout + final_rin + final_rout;
                std::cout << "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n";
                std::cout << "P O W E R  C O N S U M E D  I N  P O R T  I N S T A N C E -> " << port_count << "\n";
                std::cout << "------------------------------------------------------------------------------------------------------------------------------\n";
                std::cout << "DATA INPUT:                                |  " << final_din << "                                                             \n";
                std::cout << "------------------------------------------------------------------------------------------------------------------------------\n";
                std::cout << "DATA OUTPUT:                               |  " << final_dout << "                                                            \n";
                std::cout << "------------------------------------------------------------------------------------------------------------------------------\n";
                std::cout << "VALID IN:                                  |  " << final_vin << "                                                             \n";
                std::cout << "------------------------------------------------------------------------------------------------------------------------------\n";
                std::cout << "VALID OUT:                                 |  " << final_vout << "                                                            \n";
                std::cout << "------------------------------------------------------------------------------------------------------------------------------\n";
                std::cout << "READY IN:                                  |  " << final_rin << "                                                             \n";
                std::cout << "------------------------------------------------------------------------------------------------------------------------------\n";
                std::cout << "READY OUT:                                 |  " << final_rout << "                                                             \n";
                std::cout << "------------------------------------------------------------------------------------------------------------------------------\n\n\n\n";
                std::cout << "------------------------------------------------------------------------------------------------------------------------------\n";
                std::cout << "NET ENERGY SPENT:                          |  " << fin_pow << "                                                                         |\n\n";
                std::cout << "++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++\n\n\n\n\n";
            }
        }
    }

    //add your code...

    else if (inp_state == 2)
    {   std::cout << "Parsing " << infile << std::endl;

        for (VCDScope *scope : *trace->get_scopes())
        {
            std::cout << "Scope: " << scope->name << std::endl;
            for (VCDSignal *mysignal : scope->signals)
            {
                //VCDSignal * mysignal = trace -> get_scope("nodeVerifier0") -> signals[1];

                // Print the value of this signal at every time step.
                std::cout << "size " << mysignal->size << "\n";

                VCDTime time = inp_timestamp;
                VCDValue *val = trace->get_signal_value_at(mysignal->hash, time);

                std::cout << mysignal->reference
                          << " = ";

                // Assumes val is not nullptr!

                switch (val->get_type())
                {
                case (VCD_SCALAR):
                {
                    std::cout << VCDValue::VCDBit2Char(val->get_value_bit());
                    break;
                }
                case (VCD_VECTOR):

                {
                    std::string str3;
                    VCDBitVector *vecval = val->get_value_vector();
                    for (auto it = vecval->begin();
                         it != vecval->end();
                         ++it)
                    {
                        str3 = str3 + VCDValue::VCDBit2Char(*it);
                        //std::cout << VCDValue::VCDBit2Char(*it);
                    }
                    //std::cout <<str3;

                    long int longint = 0;
                    int len = str3.size();
                    for (int i = 0; i < len; i++)
                    {
                        longint += (str3[len - i - 1] - 48) * pow(2, i);
                    }
                    if (str3.length() == 1)
                    {
                        str3 = "00000000000000000000000000000000";
                        std::cout << str3;
                    }
                    else
                    {
                        std::cout << str3;
                    }
                    //std::cout<<longint;}
                    break;
                }
                case (VCD_REAL):
                {
                    std::cout << val->get_value_real();
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
    else if (inp_state == 3)
    {

        std::cout << "VCD PARSER.\n"
                  << "To extract signal values at a specified instant of time, use the -time flag fllowed by the time at which the signal values need to be obtained.\n\n";
        std::cout << "To calculate power at port instances, use the -power flag\n\n";
    }
}
