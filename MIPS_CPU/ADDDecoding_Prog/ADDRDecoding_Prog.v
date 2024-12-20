module ADDRDecoding_Prog
(
	input [31:0] address_in, 
	input clk,
	output reg cs_p,
	output reg [9:0] address_out
);

	// Grupo 15
	// Inicio = 15*350h = 31B0h
	// Fim = 31B0h + 1023d = 35AFh
	
always @ (posedge clk) 
	begin
	
		if((address_in >= 32'h31b0) && (address_in <= 32'h35af))
			begin
				cs_p <= 0;
				address_out <= address_in - 32'h31b0;
		
			end
			
		else 
			begin
				cs_p <= 1;
				address_out <= 0;

			end 
	
	end
endmodule 