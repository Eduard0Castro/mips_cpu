module Counter (
	input Load, Clk,
	output reg K
);
	reg [4:0]cont;
	
	always @(posedge Clk) begin
		if (Load) begin
			cont = 0;
			K = 0;
		end
		else begin
			cont = cont + 1'b1;

			if (cont == 30)
				K = 1;
		end
end
endmodule
