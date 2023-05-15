# First Argument is the name of C++ Testbench file
# Second Argument is the name of SV Testbench
# Third Argument is the name of SV DUT
# Fourth Argument is the number of threads

verilator -Wno-lint -Wno-style --cc --exe ${1} \
Configuration \
ControlFSM \
FIFO \
FlitIdentifier \
HeadFlitBuffer \
HeadFlitDecoder \
MuxSwitch \
Port \
Router \
RouterPipeline \
SwitchControl \
VCDemux \
VCMux \
VCPlaneController \
NodeVerifier \
${2} \
${3} \
--top-module ${2} --threads ${4} --trace

