DOT2HDL_DIR	:=	$(NOXYGEN_HOME)/dot2hdl
VERIFIER_DIR	:=	$(NOXYGEN_HOME)/NoCVerifier
SV_DIR		:=	$(NOXYGEN_HOME)/SystemVerilog
SCRIPT_DIR	:=	$(NOXYGEN_HOME)/Script
EXAMPLES_DIR	:=	$(NOXYGEN_HOME)/Examples

PYTHON		:=	python3

WAVEFORM_VIEWER	:=	gtkwave


# Building necessary Tools
dot2hdl:
	cd $(DOT2HDL_DIR)
	$(MAKE) -f $(DOT2HDL_DIR)/Makefile all
	cd $(NOXYGEN_HOME)

NoCVerifier:
	cd $(VERIFIER_DIR)
	$(MAKE) -f $(VERIFIER_DIR)/Makefile all
	cd $(NOXYGEN_HOME)

build: dot2hdl NoCVerifier

clean:
	cd $(DOT2HDL_DIR)
	$(MAKE) -f $(DOT2HDL_DIR)/Makefile clean
	
	cd $(VERIFIER_DIR)
	$(MAKE) -f $(VERIFIER_DIR)/Makefile clean


# Setting Up Directory for generating Netlist
# Arg1: Name of the Design
dir_setup:
	mkdir -p $(EXAMPLES_DIR)/$(DESIGN_NAME)
	mkdir -p $(EXAMPLES_DIR)/$(DESIGN_NAME)/dot
	mkdir -p $(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog
	mkdir -p $(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier
	mkdir -p $(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier/INPUT_VECTORS
	mkdir -p $(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier/OUTPUT_VECTORS
	cd $(NOXYGEN_HOME)

# Generating DOT File
# Currently, only Mesh can be generated using Python Script
# Arg1: Topology Name
# Arg2: Additonal topology attributes. 
#	For Mesh, attribute can be Dimension passed as DIM
# TODO: Add support for others as well!
dot:
ifeq "$(TOPOLOGY)" "MESH"
		$(PYTHON) $(SCRIPT_DIR)/Mesh.py DIM=$(DIM) \
					VC=$(VC) \
					TYPE_WIDTH=$(TYPE_WIDTH) \
					DATA_WIDTH=$(DATA_WIDTH) \
					FIFO_DEPTH=$(FIFO_DEPTH) \
					HFBDepth=$(HFBDepth) \
					FlitsPerPacket=$(FlitsPerPacket)
endif
	
	mv *.dot $(EXAMPLES_DIR)/$(DESIGN_NAME)/dot/
	
SV:
	cp $(SV_DIR)/*.sv $(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog/
	cd $(EXAMPLES_DIR)/$(DESIGN_NAME)/dot && \
	$(DOT2HDL_DIR)/bin/dot2hdl $(DESIGN_NAME) && \
	mv *.v $(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog/
	
TB:
	$(VERIFIER_DIR)/bin/NoCVerifier 	TASK=GEN_TB \
						TOPOLOGY=$(TOPOLOGY) \
						TB_NAME=$(TB_NAME) \
						DESIGN_NAME=$(DESIGN_NAME) \
						IV_DIR=$(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier/INPUT_VECTORS/ \
						OV_DIR=$(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier/OUTPUT_VECTORS/ \
						N=$(N) \
						DATA_WIDTH=$(DATA_WIDTH) \
						FlitsPerPacket=$(FlitsPerPacket) \
						VC=$(VC) \
						PacketsPerNode=$(PacketsPerNode) \
						SIMULATOR=$(SIMULATOR)
						
	mv *.sv $(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog/
	
TV:
	rm -rf IV_DIR=$(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier/INPUT_VECTORS/*
	rm -rf IV_DIR=$(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier/OUTPUT_VECTORS/*
	$(VERIFIER_DIR)/bin/NoCVerifier 	TASK=GEN_TV \
						TOPOLOGY=$(TOPOLOGY) \
						TB_NAME=$(TB_NAME) \
						DESIGN_NAME=$(DESIGN_NAME) \
						IV_DIR=$(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier/INPUT_VECTORS/ \
						OV_DIR=$(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier/OUTPUT_VECTORS/ \
						N=$(N) \
						DATA_WIDTH=$(DATA_WIDTH) \
						FlitsPerPacket=$(FlitsPerPacket) \
						VC=$(VC) \
						PacketsPerNode=$(PacketsPerNode) \
						SIMULATOR=$(SIMULATOR) \
						TRAFFIC=$(TRAFFIC) \
						MAX_DELAY=$(MAX_DELAY) \
						FixPacketSize=$(FixPacketSize)
						
verilate:
	cp $(SCRIPT_DIR)/verilator.sh $(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog/
	cp $(SCRIPT_DIR)/NoC_TB.cpp $(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog/
	cd $(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog/ && \
	sh $(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog/verilator.sh NoC_TB.cpp $(TB_NAME) $(DESIGN_NAME) $(THREADS) && \
	cd obj_dir && \
	$(MAKE) -f V$(TB_NAME).mk -j

simulate:
	cd $(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog/ && \
	$(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog/obj_dir/V$(TB_NAME) TRACE=$(TRACE) > $(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog/$(DESIGN_NAME).log
	
waveform:
	$(WAVEFORM_VIEWER) $(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog/NoC_TB.vcd &

check:
	$(VERIFIER_DIR)/bin/NoCVerifier 	TASK=CHK \
						TOPOLOGY=$(TOPOLOGY) \
						TB_NAME=$(TB_NAME) \
						DESIGN_NAME=$(DESIGN_NAME) \
						IV_DIR=$(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier/INPUT_VECTORS/ \
						OV_DIR=$(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier/OUTPUT_VECTORS/ \
						N=$(N) \
						DATA_WIDTH=$(DATA_WIDTH) \
						FlitsPerPacket=$(FlitsPerPacket) \
						VC=$(VC) \
						PacketsPerNode=$(PacketsPerNode) \
						SIMULATOR=$(SIMULATOR) \
						TRAFFIC=$(TRAFFIC) \
						MAX_DELAY=$(MAX_DELAY) \
						FixPacketSize=$(FixPacketSize) \
						DEEP_CHK=$(DEEP_CHK)
						
stats:
	$(VERIFIER_DIR)/bin/NoCVerifier 	TASK=PARSE_STATS \
						TOPOLOGY=$(TOPOLOGY) \
						TB_NAME=$(TB_NAME) \
						DESIGN_NAME=$(DESIGN_NAME) \
						IV_DIR=$(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier/INPUT_VECTORS/ \
						OV_DIR=$(EXAMPLES_DIR)/$(DESIGN_NAME)/Verifier/OUTPUT_VECTORS/ \
						N=$(N) \
						DATA_WIDTH=$(DATA_WIDTH) \
						FlitsPerPacket=$(FlitsPerPacket) \
						VC=$(VC) \
						PacketsPerNode=$(PacketsPerNode) \
						SIMULATOR=$(SIMULATOR) \
						TRAFFIC=$(TRAFFIC) \
						MAX_DELAY=$(MAX_DELAY) \
						FixPacketSize=$(FixPacketSize) \
						DEEP_CHK=$(DEEP_CHK) \
						STATS_FILE=$(EXAMPLES_DIR)/$(DESIGN_NAME)/SystemVerilog/$(DESIGN_NAME).log
	
.PHONY: dot2hdl NoCVerifier build clean dir_setup dot SV TB TV verilate simulate waveform check

