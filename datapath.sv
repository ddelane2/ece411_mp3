import lc3b_types::*;
//test
module datapath
(
    input clk,

	 /* ROM */
	 input lc3b_control_word control_word_ctrl,
	 
    /* control signals */
    input pcmux_sel,
    input load_pc,
	 input load_ir,
	 input load_regfile,
	 input load_mar,
	 input load_mdr,
	 input load_cc,
	 input alumux_sel,
	 input regfilemux_sel,
	 input mdrmux_sel,
	 input storemux_sel,
	 input leamux_sel,
	 input destmux_sel,
	 input offsetmux_sel,
	 input adj6mux_sel,
	 input lc3b_aluop aluop,
	 output lc3b_opcode opcode,  
	 output logic branch_enable,  
	 output logic A,
	 output logic D,
	 
    /* declare more ports here */
	 input lc3b_word mem_rdata_a, // mdrmux
	 output lc3b_word mem_address_a,  // output port
 	 output lc3b_word mem_wdata_a,  // output port, regfilemux, IR
	 
	 input lc3b_word mem_rdata_b, // mdrmux
	 output lc3b_word mem_address_b,  // output port
 	 output lc3b_word mem_wdata_b,  // output port, regfilemux, IR
	 
	 output lc3b_word instruction  //instruction given to IR
	 );

/* declare internal signals */
lc3b_offset6 offset6;  // adj6
lc3b_offset9 offset9; //IR adj9
lc3b_word adj5_out;
lc3b_word adj6_out;  //adj6 alumux
lc3b_word adj9_out;  //adj9 br_add
//lc3b_word adj11_out; //jsr
//lc3b_word imm4; //shf
lc3b_word imm5; //immediate add/and
lc3b_word pcmux_out;  //pcmux PC
lc3b_word alumux_out;  //alumux ALU
lc3b_word regfilemux_out;  //regfilemux regfile, gencc
//lc3b_word marmux_out;  //marmux MAR
lc3b_word mdrmux_out;  //mdrmux MDR
//lc3b_word aluothermux_out;
//lc3b_word leamux_out;
lc3b_reg destmux_out;
//lc3b_word offsetmux_out;
lc3b_word pc_out;  //PC pc_plus2, br_add, marmux
lc3b_word pc_off9_out;  //br_add pc_mux
//lc3b_word pc_off11_out; //pc + offset11
lc3b_word pc_plus2_out;  // pc_mux
//lc3b_word adj8_zext_out;	//trap
//lc3b_word lsb_write_out; //ldb
lc3b_word adj6mux_out;
lc3b_nzp gencc_out;  // CC
lc3b_nzp cc_out;  // cccomp
lc3b_word aluothermux_out;




//storemux
lc3b_reg sr1, sr2;	
lc3b_reg dest;
lc3b_reg storemux_out;
lc3b_word sr1_out;  // ALU
lc3b_word sr2_out;  // alumux

//*******************************************************************NEW DATAPATH BELOW*************************************************************************************************************************

//if/id signals
lc3b_word mem_rdata_if_id_ff;
lc3b_word pc_plus2_if_id_ff;
lc3b_control_word control_word_if_id_ff;
lc3b_control_word test_out, test_out2;

//id/ex signals
lc3b_reg dest_id_ex_ff;
lc3b_control_word control_word_id_ex_ff;
lc3b_word adj5_id_ex_ff;
lc3b_word adj6_id_ex_ff;
lc3b_word adj9_id_ex_ff;
lc3b_word sr2_id_ex_ff;
lc3b_word sr1_id_ex_ff;
lc3b_word pc_plus2_id_ex_ff;
logic aluothermux_sel;
lc3b_word mem_rdata_id_ex_ff;
lc3b_reg dest_id_ex_out_ff;


//ex/mem signals
lc3b_word adder_out;
lc3b_word adder_out_ff;
lc3b_word alu_out;
lc3b_control_word control_ex_mem_in_ff;
lc3b_control_word control_ex_mem_out_ff;
lc3b_reg dest_out;
lc3b_reg dest_ex_mem_out_ff;


//mem/wb signals
lc3b_control_word control_mem_wb_in_ff;
lc3b_word mem_address_mem_wb_ff;
lc3b_word mem_wdata_mem_wb_ff;
lc3b_control_word control_mem_wb_out_ff;
lc3b_reg dest_mem_wb_out_ff;

//if id stage
if_id_flipflop if_id_flipflop
(
	  .clk,
     .pc_plus2_in_ff(pc_plus2_out),
	  .control_if_id_in_ff(control_word_ctrl),	//comes from control
	  //.mem_wdata_in_ff(mem_wdata_a),
	  .mem_rdata_in_ff(mem_rdata_a),
	  .pc_plus2_out_ff(pc_plus2_if_id_ff),
	  .control_if_id_out_ff(control_word_if_id_ff),
	  //.mem_wdata_out_ff(mem_wdata_if_id_ff)lc3b_word adj6_out;
	  .mem_rdata_out_ff(mem_rdata_if_id_ff),
		.opcode(opcode),	//used here instead of instruction register
		.dest(dest), 
		.src1(sr1), 
		.src2(sr2),
		.offset6(offset6),
		.offset9(offset9),
		.A(A),
		.D(D),
		.instruction(instruction)
);

mux2 pcmux //jsr
(
    //.sel(control_word_ctrl.pcmux_sel),
	 .sel(control_word_ctrl.pcmux_sel),
    .a(pc_plus2_out),
    .b(adder_out_ff),
    .f(pcmux_out)
);

plus2 pc_plus2
(
	.in(mem_address_a),
	.out(pc_plus2_out)
);

register pc
(
    .clk,
    //.load(control_word_ctrl.load_pc),
	 .load(1'b1),
    .in(pcmux_out),
    .out(mem_address_a)
);

//id ex stage
id_ex_flipflop id_ex_flipflop
(
    .clk,
    .pc_plus2_in_ff(pc_plus2_if_id_ff),
	 .sr1_in_ff(sr1_out),
	 .sr2_in_ff(sr2_out),
	 .dest_in_ff(dest),
	 .adj5_in_ff(adj5_out),
	 .adj6_in_ff(adj6_out),
	 .adj9_in_ff(adj9_out), 
	 .mem_wdata_in_ff(mem_rdata_if_id_ff),
	 //.control_id_ex_in_ff(control_word_if_id_ff), //***
	 .control_id_ex_in_ff(control_word_if_id_ff),
	 .pc_plus2_out_ff(pc_plus2_id_ex_ff),
	 .sr1_out_ff(sr1_id_ex_ff),
	 .sr2_out_ff(sr2_id_ex_ff),
	 .dest_out_ff(dest_id_ex_ff),
	 .adj5_out_ff(adj5_id_ex_ff),
	 .adj6_out_ff(adj6_id_ex_ff),
	 .adj9_out_ff(adj9_id_ex_ff),
	 .control_id_ex_out_ff(control_word_id_ex_ff),
	 .mem_wdata_out_ff(mem_rdata_id_ex_ff),
	 .aluothermux_sel,
	 .dest_id_ex_in_ff(destmux_out),
	 .dest_id_ex_out_ff

);

//ir ir_unit		//WHERE IS PC INPUT FOR ADDRESS IN INSTRUCTION MEMORY? ***
//( 
//	.clk,
//	.load(1'b1),
//	//.in(mem_rdata_if_id_ff),
//	.in(mem_rdata_id_ex_ff),
//	.opcode(opcode),
//	.dest(dest), 
//	.src1(sr1), 
//	.src2(sr2),
//	.offset6(offset6),
//	.offset9(offset9),
//	.A(A),
//	.D(D),
//	.instruction(instruction)
//);

regfile registerfile
(
    .clk,
    .load(control_mem_wb_out_ff.load_regfile),
    .in(regfilemux_out),		//source register from storemux
    .src_a(storemux_out),
	 .src_b(sr2),
	 .dest(dest_mem_wb_out_ff), //***three bits??
    .reg_a(sr1_out),
	 .reg_b(sr2_out)
);


mux2 #(.width(3)) storemux
(
	.sel(control_word_if_id_ff.storemux_sel),
	.a(sr1),
	.b(dest),
	.f(storemux_out)
);

mux2 #(.width(3)) destmux 
(
	.sel(control_word_if_id_ff.destmux_sel),
	.a(dest),
	.b(3'b111),	//R7
	.f(destmux_out)
);

adj_u #(.width(5)) adj5
(
	.in(offset6[4:0]),
	.out(adj5_out)	
);

adj #(.width(6)) adj6 
(
	.in(offset6),
	.out(adj6_out)	
);

adj #(.width(9)) adj9	//SIGN EXTENDED TO 32 BITS? ***
(
	.in(offset9),
	.out(adj9_out)	
);

//ex mem stage
ex_mem_flipflop ex_mem_flipflop
(
    .clk,
    .adder_in_ff(adder_out),
    .alu_in_ff(alu_out),
    .control_ex_mem_in_ff(control_word_id_ex_ff),
    .adder_out_ff,
    .alu_out_ff(mem_address_b),
    .control_ex_mem_out_ff,
	 .mem_read_ex_mem(pmem_read_b),
	 .mem_write_ex_mem(pmem_write_b),
	 .dest_ex_mem_in_ff(dest_id_ex_out_ff),
	 .dest_ex_mem_out_ff,
	 .branch_enable(branch_enable)
);

mux2 #(.width(16)) alumux
(
    .sel(control_word_id_ex_ff.alumux_sel),
    .a(aluothermux_out),
    .b(adj6_id_ex_ff),
    .f(alumux_out)
);

mux2 aluother_mux	//add/and immediate5
(
	.sel(mem_rdata_id_ex_ff[5]), //***
	.a(sr2_id_ex_ff),
	.b(adj5_id_ex_ff),
	.f(aluothermux_out)	
);

alu alu
(
    .aluop(control_word_id_ex_ff.aluop),
    .a(sr1_id_ex_ff),
    .b(alumux_out),
    .f(alu_out)
);

adder adder
(
    .sr1(pc_plus2_id_ex_ff),
    .sr2(adj9_id_ex_ff),
    .sum(adder_out)
);

nzpcomp nzp
(
    .nzp(cc_out),
    .nzp_other(dest_id_ex_ff),
    .br_en(branch_enable)
);

register cc
(
    .clk,
    .load(control_word_id_ex_ff.load_cc),
    .in(gencc_out),
    .out(cc_out)
);

gencc gencc
(
    .in(regfilemux_out),
    .out(gencc_out)
);


//mem wb stage
mem_wb_flipflop mem_wb_flipflop
(
    .clk,
    .mem_address_in_ff(mem_address_b),
    .mem_wdata_in_ff(mem_wdata_b),
    .control_mem_wb_in_ff(control_ex_mem_out_ff),
    .mem_address_mem_wb_ff,
    .mem_wdata_mem_wb_ff,
    .control_mem_wb_out_ff,
	 .dest_mem_wb_in_ff(dest_ex_mem_out_ff),
	 .dest_mem_wb_out_ff
);

mux2 mdrmux
(
    .sel(control_ex_mem_out_ff.mdrmux_sel),
    .a(mem_address_b),
    .b(mem_rdata_b),
    .f(mem_wdata_b)
);

//used after mem/wb
mux2 regfilemux
(
    .sel(control_mem_wb_out_ff.regfilemux_sel),
    .a(mem_address_mem_wb_ff),
    .b(mem_wdata_mem_wb_ff),
    .f(regfilemux_out)
);


//******************************************************************OLD DATAPATH BELOW*************************************************************************************************************************
/* PC */
/*
mux4 pcmux //jsr
(
    .sel(pcmux_sel),
    .a(pc_plus2_out),
    .b(mem_wdata),
	 .c(sr1_out),
	 .d(offsetmux_out), //JSR offsetmux_out (11)
    .f(pcmux_out)
);

mux2 #(.width(3)) storemux
(
	.sel(storemux_sel),
	.a(sr1),
	.b(dest),
	.f(storemux_out)
);

mux4 marmux	//trap
(
.sel(marmux_sel),
.a(alu_out),
.b(pc_out),
.c(adj8_zext_out), //trap
.d(16'b0),
.f(marmux_out)
);

mux4 mdrmux	//stb
(
.sel(mdrmux_sel),
.a(alu_out),
.b(mem_rdata),
//.c({8'b0, sr1_out[7:0]}), //stb
.c(sr1_out), //stb
.d(16'b0),
.f(mdrmux_out)
);

mux2 adj6mux	//ldb
(
	.sel(adj6mux_sel),
	.a(adj6_out),
	.b(adj6_out >> 1), //ldb
	.f(adj6mux_out)
);

register mar
(
	.clk,
	.load(load_mar),
	.in(marmux_out),
	.out(mem_address)
);

register mdr
(
	.clk,
	.load(load_mdr),
	.in(mdrmux_out),
	.out(mem_wdata)
);


regfile registerfile
(
    .clk,
    .load(load_regfile),
    .in(regfilemux_out),		//source register from storemux
    .src_a(storemux_out),
	 .src_b(sr2),
	 .dest(destmux_out), //***three bits??
    .reg_a(sr1_out),
	 .reg_b(sr2_out)
);

mux4 alumux
(
	.sel(alumux_sel),
	.a(aluothermux_out),
	.b(adj6mux_out),
	.c(imm4), //shf
	.d(16'b0),
	.f(alumux_out)
);

mux2 aluother_mux	//add/and immediate5
(
	.sel(instruction[5]),
	.a(sr2_out),
	.b(imm5),
	.f(aluothermux_out)	
);

mux2 leamux //lea
(
	.sel(leamux_sel),
	.a(sr1_out),
	.b(pc_off9_out),
	.f(leamux_out)
);

mux2 offsetmux //ldb
(
	.sel(offsetmux_sel),
	.a(pc_off9_out),
	.b(pc_off11_out),
	.f(offsetmux_out)
);

mux2 #(.width(3)) destmux 
(
	.sel(destmux_sel),
	.a(dest),
	.b(3'b111),	//R7
	.f(destmux_out)
);

alu alu_unit
(	
	.aluop(aluop),
	.a(leamux_out),
	.b(alumux_out),
	.f(alu_out)
);

gencc genccunit
(
	.in(regfilemux_out),
	.out(gencc_out)
);

register cc
(
	.clk,
	.load(load_cc),
	.in(gencc_out),
	.out(cc_out)
);

nzpcomp nzpcompunit	
(
	.nzp(cc_out),
	.nzp_other(dest),
	.br_en(branch_enable)
);

mux4 regfilemux
(
	.sel(regfilemux_sel),
	.a(alu_out),
	.b(mem_wdata),
	.c(pc_out),
	.d(lsb_write_out),
	.f(regfilemux_out)
);

adj_u #(.width(4)) adj4 //shf
(
	.in(instruction[3:0]),
	.out(imm4)	
);

adj_u #(.width(5)) adj5
(
	.in(instruction[4:0]),
	.out(imm5)	
);

adj #(.width(6)) adj6 
(
	.in(offset6),
	.out(adj6_out)	
);

adj #(.width(9)) adj9
(
	.in(offset9),
	.out(adj9_out)	
);

adj #(.width(11)) adj11 //JSR
(
	.in(instruction[10:0]),
	.out(adj11_out)	
);

adj_8_zext #(.width(8))adj8_zext	//trap
(
	.in(instruction[7:0]),
	.out(adj8_zext_out)
);

ir ir_unit
( 
.clk,
.load(load_ir),
.in(mem_wdata),
.opcode(opcode),
.dest(dest), 
.src1(sr1), 
.src2(sr2),
.offset6(offset6),
.offset9(offset9),
.A(A),
.D(D),
.instruction(instruction)
);

adder pc_off9
(
		.sr1(adj9_out),
		.sr2(pc_out),
		.sum(pc_off9_out)
);

adder pc_off11//jsr
(
		.sr1(adj11_out),
		.sr2(pc_out),
		.sum(pc_off11_out)
);

register pc
(
    .clk,
    .load(load_pc),
    .in(pcmux_out),
    .out(pc_out)
);

plus2 pc_plus2
(
.in(pc_out),
.out(pc_plus2_out)
);

lsb_write lsb_write_unit //ldb
(
	.lsb(alu_out[0]),
	.in(mem_wdata),
	.out(lsb_write_out)
);*/

endmodule : datapath
