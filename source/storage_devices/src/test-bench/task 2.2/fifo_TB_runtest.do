SetActiveLib -work
comp -include "$dsn\src\task 2.2\FIFO.vhd" 
comp -include "$dsn\src\test-bench\task 2.2\fifo_TB.vhd" 
asim +access +r fifo_tb 
wave 
wave -noreg CLK
wave -noreg write_enable
wave -noreg data_bus
wave -noreg empty
wave -noreg full

run
endsim
# The following lines can be used for timing simulation
# acom <backannotated_vhdl_file_name>
# comp -include "$dsn\src\test-bench\fifo_TB_tim_cfg.vhd" 
# asim +access +r TIMING_FOR_fifo 
