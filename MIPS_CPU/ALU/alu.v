module alu
#(parameter DATA_WIDTH = 32)
(
	input[DATA_WIDTH-1:0] a, 
	input[DATA_WIDTH-1:0] b,
	input[1:0] load,
	output reg [DATA_WIDTH-1:0] out, 
	output reg zeroflag
);
	

always @ (*) begin
	zeroflag = 0;
	case(load)
		2'b00: out <= a + b; // Soma
		2'b01:
			begin
				out <= a - b; // Sub
				if (out == 0) zeroflag = 1;
			end
		2'b10: out <= a & b; // AND
		2'b11: out <= a | b; // OR
		default: 
				out <= 32'd0;
	endcase			
end

endmodule 