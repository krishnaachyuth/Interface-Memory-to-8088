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

logic OE,rw;
logic ld_Addr,ld_data;
logic [3:0] cs;
//logic cs;
genvar i,j;

logic [19:0] Address;
wire [7:0]  Data;

localparam bit[19:0] MEM_LSB[1:0] = '{20'h8FFFF , 20'h00000}; 
localparam bit[19:0] MEM_MSB[1:0] = '{20'hFFFFF , 20'h7FFFF};    

localparam bit[16:0] IO_LSB[1:0] = '{16'hFF00 , 16'h1C00};
localparam bit[16:0] IO_MSB[1:0] = '{16'hFF0F , 16'h1DFF};

/*localparam IO_DEVICE1_LSB = 16'hFF00;
localparam IO_DEVICE1_MSB = 16'hFF0F;      

localparam IO_DEVICE2_LSB = 16'h1C00; 
localparam IO_DEVICE2_MSB = 16'h1DFF;      
*/

Intel8088 P(CLK, MNMX, TEST, RESET, READY, NMI, INTR, HOLD, AD, A, HLDA, IOM, WR, RD, SSO, INTA, ALE, DTR, DEN);
FSM m1 (CLK,RESET,ALE,RD,WR,Address,Data , OE,rw , ld_Addr,ld_data );

/*
datapath #(MEM_LSB[0] , MEM_MSB[0]) m2 (CLK,Address,ld_Addr,rw,OE,cs[0],ld_data,Data);
datapath #(MEM_LSB[1] , MEM_MSB[1]) m3 (CLK,Address,ld_Addr,rw,OE,cs[1],ld_data,Data);
datapath #(IO_LSB[0] , IO_MSB[0]) m4 (CLK,Address,ld_Addr,rw,OE,cs[2],ld_data,Data);
datapath #(IO_LSB[1] , IO_MSB[1]) m5 (CLK,Address,ld_Addr,rw,OE,cs[3],ld_data,Data);
*/


generate 
	for(i=0;i<2;i++)
	begin 
		datapath #(MEM_LSB[i] , MEM_MSB[i]) mem (CLK,Address,ld_Addr,rw,OE,cs[i],ld_data,Data);	
	end
endgenerate 

generate 
	for(j=0;j<2;j++)
	begin 
		datapath #(IO_LSB[j] , IO_MSB[j]) IO (CLK,Address,ld_Addr,rw,OE,cs[j+2],ld_data,Data);	
	end
endgenerate 


always@(posedge ALE )
begin
 if(IOM == 0 & ALE)
	cs = {1'b0 , 1'b0 , A[19], ~A[19]};
 else if (IOM == 1'b1 & ALE )
    cs = {A[15], ~A[15],1'b0 , 1'b0 };
 else 
  cs = '0;
end

/*
always@(posedge ALE)
begin 
	if(IOM == 0)	cs = Address[19];
	else cs = Address[15];
end 
*/

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
