module extend (
	input rst,
	input clk,
	input [15:0] data,
	output reg [31:0] out
	
);

always @ (posedge clk) 

	begin
		if(rst) 
			out <= 0;
		else
		
			begin
			
				if(data[15] == 0)
					out <= {16'h0, data[15:0]};
				else
					out <= {16'hffff, data[15:0]};
					
			end
	end
endmodule 