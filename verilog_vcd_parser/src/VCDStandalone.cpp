/*!
@file
@brief Definition of the VCDFileParser class
*/

#include "VCDFileParser.hpp"
#include "/home/ubuntu/Desktop/NoC_Netlist_Generator/verilog-vcd-parser/src/VCDValue.hpp"

/*!
@brief Standalone test function to allow testing of the VCD file parser.
*/
int main(int argc, char **argv)
{

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

    if(trace == nullptr) {
    // Something went wrong.
} else {

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

VCDSignal * mysignal = trace -> get_scope("switch") -> signals[13];

// Print the value of this signal at every time step.

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
        {
            VCDBitVector * vecval = val -> get_value_vector();
            for(auto it = vecval -> begin();
                     it != vecval -> end();
                     ++it) {
                std::cout << VCDValue::VCDBit2Char(*it);
            }
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
