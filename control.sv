import lc3b_types::*; /* Import types defined in lc3b_types.sv */

module control
(
/* Input and output port declarations */
	 
	 input clk,
	 input lc3b_control_word control_word_ctrl,
/* Datapath controls */
	input lc3b_opcode opcode,
	input branch_enable,
	input lc3b_word instruction, //JSR
	input lc3b_word alu_out,	//ldb
	//input A,	//shf
	//input D,	//shf
	//input lsb,	//ldb
	output logic load_pc,
	output logic load_ir,
	output logic load_regfile,
	output logic load_mar,
	output logic load_mdr,
	output logic load_cc,
	output logic pcmux_sel,
	output logic storemux_sel,
	output logic alumux_sel,
	output logic leamux_sel,
	output logic regfilemux_sel,
	output logic mdrmux_sel,
	output logic destmux_sel,
   output logic offsetmux_sel,
	output logic adj6mux_sel,
	output lc3b_aluop aluop,

/* Memory signals */
	input mem_resp_a,
	output logic mem_read_a,
	output logic mem_write_a,
	output lc3b_mem_wmask mem_byte_enable_a,
	
	input mem_resp_b,
	output logic mem_read_b,
	output logic mem_write_b,
	output lc3b_mem_wmask mem_byte_enable_b
	);
//
//enum int unsigned {
//    /* List of states */
//	fetch1,
//	fetch2,
//	fetch3,
//	decode,
//	s_add,
//	s_and,
//	s_not, 
//	s_br,
//	s_br_taken,
//	s_calculate_addr,
//	s_ldr1,
//	s_ldr2,
//	s_str1,
//	s_str2, 
//	s_lea,
//	s_jmp,
//	s_jsr_1,
//	s_jsr_2,
//	s_ldb,
//	s_trap_1,
//	s_trap_2,
//	s_trap_3,
//	s_sti_1,
//	s_sti_2,
//	s_sti_3,
//	s_sti_4,
//	s_ldi_1,
//	s_ldi_2,
//	s_ldi_3,
//	s_ldi_4,
//	s_stb_1,
//	s_stb_2,
//	s_ldb_1,
//	s_ldb_2,
//	s_shf
//	
//} state, next_state;
////
////always_comb
////	begin : state_actions
////		/* Default assignments */
////		load_pc = 1'b0;
////		load_ir = 1'b0;
////		load_regfile = 1'b0;
////		load_mar = 1'b0;
////		load_mdr = 1'b0;
////		load_cc = 1'b0;
////		pcmux_sel = 2'b00;
////		storemux_sel = 1'b0;
////		alumux_sel = 2'b00;
////		//aluothermux_sel = 1'b0; //addd
////		regfilemux_sel = 2'b00;
////		marmux_sel = 2'b00;
////		mdrmux_sel = 2'b00;
////		leamux_sel = 1'b0;
////		destmux_sel = 1'b0;
////		adj6mux_sel = 1'b0;
////		aluop = alu_add;
////		mem_read = 1'b0;
////		mem_write = 1'b0;
////		mem_byte_enable = 2'b11;
////		offsetmux_sel = 1'b0;
////
////	case(state)
//////			fetch1: begin
//////				/* MAR <= PC */
//////				marmux_sel = 2'b01;
//////				load_mar = 1;
//////				
//////				/* PC <= PC + 2 */
//////				pcmux_sel = 2'b00;
//////				load_pc = 1;
//////			end
//////
//////			fetch2: begin
//////				/* Read memory */
//////				mem_read = 1;
//////				mdrmux_sel = 2'b01;
//////				load_mdr = 1;
//////			end
//////			
//////			fetch3: begin
//////				/* Load IR */
//////				load_ir = 1;
//////			end
////
////			decode: /* Do nothing */;
////
////			/*s_add: begin	
////				aluop = alu_add;
////				load_regfile = 1;
////				load_cc = 1;
////			end
////
////			s_and: begin
////				aluop = alu_and;
////				load_regfile = 1;
////				regfilemux_sel = 2'b00;
////				load_cc = 1;
////			end
////			
////			s_not: begin
////				aluop = alu_not;
////				load_regfile = 1;
////				regfilemux_sel = 2'b00;
////				load_cc = 1;load_pc
////			end
////			
////			s_br: ;
////			
////			s_br_taken: begin 
////				load_pc = 1;
////				offsetmux_sel = 1'b0;
////				pcmux_sel = 2'b11;
////			end	
////			
////			s_calculate_addr: begin
////				storemux_sel = 0;
////				alumux_sel = 2'b01;	//calculate address
////				aluop = alu_add;
////				marmux_sel = 2'b00;
////				load_mar = 1;
////				if(opcode == op_ldb)	//***
////					adj6mux_sel = 1'b1;	//(no shift for offset6)
////			end
////
////			s_ldr1: begin	
////				load_mdr = 1;	
////				mem_read = 1;
////				mdrmux_sel = 2'b01;	
////					
////			end
////			
////			s_ldr2: begin
////				load_cc = 1;
////				regfilemux_sel = 2'b01;	
////				load_regfile = 1;		
////			end
////			
////			s_str1: begin  
////				aluop = alu_pass;
////				load_mdr = 1'b1;
////				storemux_sel = 1'b1;
////			end
////			
////			s_str2: begin
////				mem_write = 1;
////			end
////			
////			s_sti_1: begin		//store memory into mdr
////				mdrmux_sel = 2'b01;
////				load_mdr = 1'b1; 
////				mem_read = 1'b1;
////			end
////			
////			s_sti_2: begin		//store address into mar for a write 
////				marmux_sel = 2'b11;
////				load_mar = 1'b1;
////			end
////			
////			s_sti_3: begin		//store sr into mdr 
////				aluop = alu_pass;
////				load_mdr = 1'b1;fetch1: begin
//////				/* MAR <= PC */
//////				marmux_sel = 2'b01;
//////				load_mar = 1;
//////				
//////				/* PC <= PC + 2 */
//////				pcmux_sel = 2'b00;
//////				load_pc = 1;
//////			end
//////
//////			fetch2: begin
//////				/* Read memory */
//////				mem_read = 1;
//////				mdrmux_sel = 2'b01;
//////				load_mdr = 1;
//////			end
//////			
//////			fetch3: begin
//////				/* Load IR */
//////				load_ir = 1;
//////			end
//////				storemux_sel = 1'b1;
//////			end	
////			
//////			s_sti_4: begin	// write to memory
//////				mem_write = 1'b1;	
//////			end
//////		
//////			s_ldi_1: begin	//mar has baseR+(offset6<<1) address at this point
//////				mdrmux_sel = 2'b01;	//mdr <- data from memory
//////				load_mdr = 1'b1; 
//////				mem_read = 1'b1;
//////			end
//////			
//////			s_ldi_2: begin
//////				marmux_sel = 2'b11;		//mar <- mdr
//////				load_mar = 1'b1;		
//////			end
//////			
//////			s_ldi_3: begin
//////				mdrmux_sel = 2'b01;	//mdr <- data from memory
//////				load_mdr = 1'b1; 
//////				mem_read = 1'b1;
//////			end
//////			
//////			s_ldi_4: begin
//////				regfilemux_sel = 2'b01;	//DR <- mdr
//////				load_regfile = 1'b1;
//////				storemux_sel = 1'b1;	//***
//////				load_cc = 1'b1;
//////			end
//////			
//////			s_stb_1: begin
//////				storemux_sel = 1'b1;
//////				mdrmux_sel = 2'b10;
//////				load_mdr = 1'b1;
//////			end
//////				
//////			s_stb_2: begin
//////				mem_write = 1'b1;
//////				if(alu_out[0] == 1'b0)
//////					mem_byte_enable = 2'b10;
//////				else
//////					mem_byte_enable = 2'b01;
//////			end
//////			
//////			s_ldb_1: begin
//////				load_mdr = 1;	//mdr <- data from address
//////				mem_read = 1;
//////				mdrmux_sel = 2'b01;	
//////			end
//////			
//////			s_ldb_2: begin
//////				regfilemux_sel = 2'b11;	
//////				load_regfile = 1;		
//////				load_cc = 1;
//////			end
//////			
//////			s_lea: begin
//////				load_cc = 1'b1;
//////				regfilemux_sel = 2'b00;
//////				load_regfile = 1'b1;
//////				leamux_sel = 1'b1;
//////				aluop = alu_pass;
//////			end
//////			
//////			s_jmp: begin
//////				pcmux_sel = 2'b10;
//////				load_pc = 1'b1;
//////			end
//////
//////			s_jsr_1: begin //R7 <- PC
//////				regfilemux_sel = 2'b10;
//////				load_regfile = 1'b1;
//////				destmux_sel = 1'b1;
//////			end
//////			
//////			s_jsr_2: begin load_mdr = 1'b1; // if bit[11] == 0, PC = BaseR. 	else   PC = PC + SEXT(PCoffset11)<<1
//////					load_pc = 1'b1;
//////					offsetmux_sel = 1'b1;
//////				if(instruction[11] == 0)
//////					pcmux_sel = 2'b10;		//PC <- BaseR
//////				else
//////					pcmux_sel = 2'b11; 		//PC <- offset11+PC
//////			end
//////		
//////		s_trap_1: begin
//////			marmux_sel = 2'b10;	//mar <- zext(trap8)
//////			load_mar = 1'b1;
//////		end
//////			
//////		s_trap_2: begin			
//////			regfilemux_sel = 2'b10;	//R7 <- PC
//////			load_regfile = 1'b1;
//////			destmux_sel = 1'b1;
//////			mdrmux_sel = 2'b01;	//MDR <- data
//////			load_mdr = 1'b1;
//////			mem_read = 1'b1;
//////		end 
//////		
//////		s_trap_3: begin  //PC <- MDR
//////			pcmux_sel = 2'b01;
//////			load_pc = 1'b1;
//////		end
//////		
//////		s_shf: begin
//////			if(D == 1'b0)
//////				aluop = alu_sll;
//////			else 
//////			begin
//////				if(A == 1'b0)
//////					aluop = alu_srl;
//////				else
//////					aluop = alu_sra;
//////			end
//////			
//////			load_regfile = 1'b1;
//////			//storemux_sel = 1'b1;
//////			alumux_sel = 2'b10;
//////			load_cc = 1'b1;
//////		end
////		
////		
////			default: /* Do nothing */;
////			
////		endcase
////	end
//
//	
//always_comb												 /* Next state information and conditions (if any) for transitioning between states */
//
//	begin : next_state_logic
//		
//		  case(state)
//		  
////			fetch1: begin
////				next_state = fetch2;
////			end
////			
////			fetch2: begin
////				if(mem_resp == 0)
////					next_state = fetch2;
////				else
////					next_state = fetch3;
////			end
////			
////			fetch3: begin
////				next_state = decode;
////			end
////				
////			decode: begin					
////				if(opcode == op_add)
////					next_state = s_add;
////				else if(opcode == op_and)
////					next_state = s_and;
////				else if(opcode == op_not)
////					next_state = s_not;
////				else if(opcode == op_br)
////					next_state = s_br;
////				else if(opcode == op_ldr || opcode == op_str || opcode == op_stb || opcode == op_ldb || opcode == op_sti || opcode == op_ldi)
////					next_state = s_calculate_addr;
////				else if(opcode == op_lea) 
////					next_state = s_lea;
////				else if(opcode == op_jmp)
////					next_state = s_jmp;
////				else if(opcode == op_jsr)
////					next_state = s_jsr_1;
////				else if(opcode == op_ldb)
////					next_state = s_ldb;
////				else if(opcode == op_trap)
////					next_state = s_trap_1;
////				else if(opcode == op_shf)
////					next_state = s_shf;
////				else
////					next_state = fetch1;
////			end
////			
////			s_add: begin
////				next_state = fetch1;
////			end
////			
////			s_and: begin	
////				next_state = fetch1;
////			end
////			
////			s_not: begin	
////				next_state = fetch1;
////			end
////			
////			s_calculate_addr: begin
////				if(opcode == op_ldr)
////					next_state = s_ldr1;
////				else if(opcode == op_str)
////					next_state = s_str1;
////				else if(opcode == op_sti)
////					next_state = s_sti_1;
////				else if(opcode == op_ldi)
////					next_state = s_ldi_1;
////				else if(opcode == op_ldb)
////					next_state = s_ldb_1;
////				else if(opcode == op_stb)
////					next_state = s_stb_1;
////				else
////					next_state = fetch1;
////			end
////
////			s_ldr1: begin	
////				if(mem_resp == 0)
////					next_state = s_ldr1;
////				else 
////					next_state = s_ldr2;
////			end
////			
////			s_ldr2: begin	
////				next_state = fetch1;
////			end
////			
////			s_str1: begin	
////				next_state = s_str2;
////			end
////			
////			s_str2: begin	
////				if(mem_resp == 0)
////					next_state = s_str2;
////				else
////					next_state = fetch1;
////			end
////			
////			s_br: begin	
////				if(branch_enable == 1)
////					next_state = s_br_taken;
////				else 
////					next_state = fetch1;
////			end
////			
////			s_br_taken: begin
////				next_state = fetch1;
////			end
////			
////			s_lea: begin
////				next_state = fetch1;
////			end
////		
////			s_jmp: begin
////				next_state = fetch1;
////			end
////			
////			s_jsr_1: begin
////				next_state = s_jsr_2;
////			end
////			
////			s_jsr_2: begin
////				next_state = fetch1;
////			end
////			
////			s_trap_1: begin
////				next_state = s_trap_2;
////			end
////			
////			s_trap_2: begin
////				if(mem_resp == 1'b0)
////					next_state = s_trap_2;
////				else 
////					next_state = s_trap_3;
////			end
////			
////			s_trap_3: begin
////				next_state = fetch1;
////			end
////			
////			s_sti_1: begin
////				if(mem_resp == 1'b0)
////					next_state = s_sti_1;
////				else 
////					next_state = s_sti_2;
////			end
////			
////			s_sti_2: begin 
////				next_state = s_sti_3;
////			end
////			
////			s_sti_3: begin
////				next_state = s_sti_4;
////			end
////			
////			s_sti_4: begin
////				next_state = fetch1;
////			end	
////		
////			s_stb_1: begin
////				next_state = s_stb_2;
////			end	
////			
////			s_stb_2: begin
////			if(mem_resp == 1'b0)
////				next_state = s_stb_2;
////			else
////				next_state = fetch1;
////			end
////			
////			s_ldb_1: begin
////				if(mem_resp == 1'b0)
////					next_state = s_ldb_1;
////				else 
////					next_state = s_ldb_2;
////			
////			end
////			
////			s_ldb_2: begin
////				next_state = fetch1;
////			end
////			
////			s_ldi_1: begin
////				if(mem_resp == 1'b0)
////					next_state = s_ldi_1;
////				else 
////					next_state = s_ldi_2;
////			end
////			
////			s_ldi_2: begin
////				next_state = s_ldi_3;
////			end
////			
////			s_ldi_3: begin
////				if(mem_resp == 1'b0)
////					next_state = s_ldi_3;
////				else 
////					next_state = s_ldi_4;
////			end
////			
////			s_ldi_4: begin
////				next_state = fetch1;
////			end
////			
////			s_shf: begin
////				next_state = fetch1;
////			end
//			
//				default: next_state = fetch1;	//do nothing
//				
//		endcase
//end
//
//always_ff @(posedge clk)
//	begin: next_state_assignment
//		 state <= next_state;
//	end

endmodule : control