`timescale 1ns/100ps
module pc_TB ();

reg clk;
reg rst;
reg zeroflag, jmpFlag, branchFlag;
reg [31:0] jmpAddress, branchOffset;
wire [31:0] out;

pc DUT(
	.clk(clk),
	.rst(rst),
	.zeroflag(zeroflag),
	.jmpFlag(jmpFlag),
	.jmpAddress(jmpAddress),
	.branchFlag(branchFlag),
	.branchOffset(branchOffset),
	.out(out)
);

initial 
	begin
		clk = 0;
		rst = 1;
		zeroflag = 0;
		jmpFlag = 0;
		branchFlag = 0;
		
		jmpAddress = 32'h340C;
		branchOffset = -12;
		
		
		#50 rst = 0;
		#45 branchFlag = 1;
		#10 branchFlag = 0;
		#10 jmpFlag = 1;
		#10 jmpFlag = 0;
		
		#100 $stop;
	end

always #5 clk = ~clk;

endmodule
