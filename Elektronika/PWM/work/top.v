`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
//
// JOS Projekt
// Autor: Krzysztof Macura
// Temat: Wielokoana³owy generator sygna³ów PWM 
//        z sygna³ami komplementarnymi i czasem martwym. 
// Data rozpoczêcia: 23.05.2023
//
//
//////////////////////////////////////////////////////////////////////////////////


/* Trzeba ogarn¹æjak dzia³a kod modu³u switch_crtl i zasosowac w projekcie
module SWITCH_CTRL #(
	parameter l_bit = 4
)
(
	input 			CLK,
	input 			CLR,
	input 			CE,
	input 			S_IN,
	output 			KEY_EN,
	output 			KEY_UP
);
	
	reg [l_bit-1:0] P_OUT;
      
   always @(posedge CLK)
	begin
		if(CLR)
			P_OUT <= {l_bit{1'b0}};
		else
			if (CE)
				P_OUT <= {P_OUT[l_bit-2:0],S_IN};
	end
				
	assign KEY_UP = (&P_OUT[l_bit-2:0]) & ~P_OUT[l_bit-1] & CE;	
	assign KEY_EN = (&P_OUT[l_bit-1:0]);
endmodule


module debouncer(


);
endmodule

*/

module prescaler(  //tested
input CLK,
output reg C_CLK
);

reg [31:0] switch = 0;

always @(posedge CLK) begin         //prescaler na 500 Hz (a potem parametryzowany)
    if (switch == 32'h30D40-1'b1) begin
        C_CLK <= 1;
        switch <= 0;
        end
    else begin
        C_CLK <= 0;
        switch <= switch +1;
        end
end
endmodule


module selector (
input [1:0] DRV_IN,
input [1:0] SEL,
output reg [1:0] DRV_OUT [4]
);

always @(SEL or DRV_IN) begin

 case (SEL)
        2'b00: DRV_OUT[0] = DRV_IN;
        2'b01: DRV_OUT[1] = DRV_IN;
        2'b10: DRV_OUT[2] = DRV_IN;
        2'b11: DRV_OUT[3] = DRV_IN;
     endcase        

end
endmodule




module counter_8b(
input CLK,
input CE,
output reg [7:0] Q, 
output reg CO
);

    always @(posedge CLK) begin
        if (CE) begin
            Q = Q + 1;
            if (Q == 255)
                CO = 1'b1;
             else 
                CO = 1'b0;
             end
        else
            Q = Q;
        end
endmodule


module register_8b(
input [7:0] IN_word,
input WE,
input CLK,
output reg [7:0] OUT_word
);

always @(posedge CLK) begin
    if (WE)
        OUT_word = IN_word;
    else
        OUT_word = OUT_word;
end

endmodule


module counter_8b_bidir(   //do sparametryzowania i ogarniêcia innego stopniowania
input CLK,
input ADD,
input DEC,
output reg [7:0] Q
);

always @(posedge ADD or DEC) begin
    case ({ADD,DEC})
        2'b01: Q = Q == 8'd0    ?    240   : Q - 8'd16;
        2'b10: Q = Q == 8'd240  ?    0     : Q + 8'd16;
        default Q = Q;
     endcase        
    end
endmodule


module comparator(
input [7:0] REF,
input [7:0] ACT,
input [7:0] DT,
input CLK,
output reg [1:0] Q
);
//reg [1:0] TMP;


always @(REF or ACT) begin
    if (0 <= ACT && ACT <= REF)
        Q = 2'b10;
    else if (REF < ACT && ACT <= REF + DT)
        Q = 2'b00;
    else if (REF + DT < ACT && ACT <= 255 - REF - (DT<<1))
        Q = 2'b01;
    else if (255 - REF - (DT<<1) < ACT && ACT <= 255)
        Q = 2'b01;
    else
        Q = 2'b11;
    end
    
//always @(CLK)
//    Q <= TMP;
endmodule




module pwm_ch(
input CLK,
input CE,
input [1:0] DRV,
output reg [2:0] Q
);
wire [7:0] TMP;
wire CO;
wire [7:0] N_WORD; // ;) xD #PDK ¿e niby s³owo bitowe okreœlaj¹ce n-t¹ próbkê
wire [7:0] REF_WORD;
reg [7:0] DT = 8'b1;

register_8b reg1(.CLK(CLK),.WE(CO));
counter_8b cnt1(.CLK(CLK), .CE(CE),.CO(CO));
counter_8b_bidir(.CLK(CLK),.ADD(DRV[0]), .DEC(DRV[1]));
comparator comp1(.CLK(CLK),.Q(TMP), .ACT(N_WORD), .REF(REF_WORD), .DT(DT));

always @(CLK)begin
    Q <= TMP;
end

endmodule