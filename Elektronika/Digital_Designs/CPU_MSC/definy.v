/////////////////////////////////////
// Mikroprocesory MSC
// KMA_CPU 
// Definy
// 21.10.2024
/////////////////////////////////////



`ifdef USE_INSTRUCTIONS
    `define LD  8'b00000000     // Szybkie ladowanie do ACC z pamieci {4'b(op),4'b(addr)} + 8'b(addr) w kolejnym takcie
    `define ST  8'b00010000     // Szybki zapis z ACC do pamieci {4'b(op),4'b(addr)} + 8'b(addr) w kolejnym takcie
    `define ADD 8'b00100000     // Suma ACC + argument {4'b(op),2'b(sel_in),2'b(addr_in/xx)} + (jesli data memory) 12'b(addr) w kolejnych taktach
    `define SUB 8'b00110000     // Roznica ACC - argument {4'b(op),2'b(sel_in),2'b(addr_in/xx)} + (jesli data memory) 12'b(addr) w kolejnych taktach
    `define AND 8'b01000000     // Iloczyn logiczny ACC i argument {4'b(op),2'b(sel_in),2'b(addr_in/xx)} + (jesli data memory) 12'b(addr) w kolejnych taktach
    `define OR  8'b01010000     // Suma logiczna ACC i argument {4'b(op),2'b(sel_in),2'b(addr_in/xx)} + (jesli data memory) 12'b(addr) w kolejnych taktach
    `define XOR 8'b01100000     // Suma modulo logiczna ACC i argument {4'b(op),2'b(sel_in),2'b(addr_in/xx)} + (jesli data memory) 12'b(addr) w kolejnych taktach
    `define NOT 8'b01110000     // Negacja ACC Szybka negacja. //?{4'b(op),2'b(sel_in),2'b(addr_in/xx)} + (jesli data memory) 12'b(addr) w kolejnych taktach
    `define JMP 8'b10000000     // Prosty skok bezwarunkowy {4'b(op),4'b(addr)} + 8'b(addr) w kolejnym takcie 
    `define JC  8'b10110000     // Skok warunkowy flaga carry pod adres j.w.
    `define JZ  8'b10010000     // Skok warunkowy flaga zera pod adres j.w.
    `define RET 8'b10100000     // Return
    `define PSH 8'b11000000     // przenies na stos wart. z rej. wewn. {4'b(op),2'b(sel_in),2'b(addr_in/xx)}
    `define POP 8'b11010000     // zdejmij ze stosu wart. do rej. wewn. {4'b(op),2'b(sel_in),2'b(addr_in/xx)}
    `define MOV 8'b11100000     // przepis wartorsci {4'b(op), 2'b source, 2'b destination } MOV ACC MEM
    `define NOP 8'b11110000     // pusta instrukcja PC + 1
    
    `define ACC 2'b00           // ADDR of acumulator
    `define REG 2'b01           // ADDR of regfile
    `define MEM 2'b11           // ADDR of Data Memory
    `define STA 2'b10           // ADDR of stack
    
    `define R0  2'b00           //adresy rejestrów w regfile
    `define R1  2'b01
    `define R2  2'b10
    `define R3  2'b11
`else
    `define LD  4'b0000   
    `define ST  4'b0001   
    `define ADD 4'b0010   
    `define SUB 4'b0011   
    `define AND 4'b0100   
    `define OR  4'b0101   
    `define XOR 4'b0110   
    `define NOT 4'b0111   
    `define JMP 4'b1000   
    `define JC  4'b1011   
    `define JZ  4'b1001   
    `define RET 4'b1010   
    `define PSH 4'b1100   
    `define POP 4'b1101   
    `define MOV 4'b1110   
    `define NOP 8'b1111   
    
    `define ACC 2'b00     
    `define REG 2'b01     
    `define MEM 2'b11     
    `define STA 2'b10     
    
    `define R0 2'b00
    `define R1 2'b01
    `define R2 2'b10
    `define R3 2'b11
`endif


`define regs_number 4         //number of registers in register file (TODO develop better register file module)
`define op_code_width     4   //width of basic operation code vector
`define data_width        8   //data vector width
`define instruction_width 8   //instruction vector width
`define pm_addr_width     12  //memories address width 
`define dm_addr_width     12  //memories address width 
`define stack_size 1024       //size of stack memory


//codes for intrernal states of instruction decoder fsm (TODO: create parameters in decoder module)
`define init 8'h00            //init state - ready for new instruction
`define i_LD_1 8'h01          //Next fsm state for LD instruction
`define i_ST_1 8'h10          //Next fsm states for ST instruction
`define i_ST_2 8'h11
`define i_ALU_OP_RF_0 8'h20   //Next fsm states for instruction with alu operations.
`define i_ALU_OP_1 8'h21
`define i_GET_MEM_0 8'h2A     //Next fsm states to getting data memory address from program memory
`define i_GET_MEM_1 8'h2B
`define i_PUSH_1 8'h30        //Next fsm state for push operation
`define i_POP_1 8'h31         //Next fsm state for pop operation
`define i_JMP_1 8'h40         //Next fsm states for jump (better jumps to develop in the future)
`define i_JMP_2 8'h41
`define i_MOV_1 8'h50         //Next fsm states for Move operation
`define i_MOV_i0 8'h51
`define i_MOV_i1 8'h52
`define i_MOV_o0 8'h53
`define i_OP_end 8'h60        //code for operation end.
 
 
 
 


