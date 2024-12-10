module ADDRDecoding
(
	input [31:0] address,
	input clk,
	output reg cs
);

	// Grupo 15
	// Inicio = 15*250h = 22b0h
	// Fim = 22b0h + 1023d = 26afh
	
	always @ (posedge clk) begin

		if((address >= 32'h22b0) && (address <= 32'h26af))
			cs <= 0;
		else 
			cs <= 1;
	end 
	
endmodule 