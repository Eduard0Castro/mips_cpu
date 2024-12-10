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
		-	Máxima Frequência do Sistema = Frequência Multiplicador / 34
			Máxima Frequência do Sistema = (178.79 MHz/34)(Slow 1200mV 100C Model) = 5.26 MHz   
	
	e) Provavelmente não haverá problemas de metaestabilidade, porque, como as frequencias de clock dos dois
		circuitos são múltiplas, o controle de fase executado pela PLL já consegue inibir essa situação. Além disso, 
		se algo ocorrer com a operação da pll ela consegue avisar que há algum problema.
		
	f) O multiplicador é eficiente do ponto de vista da frequência máxima de operação, porém sua latência também é muito alta diminuindo 
	a frequência total do sistema.
	
	g) Explorar diferentes algoritmos para o multiplicador. Adicionar mais estágios ao pipeline pode melhorar a eficiência (por exemplo, 
	uma instrução a cada 38 ciclos de clock). Fazer um trade-off entre área e velocidade, utilizando registradores de 64 bits. Isso poderia 
	dobrar o throughput se combinado com outro algoritmo de multiplicação. Vale ressaltar que a FPGA atualmente não está sendo utilizada nem 
	perto de sua capacidade total. Considerar um pipeline em paralelo, com 5 instruções a cada ciclo de clock do sistema, pode ser uma opção 
	interessante.
	
*/

module cpu(
	input CLK,
	input reset,
	output[31:0] ADDR,
	output[31:0] ADDR_Prog,
	input [31:0] Data_BUS_READ,
	input [31:0] Prog_BUS_READ,
	output[31:0] Data_BUS_WRITE,
	output WR_RD,
	output CS,
	output CS_P
);

	wire cs;
	wire cs_p;
	wire idle;
	wire done;
	wire locked;
	(*keep=1*)wire CLK_MUL;
	(*keep=1*)wire CLK_SYS;
	
	wire[31:0] inst_mem_ad;
	wire[31:0] inst_mem_decode;
	wire[31:0] inst_prog;
	wire[31:0] extended_inst;
	wire[31:0] ctrl;
	wire[31:0] reg1_ctrl;
	wire[31:0] reg2_reg3;
	wire[31:0] ctrl_write_back;
	wire[31:0] register_1;
	wire[31:0] register_2;
	wire[31:0] mux1_alu;
	wire[31:0] MUX5_INST;
	wire[31:0] mux3_mux2;
	(*keep=1*)wire[31:0] writeBack;
	wire[31:0] mux4_reg5;
	wire[31:0] alu_result;
	wire[31:0] product;
	wire[31:0] register_address;
	wire[31:0] register_2_value;
	wire[31:0] reg6_write_back;
	wire[31:0] memory_data;
	wire[31:0] instruction;

	assign ADDR = register_address;
	assign Data_BUS_WRITE = register_2_value;
	assign WR_RD = reg2_reg3[14];
	assign CS = cs;
	assign ADDR_Prog = inst_mem_ad;
	assign CS_P = cs_p;
	
	ADDRDecoding ADDR_DEC(.address(register_address), .clk(CLK_SYS), .cs(cs));
	
	ADDRDecoding_Prog ADDR_DEC_PROG(.address_in(inst_mem_ad), .address_out(inst_mem_decode), .clk(CLK_SYS), .cs_p(cs_p));
	
	alu ALU(.a(register_1), .b(mux1_alu), .load(reg1_ctrl[16:15]), .out(alu_result));
	
	control CONTROL(.instruction(instruction), .ctrl(ctrl));
	
	datamemory DATA_MEM(
		.address(register_address[9:0]),
		.in(register_2_value),
		.we(reg2_reg3[14]), 
		.clk(CLK_SYS),
		.out(memory_data)
	);
	
	extend EXTEND(.rst(reset), .clk(CLK_SYS), .data(inst_prog[15:0]), .out(extended_inst));
	
	instructionmemory INST_MEM(.address(inst_mem_decode), .clk(CLK_SYS), .out(inst_prog));

	multiplicador mul(
		.St(reg1_ctrl[12]),
		.Clk(CLK_MUL),
		.reset(reset),
		.Multiplicando(register_1[15:0]), 
		.Multiplicador(register_2[15:0]),
		.Idle(idle),
		.Done(done),
		.Produto(product)
	);
	
	mux MUX1(.a(register_2), .b(extended_inst), .sel(reg1_ctrl[11]), .out(mux1_alu));

	mux MUX2(.a(reg6_write_back), .b(mux3_mux2), .sel(ctrl_write_back[10]), .out(writeBack));

	mux MUX3(.a(memory_data), .b(Data_BUS_READ), .sel(cs), .out(mux3_mux2));

	mux MUX4(.a(alu_result), .b(product), .sel(reg1_ctrl[12]), .out(mux4_reg5));

	mux MUX5(.a(inst_prog), .b(Prog_BUS_READ), .sel(cs_p), .out(instruction));
	
	pc PC(.rst(reset), .clk(CLK_SYS), .out(inst_mem_ad));
	
	Register REG1(.rst(reset), .clk(CLK_SYS), .in(ctrl), .out(reg1_ctrl));
	Register REG2(.rst(reset), .clk(CLK_SYS), .in(reg1_ctrl), .out(reg2_reg3));
	Register REG3(.rst(reset), .clk(CLK_SYS), .in(reg2_reg3), .out(ctrl_write_back));
	Register REG4(.rst(reset), .clk(CLK_SYS), .in(register_2), .out(register_2_value));
	Register REG5(.rst(reset), .clk(CLK_SYS), .in(mux4_reg5), .out(register_address));
	Register REG6(.rst(reset), .clk(CLK_SYS), .in(register_address), .out(reg6_write_back));
	
	registerfile REG_FILE(
		.data(writeBack),
		.clk(CLK_SYS),
		.rst(reset),
		.we(ctrl_write_back[13]),
		.rs(ctrl[31:27]), 
		.rt(ctrl[26:22]),
		.rd(ctrl_write_back[21:17]),
		.a(register_1),
		.b(register_2)
	);
					
	PLL PLL(.areset(1'b0), .inclk0(CLK), .c0(CLK_SYS), .c1(CLK_MUL), .locked(locked));

endmodule
