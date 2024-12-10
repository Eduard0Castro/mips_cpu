`timescale 1ns/100ps
module ACC_TB();
	
	reg [32:0] Entradas;
	reg Load, Sh, Ad, Clk, reset;
	wire [32:0] Saidas;

	ACC DUT (	
		.Entradas(Entradas),
		.Load(Load),
		.Sh(Sh),
		.Ad(Ad),
		.Clk(Clk),
		.reset(reset),
		.Saidas(Saidas)
	);
	
	initial Clk = 0;
	
	always #5 Clk = ~Clk;
	
	initial begin
		Entradas = 33'b0_1111_0000_1111_0000_1111_0000_1111_0000;
		Load = 0;
		Ad = 0;
		Sh = 0;
		reset = 1;
		#10 reset = 0;

		#20
		Load = 1;
		
		#20
		Load = 0;
		Ad = 1;
		Sh = 0;
		
		#30
		Sh = 1;
		Ad = 0;
		
		#60
		Ad = 1;
		Sh = 0;
		
		#60
		Sh = 1;
		
		
	end
	
	initial #300 $stop;
endmodule 