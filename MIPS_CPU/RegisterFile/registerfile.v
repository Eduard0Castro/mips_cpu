module registerfile 
#(parameter DATA_WIDTH = 32)
(
	input [DATA_WIDTH-1:0] data,
	input clk, rst, we,
	input [4:0] rs,rt,rd,
	output reg [DATA_WIDTH-1:0] a,b
);

	integer i;
	
	reg [DATA_WIDTH-1:0] register [0:15];
	
	always @ (negedge clk) begin
		if(rst) begin
			for(i = 0; i < 16; i = i+1) 
				register[i] = 32'b0;
		end else if (we) begin
			register[rd] <= data;
		end
	end
	
	always @ (posedge clk) begin
			a <= register[rs];
			b <= register[rt];
	end

endmodule
