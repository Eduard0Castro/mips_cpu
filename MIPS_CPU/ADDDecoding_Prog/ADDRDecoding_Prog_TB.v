`timescale 1ns/100ps
module ADDRDecoding_Prog_TB();

	wire cs_p;
	reg clk;
	reg [31:0] address;
	integer i;
	
	ADDRDecoding_Prog DUT (
		.cs_p(cs_p),
		.address(address),
		.clk(clk)
	);
	
	initial begin
		clk = 0;
		address = 0;
		
		for(i = 32'h0200; i <= 32'h06b0; i = i + 32'h4)
			#10 address = i;
			
		#20 $stop;
	end
	
	always #5 clk = ~clk;
endmodule 