set ID 3

create_bd_design "MB_$ID"
update_compile_order -fileset sources_1

startgroup
create_bd_cell -type ip -vlnv xilinx.com:ip:microblaze:11.0 microblaze_$ID
endgroup

set_property -dict [list CONFIG.C_AREA_OPTIMIZED {1} CONFIG.G_TEMPLATE_LIST {1} CONFIG.C_USE_REORDER_INSTR {0} CONFIG.C_DEBUG_ENABLED {0} CONFIG.C_NUMBER_OF_PC_BRK {0} CONFIG.C_FSL_LINKS {1} CONFIG.C_ADDR_TAG_BITS {0} CONFIG.C_CACHE_BYTE_SIZE {4096} CONFIG.C_DCACHE_ADDR_TAG {0} CONFIG.C_DCACHE_BYTE_SIZE {4096} CONFIG.C_MMU_DTLB_SIZE {2} CONFIG.C_MMU_ITLB_SIZE {1} CONFIG.C_MMU_ZONES {2}] [get_bd_cells microblaze_$ID]

apply_bd_automation -rule xilinx.com:bd_rule:microblaze -config { axi_intc {0} axi_periph {Enabled} cache {None} clk {New External Port (100 MHz)} debug_module {Debug Only} ecc {None} local_mem {8KB} preset {None}}  [get_bd_cells microblaze_$ID]

startgroup
make_bd_intf_pins_external  [get_bd_intf_pins microblaze_$ID/S0_AXIS]
endgroup
startgroup
make_bd_intf_pins_external  [get_bd_intf_pins microblaze_$ID/M0_AXIS]
endgroup

apply_bd_automation -rule xilinx.com:bd_rule:board -config { Board_Interface {Custom} Manual_Source {New External Port (ACTIVE_LOW)}}  [get_bd_pins rst_Clk_100M/ext_reset_in]

make_wrapper -files [get_files /media/madhur/CommonSpace/Work/Vivado/NoC_19/NoC_19.srcs/sources_1/bd/MB_$ID/MB_$ID.bd] -top

add_files -norecurse /media/madhur/CommonSpace/Work/Vivado/NoC_19/NoC_19.srcs/sources_1/bd/MB_$ID/hdl/MB_$ID\_wrapper.v

update_compile_order -fileset sources_1

