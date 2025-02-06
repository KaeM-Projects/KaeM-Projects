/////////////////////////////////////
// Mikroprocesory MSC
// KMA_CPU 
// Jednostka: cpu top
// 21.10.2024
/////////////////////////////////////

`include "definy.v"


module cpu_top #(     //top module for cpu
parameter data_width = `data_width ,                 
parameter instruction_width = `instruction_width ,    
parameter pm_addr_width = `pm_addr_width ,            
parameter op_code_width = `op_code_width 
)(
input clk,
input rst,
output reg [7:0] state_out      // output to observe code of current cpu state, for operations based on fsm
);

                                        //wires or signals:
wire [instruction_width-1 : 0] pm_in;   //data from program memory (instructions, addresses)

wire [pm_addr_width-1:0] pc_in;         //value from program counter
wire pc_ce;                             //program counter clock enable
wire [pm_addr_width-1:0] pc_out;        //sending new value to program counter
wire pc_we;                             //program counter value write enable

wire [pm_addr_width-1:0] pm_addr;       //program memory address bus

wire [op_code_width-1:0] op_alu;        //bus to get slice of alu operand from instruction

wire accu_ce;                           //accumulator clock enable

wire [pm_addr_width-1:0] dm_addr;       //data memory address buss
wire dm_wr;                             //data memory write enable
wire [data_width-1:0] dm_data_in;       //data memory data bus
wire [data_width-1:0] dm_data_out;      //data memory data bus

wire [data_width-1:0] data_in;          //data bus for alu
wire cy;
wire [data_width-1:0] data_out;         

wire [data_width-1:0] rf_data_in;       //ports for regisater file data
wire [data_width-1:0] rf_data_out;
wire [1:0] rf_addr_out;                 //register file reg address (expand registers number up to 256 in the future)
wire rf_we;                             //registers wrtite enable

wire [data_width-1:0] stack_data_in;    //stack data bus
wire [data_width-1:0] stack_data_out;   
wire stack_pop;                         //signal driving pop from stack
wire stack_push;                        //signal driving push to stack

wire cy_alu_accu;                       //carry value alu2accu
wire [data_width-1:0] allu_to_accu_data;//alu2accu data bus

dekoder #()dekoder_inst(    //instantion of decoder module
.clk(clk),
.rst(rst),
.pm_in(pm_in),

.pc_in(pc_in),
.pc_ce(pc_ce),
.pc_out(pc_out),
.pc_we(pc_we),

.pm_addr(pm_addr),

.op_alu(op_alu),

.accu_ce(accu_ce),

.dm_addr(dm_addr),     
.dm_wr(dm_wr),                  
.dm_data_in(dm_data_in),          
.dm_data_out(dm_data_out),      

.data_in(data_in),
.cy(cy),
.data_out(data_out),    

.rf_data_in(rf_data_in),
.rf_data_out(rf_data_out),
.rf_addr_out(rf_addr_out),
.rf_we(rf_we),

.stack_data_in(stack_data_in),
.stack_data_out(stack_data_out),
.stack_pop(stack_pop),
.stack_push(stack_push),

.state_out(state_out)
);



program_memory #() pm_inst(   //instantion of program memory mopdule
.clk(clk),
.address(pm_addr),
.data_out(pm_in)
);

data_memory #() dm_inst(      //instantion of data memory module
.clk(clk),
.wr(dm_wr),
.address(dm_addr),
.data_in(dm_data_out),
.data_out(dm_data_in)
);

stack#() stack_inst(         //instatnion of stack moldule
.clk(clk),
.rst(rst),
.stack_data_in(stack_data_out),
.pop_signal(stack_pop),
.push_signal(stack_push),
.stack_data_out(stack_data_in),
.stack_full()
);

register_file #() rf_inst(    //instantion of regfister file module
.clk(clk),
.we(rf_we),
.rst(rst),
.reg_addr(rf_addr_out),
.reg_in(rf_data_out),
.reg_out(rf_data_in)
);

program_counter #() pc_inst(  //instantion of program counter mnodule 
.clk(clk),
.we(pc_we),
.ce(pc_ce),
.rst(rst),
.data_in(pc_out),
.data_out(pc_in)
);

accu #() accu_inst(       //instantion of accumulator module
.clk(clk),
.ce(accu_ce),
.rst(rst),
.cy_i(cy_alu_accu),
.cy_o(cy),
.data_in(allu_to_accu_data),
.data_out(data_in)
);


Alu #()alu_inst(          //instantion of alu module
.OP(op_alu),
.data_in(data_out),
.cr_in(data_in),
.cy(cy_alu_accu),
.data_out(allu_to_accu_data)
);

endmodule