module top();
//logic [7:0]Mem[20'h00000:20'h7FFFF];
parameter MEM_LSB = 20'h00000 , MEM_MSB = 20'h7FFFF;
logic [7:0]Mem1[MEM_MSB:MEM_LSB];
integer f;

/*
initial begin 
	f=$fopen("dummy.txt","w");
end

initial begin 

for(int i=0;i<=20'h7FFFF;i++)
begin
	Mem[i] = i[7:0];
	#1 $fwrite(f,"%x\n",Mem[i]);
end
$fclose(f); 
end
*/
	

initial begin 
//for(int i=0;i<=20'hFFFFF;i++)
	$readmemh("dummy.txt",Mem1,16'hFF00,16'hFF0F);
end	

endmodule