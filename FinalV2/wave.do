onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top/CLK
add wave -noupdate /top/RESET
add wave -noupdate /top/CS
add wave -noupdate /top/bus/AD
add wave -noupdate /top/bus/A
add wave -noupdate /top/bus/IOM
add wave -noupdate /top/bus/WR
add wave -noupdate /top/bus/RD
add wave -noupdate /top/bus/SSO
add wave -noupdate /top/bus/INTA
add wave -noupdate /top/bus/ALE
add wave -noupdate /top/bus/DTR
add wave -noupdate /top/bus/Address
add wave -noupdate /top/bus/Data
add wave -noupdate /top/mem0/State
add wave -noupdate /top/mem0/NextState
add wave -noupdate /top/mem1/State
add wave -noupdate /top/mem1/NextState
add wave -noupdate /top/IO0/State
add wave -noupdate /top/IO0/NextState
add wave -noupdate /top/IO1/State
add wave -noupdate /top/IO1/NextState
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
quietly wave cursor active 0
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ns} {1 us}
