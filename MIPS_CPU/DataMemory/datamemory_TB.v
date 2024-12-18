`timescale 1ns/100ps
module datamemory_TB();
parameter data_WIDTH = 32;
parameter ADDR_WIDTH = 10;

	reg [ADDR_WIDTH-1:0] address;
	reg we, clk;
	reg [data_WIDTH-1:0] in;
	wire [data_WIDTH-1:0] out;
	integer i = 0;

	datamemory DUT (
		.address(address),  
		.we(we), 
		.clk(clk),
		.in(in), 
		.out(out)
	);

	initial begin
		clk = 0;
		we = 0;
		address = 9'b0;
		in = 32'b0;
		
		#40 address = 10'h0;
		#40 address = 10'h1;
		#40 address = 10'h2;
		#40 address = 10'h3;
		
		#20 we = 1; 
		
		for (i = 0; i < 16; i = i + 1) begin
			#40 address = i;
			in = i;
		end
		
		#40 we = 0;
		for (i = 0; i < 16; i = i + 1) 
			#40 address = i;
			
		#80 $stop;
	end

	//initial begin
	//	for(k = 0; k < 32'hFFFFFFFF; k = k + 4)
	//		#40 in = k;
	//end

	always #5 clk = ~clk;

endmodule
