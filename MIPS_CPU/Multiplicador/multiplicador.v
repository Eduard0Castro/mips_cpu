module multiplicador (
	input St, Clk, reset,
	input [15:0] Multiplicando, Multiplicador,
	output Idle, Done,
	output [31:0] Produto
	);
	
	wire Load, Sh, Ad, K, M;
	wire [16:0] Soma;
	wire [32:0] Saidas;
	
	assign Produto[31:0] = Saidas[31:0];
	assign M = Saidas[0];

	ACC acc(.Load(Load), .Sh(Sh), .Ad(Ad), .Clk(Clk), .reset(reset),
		.Entradas({Soma, Multiplicador}), .Saidas(Saidas));
		
	Adder add(.OperandoA(Multiplicando), .OperandoB(Saidas[31:16]),
		.Soma(Soma));
		
	CONTROL control(.Clk(Clk), .K(K), .St(St), .M(M), .reset(reset),
		.Idle(Idle), .Done(Done), .Load(Load), .Sh(Sh), .Ad(Ad));
		
	Counter counter(.Load(Load), .Clk(Clk), .K(K));

endmodule
