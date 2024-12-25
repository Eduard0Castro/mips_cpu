`timescale 1ns/10ps
module extend_TB ();

	reg [15:0] data;
	reg clk, rst;
	wire [31:0] out;
	
	extend DUT (
		.data(data),
		.clk(clk),
		.rst(rst),
		.out(out)
	);
	
	initial begin
		rst = 1;
		clk = 0;
		data = -2;
		
		#10 rst = 0;
		#45 data = 3;
		
		#100 $stop;
	end
	
	always #10 clk = ~clk;
endmodule
