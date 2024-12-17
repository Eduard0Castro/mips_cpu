module registerfile 
#(parameter DATA_WIDTH = 32, parameter ADDR_WIDTH = 5)
(
	input [DATA_WIDTH-1:0] data,
	input clk, we,
	input [ADDR_WIDTH - 1:0] rs,rt,rd,
	output reg [DATA_WIDTH-1:0] a,b
);

	integer i;
	
	reg [DATA_WIDTH-1:0] register [0:(1 << ADDR_WIDTH) - 1];
	
	initial	register[0] = {DATA_WIDTH{1'b0}}; //register[0] is hard wired

	always @ (posedge clk) 
		begin
				
			if (we && (rd != 0)) register[rd] <= data;
				
			a <= register[rs];
			b <= register[rt];
		end

endmodule
