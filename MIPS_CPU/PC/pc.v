module pc(
	input rst, 
	input clk, 
	output [31:0] out
);

integer address = 0;
assign out = address;

always @(posedge clk)
	begin
		if(rst)
			address <= 0;
		else
			address <= address + 4;
	end

endmodule
