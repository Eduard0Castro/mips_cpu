`timescale 1ns/100ps
module multiplicador_TB();
	
	reg St, Clk, reset;
	reg [15:0] Multiplicando, Multiplicador;
	wire Idle, Done;
	wire [31:0] Produto;

	multiplicador DUT(
		.St(St),
		.Clk(Clk),
		.reset(reset),
		.Multiplicando(Multiplicando),
		.Multiplicador(Multiplicador),
		.Idle(Idle),
		.Done(Done),
		.Produto(Produto)
		);
		
	initial Clk = 0;
	
	always #5 Clk = ~Clk;
	
	
	initial begin
		reset = 1;
		St = 0;
		Multiplicando = 16'd2000;
		Multiplicador = 16'd2000;
		#10
		reset = 0;
		St = 1;

		#300
		St = 0;
		#100
		Multiplicador = 15;
		Multiplicando = 15;
		#10
		St = 1;
		
		#300
		St = 0;
		#100
		Multiplicando = 16'hffff;
		Multiplicador = 16'hffff;
		#10
		St = 1;
		#300
		St = 0;
		
	end
	
	initial #1300 $stop;
	
endmodule
