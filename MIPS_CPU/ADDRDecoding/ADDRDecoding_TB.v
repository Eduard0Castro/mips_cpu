`timescale 1ns/100ps
module ADDRDecoding_TB();

	wire cs, we;
	reg clk, we_ctrl;
	reg [31:0] address;
	wire [9:0] address_out;
	
	integer i;
	
	ADDRDecoding DUT (
		.cs(cs),
		.address(address),
		.clk(clk),
		.we_ctrl(we_ctrl),
		.we(we),
		.address_out(address_out)
	);
	
	initial begin
		clk = 0;
		address = 0;
		we_ctrl = 0;
		
		for(i = 32'h22b0; i <= 32'h26af; i = i + 32'hC8)
			#100 address = i;
			
		#200 $stop;
	end
	
	always #50 clk = ~clk;
endmodule 