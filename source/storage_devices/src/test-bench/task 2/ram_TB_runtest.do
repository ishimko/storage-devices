SetActiveLib -work
comp -include "$dsn\src\task 2\RAM.vhd" 
comp -include "$dsn\src\test-bench\task 2\ram_TB.vhd" 
asim +access +r TESTBENCH_FOR_ram 
wave 
wave -noreg CLK
wave -noreg write_enable
wave -noreg address_bus
wave -noreg data_bus 
wave -noreg expected

run
endsim
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\test-bench\ram_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_ram 
