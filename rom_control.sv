import lc3b_types::*;
module control_rom
(
	input lc3b_opcode opcode,
	output lc3b_control_word ctrl
);

always_comb
begin
/* Default assignments */
	ctrl.opcode = opcode;
	ctrl.load_cc = 1'b0;
	ctrl.load_pc = 1'b0;
	ctrl.load_ir = 1'b0;
	ctrl.load_regfile = 1'b0;
	ctrl.pcmux_sel = 1'b0;
	ctrl.storemux_sel = 1'b0;
	ctrl.leamux_sel = 1'b0;
	ctrl.regfilemux_sel = 1'b0;
	ctrl.mdrmux_sel = 1'b0;
	ctrl.destmux_sel = 1'b0;
	ctrl.mem_read = 1'b0;
	ctrl.mem_write = 1'b0;
	ctrl.alumux_sel = 1'b0;

	
/* Assign control signals based on opcode */
		case(opcode)
		op_add: begin
			ctrl.aluop = alu_add;
			ctrl.load_regfile = 1'b1;
			ctrl.load_cc = 1'b1;
			
		end
		
		op_and: begin
		ctrl.aluop = alu_and;
		ctrl.load_regfile = 1'b1;
		ctrl.load_cc = 1'b1;

		end
		
		op_not: begin
		ctrl.aluop = alu_not;
		ctrl.load_regfile = 1'b1;
		ctrl.load_cc = 1'b1;

		end
		
		op_str: begin
		ctrl.aluop = alu_add;
		ctrl.storemux_sel = 1'b1;
		ctrl.mem_write = 1'b1;
		ctrl.alumux_sel = 1'b1;

		end
		
		op_ldr: begin
		ctrl.aluop = alu_add;
		ctrl.mem_read = 1'b1;
		ctrl.mdrmux_sel = 1'b1;
		ctrl.load_cc = 1'b1;
		ctrl.regfilemux_sel = 1'b1;
		ctrl.load_regfile = 1'b1;
		ctrl.alumux_sel = 1'b1; 
		ctrl.load_regfile = 1'b1;

		end
		
		op_br: ;
		
		
		default: begin
		ctrl = 0; /* Unknown opcode, set control word to zero */
		end
		endcase
end
endmodule : control_rom