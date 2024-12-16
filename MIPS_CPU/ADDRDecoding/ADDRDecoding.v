module ADDRDecoding
(
	input [31:0] address,
	input clk, we_ctrl,
	output reg [9:0]address_out, //[0, 1023] pode-se representar com 10 bits
	output reg cs,
	output we
);

	// Grupo 15
	// Inicio = 15*250h = 22b0h
	// Fim = 22b0h + 1023d = 26afh
	
	assign we = we_ctrl;
	
	always @ (posedge clk) begin

		if((address >= 32'h22b0) && (address <= 32'h26af))
			begin
				cs <= 0;
				address_out <= address - 32'h22b0;
			end
		else 
			begin
				cs <= 1;
				address_out <= 0;
			end
	end 
	
endmodule 