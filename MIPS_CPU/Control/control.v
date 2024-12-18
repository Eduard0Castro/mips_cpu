module control (
	input[31:0] instruction, 
	output[31:0] ctrl,
	output [31:0] jmpAddress,
	output reg jmpFlag
);

reg [4:0] rs;    
reg [4:0] rt;
reg [4:0] rd;
reg [5:0] opcode;
reg [1:0] load;
reg we_datamemory, we_registerfile, sel_mux3, sel_mux2, sel_mux5;
reg branchFlag;

assign ctrl = {rs, rt, rd, load, we_datamemory, 
			      we_registerfile, sel_mux3, sel_mux2, sel_mux5, branchFlag,
			      9'b0}; 
					
assign jmpAddress = {6'b000000, instruction[25:0]};

always @ (instruction) 
	begin
		opcode = instruction[31:26];
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
		
		case (opcode)
		
			//Instruction of type I
			32'd47: //LW
				begin 
					rd = rt;
					sel_mux2 = 1;
					sel_mux5 = 1;
					we_registerfile = 1;
				end
				
			32'd48: //SW
				begin
					rd = 0;
					sel_mux2 = 1;
					sel_mux5 = 1;
					we_datamemory = 1;
				end
				
			32'd49: //BNE
				begin
					rd = 0;
					branchFlag = 1;
					load = 2'b01;
				end
				
			32'd50: //ADDI
				begin
					rd = rt;
					sel_mux2 = 1;
				end
				
			32'd51: //ORI
				begin
					rd = rt;
					load = 2'b11;
					sel_mux2 = 1;
				end
				
				
			//Instructions of type R:
			32'd25: //Normal ALU and MUL operations
				begin
					we_registerfile = 1;
					
					case(instruction[5:0])
						
						6'd50: sel_mux3 = 1; //MUL
						6'd32: load = 2'b00; //ADD
						6'd34: load = 2'b01; //SUB
						6'd36: load = 2'b10; //AND
						6'd37: load = 2'b11; //OR
						default: 
							begin
								rs = 0;
								rt = 0;
								rd = 0;
								we_registerfile = 0;
							end
					endcase
				end
			
			32'd02: //JMP
				begin
					jmpFlag = 1;
					rs = 0;
					rt = 0;
					rd = 0;
				end
				
			default:
				begin				
					rs = 0;
					rt = 0;
					rd = 0;					
				end
						
		endcase				
	end

endmodule
