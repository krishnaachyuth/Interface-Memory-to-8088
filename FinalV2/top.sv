/**********************************************************************/
/* ECE -571 INTRODUCTION TO SYSTEM VERILOG FOR DESIGN AND VERIFICATION*/
/*				FINAL PROJECT										  */
/* Description: The top level module instantiates two 512KiB memories */
/*				one which responds to addresses between 0 and 512KiB, */
/*				other which responds to addresses between 1 and 1M-1. */
/*				Also, instantiates two I/O devices, one which responds*/ 
/*				to port numbers 0xFF00 through 0xFF0F and other to    */
/*				0xC100 through 0x1DFF                                 */
/* Authors : Achyuth Krishna Chepuri (952279119)                      */
/* 			 Sai Sri Harsha Atmakuri (932141135)                      */
/*			 Sathwik Reddy Madireddy (920582851)                      */ 
/**********************************************************************/

module top();

bit CLK;
bit RESET;

initial 
begin
CLK = '0;
RESET = '0;
bus.MNMX = '1;
bus.TEST = '1;
bus.READY = '1;
bus.NMI = '0;
bus.INTR = '0;
bus.HOLD = '0;
end

logic [3:0] CS;

localparam bit[19:0] MEM_LSB[1:0] = '{20'h80000 , 20'h00000};   
localparam bit[19:0] MEM_MSB[1:0] = '{20'hFFFFF , 20'h7FFFF};    

localparam bit[16:0] IO_LSB[1:0] = '{16'hFF00 , 16'h1C00};   
localparam bit[16:0] IO_MSB[1:0] = '{16'hFF0F , 16'h1DFF};   


Intel8088Pins bus (.CLK(CLK),.RESET(RESET));
Intel8088 P ( bus.Processor );
Memory_IO #(MEM_LSB[0] , MEM_MSB[0], 0 , "MEM1.txt" ) mem0 (  bus.Peripheral , CS[0]);
Memory_IO #(MEM_LSB[1] , MEM_MSB[1], 0 , "MEM2.txt" ) mem1 (  bus.Peripheral ,CS[1]);
Memory_IO #(IO_LSB[0] , IO_MSB[0] , 1 , "IO2.txt" ) IO0 (  bus.Peripheral , CS[2]);
Memory_IO #(IO_LSB[1] , IO_MSB[1] , 1 , "IO1.txt") IO1 (  bus.Peripheral , CS[3]);


assign CS[0] = ~bus.Address[19];
assign CS[1] = bus.Address[19];
assign CS[2] = bus.Address[15:9] == 7'b0001_110;  // for IO1 - 1C00 - 1DFF
assign CS[3] = bus.Address[15:4] == 12'b1111_1111_0000; //for IO2 - FF00 - FF0F

// 8282 Latch to latch bus address
always_latch
begin
if (bus.ALE)
	bus.Address <= {bus.A, bus.AD};
end

// 8286 transceiver
assign bus.Data =  (bus.DTR & ~bus.DEN) ? bus.AD   : 'z;
assign bus.AD   = (~bus.DTR & ~bus.DEN) ? bus.Data : 'z;


always #50 CLK = ~CLK;

initial
begin
$dumpfile("dump.vcd"); $dumpvars;

repeat (2) @(posedge CLK);
RESET = '1;
repeat (5) @(posedge CLK);
RESET = '0;

repeat(10000) @(posedge CLK);
$finish();
end

endmodule