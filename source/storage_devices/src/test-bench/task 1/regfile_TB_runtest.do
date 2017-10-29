SetActiveLib -work
comp -include "$dsn\src\task 1\RegFile.vhd" 
comp -include "$dsn\src\test-bench\task 1\regfile_TB.vhd" 
asim +access +r regfile_tb 
wave 
wave -noreg init
wave -noreg write_port
wave -noreg read_port
wave -noreg write_address
wave -noreg read_address
wave -noreg CLK	

run
endsim
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\test-bench\regfile_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_regfile 
