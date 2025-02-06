`include "definy.v"

reg [7:0] mem [] = {
{`NOP,4'hF},
{`NOP,4'hF},
{`NOP,4'hF},
{`NOP,4'hF},
//{`LD,4'h0},
//{8'h99},
//{`ST,4'h1},
//{8'h55},
//{`ADD,`MEM,2'b00},
////{`ADD,`REG,`R1},
//{8'h02},
//{8'h33},
//{`NOP,4'hF},
//{`NOP,4'hF},
//{`NOP,4'hF},
//
//{`ADD,`REG,`R1},
//{`PSH,`MEM,2'b00},
//{8'h01},
//{8'h77},
//{`POP, `ACC,2'b00},
//{`POP, `MEM,2'b00},
//{8'h02},
//{8'h03},
{`NOP,4'hF},
{`NOP,4'hF},
//
//
{`MOV,`MEM,`MEM},
{8'h02},
{8'h03},
{8'h04},
{8'h05},
//{`MOV,`REG,`REG},
//{8'h02},
//{8'h03},

//{`MOV,`REG,`ACC},
//{8'h02},
//{`MOV,`ACC,`REG},
//{8'h02},
//{`JMP,4'h0},
//{8'h01},
//{8'h00},


{`NOP,4'hF}
};


reg [7:0] dm_mem [] = {
8'h35,
8'h03,
8'h17
};


module top();
reg clk;
reg rst;

reg[7 : 0] pm_in;

reg[`pm_addr_width-1:0] pc_in;
reg pc_ce;
reg pc_we;
reg [`pm_addr_width-1:0] pc_out;

reg [`pm_addr_width-1:0] pm_addr;

reg [`op_code_width-1:0] op_alu;

reg accu_ce;

reg [`pm_addr_width-1:0] dm_addr;       // adres pamieci dany7ch
reg dm_wr;                             // sygnal sterujacy zapisem do pamieci danych
reg[`data_width-1:0] dm_data_in;            // wejscie z pamieci danych
reg [`data_width-1:0] dm_data_out;      // wyjscie do pamieci danych 

reg[`data_width-1:0] data_in;
reg [`data_width-1:0] data_out;          //wyjscie do podblokow - alu; itd

reg[`data_width-1:0] rf_data_in = 7;
reg [`data_width-1:0] rf_data_out;
reg [1:0] rf_addr_out;
reg rf_we;

reg[`data_width-1:0] stack_data_in = 6;
reg [`data_width-1:0] stack_data_out;
reg stack_pop;
reg stack_push;

reg [ 7:0] state;


accu #() acc (
.clk(clk),
.ce(accu_ce),
.rst(rst),
.data_in(data_out),
.data_out(data_in)
);

dekoder #() uut            
(
 .clk(clk),               
 .rst(rst),
 .pm_in(pm_in),

 .pc_in(pc_in),
 .pc_ce(pc_ce),
 .pc_we(pc_we),
 .pc_out(pc_out),

 .pm_addr(pm_addr),

 .op_alu(op_alu),

 .accu_ce(accu_ce),

 .dm_addr(dm_addr),
 .dm_wr(dm_wr),         
 .dm_data_in(dm_data_in),           
 .dm_data_out(dm_data_out),    

 .data_in(data_in),
 .data_out(data_out),       

 .rf_data_in(rf_data_in),
 .rf_data_out(rf_data_out),
 .rf_addr_out(rf_addr_out),
 .rf_we(rf_we),

 .stack_data_in(stack_data_in),
 .stack_data_out(stack_data_out),
 .stack_pop(stack_pop),
 .stack_push(stack_push)
 ,.state_out(state)
);

initial begin
  clk = 1;
  rst = 0;
  pc_in = 0;
end

always #5 clk = ~clk;

always @(*) pm_in = mem[pc_in];

always @(*) dm_data_in = dm_mem[dm_addr]; 
always @(posedge clk) if (dm_wr) dm_mem[dm_addr] = dm_data_out; 

always @(posedge clk) begin
  if (pc_ce) pc_in = pc_in +1;

end

initial begin
#15
rst = 1;
#10




#300 $finish;

end



endmodule