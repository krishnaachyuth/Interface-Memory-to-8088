vlib work 

vlog -lint -source datagenerate.sv
#vlog -lint -source 8088.svp
#vlog -lint -source topmem-3.sv

vsim work.top

vsim -voptargs=+acc work.top
#add wave sim:/top/*
#add wave sim:/top/mem0.State
#add wave sim:/top/mem0.NextState
#add wave sim:/top/mem0.OE
#add wave sim:/top/mem0.CS

run -all