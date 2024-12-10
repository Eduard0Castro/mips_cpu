`timescale 1ns/100ps

module mux_TB();

	reg [31:0] a;
	reg [31:0] b;
	reg sel;
	wire [31:0] out;
	
	mux DUT (
		.a(a),
		.b(b),
		.sel(sel),
		.output(out)
	);
	
	initial 
	begin
		sel = 0;
		a = 32'h0000ffff;
		b = 32'hffff0000;
		#50 sel = 1;
		#50 $stop;
	end

endmodule 