# Interface Memory to 8088

This project involves system-level design and integration, creation and use of SystemVerilog
interfaces, $readmemh, bus-functional models, FSM modeling, and using protected
SystemVerilog IP


<h3>Pin Specifications</h3>


Signal            | I/O   | Function  | 
------------------| ------------- |-------|
AD7-AD0           | I/O | Multiplexed data and least significant 8 bits of address |
A19-A8            | O | Most significant 12 bits of address(ignoring the multiplexed useof  A19-A16 as S6-S3 |
CLK               | I | Clock |
HOLD              | I | DMA request to hold the processor. When asserted, processor stops suspends execution, places address, data, and control signals in high-impedance. Should be kept at 0 |
HLDA              | O | Acknowledges processor has entered hold state |
IO/M bar          | O | Acknowledges processor has entered hold state |
WR bar            | O | When low, indicates a bus write operation |
RD bar            | O | When low, indicates a bus read operation |
SSO bar           | O | Used in conjunction with other signals to determine type of bus cycle |
Ready             | O | When low, processor enter wait states; when high has no effect. Your model does not need to model wait states |
Reset             | O | When asserted for four or more clock periods,resets the processor |
NMI               | I | Non-maskable interrupt. Is always 0 for this project |
INTR              | I | Interrupt Request. Always low for this project |
INTA bar          | O | Interrupt request. Always low for this project |
ALE               | O | Address latch enable- indicates address/data bus contains valid address. Is floated during a hole state |
DT/R bar          | O | Data transmit/receive. When high indicates processor is putting data on the data bus(AD7-AD0). When low, indicates process is expecting to receive data from the data bus |
DEN bar            | O | Data bus enable - used to activate external data buffers |
MN/MX bar          | I | When high indicates minimum mode. Always high for this project |
TEST bar           | I | Should always be high for this assignment |

<h2>Input busops file specification</h2>
Upon sucessfully reset, 8088 svp file reads file called **busops.txt**. The file format is:<br>
<b>time  &nbsp;</b>    <b>type  &nbsp;</b>     <b>operation  &nbsp;</b>     <b>address 
 &nbsp;</b>   <br>
Where, <br>
<b>time</b> is the elapsed time in CPU clocks, <br> 
<b>type</b> is either I or M to denote an I/O or memory operation,<br>
<b>operation</b> is R or W to denote read or write, and **address** is a 20-bit address(in hexadecimal).<br> The fields are seperated by tab character.<br>
Example:
<b>136  &nbsp;</b>  <b>M  &nbsp;</b>  <b>R  &nbsp;</b>  <b>0x7F30B  &nbsp;</b>  <br>
Specifies that the processor should perform a memory read operation from location 0x7F30B at clock cycle 136 (or soon therafter if the bus is busy at that time). <br>

<h3>Memory and IO</h3>

This project instantiates two 2KiB memories, one which responds to
addresses between <b>0 and 512Ki-1</b> and the other which responds to addresses between <b>512Ki and 1M-1</b>.<br>
Also, instantiates wo I/O devices, one of which responds to port numbers <b>0xFF00
through 0xFF0F</b> and the other to <b>0x1C00 through 0x1DFF</b>.<br>

Below image taken depicts the use case:
![image](https://github.com/krishnaachyuth/Interface_RAM_to_8088/assets/34981932/af8314b8-ea8a-45ef-9530-afa7d9a8825e)

Image below taken from [Microprocessors and Interfacing: Programming and Hardware by Douglas V.Hall](https://www.amazon.com/Microprocessors-Interfacing-Programming-Douglas-Hall/dp/0070257426) shows the timing for read, write operation. T<sub>wait</sub> is ignored for this project.

![image](https://github.com/krishnaachyuth/Interface_RAM_to_8088/assets/34981932/76c03445-3cfc-4245-aa68-855cf7efa883)

