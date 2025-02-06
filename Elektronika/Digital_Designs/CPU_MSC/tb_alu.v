`include "definy.v"


module top();
//reg clk;
//reg rst;


reg [`op_code_width-1:0] OP;
reg signed [`data_width-1:0] data_in;
reg signed [`data_width-1:0] cr_in;
reg cy;
reg signed [`data_width-1:0] data_out;


Alu #() alu_ins(
.OP(OP),
.data_in(data_in),
.cr_in(cr_in),
.cy(cy),
.data_out(data_out)
);


initial begin
#10

//data_in = 8'hFF;
//cr_in= 8'h01;


data_in = -8'd2;
cr_in=  -8'd127;


#10
//OP = `LD;
//#10
//OP = `ST;
//#10
OP = `ADD;
#10
$display("add %0.d + %0.d = %0.d,   %0.d",cr_in, data_in,data_out, (data_in + cr_in));
#10
OP = `SUB;
#10
$display("add %0.d - %0.d = %0.d",cr_in, data_in,data_out);
//#10
//OP = `AND;
//#10
//OP = `OR;
//#10
//OP = `XOR;
//#10
//OP = `NOT;
//#10


#300 $finish;
end



endmodule