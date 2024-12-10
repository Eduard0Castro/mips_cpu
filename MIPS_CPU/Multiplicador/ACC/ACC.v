module ACC (
	input [32:0] Entradas,
	output reg [32:0] Saidas,
	input Load, Sh, Ad, Clk, reset
); 
	
	always @(posedge Clk) begin
		if(reset) Saidas = 0;
		if (Ad) Saidas[32:16] = Entradas[32:16];
			
		if (Sh) Saidas = {1'b0, Saidas[32:1]};
			
		if (Load) Saidas = {17'b0, Entradas[15:0]};  			
	end	
endmodule 