module pc(
	input rst, 
	input clk, 
	input zeroflag, jmpFlag, branchFlag,
	input [31:0] jmpAddress, 
	input [31:0] branchOffset,
	output reg [31:0] out
);


always @(posedge clk)
	begin
		if(rst)
			out <= 0;
			
		else if (branchFlag)
			begin
				
				if (!zeroflag) out <= out + 4 + branchOffset; 
				else out <= out + 4;
				
			end
			
		else if (jmpFlag) out <= jmpAddress;
		
		else
			out <= out + 4;
	end

endmodule
