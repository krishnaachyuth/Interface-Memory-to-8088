/**********************************************************************/
/* ECE -571 INTRODUCTION TO SYSTEM VERILOG FOR DESIGN AND VERIFICATION*/
/*				FINAL PROJECT										  */
/* Description: This file designs a synthesizable FSM that can be used*/
/*              as an 8088 bus compatible Memory or I/O module.      */			
/* Authors : Achyuth Krishna Chepuri (952279119)                      */
/* 			 Sai Sri Harsha Atmakuri (932141135)                      */
/*			 Sathwik Reddy Madireddy (920582851)                      */ 
/**********************************************************************/


module Memory_IO(Intel8088Pins.Peripheral bus,input logic CS);

logic OE,rw;
logic ld_Addr,ld_data;

parameter MEM_LSB = 20'h00000 , MEM_MSB = 20'h7FFFF;
parameter ACTIVE = 1'b0;
parameter file = "dummy.txt";

logic [7:0]Mem[MEM_MSB:MEM_LSB] ;
logic [19:0] AddrReg;
logic [7:0]  DataReg;

typedef  enum logic[5:0] { T1 = 6'b000001 , T2 = 6'b000010 , T3_READ = 6'b000100 , 
T4_READ = 6'b001000 , T3_WRITE = 6'b010000 , T4_WRITE = 6'b100000 } state_t;

state_t State, NextState;

// sequential logic
always_ff @(posedge bus.CLK)
begin
if (bus.RESET)
	State <= T1;	
else
	State <= NextState;
end

//NextState logic
always_comb
begin
NextState = State;
unique0 case(State)
	T1:       NextState = ( bus.ALE && CS && bus.IOM == ACTIVE ) ? T2 : T1;
	T2:       NextState = ( bus.RD && bus.WR ) ? T2 : ( ~bus.RD ) ? T3_READ : T3_WRITE;
	T3_READ:  NextState = T4_READ;
	T4_READ:  NextState = T1;
	T3_WRITE: NextState = T4_WRITE ;
	T4_WRITE: NextState = T1;
endcase
end

// output combinational logic   
always_comb
begin
{ld_Addr , ld_data , OE , rw} = '0;
 
unique0 case(State)
	T1: begin
		end
	T2: begin
		ld_Addr=1'b1;
		end
	T3_READ:  begin 
              OE = 1'b1; 
			  end
	T4_READ:  OE = 1'b0;
	T3_WRITE: ld_data = 1'b1;	
	T4_WRITE: rw = 1'b1;
endcase
end


initial 
begin
$readmemb(file, Mem , MEM_LSB , MEM_MSB);
end

assign bus.Data = (OE) ? Mem[AddrReg] : 'bz;

always_ff@(posedge bus.CLK) 
begin
if(ld_Addr)  
	AddrReg <= bus.Address;
end	

always_ff@(posedge bus.CLK) 
begin 
if(rw) 
	Mem[AddrReg] <= DataReg;
end

always_ff@(posedge bus.CLK)
begin 
if(ld_data)  
	DataReg <= bus.Data;
end

endmodule
