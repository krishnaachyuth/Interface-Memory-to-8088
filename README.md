# Interface_RAM_to_8088

This project involves system-level design and integra/on, crea/on and use of SystemVerilog
interfaces, $readmemh, bus-func/onal models, FSM modeling, and using protected
SystemVerilog IP

A brief summary of the 8088 pins is shown below.
Signal I/O Func/on
AD7-AD0 I/O Mul/plexed data and least significant 8 bits of address
A19-A8 O Most significant 12 bits of address (you can ignore the mul/plexed use of
A19-A16 as S6-S3).
CLK I Clock
HOLD I DMA request to hold the processor. When asserted, processor stops
suspends execu/on, places address, data, and control signals in high-
impedance. Should be kept at 0.
HLDA O Acknowledges processor has entered hold state
IO/M! O When low, indicates address is a memory address; when high, indicates I/O
(port) address
WR""""" O When low, indicates a bus write opera/on
RD"""" O When low, indicates a bus read opera/on
SSO""""" O Used in conjunc/on with other signals to determine type of bus cycle
READY I When low, processor enters wait states; When high has no effect. Your
model does not need to model wait states.
RESET I When asserted for four or more clock periods, resets the processor. (A real
process then begins execu/ng instruc/ons at 0xFFFF0.)
NMI I Non-maskable interrupt. Should always be 0 for this assignment.
INTR I Interrupt request. Should always be low for this assignment.
INTA"""""" O Interrupt Acknowledge. Will always be high for this assignment.
ALE O Address latch enable – indicates address/data bus contains valid address. Is
not floated during a hold state
DT/R" O Data transmit/receive. When high indicates processor is pupng data on
the data bus (AD7-AD0). When low, indicates process is expec/ng to
receive data from the data bus.
DEN""""" O Data bus enable – used to ac/vate external data buffers.
MN/MX"""" I When high, indicates minimum mode. Should always be high for this
assignment.
TEST"""""" I Should always be high for this assignmen
