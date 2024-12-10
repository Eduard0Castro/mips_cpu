`timescale 1ns/100ps
module ADDRDecoding_TB();

	wire cs;
	reg clk;
	reg [31:0] address;
	integer i;
	
	ADDRDecoding DUT (
		.cs(cs),
		.address(address),
		.clk(clk)
	);
	
	initial begin
		clk = 0;
		address = 0;
		
		for(i = 32'h0300; i <= 32'h07b0; i = i + 32'hC8)
			#100 address = i;
			
		#200 $stop;
	end
	
	always #50 clk = ~clk;
endmodule 