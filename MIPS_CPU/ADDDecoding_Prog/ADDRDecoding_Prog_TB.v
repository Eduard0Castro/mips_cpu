`timescale 1ns/100ps
module ADDRDecoding_Prog_TB();

	wire cs_p;
	reg clk;
	reg [31:0] address_in;
	wire [31:0] address_out;
	integer i;
	
	ADDRDecoding_Prog DUT (
		.cs_p(cs_p),
		.address_in(address_in),
		.address_out(address_out),
		.clk(clk)
	);
	
	initial begin
		clk = 0;
		address_in = 0;
		
		for(i = 32'h31b0; i <= 32'h35af; i = i + 32'h4)
			#10 address_in = i;
			
		#20 $stop;
	end
	
	always #5 clk = ~clk;
endmodule 