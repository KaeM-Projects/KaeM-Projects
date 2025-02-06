/////////////////////////////////////
// Mikroprocesory MSC
// KMA_CPU 
// include: dekoder taski
// 21.10.2024 
/////////////////////////////////////

//All tasks of decoder fsm. Name of task related with operation mnemonic.

task i_MOV_0; 
  mem_blk_addr <= instruction_register[op_code_width-1:0];
  case (instruction_register[op_code_width-1:op_code_width-2])
    `ACC : begin i_PUSH_0({`ACC,2'b00},`i_MOV_1); pc_ce = 1'b0; end
    `REG : begin state <= `i_MOV_i0; pc_ce = 1'b0; end
    `MEM : i_PUSH_0({`MEM,2'b00},`i_MOV_i1);
    default : i_OP_end;
  endcase;   
endtask

task i_MOV_i0;
  pc_ce = 1'b1;
  i_PUSH_0({`REG,instruction_register[op_code_width-3:0]},`i_MOV_1);
endtask

task i_MOV_i1;
  pc_ce = 1'b0;
  sw_data_src <= `MEM;
  stack_push <= 1;
  state <= `i_MOV_1;
endtask

task i_MOV_1;
  disable_signals;
  pc_ce = 1'b1;
  case (mem_blk_addr[op_code_width-3:0])
    `ACC : i_POP_0({`ACC,2'b00});
    `REG : state <= `i_MOV_o0;
    `MEM : i_POP_0({`MEM,2'b00});
    default : i_OP_end;
  endcase;   

endtask

task i_MOV_o0;
  i_POP_0({`REG,instruction_register[op_code_width-3:0]});
endtask


task i_POP_0(
input [mem_blk_addr_width-1:0] _mem_blk_addr
);
  begin
    case (_mem_blk_addr[mem_blk_addr_width-1:mem_blk_addr_width-2])
      `ACC : begin
               sw_data_src <= `STA;
               accu_ce <= 1'b1;
               stack_pop <= 1;
               i_OP_end;
             end
      `REG : begin
               rf_addr_out <= _mem_blk_addr[mem_blk_addr_width-3:0];  
               stack_pop <= 1;
               sw_data_src <= `STA;
               rf_we <= 1'b1;    
               i_OP_end;
             end
      `MEM : begin 
               state <= `i_GET_MEM_0;
               mem_state <= `i_POP_1;
             end
      default : reset;
  endcase; 
  end
endtask


task i_PUSH_0(
input [mem_blk_addr_width-1:0] _mem_blk_addr,
input [7:0] state_after = `init
);
  begin
    mem_state <= 8'h00;
    case (_mem_blk_addr[mem_blk_addr_width-1:mem_blk_addr_width-2])
      `ACC : begin
               sw_data_src <= `ACC;
               stack_push <= 1;
               if (!state_after) i_OP_end; else state <= state_after;
             end
      `REG : begin       
               rf_addr_out <= _mem_blk_addr[mem_blk_addr_width-3:0];  
               sw_data_src <= `REG;
               stack_push <= 1;
               if (!state_after) i_OP_end; else state <= state_after;
             end
      `MEM : begin 
               if (!state_after) mem_state <= `i_PUSH_1; else mem_state <= state_after;
               state <= `i_GET_MEM_0;
             end
      default : reset;
    endcase; 
  end
endtask

task i_PUSH_1;
  begin
    sw_data_src <= `MEM;
    stack_push <= 1'b1;
    i_OP_end;
  end
endtask

task i_POP_1;
  begin 
    sw_data_src <= `STA;
    stack_pop <= 1'b1;
    dm_wr <= 1'b1;
    i_OP_end;
  end
endtask

task i_STA_0;
  begin
    sw_data_src <= `STA;
    accu_ce <= 1;
    if(mem_blk_addr[1])stack_pop <= 1; //comment this line if alu op on stack shouldn't pop. (only read value)
    i_OP_end;
  end
endtask

task i_GET_MEM_0;
  begin
    state <=`i_GET_MEM_1;  
    working_register[instruction_width-(op_code_width+1):0] <= instruction_register;
  end
endtask

task i_GET_MEM_1;
  begin
    working_register[pm_addr_width-1:op_code_width] <= instruction_register;
    i_GOTO_state(mem_state);
  end
endtask

task i_GOTO_state(
input [7:0] _state
);
  case(_state)
    `i_ALU_OP_1:  i_ALU_OP_1;
    `i_JMP_1   :  i_JMP_1;
    `i_PUSH_1  :  i_PUSH_1;
    `i_POP_1  :  i_POP_1;
    `i_MOV_1  :  i_MOV_1;
    `i_MOV_i1  :  i_MOV_i1;
    default : i_OP_end;
  endcase
endtask



task i_JMP_0;
  pc_mem_val <= pc_in;
  state <= `i_GET_MEM_0; 
  mem_state <= `i_JMP_1;
endtask

task i_JMP_1;
  pc_ce <= 1'b0;
  pc_we <= 1'b1;
  state <= `i_JMP_2;
endtask

task i_JMP_2;
  pc_we <= 1'b0;
  i_OP_end;
endtask

task i_JZ_0;      //TODO zmzergowac do JMP >>> JMP/ JMP T + / Z/ C warunek w 4 mloddzych bitach instrukcji 
  pc_mem_val <= pc_in;
  if(!acc_zero) begin 
    state <= `i_GET_MEM_0; 
    mem_state <= `i_JMP_1;
  end
  else state = `i_OP_end;
endtask

task i_JC_0;
  pc_mem_val <= pc_in;
  if(cy) begin 
    state <= `i_GET_MEM_0; 
    mem_state <= `i_JMP_1;
  end
  else state = `i_OP_end;

endtask


task i_RET_0;
  pc_we <= 1'b1;
  working_register <= pc_mem_val + 2;
  i_OP_end;
endtask

task i_ALU_OP_0;
  begin
    op_alu <= instruction_register[instruction_width-1:op_code_width];
      case (instruction_register[op_code_width-1:op_code_width-2])
        `REG : i_ALU_OP_RF_0;
        `STA : i_STA_0;
        `MEM : begin state <= `i_GET_MEM_0; mem_state <= `i_ALU_OP_1; end
        default : i_OP_end;
      endcase; 
  end
endtask

task  i_ALU_OP_RF_0;
  rf_addr_out <= instruction_register[mem_blk_addr_width-3:0];
  accu_ce <= 1;
  sw_data_src <= `REG;
  i_OP_end;
endtask


task i_ALU_OP_1;
  begin
    accu_ce <= 1;
    sw_data_src <= `MEM;
    i_OP_end;
  end
endtask

task i_OP_end;
  begin
    pc_ce <= 1;
    state <= `init;
  end
endtask


task i_NOP;
  begin
    i_OP_end;
  end 
endtask


task i_LD_0;
  begin
    op_alu <= instruction_register[instruction_width-1:op_code_width];  // pobranie kodu operacji
    working_register[instruction_width-(op_code_width+1):0] <= instruction_register [op_code_width-1:0];
    state <= `i_LD_1;
  end
endtask

task i_LD_1;
  begin
    working_register[pm_addr_width-1:op_code_width] <= pm_in; 
    accu_ce <= 1;
    sw_data_src <= `MEM;
    i_OP_end;
  end
endtask


task i_ST_0;
  begin
    working_register[instruction_width-(op_code_width+1):0] <= instruction_register [op_code_width-1:0];
    state <= `i_ST_1;
  end
endtask

task i_ST_1;
  begin
    working_register[pm_addr_width-1:op_code_width] <= pm_in;
    sw_data_src <= `ACC;
    dm_wr <= 1'b1;
    i_OP_end;
  end
endtask

task disable_signals;
  begin
    accu_ce <= 1'b0;
    dm_wr <= 1'b0;
    stack_pop <= 1'b0;
    stack_push <= 1'b0;
    pc_we <= 1'b0;
    rf_we <= 1'b0;
  end
endtask

task reset;
  begin
    pc_ce   <= 1'b1;
    pc_we  <= 1'b0;
    op_alu  <= 1'b0;
    accu_ce <= 1'b0;
    working_register <= 1'b0;
    dm_wr   <= 1'b0;
    rf_we <= 1'b0;
    state   <= 1'b0;
    stack_pop <= 1'b0;
    stack_push <= 1'b0;
  end
endtask