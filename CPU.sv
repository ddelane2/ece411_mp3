import lc3b_types::*;

module CPU
(
    input clk,

    /* Memory signals */
    input mem_resp_a,
    input lc3b_word mem_rdata_a,
    output mem_read_a,
    output mem_write_a,
    output lc3b_mem_wmask mem_byte_enable_a,
    output lc3b_word mem_address_a,
    output lc3b_word mem_wdata_a,
	 
	 input mem_resp_b,
    input lc3b_word mem_rdata_b,
    output mem_read_b,
    output mem_write_b,
    output lc3b_mem_wmask mem_byte_enable_b,
    output lc3b_word mem_address_b,
    output lc3b_word mem_wdata_b
);
//**********************************************
/* Internal Signals */
lc3b_opcode opcode;
logic branch_enable;
logic load_cc, load_ir, load_mar, load_mdr, load_pc, load_regfile;
logic storemux_sel, destmux_sel, offsetmux_sel, leamux_sel, adj6mux_sel;
logic A, D;
logic regfilemux_sel, mdrmux_sel; 
logic pcmux_sel, alumux_sel;
lc3b_aluop aluop;
lc3b_word instruction; //JSR
lc3b_word alu_out;
lc3b_control_word ctrl_word;

/* Top Level Blocks */

/*
control controlunit
(
	.clk,
	.control_word_ctrl(ctrl_word),
	.opcode(opcode),
	.branch_enable(branch_enable),
	.instruction(instruction),
	.alu_out(alu_out),
	//.A(A),
	//.D(D),
	.load_pc(load_pc),
	.load_ir(load_ir),
	.load_regfile(load_regfile),
	.load_mar(load_mar),
	.load_mdr(load_mdr),
	.load_cc(load_cc),
	.pcmux_sel(pcmux_sel),
	.storemux_sel(storemux_sel),
	.alumux_sel(alumux_sel),
	//.aluothermux_sel(aluothermux_sel), //addd
	.regfilemux_sel(regfilemux_sel),
	.mdrmux_sel(mdrmux_sel),
	.leamux_sel(leamux_sel),
	.destmux_sel(destmux_sel),
	.offsetmux_sel(offsetmux_sel),
	.adj6mux_sel(adj6mux_sel),
	.aluop(aluop),

/* memory signals 
	.mem_resp_a,
	.mem_read_a,
	.mem_write_a,
	.mem_byte_enable_a,
	.mem_resp_b,
	.mem_read_b,
	.mem_write_b,
	.mem_byte_enable_b
);
*/

datapath datapathunit
(
    .clk,

    /* control signals */
	 .control_word_ctrl(ctrl_word),
	.load_pc(load_pc),
	.load_ir(load_ir),
	.load_regfile(load_regfile),
	.load_mar(load_mar),
	.load_mdr(load_mdr),
	.load_cc(load_cc),
	.pcmux_sel(pcmux_sel),
	.storemux_sel(storemux_sel),
	.alumux_sel(alumux_sel),
	//.aluothermux_sel(aluothermux_sel), //addd
	.regfilemux_sel(regfilemux_sel),
	.mdrmux_sel(mdrmux_sel),
	.leamux_sel(leamux_sel),
	.destmux_sel(destmux_sel),
	.offsetmux_sel(offsetmux_sel),
	.adj6mux_sel(adj6mux_sel),
	.aluop(aluop),
	.opcode(opcode),
	.branch_enable(branch_enable),
	.mem_rdata_a,
	.mem_address_a,  // output port
	.mem_wdata_a, // output port, regfilemux, IR
	.mem_rdata_b,
	.mem_address_b,  // output port
	.mem_wdata_b, // output port, regfilemux, IR
	.instruction(instruction),
	//.alu_out(alu_out),
	.A(A),
	.D(D)
);

control_rom control_rom
(
	//.opcode(lc3b_opcode'(mem_wdata_a[15:12])),
	.opcode(lc3b_opcode'(mem_rdata_a[15:12])),
	.ctrl(ctrl_word)
);


endmodule : CPU
