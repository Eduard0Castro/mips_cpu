`timescale 1ns/100ps
module control_TB();
	reg  [31:0] instruction;
	wire [31:0] ctrl;
	wire [31:0] jmpAddress;
	wire jmpFlag;
		
	control DUT (
		.instruction(instruction),
		.ctrl(ctrl),
		.jmpAddress(jmpAddress),
		.jmpFlag(jmpFlag)
	);
	
	initial begin
		//formato i       opcode| rs  |  rt |        offset
		instruction = 32'b101111_00000_00001_0000_0000_0000_0000; // LW
		
		#50
		instruction = 32'b101111_00000_00010_0000_0000_0000_0001; // LW
		
		#50 
		instruction = 32'b110000_00001_00001_0000_0000_0000_0001; // SW
		
		#50 
		instruction = 32'b110000_00100_00010_0000_0000_0000_0000; // SW
		
		#50
		instruction = 32'b110001_00001_00010_0000_0000_0000_1000; //BNE
		
		#50
		instruction = 32'b110011_00000_11110_0000_0000_0010_0000; //ORI
		
		#50
		instruction = 32'b110010_00000_11111_0000_0000_0010_0000; //ADDI
		
		#50
		//formato R		 opcode  | rs  |  rt | rd  |     op
		instruction = 32'b011001_00001_00010_00011_01010_110010; //MUL
		
		#50
		instruction = 32'b011001_00001_00010_00110_01010_100000; //ADD
		
		#50
		instruction = 32'b011001_00001_00010_00111_01010_100010; //SUB
		
		#50
		instruction = 32'b011001_00001_00010_01000_01010_100100; //AND
		
		#50
		instruction = 32'b011001_00001_00010_01001_01010_100101; //OR
		
		
		//formato J      opcode |          address
		#50
		instruction = 32'b000010_000000_0000_0011_0011_1010_1111; //JMP
		
		//Instrução NOP:
		#50
		instruction = 32'd0;													 //NOP
		
		#50 $stop;
	end
	
endmodule
