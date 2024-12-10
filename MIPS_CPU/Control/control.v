module control (
	input[31:0] instruction, 
	output[31:0] ctrl
);

reg[4:0] rs;		     
reg[4:0] rt;
reg[4:0] rd;
reg [1:0] load;
reg we_datamemory, we_registerfile, start_sel_mux4, sel_mux1, sel_mux2;

assign ctrl = {rs, rt, rd, load, we_datamemory, we_registerfile, start_sel_mux4, sel_mux1, sel_mux2, 10'b0}; 

always @ (instruction) 
	begin
		rs = instruction[25:21];
		rt = instruction[20:16];
		rd = instruction[15:11];
		we_registerfile = 0;
		we_datamemory = 0;
		load = 2'b00; // ADD
		start_sel_mux4 = 0;
		sel_mux1 = 0;
		sel_mux2 = 0;
		
		// Instrucoes I
		if(instruction[31:26] == 32'd47) 
			begin // LW - Grupo(15)+32 = 47
				rd = rt;
				sel_mux1 = 1;
				sel_mux2 = 1;
				start_sel_mux4 = 0;
				we_datamemory = 0;
				we_registerfile = 1;
			end 
		
		else if(instruction[31:26] == 32'd48) 
			begin // SW - Grupo(15)+33 = 48
				rd = 0;
				sel_mux1 = 1;
				sel_mux2 = 1;
				start_sel_mux4 = 0;
				we_datamemory = 1;
				we_registerfile = 1;
			end
		
		// Instruções R
		else if(instruction[31:26] == 32'd25) 
			begin // Grupo(15)+10 = 25
			
				we_registerfile = 1;
				sel_mux1 = 0;
				sel_mux2 = 0;
				
				if(instruction[5:0] == 50) 
					begin //MUL
						start_sel_mux4 = 1;
					end
					
				else if (instruction[5:0] == 32) 
					begin //ADD
						load = 2'b00;
						start_sel_mux4 = 0;
					end
					
				else if(instruction[5:0] == 34) 
					begin //SUB
						load = 2'b01;
						start_sel_mux4 = 0;
					end
					
				else if(instruction[5:0] == 36) 
					begin //AND
						load = 2'b10;
						start_sel_mux4 = 0;
					end
				else if(instruction[5:0] == 37) 
					begin //OR
						load = 2'b11;
						start_sel_mux4 = 0;
					end
				else 
					begin
						rs = 0;
						rt = 0;
						rd = 0;
						we_registerfile = 0;
					end
			end 
		else 
			begin
				rs = 0;
				rt = 0;
				rd = 0;
			end
	end

endmodule
