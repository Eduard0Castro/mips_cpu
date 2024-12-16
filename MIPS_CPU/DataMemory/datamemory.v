module datamemory
#(	parameter data_WIDTH = 32,	parameter ADDR_WIDTH = 10)

(
	input [ADDR_WIDTH-1:0] address,
	input [data_WIDTH-1:0] in,
	input we,
	input clk,
	output reg [data_WIDTH-1:0] out
);


	reg [data_WIDTH-1:0] memory [0:(1<<ADDR_WIDTH)-1]; // 1024 words de 4bytes

	initial begin
		memory[0] = 32'd2001;
		memory[1] = 32'd4001;
		memory[2] = 32'd5001;
		memory[3] = 32'd3001;
	end

	always @ (posedge clk) begin
		if(we)
			memory[address] <= in;  // Escrever
		else
			out <= memory[address]; // Ler
	end

endmodule
