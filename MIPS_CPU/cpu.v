/*
	Grupo 15:
	Eduardo José de Souza Castro - 2021009360
	
-------------------------------------------------------------------------------------------------------------------------------------------------------
	
	RESPOSTAS
	
	a) Cinco períodos de clock, pois há 5 estágios de pipeline.
	
	b) Uma instrução a cada 5 pulsos de clock 32bits/5*CLK_SYS.
	
	c) - FPGA:  Cyclone IV GX EP4CGX150DF31I7AD
		- Máxima Frequência do Multiplicador: 179.79 MHz.(Slow 1200mV 100C Model)
		- Máxima Frequência do Sistema: 46.25 MHz. (Slow 1200mV 100C Model)
	
	d) - FPGA:  Cyclone IV GX EP4CGX150DF31I7AD
		- Máxima Frequência do Sistema = Frequência Multiplicador / 34
			Máxima Frequência do Sistema = (178.79 MHz/34)(Slow 1200mV 100C Model) = 5.26 MHz   
	
	e) Provavelmente não haverá problemas de metaestabilidade, porque, como as frequencias de clock dos dois
		circuitos são múltiplas, o controle de fase executado pela PLL já consegue inibir essa situação. 
		Além disso, se algo ocorrer com a operação da pll ela consegue avisar que há algum problema.
		
	f) O multiplicador é eficiente do ponto de vista da frequência máxima de operação, porém sua latência 
		também é muito alta diminuindo a frequência total do sistema.
	
	g) Explorar diferentes algoritmos para o multiplicador. Adicionar mais estágios ao pipeline pode melhorar 
		a eficiência (por exemplo, uma instrução a cada 38 ciclos de clock). Fazer um trade-off entre área e 
		velocidade, utilizando registradores de 64 bits. Isso poderia dobrar o throughput se combinado com outro 
		algoritmo de multiplicação. Vale ressaltar que a FPGA atualmente não está sendo utilizada nem perto de 
		sua capacidade total. Considerar um pipeline em paralelo, com 5 instruções a cada ciclo de clock do sistema, 
		pode ser uma opção interessante.
	
*/

module cpu(
	input CLK,
	input reset,
	output[31:0] ADDR,
	output[31:0] ADDR_Prog,
	input [31:0] Data_BUS_READ,
	input [31:0] Prog_BUS_READ,
	output[31:0] Data_BUS_WRITE,
	output WE,
	output CS,
	output CS_P
);

	wire cs;
	wire cs_p;
	wire idle;
	wire done;
	wire locked;
	wire we_datamemory;
	wire [9:0]address_datamemory;
	wire zeroflag, jmpFlag;
	wire [31:0] jmpAddress;
	wire [15:0] branchOffset;
	(*keep=1*)wire CLK_MUL;
	(*keep=1*)wire CLK_SYS;
	
	wire[31:0] inst_mem_ad;
	wire[31:0] inst_mem_decode;
	wire[31:0] inst_prog;
	wire[31:0] extended_inst;
	wire[31:0] imm_out;
	wire[31:0] ctrl;
	wire[31:0] reg1_ctrl;
//	wire[31:0] ctrl2_out;
	wire[31:0] ctrl_wb;
	wire[31:0] a_register_value;
	wire[31:0] b_register_value;
	wire[31:0] mux2_alu;
	wire[31:0] MUX5_INST;
	wire[31:0] mux4_mux5;
	(*keep=1*)wire[31:0] writeBack;
	wire[31:0] alu_result;
	wire[31:0] product;
	wire[31:0] mux3_regD;
	wire[31:0] a_register_out;
	wire[31:0] b_register_out;
	wire[31:0] regD_write_back;
	wire[31:0] memory_data;
	wire[31:0] instruction;

	assign ADDR = mux3_regD;
	assign Data_BUS_WRITE = b_register_out;
	assign WE = reg1_ctrl[14];
	assign CS = cs;
	assign ADDR_Prog = inst_mem_ad;
	assign CS_P = cs_p;
	
	ADDRDecoding ADDR_DEC(.address(mux3_regD), 
								 .clk(CLK_SYS), 
								 .cs(cs),
								 .we_ctrl(reg1_ctrl[14]), 
								 .address_out(address_datamemory), 
								 .we(we_datamemory));
	
	ADDRDecoding_Prog ADDR_DEC_PROG(.address_in(inst_mem_ad), 
											  .address_out(inst_mem_decode), 
											  .clk(CLK_SYS), 
											  .cs_p(cs_p));
	
	alu ALU(.a(a_register_out), 
			  .b(mux2_alu), 
			  .zeroflag(zeroflag), 
			  .load(reg1_ctrl[16:15]), 
			  .out(alu_result));
	
	control CONTROL(.instruction(instruction), 
						 .ctrl(ctrl), 
						 .jmpAddress(jmpAddress), 
						 .jmpFlag(jmpFlag));
	
	datamemory DATA_MEM(
		.address(address_datamemory),
		.in(b_register_out),
		.we(we_datamemory), 
		.clk(CLK_SYS),
		.out(memory_data)
	);
	
	extend EXTEND(.rst(reset), .clk(CLK_SYS), .data(instruction[15:0]), .out(extended_inst));
	
	instructionmemory	instructionmemory_inst (
		.address ( inst_mem_decode ),
		.clock ( CLK_SYS ),
		.q ( inst_prog )
	);

	multiplicador mul(
		.St(reg1_ctrl[12]),
		.Clk(CLK_MUL),
		.reset(reset),
		.Multiplicando(a_register_out[15:0]), 
		.Multiplicador(b_register_out[15:0]),
		.Idle(idle),
		.Done(done),
		.Produto(product)
	);
	
	mux MUX1(	.a(inst_prog), 
				.b(Prog_BUS_READ), 
				.sel(cs_p), 
				.out(instruction));  //MUX Instruction Fetch

	mux MUX2(	.a(b_register_out), 
				.b(imm_out), 
				.sel(reg1_ctrl[11]), 
				.out(mux2_alu)); 		//MUX entrada ALU (Execute)

	mux MUX3(	.a(alu_result), 
				.b(product), 
				.sel(reg1_ctrl[12]), 
				.out(mux3_regD)); 	//MUX result ALU e mult (Execute)

	mux MUX4(	.a(memory_data), 
				.b(Data_BUS_READ), 
				.sel(ctrl_wb[0]), 
				.out(mux4_mux5)); 	//Penúltimo mux datamemory e dataBUSREAD (Write Back)

	mux MUX5(	.a(regD_write_back), 
				.b(mux4_mux5), 
				.sel(ctrl_wb[10]), 
				.out(writeBack)); 	//Mux final write back (Write Back)

	
	pc PC(.rst(reset), 
			.clk(CLK_SYS), 
			.zeroflag(zeroflag), 
			.jmpFlag(jmpFlag), 
			.jmpAddress(jmpAddress),
			.branchFlag(reg1_ctrl[9]), 
			.branchOffset(imm_out),
			.out(inst_mem_ad));
	
	Register CTRL1(.rst(reset), .clk(CLK_SYS), .in(ctrl), .out(reg1_ctrl));				  		//Primeiro ctrl
	Register IMM(.rst(reset), .clk(CLK_SYS), .in(extended_inst), .out(imm_out));		  		//IMM register
	//Register REG2(.rst(reset), .clk(CLK_SYS), .in(reg1_ctrl), .out(ctrl2_out)); 		  	//Segundo ctrl
	Register CTRL2(.rst(reset), .clk(CLK_SYS), .in({reg1_ctrl[31:1], cs}), .out(ctrl_wb)); //Segundo 2 ctrl
	Register A(.rst(reset), .clk(CLK_SYS), .in(a_register_value), .out(a_register_out));   //Registro A
	Register B(.rst(reset), .clk(CLK_SYS), .in(b_register_value), .out(b_register_out));  	//Registro B
	Register D(.rst(reset), .clk(CLK_SYS), .in(mux3_regD), .out(regD_write_back));  			//Registro D
	
	registerfile REG_FILE(
		.data(writeBack),
		.clk(CLK_SYS),
		.we(ctrl_wb[13]),
		.rs(ctrl[31:27]), 
		.rt(ctrl[26:22]),
		.rd(ctrl[21:17]),
		.a(a_register_value),
		.b(b_register_value)
	);
					
	PLL PLL(.areset(1'b0), .inclk0(CLK), .c0(CLK_SYS), .c1(CLK_MUL), .locked(locked));

endmodule
