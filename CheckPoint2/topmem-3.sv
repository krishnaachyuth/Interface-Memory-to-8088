module top;

bit CLK = '0;
bit MNMX = '1;
bit TEST = '1;
bit RESET = '0;
bit READY = '1;
bit NMI = '0;
bit INTR = '0;
bit HOLD = '0;

wire logic [7:0] AD;
logic [19:8] A;
logic HLDA;
logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;


logic [3:0] CS;

genvar i,j;

logic [19:0] Address;
wire [7:0]  Data;

localparam bit[19:0] MEM_LSB[1:0] = '{20'h80000 , 20'h00000};   //524288,0
localparam bit[19:0] MEM_MSB[1:0] = '{20'hFFFFF , 20'h7FFFF};   //1048575,524287 

localparam bit[16:0] IO_LSB[1:0] = '{16'hFF00 , 16'h1C00};   //65280,7168
localparam bit[16:0] IO_MSB[1:0] = '{16'hFF0F , 16'h1DFF};   //65295,7679

Intel8088 P(CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, AD, A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN);
FSM #(MEM_LSB[0] , MEM_MSB[0],0 , "MEM1.txt" ) mem0 (CLK,RESET,ALE,IOM,CS[0],RD,WR,Address,Data);
FSM #(MEM_LSB[1] , MEM_MSB[1],0 , "MEM2.txt" ) mem1 (CLK,RESET,ALE,IOM,CS[1],RD,WR,Address,Data);
FSM #(IO_LSB[0] , IO_MSB[0],1 , "IO2.txt" ) IO0 (CLK,RESET,ALE,IOM,CS[2],RD,WR,Address,Data);
FSM #(IO_LSB[1] , IO_MSB[1],1 , "IO1.txt") IO1 (CLK,RESET,ALE,IOM,CS[3],RD,WR,Address,Data);


assign CS[0] = ~Address[19];
assign CS[1] = Address[19];
assign CS[2] = Address[15:8] == 8'b0001_1100;
assign CS[3] = Address[15:4] == 12'b1111_1111_0000;

// 8282 Latch to latch bus address
always_latch
begin
if (ALE)
	Address <= {A, AD};
end

// 8286 transceiver
assign Data =  (DTR & ~DEN) ? AD   : 'z;
assign AD   = (~DTR & ~DEN) ? Data : 'z;


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