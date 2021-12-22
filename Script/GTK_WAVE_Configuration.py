N = 9

with open("NoC.gtkw", "w") as file:
	file.write("[*]\n[*] GTKWave Analyzer v3.3.103 (w)1999-2019 BSI\n[*] Tue Nov 23 17:28:43 2021\n[*]\n")
	file.write(
	"[dumpfile] \"/media/madhur/CommonSpace/Work/SystemSimulators/NoC Simulator/Mesh1515_deadlock_test_160_VC/NoC.vcd\"\n\
	[savefile] \"/media/madhur/CommonSpace/Work/SystemSimulators/NoC Simulator/Mesh1515_deadlock_test_160_VC/NoC_TB.gtkw\"\n\
	[size] 1848 1016\n\
	[pos] -1 -1\n\
	[sst_width] 305\n\
	[signals_width] 302\n\
	[sst_expanded] 1\n\
	[sst_vpaned_height] 400\n"
	)
	file.write("@28\nNoC_TB.clk\nNoC_TB.rst\n")
	for i in range(N):
		file.write(
		"@22\n\
		NoC_TB.Node{i}_data_in[31:0]\n\
		@28\n\
		NoC_TB.Node{i}_valid_in\n\
		NoC_TB.Node{i}_ready_in\n\
		@22\n\
		NoC_TB.Node{i}_data_out[31:0]\n\
		@28\n\
		NoC_TB.Node{i}_valid_out\n\
		NoC_TB.Node{i}_ready_out\n\
		@200\n\
		-\n".format(i=i)
		)
	file.write("[pattern_trace] 1\n[pattern_trace] 0")
