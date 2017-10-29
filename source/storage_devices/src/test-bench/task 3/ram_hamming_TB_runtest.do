SetActiveLib -work
comp -include "$dsn\src\task 3\RAM_Hamming.vhd" 
comp -include "$dsn\src\test-bench\task 3\ram_hamming_TB.vhd" 
asim +access +r ram_hamming_tb 
wave 
wave -noreg CLK
wave -noreg write_enable
wave -noreg address_bus
wave -noreg data_bus
wave -noreg error

run
endsim
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\TestBench\ram_hamming_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_ram_hamming 
