`timescale 1ns/100ps
module registerfile_TB();
	parameter DATA_WIDTH=32;
		
	reg [DATA_WIDTH-1:0] data;
	reg clk, we;
	reg [4:0] rs,rt,rd;
	wire [DATA_WIDTH-1:0] a,b;


	registerfile DUT (
		.data(data),  
		.we(we), 
		.clk(clk),
		.rs(rs),
		.rt(rt),
		.rd(rd),
		.a(a),
		.b(b)
	);

	initial begin
		clk = 0;
		we = 0;
		rs = 0;
		rt = 0;
		rd = 0;
		
		#20 we = 1;
		data = 2001;
		rd = 1;
		
		#40 data = 4001;
		rd = 2;
		rs = 1;
		
		#40 data = 5001;
		rd = 6;
		rt = 2;
		
		#40 data = 3001;
		rd = 8;
		rs = 6;		
		
		#40 
		rt = 8;
		
		#40 we = 0;
		data = 2001;
		rd = 1;
		
		#40 data = 4001;
		rd = 2;
		rs = 1;
		
		#40 data = 5001;
		rd = 6;
		rt = 2;
		
		#40 data = 3001;
		rd = 8;
		rs = 6;		
		
		#40 rt = 8;
		
		#40 $stop; 
	end

	always #5 clk = ~clk;

endmodule 