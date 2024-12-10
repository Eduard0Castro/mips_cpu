module CONTROL (
	input Clk, K, St, M, reset,
	output reg Idle, Done, Load, Sh, Ad
);

	reg	[1:0] state;

	// Declare states
	parameter S0 = 0, S1 = 1, S2 = 2, S3 = 3;

	// Output depends only on the state
	always @ (state, St) begin
				Idle = 0;
				Done = 0;
				Load = 0;
				Sh = 0;
				Ad = 0;
		
		case (state)
			S0: begin
				Done = 0;
				Sh = 0;
				Ad = 0;
				Idle = 1;
				
				if(St) begin
					Load = 1;
				end
			end

			S1: begin
				Load = 0;
				Idle = 0;
				Sh = 0;
				if (M) begin
					Ad = 1;
				end
				else begin
					Ad = 0;
				end
			end

			S2: begin
				Sh = 1;
				Ad = 0;
			end

			S3: begin
				Done = 1;
				Sh = 0;
				Ad = 0;
			end
			
		endcase
	end

	// Determine the next state
	always @ (posedge Clk) begin
		if(reset) state <= S0;
		case (state)
			S0: begin
				if(St)
					state <= S1;
				end
				
			S1: begin
				state <= S2;
			end
				
			S2: begin
				if (K)
					state <= S3;
				else
					state <= S1;
			end
				
			S3: begin
				if(Done)
					state <= S0;
			end
			
			default: state <= S0;
			endcase
	end
	
endmodule
