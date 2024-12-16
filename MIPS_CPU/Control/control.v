module control (
	input[31:0] instruction, 
	output[31:0] ctrl,
	output [31:0] jmpAddress,
	output reg jmpFlag
);

reg [4:0] rs;    
reg [4:0] rt;
reg [4:0] rd;
reg [1:0] load;
reg we_datamemory, we_registerfile, sel_mux3, sel_mux2, sel_mux5;
reg branchFlag;

assign ctrl = {rs, rt, rd, load, we_datamemory, 
			      we_registerfile, sel_mux3, sel_mux2, sel_mux5, branchFlag,
			      9'b0}; 
					
assign jmpAddress = {6'b000000, instruction[25:0]};

always @ (instruction) 
	begin
		rs = instruction[25:21];
		rt = instruction[20:16];
		rd = instruction[15:11];
		we_registerfile = 0;
		we_datamemory = 0;
		load = 2'b00; // ADD
		sel_mux3 = 0;
		sel_mux2 = 0;
		sel_mux5 = 0;
		jmpFlag = 0;
		branchFlag = 0;
		
		// Instrucoes I
		if(instruction[31:26] == 32'd47) 
			begin // LW - Grupo(15)+32 = 47
				rd = rt;
				sel_mux2 = 1;
				sel_mux5 = 1;
				sel_mux3 = 0;
				we_datamemory = 0;
				we_registerfile = 1;
				load = 2'b00; //Somar conteúdo de rs (registro A) com offset, que vem de B.
			end 
		
		else if(instruction[31:26] == 32'd48) 
			begin // SW - Grupo(15)+33 = 48
				rd = 0;
				sel_mux2 = 1;
				sel_mux5 = 1;
				sel_mux3 = 0;
				we_datamemory = 1;
				we_registerfile = 0;
			end
			
		else if (instruction[31:26] == 32'd49)
			begin // BNE - Grupo (15) + 34 = 49
				rd = 0;
				branchFlag = 1;
				load = 2'b01;
				
			end
		
		// Instruções R
		else if(instruction[31:26] == 32'd25) 
			begin // Grupo(15)+10 = 25
			
				we_registerfile = 1;
				sel_mux2 = 0;
				sel_mux5 = 0;
				
				if(instruction[5:0] == 50) //MUL
					begin 
						sel_mux3 = 1;
					end
					
				else if (instruction[5:0] == 32) //ADD
					begin 
						load = 2'b00;
						sel_mux3 = 0;
					end
					
				else if(instruction[5:0] == 34) //SUB
					begin 
						load = 2'b01;
						sel_mux3 = 0;
					end
					
				else if(instruction[5:0] == 36) //AND
					begin 
						load = 2'b10;
						sel_mux3 = 0;
					end
				else if(instruction[5:0] == 37) //OR
					begin 
						load = 2'b11;
						sel_mux3 = 0;
					end
				else 
					begin
						rs = 0;
						rt = 0;
						rd = 0;
						we_registerfile = 0;
					end
			end 
			
		else if (instruction[31:26] == 32'd02) //JMP - 02
			begin
				jmpFlag = 1;
				rs = 0;
				rt = 0;
				rd = 0;
				we_registerfile = 0;
				we_datamemory = 0;
			
			end
		else 
			begin
				rs = 0;
				rt = 0;
				rd = 0;
			end
	end

endmodule
