`timescale 1ns/100ps
module pc_TB ();

	reg clk;
	reg rst;
	wire [31:0] out;

	pc DUT(
		.clk(clk),
		.rst(rst),
		.out(out)
	);

	initial begin
		clk = 0;
		rst = 1;
		
		#50 rst = 0;
		
		#1000 $stop;
	end

	always #5 clk = ~clk;
	always #5 $display(DUT.address);

endmodule
