`timescale 1ns/10ps
module extend_TB ();

	reg [15:0] data;
	reg clk;
	reg en;
	wire [31:0] out;
	
	extend DUT (
		.data(data),
		.clk(clk),
		.out(out),
		.en(en)
	);
	
	initial begin
		clk = 0;
		en = 0;		
		data = 16'b1111111111111111;
		#100 en = 1;
		
		#100 $stop;
	end
	
	always #50 clk = ~clk;
endmodule
