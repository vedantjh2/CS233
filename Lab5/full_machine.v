// full_machine: execute a series of MIPS instructions from an instruction cache
//
// except (output) - set to 1 when an unrecognized instruction is to be executed.
// clock   (input) - the clock signal
// reset   (input) - set to 1 to set all registers to zero, set to 0 for normal execution.

module full_machine(except, clock, reset);
    output      except;
    input       clock, reset;

    wire [31:0] inst;  
    wire [31:0] PC;  
    wire [31:0] nextPC; 
    wire [31:0] nextPC_zero, nextPC_one, nextPC_two, nextPC_three; 
    wire [31:0] b_data, a_data, alu32_out, data_out, byte_val, mem_val, slt_val, addm_out, lui_out, b_for_alu, lui_ext;
    wire mux_2;
    wire [31:0] sign_ext;
    wire [31:0] zero_ext;
    wire [31:0] wire_ext, w_data, mux3_out;
    wire a, b, c;
    wire [4:0] w_addr;
    wire rd_src, wr_enable, overflow, zero, negative;
    wire [1:0] alu_src2;
    wire [2:0] alu_op;
    wire [31:0] branchoffset;
    wire [1:0] control_type;
    wire       mem_read, word_we, byte_we, byte_load, slt, lui, addm;
    wire [7:0] data_mem_mux_out;
    wire [29:0] pc_int;

    wire [2:0] two_zeros;

    // DO NOT comment out or rename this module
    // or the test bench will break
    register #(32) PC_reg(PC, nextPC, clock, 1'b1, reset);

    // DO NOT comment out or rename this module
    // or the test bench will break
    

    // DO NOT comment out or rename this module
    // or the test bench will break
    
    /* add other modules */
    alu32 pc_on_top_left(nextPC_zero, a, b, c, PC, 32'h4, 3'h2);
    alu32 pc_after_top_left(nextPC_one, a, b, c, nextPC_zero, branchoffset, 3'h2); 
    assign pc_int = { nextPC_zero[31:28], inst[25:0] };
    assign two_zeros = 2'b0;
    assign nextPC_two = { pc_int, {2'b0}}; 
    assign nextPC_three = a_data;


    mux4v for_pc(nextPC, nextPC_zero, nextPC_one, nextPC_two, nextPC_three, control_type);

    assign lui_ext = { inst[15:0], {16{1'b0}}  };
    mux2v rt_or_rd(w_addr, inst[15:11], inst[20:16], rd_src);
    mux2v for_lui(lui_out, mem_val, lui_ext, lui); 
    mux3v for_bdata_in_big_alu(mux3_out, b_data, sign_ext, zero_ext, alu_src2);

    mux2v for_b_of_alu32(b_for_alu, mux3_out, 32'b0, addm);

    alu32 al(alu32_out, overflow, zero, negative, a_data, b_for_alu, alu_op);
    data_mem data_memory(data_out, alu32_out, b_data, word_we, byte_we, clock, reset); 
    mux4v after_data_memory(data_mem_mux_out, data_out[7:0], data_out[15:8], data_out[23:16], data_out[31:24], alu32_out[1:0]);
    
    mux2v byte_load_mux(byte_val, data_out, { {24{1'b0}} , data_mem_mux_out }, byte_load); //does the 24 0 bits come after or before data_mem_mux_out
    mux2v slt_mux(slt_val, alu32_out, { {31{1'b0}} , negative}, slt); 
    mux2v mem_red_mux(mem_val, slt_val, byte_val, mem_read );

    instruction_memory im( inst, PC[31:2] );
    mips_decode instruction_decoder(alu_op, wr_enable, rd_src, alu_src2, except, control_type, mem_read, word_we, byte_we, byte_load, slt, lui, addm, inst[31:26], inst[5:0], zero);

    regfile rf (a_data, b_data, inst[25:21], inst[20:16], w_addr, w_data, wr_enable, clock, reset); // change w_data

    wire [15:0] temp = inst[15:0];
    assign zero_ext = { {16{1'b0}} , inst[15:0] };
    assign sign_ext = {{16{temp[15]}}, inst[15:0]};
   
    assign branchoffset = { {2{1'b0}},  {sign_ext[29:0] << 2} };  //do we bit shift after zero extending or before

    //do addm
    alu32 aladdm(addm_out, a, b, c, b_data, data_out, 3'h2);
    mux2v for_addm_and_lui(w_data, lui_out, addm_out, addm);

    
endmodule // full_machine