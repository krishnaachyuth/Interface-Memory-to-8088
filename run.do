vlib work 

vlog -lint -source IOM.sv
vlog -lint -source 8088.svp
vlog -lint -source topmem-3.sv

vsim work.top

vsim -voptargs=+acc work.top
add wave sim:/top/*
add wave sim:/top/m1.State
add wave sim:/top/m1.NextState
add wave sim:/top/m1.OE

run -all