`timescale 1ns/100ps
module Counter_TB();
	reg Load, Clk;
	wire K;
		
	 Counter DUT (
      .Load(Load),
      .Clk(Clk),
      .K(K)
    );

	initial Clk = 0;
	
	always #5 Clk = ~Clk;

   initial begin
		Load = 1;
		
		#10
		Load = 0;
		
		#320
		Load = 1;
		
		#10
		Load = 0;
	end	  
		
	initial begin
		#440 $stop;
   end
	

endmodule
