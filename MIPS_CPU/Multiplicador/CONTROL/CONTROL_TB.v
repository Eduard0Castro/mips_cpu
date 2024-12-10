`timescale 1ns/100ps
module CONTROL_TB ();

	reg Clk, K, St, M, reset;
	wire Idle, Done, Load, Sh, Ad;
	
	CONTROL DUT(
		.Clk(Clk),
		.K(K),
		.St(St),
		.M(M),
		.reset(reset),
		.Idle(Idle),
		.Done(Done),
		.Load(Load),
		.Sh(Sh),
		.Ad(Ad)
	);
	
	always #5 Clk = ~Clk;
	
	initial begin
		Clk = 0;
		St = 0;
		reset = 1;
		
		#10 reset = 0;
		
		#20
		St=1;
		M=1;
		K=0;
		
		#10
		St = 0;
		
		#20
		M = 0;
		
		#20
		M = 1;
		
		#20
		M = 0;
		
		#20
		M = 1;
		K = 1;
	end
	
	initial #100 $stop;
	
endmodule
