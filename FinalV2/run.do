vlib work 

#vlog -lint -source 8088-1.svp
vlog -lint -source 8088if.svp
vlog -lint -source interface.sv
vlog -lint -source Memory_IO.sv
vlog -lint -source top.sv

vsim work.top

vsim -voptargs=+acc work.top
do wave.do

#add wave sim:/top/*
#add wave -r *
run -all