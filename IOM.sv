module FSM(CLK,RESET,ALE,RD,WR,Address,Data , OE,rw , ld_Addr,ld_data );
input logic CLK,RESET,ALE,RD,WR;
input logic [19:0]Address;
inout logic [7:0]Data;

output logic OE,rw;
output logic ld_Addr,ld_data;

typedef enum {T1,T2,T3_READ,T4_READ,T3_WRITE,T4_WRITE} state_t;
state_t State,NextState;


// sequential logic
always_ff @(posedge CLK)
begin
if (RESET)
	State <= T1;	
else
	State <= NextState;
end

//NextState logic
always_comb
begin
case(State)
	T1:NextState = (ALE)?T2:T1;
	T2:NextState = (RD&&WR)?T2:(~RD)?T3_READ:T3_WRITE;
	T3_READ:NextState = RD ?  T4_READ :T3_READ;
	T4_READ: NextState = T1;
	T3_WRITE:NextState = WR ?  T4_WRITE :T3_WRITE;
	T4_WRITE: NextState = WR ? T1:T4_WRITE;
endcase
end

// output combinational logic
always_comb
begin
{ld_Addr,ld_data,OE,rw} = '0;

case (State)
	T1:begin
		 end
	T2:begin
		 ld_Addr=1'b1;
		 end
	T3_READ: begin  OE = 1'b1; end
	T4_READ: OE = 1'b0;
	T3_WRITE: ld_data = 1'b1;	
	T4_WRITE: rw= 1'b1;
endcase
end

endmodule





module datapath(CLK,Address,ld_Addr,rw,OE,cs,ld_data,Data);
input logic CLK;
input logic ld_Addr;
input logic [19:0]Address;
input logic OE;
input logic cs;
input logic ld_data;
inout logic [7:0]Data;
input logic rw;
parameter mem_LSB = 20'h00000 , mem_MSB = 20'h7FFFF;

logic [7:0]Mem[mem_MSB:mem_LSB] , MemData;
logic [19:0]AddrReg;
logic [7:0] DataReg;

initial begin 
for(int i=0;i<=20'hFFFFF;i++)
	Mem[i] = i[7:0];
end

assign Data = (OE & cs) ? Mem[AddrReg] : 'bz;


always_ff@(posedge CLK) 
begin
if(ld_Addr & cs)  AddrReg <= Address;
end	

always@(posedge CLK) 
begin 
if(rw & cs) 
	Mem[AddrReg] <= DataReg;
end

always_ff@(posedge CLK)
begin 
if(ld_data & cs ) 
begin 
	DataReg <= Data;
end
end

endmodule