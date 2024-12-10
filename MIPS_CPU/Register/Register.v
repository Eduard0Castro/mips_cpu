module Register
(
	input rst, 
	input clk,
	input[31:0] in,      
	output reg[31:0] out
);

	always @(posedge clk) begin
		if (rst) out <= 0;
		else     out <= in;
	end
endmodule
