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
	// último endereco de memory de instrucoes -> 35AFh
	
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

		memory[0] = {n2, r0, r1, add_a};          // R1 <- A (LW) 
		memory[1] = {n2, r0, r2, add_b};          // R2 <- B (LW)
		memory[2] = {n2, r0, r3, add_c};          // R3 <- C (LW)
		memory[3] = {n2, r0, r4, add_d};          // R4 <- D (LW)

		memory[4] = 32'd0;
		memory[5] = 32'd0;

		memory[6] = {ng, r2, r1, r5, n10, sub};   // R5 <- (B - A) (SUB)

		memory[7] = 32'd0;
		memory[8] = {ng, r3, r4, r6, n10, sub};   // R6 <- (C - D) (SUB)
		memory[9] = 32'd0;
		memory[10] = 32'd0;
		memory[11] = 32'd0;
		memory[12] = {ng, r5, r6, r7, n10, mul};   // R7 <- R5 * R6 (MUL)
		memory[13] = 32'd0;
		memory[14] = 32'd0;
		memory[15] = 32'd0;
		memory[16] = {n3, r0, r7, last_add};       // SW -> last_add
		memory[17] = 32'd0;

		
	end

	always @ (posedge clk) 
		out <= memory[address];

endmodule
