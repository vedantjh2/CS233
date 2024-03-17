// mips_decode: a decoder for MIPS arithmetic instructions
//
// alu_op       (output) - control signal to be sent to the ALU
// writeenable  (output) - should a new value be captured by the register file
// rd_src       (output) - should the destination register be rd (0) or rt (1)
// alu_src2     (output) - should the 2nd ALU source be a register (0) or an immediate (1)
// except       (output) - set to 1 when we don't recognize an opdcode & funct combination
// control_type (output) - 00 = fallthrough, 01 = branch_target, 10 = jump_target, 11 = jump_register 
// mem_read     (output) - the register value written is coming from the memory
// word_we      (output) - we're writing a word's worth of data
// byte_we      (output) - we're only writing a byte's worth of data
// byte_load    (output) - we're doing a byte load
// slt          (output) - the instruction is an slt
// lui          (output) - the instruction is a lui
// addm         (output) - the instruction is an addm
// opcode        (input) - the opcode field from the instruction
// funct         (input) - the function field from the instruction
// zero          (input) - from the ALU
//
// bne, beq, j, jr, lui, slt, lw, lbu, sw, sb, addm
module mips_decode(alu_op, writeenable, rd_src, alu_src2, except, control_type,
                   mem_read, word_we, byte_we, byte_load, slt, lui, addm,
                   opcode, funct, zero);
    output [2:0] alu_op;
    output [1:0] alu_src2;
    output       writeenable, rd_src, except;
    output [1:0] control_type;
    output       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    input  [5:0] opcode, funct;
    input        zero;

    wire add_, sub_, and_, or_, nor_, xor_, addi_, andi_, ori_, xori_;

    wire bne_, beq_, j_, jr_, lui_, slt_, lw_, lbu_, sw_, sb_;

    //add
    assign add_ = (opcode == `OP_OTHER0) & (funct == `OP0_ADD);

    //sub
    assign sub_ = (opcode == `OP_OTHER0) & (funct == `OP0_SUB);

    //and
    assign and_ = (opcode == `OP_OTHER0) & (funct == `OP0_AND);

    //or
    assign or_ = (opcode == `OP_OTHER0) & (funct == `OP0_OR);

    //nor
    assign nor_ = (opcode == `OP_OTHER0) & (funct == `OP0_NOR);

    //xor
    assign xor_ = (opcode == `OP_OTHER0) & (funct == `OP0_XOR);

    //addi
    assign addi_ = (opcode == `OP_ADDI);

    //andi
    assign andi_ = (opcode == `OP_ANDI);

    //ori
    assign ori_ = (opcode == `OP_ORI);

    //xori
    assign xori_ = (opcode == `OP_XORI);//zero extend 

    //bne
    assign bne_ = (opcode == `OP_BNE);

    //beq
    assign beq_ = (opcode == `OP_BEQ);

    //j
    assign j_ = (opcode == `OP_J);

    //jr
    assign jr_ =  (opcode == `OP_OTHER0) & (funct == `OP0_JR);

    //lui
    assign lui_ = (opcode == `OP_LUI);

    //slt
    assign slt_ = (opcode == `OP_OTHER0) & (funct == `OP0_SLT) ;

    //lw
    assign lw_ = (opcode == `OP_LW);

    //lbu
    assign lbu_ = (opcode == `OP_LBU);

    //sw
    assign sw_ = (opcode == `OP_SW);

    //sb
    assign sb_ = (opcode == `OP_SB);

    //addm
    assign addm = (opcode == `OP_OTHER0) & (funct == `OP0_ADDM);

    
    assign alu_op[0] = sub_ | or_ | ori_ | xor_ | xori_ | beq_ | bne_ | slt_; 
    assign alu_op[1] = add_ | addi_ | sub_ | nor_ | xor_ | xori_ | beq_ | bne_ | slt_ | lw_ | lbu_ | sw_ | sb_ | addm;
    assign alu_op[2] =  or_ | nor_ | xor_ | and_ | ori_ | xori_ | andi_;

    assign writeenable = add_ | sub_ | and_ | or_ | nor_ | xor_ | addi_ | andi_ | ori_ | xori_ | slt_ | lw_ | lbu_ | lui_ | addm;

    assign alu_src2[1] = andi_ | ori_ | xori_;
    assign alu_src2[0] = lw_ | lbu_ | sw_ | sb_ | addi_; 
    
    assign rd_src = addi_ | andi_ | ori_ | xori_ | ori_ | lw_ | lbu_ | sw_ | sb_ | lui_;

    assign control_type[1] = j_ | jr_; 
    assign control_type[0] = (beq_ & zero) | (bne_ & ~zero ) | jr_; 

    assign except = ~(add_ | sub_ | and_ | or_ | nor_ | xor_ | addi_ | andi_ | ori_ | xori_ | bne_|  beq_ | j_ | jr_ | lui_ | slt_ | lw_ | lbu_ | sw_ | sb_ | addm);

    assign mem_read = lw_ | lbu_;
    assign word_we = sw_;

    assign byte_load = lbu_; 

    assign byte_we = sb_;
    assign lui = lui_;

    assign slt = slt_;


endmodule // mips_decode