module instructionmemory 
#(	parameter data_WIDTH = 32,	parameter ADDR_WIDTH = 10 )

(
	input [ADDR_WIDTH-1:0] address,
	input clk,
	output reg [data_WIDTH-1:0] out
);

	reg [data_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1];
	
	// início offsset -> 22B0h
	// última posição de memória -> 26AFh
	// primeiro endereco de memory de instrucoes -> 31B0h
	// ultimo endereco de memory de instrucoes -> 35AFh
	
	parameter r0 = 5'd0;
	parameter r1 = 5'd1;
	parameter r2 = 5'd2;
	parameter r3 = 5'd3;
	parameter r4 = 5'd4;
	parameter r5 = 5'd5;
	parameter r6 = 5'd6;
	parameter r7 = 5'd7;
	parameter r8 = 5'd8;
	
	parameter n10 = 5'd10;
	parameter ng = 6'd25; // tipo r // grupo + 10
	parameter n2 = 6'd47; //lw grupo +32
	parameter n3 = 6'd48; // sw grupo +33

	parameter soma = 6'd32;
	parameter sub = 6'd34;
	parameter e = 6'd36;
	parameter ou = 6'd37;
	parameter mul = 6'd50;
	
	parameter add_a = 16'h22B0;
	parameter add_b = 16'h22B1;
	parameter add_c = 16'h22B2;
	parameter add_d = 16'h22B3;

	parameter last_add = 16'h22B4;

	integer i;
	
	initial begin

			//Codigo com outras instruções:

			memory[10'h31BC] = {n2, r0, r1, add_a};          // R1 <- A (LW)
			memory[10'h31C0] = {n2, r0, r2, add_b};          // R2 <- B (LW)
			memory[10'h31C4] = {n2, r0, r3, add_c};          // R3 <- C (LW)
			memory[10'h31C8] = {n2, r0, r4, add_d};          // R4 <- D (LW)

			memory[10'h31CC] = 32'd0;
			memory[10'h31D0] = 32'd0;

			memory[10'h31D4] = {ng, r2, r1, r5, n10, sub};   // R5 <- (B - A) (SUB)

			memory[10'h31D8] = 32'd0;
			memory[10'h31DC] = {ng, r3, r4, r6, n10, sub};   // R6 <- (C - D) (SUB)
			memory[10'h31E0] = 32'd0;
			memory[10'h31E4] = 32'd0;
			memory[10'h31E8] = 32'd0;
			memory[10'h31EC] = {ng, r5, r6, r7, n10, mul};   // R7 <- R5 * R6 (MUL)
			memory[10'h31F0] = 32'd0;
			memory[10'h31F4] = 32'd0;
			memory[10'h31F8] = 32'd0;
			memory[10'h31FC] = {n3, r0, r7, last_add};       // SW -> last_add
			memory[10'h3200] = 32'd0;

		
	end

	always @ (posedge clk) 
		out <= memory[address];

endmodule
