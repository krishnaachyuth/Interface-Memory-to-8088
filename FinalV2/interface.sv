/**********************************************************************/
/* ECE -571 INTRODUCTION TO SYSTEM VERILOG FOR DESIGN AND VERIFICATION*/
/*            FINAL PROJECT   													  */
/* Description : This file Creates an Interface for 8088 pins with    */
/*                 Processor and a Peripheral modport                 */ 				
/* Authors : Achyuth Krishna Chepuri (952279119)                      */
/* 			 Sai Sri Harsha Atmakuri (932141135)                      */
/*			 Sathwik Reddy Madireddy (920582851)                      */ 
/**********************************************************************/


interface Intel8088Pins(input logic CLK,RESET);

logic MNMX;
logic TEST;
logic READY;
logic NMI;
logic INTR;
logic HOLD;
logic HLDA;

tri [7:0] AD;
tri [19:8] A;

logic IOM;
logic WR;
logic RD;
logic SSO;
logic INTA;
logic ALE;
logic DTR;
logic DEN;
logic [19:0]Address;
wire [7:0]Data;



  modport Processor ( input CLK,
    input MNMX,
    input TEST,
    input RESET,
    input READY,
    input NMI,
    input INTR,
    input HOLD,
    inout AD,
    output A,
    output HLDA,
    output IOM,
    output WR,
    output RD,
    output SSO,
    output INTA,
    output ALE,
    output DTR,
    output DEN
  );

  modport Peripheral ( 
    input CLK,
	input RESET,
	input ALE,
	input IOM,
	input RD,
	input WR,
    input Address,
	inout Data   
    );
endinterface
