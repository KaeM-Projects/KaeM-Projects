/////////////////////////////////////
// Mikroprocesory MSC
// KMA_CPU 
// Jednostka: 
// 21.10.2024
/////////////////////////////////////
`include "definy.v"

module dekoder #(
parameter data_width = `data_width ,                  // 4
parameter instruction_width = `instruction_width ,    // 8
parameter pm_addr_width = `pm_addr_width ,            // 12
parameter op_code_width = `op_code_width )            // 4
(
input clk,
input rst,

input [pm_addr_width-1:0] pc_in,
output reg pc_ce,
output reg [pm_addr_width-1:0] pc_out,
output reg pc_we,

input [instruction_width-1 : 0] pm_in,
output reg [pm_addr_width-1:0] pm_addr,

output reg [op_code_width-1:0] op_alu,

output reg accu_ce,

output reg [pm_addr_width-1:0] dm_addr,       // adres pamieci dany7ch
output reg dm_wr,                             // sygnal sterujacy zapisem do pamieci danych
input signed [data_width-1:0] dm_data_in,            // wejscie z pamieci danych
output reg signed [data_width-1:0] dm_data_out,      // wyjscie do pamieci danych 

input signed [data_width-1:0] data_in,
input cy,
output reg signed [data_width-1:0] data_out,          //wyjscie do podblokow - alu, itd

input signed [data_width-1:0] rf_data_in,
output reg signed [data_width-1:0] rf_data_out,
output reg [1:0] rf_addr_out,
output reg rf_we,

input signed [data_width-1:0] stack_data_in,
output reg signed [data_width-1:0] stack_data_out,
output reg stack_pop,
output reg stack_push



,output reg [7:0] state_out

);
//--------------------END OF PORTS------------------------------


//--------------------INTERNAL SIGNALS AND VARIABLES------------
localparam mem_blk_addr_width = instruction_width - op_code_width;  //width of instruction slice containing internal data block address
reg [instruction_width-1:0] instruction_register;                   //registers to store instruction word
reg [instruction_width-1:0] instruction_mem;                        
reg [pm_addr_width-1:0] working_register;                           //register to store memory addresses readed from program memory

reg [7:0] state;                                                    //registerr with next state of decoder fsm
reg [7:0] mem_state;                                                //memory for next state, after nested instruction cycle                                                         
reg [1:0] sw_data_src;                                              //switch for data source/bus connections multiplexing

reg [mem_blk_addr_width-1:0] mem_blk_addr;                          //instruction slice with internal block data addr

reg [pm_addr_width-1:0] pc_mem_val;                                 //reg to store program counter value (for RET after JMP)

reg acc_zero;                                                       //zero flag of ACC value

assign instruction_register = pm_in;                                
assign pc_out = working_register;
assign dm_addr = working_register;      
assign pm_addr = pc_in;
assign state_out = state;
assign acc_zero = |data_in;

//--------------------END OF INTERNAL SIGNALS AND VARIABLES-----

always @(*) begin  //multiplexing connections of data source
  case(sw_data_src)
    `ACC : begin      //set accumulator as data source 
      dm_data_out     <= data_in; 
      stack_data_out  <= data_in; 
      rf_data_out     <= data_in;       
    end
    `MEM : begin      //set data memnory as data source
      data_out        <= dm_data_in; 
      stack_data_out  <= dm_data_in; 
      rf_data_out     <= dm_data_in; 
    end
    `STA : begin      //set stack as data source
      dm_data_out     <= stack_data_in;
      data_out        <= stack_data_in;
      rf_data_out     <= stack_data_in;
    end
    `REG : begin      //set regfile as data source 
      data_out        <= rf_data_in;  
      dm_data_out     <= rf_data_in;  
      stack_data_out  <= rf_data_in;  
    end
  endcase
end

//-------------------koniec------------------------------------


initial reset;      // reset at start

//--------------------BEGIN OF BEHAV.---------------------------
always @(posedge clk, negedge rst) begin
  if(!rst) begin
    reset;
  end
  else begin
    if(state == `init) begin
      disable_signals;  // task to disable all internal signals set in prev cycle.
      instruction_mem <= pm_in;
       case (pm_in[instruction_width-1 : op_code_width]) // go to 1st fsm state related with instruction
        `LD  : i_LD_0; // -> goto i_LD_1
        `ST  : i_ST_0; // -> goto i_ST_0
        `ADD : i_ALU_OP_0;
        `SUB : i_ALU_OP_0;
        `AND : i_ALU_OP_0;
        `OR  : i_ALU_OP_0;
        `XOR : i_ALU_OP_0;
        `NOT : i_ALU_OP_0;
        `PSH : i_PUSH_0(instruction_register[op_code_width-1:0]);
        `POP : i_POP_0(instruction_register[op_code_width-1:0]);
        `MOV : i_MOV_0;
        `JMP : i_JMP_0;
        `JZ  : i_JZ_0;
        `JC  : i_JC_0;
        `RET : i_RET_0;
        
        `NOP : i_NOP;
        default : ;
      endcase
     end
    else begin
      case (state)  // go to next fsm states
      `i_LD_1 : i_LD_1;
      `i_ST_1 : i_ST_1;
      `i_ALU_OP_RF_0 : i_ALU_OP_RF_0;
      `i_ALU_OP_1 : i_ALU_OP_1;
      `i_GET_MEM_0 : i_GET_MEM_0;
      `i_GET_MEM_1 : i_GET_MEM_1;
      `i_PUSH_1 : i_PUSH_1;
      `i_POP_1  : i_POP_1;
      `i_MOV_i0 : i_MOV_i0;
      `i_MOV_i1 : i_MOV_i1;
      `i_MOV_o0 : i_MOV_o0;
      `i_MOV_1  : i_MOV_1;
      `i_JMP_1  : i_JMP_1;
      `i_JMP_2  : i_JMP_2;
      `i_OP_end : i_OP_end;

     default : reset;
     endcase
    end
  end
end
//-------------------END OF BEHAV.----------------


`include "dekoder_taski.v"


endmodule


