//ALU CODES
`define ALU_ADD  3'd0
`define ALU_SUB  3'd1
`define ALU_AND  3'd2
`define ALU_OR   3'd3
`define ALU_XOR  3'd4
`define ALU_NOT  3'd5
`define ALU_LD   3'd6
`define ALU_DEF  3'd7


//INSTRUCTION
//SECTION: REGISTERS
`define OPCODE_ADD_R {2'b00, 3'd0} //to Accu Add value of Rx
`define OPCODE_SUB_R {2'b00, 3'd1} //to Accu Sub value of Rx
`define OPCODE_AND_R {2'b00, 3'd2} //AND of Accu and value of Rx
`define OPCODE_OR_R  {2'b00, 3'd3} //OR  of Accu and value of Rx
`define OPCODE_XOR_R {2'b00, 3'd4} //XOR of Accu and value of Rx
`define OPCODE_JMP_R {2'b00, 3'd5} //JMP: change Program Counter value to the value of Rx

//SECTION: DATA MEMORY
`define OPCODE_ADD_DM {2'b01, 3'd0} //same as REGISTER SECTION but with usage of Data Memory
`define OPCODE_SUB_DM {2'b01, 3'd1}
`define OPCODE_AND_DM {2'b01, 3'd2}
`define OPCODE_OR_DM  {2'b01, 3'd3}
`define OPCODE_XOR_DM {2'b01, 3'd4}
`define OPCODE_JMP_DM {2'b01, 3'd5}

//SECTION: IMMEDIATE DATA
`define OPCODE_ADD_IMD {2'b10, 3'd0} //same as REGISTER SECTION but with usage of Immediate Data
`define OPCODE_SUB_IMD {2'b10, 3'd1}
`define OPCODE_AND_IMD {2'b10, 3'd2}
`define OPCODE_OR_IMD  {2'b10, 3'd3}
`define OPCODE_XOR_IMD {2'b10, 3'd4}
`define OPCODE_JMP_IMD {2'b10, 3'd5}

//SECTION: REST OF INSTRUCTIONS
`define OPCODE_LD_R   {2'b11, 3'd0} //load from R   to Accu
`define OPCODE_LD_DM  {2'b11, 3'd1} //load from DM  to Accu
`define OPCODE_LD_IMD {2'b11, 3'd2} //load from IDM to Accu
`define OPCODE_ST_DM  {2'b11, 3'd3} //store from Accu to DM
`define OPCODE_ST_R   {2'b11, 3'd4} //store from Accu to R
`define OPCODE_NOT    5'd29  //3'd5 //Negates value of Accu 

`define OPCODE_NOP    5'd31  //3'd7 //No operation is executed

//INSTRUCTION DECODER
`define PM_ID_INS_WIDTH 13;

`define SEC_R    2'd0
`define SEC_DM   2'd1
`define SEC_IMD  2'd2
`define SEC_REST 2'd3

`define JMP 3'd5


