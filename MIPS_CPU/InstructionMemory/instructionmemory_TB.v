`timescale 1ns/100ps
module instructionmemory_TB();
	parameter data_WIDTH = 32;
	parameter ADDR_WIDTH = 10;

	reg [ADDR_WIDTH-1:0] address;
	reg clk;
	wire [data_WIDTH-1:0] out;
	integer k = 0;

	instructionmemory DUT (
		.address(address),  
		.clk(clk), 
		.out(out)
	);

	initial begin
		clk = 0;
		address = 10'b0;	
		
		for (k = 0; k < 27; k = k + 1) 
			#100 address = k;
			
		#200 $stop;
	end

	always #50 clk = ~clk;

endmodule
