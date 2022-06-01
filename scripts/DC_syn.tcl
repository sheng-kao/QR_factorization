set_host_options -max_cores 8
set top_name QR_top
set syn _syn

#Read All Files
read_verilog ../design_data/$top_name.v
# read other verilog file  ex. read_verilog ../design_data/XXXX.v
read_verilog ../design_data/GG.v
read_verilog ../design_data/GR.v
#=========================
current_design $top_name
link

#Setting Clock Constraints
source -echo -verbose ../design_data/$top_name.sdc

#Synthesis all design
compile_ultra

write -format ddc     -hierarchy -output $top_name$syn.ddc
write_sdf -version 1.0  $top_name$syn.sdf
write_sdc $top_name$syn.sdc
write -format verilog -hierarchy -output $top_name$syn.v
report_area > area.log
report_timing > timing.log
report_qor   >  $top_name$syn.qor
