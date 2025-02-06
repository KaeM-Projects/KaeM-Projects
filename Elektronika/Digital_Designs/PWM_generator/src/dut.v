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

module generator_4_ch(
	input wire [1:0] chn_sel_in,	//input selektor sterowanego kana³u 
	input wire sw1_in,				//switch + (zwiêksz szerokoœæ impulsu)
	input wire sw2_in,				//switch - (zmniejsz szerokoœæ imp.)
	input wire CLK,					//zegar g³ówny CLK	
	output [1:0] Q_ch_0,			//wyjscia kana³ów pwm
	output [1:0] Q_ch_1,
	output [1:0] Q_ch_2,
	output [1:0] Q_ch_3,	 
	);
	
	wire C_CLK;
	wire [1:0] drv_ch_out0;
	wire [1:0] drv_ch_out1;
	wire [1:0] drv_ch_out2;
	wire [1:0] drv_ch_out3;
	
	
	prescaler presc_1(		//preskaler 
	.CLK(CLK),				
	.C_CLK(C_CLK));			
	
	
	in_interface in_intf(			//interfejs wejœciowy 
	.chn_sel_in(chn_sel_in),	
	.sw1_in(sw1_in),				
	.sw2_in(sw2_in),				
	.CLK(CLK),					
	.CE(C_CLK),					
	.drv_ch_out0(drv_ch_out0),
	.drv_ch_out1(drv_ch_out1),
	.drv_ch_out2(drv_ch_out2),
	.drv_ch_out3(drv_ch_out3));	 
	
	pwm_gen_ch PWM_0(		   //PWM kana³ 0
	.CLK(CLK),					
	.CE(C_CLK),					
	.DRV(drv_ch_out0),		    
	.Q(Q_ch_0));
	
	pwm_gen_ch PWM_1(		   //PWM kana³ 1
	.CLK(CLK),					
	.CE(C_CLK),					
	.DRV(drv_ch_out1),		    
	.Q(Q_ch_1));
	
	pwm_gen_ch PWM_2(		   //PWM kana³ 2
	.CLK(CLK),					
	.CE(C_CLK),					
	.DRV(drv_ch_out2),		    
	.Q(Q_ch_2));
	
	pwm_gen_ch PWM_3(		   //PWM kana³ 3
	.CLK(CLK),					
	.CE(C_CLK),					
	.DRV(drv_ch_out3),		    
	.Q(Q_ch_3));
	
	
endmodule









module pwm_gen_ch(			//modu³ generatora PWM. Zawiera instancje komparatora, licznika zwyk³ego, rejestru oraz licznika dwukierunkowego.
input CLK,					//zegar g³ówny
input CE,					//sygna³ steruj¹cy z preskan]lera
input [1:0] DRV,		    //sygna³ steruj¹cy licznikiem dwukierunkowym
output reg [1:0] Q = 0		//wyjœcie z generatora PWM Q <- Q[1] oraz ~Q <- Q[0] 
);
wire [1:0] TMP;			    //po³¹czenie dla sygna³u z komparatora (sygna³ synchronizowany z CLK)
wire CO;					//po³¹czenie dla sygna³u przepe³nienia licznika (sterowanie wpisem wartoœci dla rejestru)
wire [7:0] ACT_WORD; 		//po³¹czenie dla s³owa bitowego z licznika jednostek czasu: licznik <-> komparator
wire [7:0] REF_WORD;		//po³¹czenie dla s³owa bitowego ustalonej wartoœci odniesienia (wype³nienia impulsu) licznik dwukierunkowy <-> rejestr
wire [7:0] REF2_WORD;		//po³¹czenie jak powy¿ej ale dla: rejestr <-> komparaotr
reg [7:0] DT = 8'b1;

register_8b reg1(.CLK(CLK),.WE(CO),.IN_word(REF_WORD),.OUT_word(REF2_WORD));		//rejestr 8bit przechowywuj¹cy s³owo bitowe wart. odniesienia
counter_8b cnt1(.CLK(CLK), .CE(CE), .CO(CO), .Q(ACT_WORD));							//licznik jednostek czasu (trwania impulsu)
counter_8b_bidir cnt_bdir(.CLK(CLK),.INCR(DRV[0]), .DEC(DRV[1]),.Q(REF_WORD));		//licznik dwukierunkowy do ustalania wartoœci odniesienia (przyciskami)
comparator comp1(/*.CLK(CLK),*/.Q(TMP), .ACT(ACT_WORD), .REF(REF2_WORD), .DT(DT));	//komparator po³¹cznie 

always @(posedge CLK)begin 
	Q <= TMP;	   //synchronizacja wartoœci z komparatora zboczem CLK
end

endmodule

//////////////////////////////////////////////////////////////////////////////////////////////////////


module in_interface (			//interfejs wejœciowy - zbieranie inputu z przycisków i rozdzielanie na poszczególne generatory.
input wire [1:0] chn_sel_in,	//input selektor sterowanego kana³u 
input wire sw1_in,				//switch + (zwiêksz szerokoœæ impulsu)
input wire sw2_in,				//switch - (zmniejsz szerokoœæ imp.)
input wire CLK,					//zegar g³ówny CLK
input wire CE,					//Sygna³steruj¹cy z preskalera
output [1:0] drv_ch_out0,	//wyjœcia dla poszczególnych generatorów (kanaów pwm)
output [1:0] drv_ch_out1,
output [1:0] drv_ch_out2,
output [1:0] drv_ch_out3
);

wire [1:0] switches_internal;	//po³¹czenie sygna³u +/- z eliminatora drgañ
wire [1:0] chn_sel_internal;			//po³¹czenie sygna³u select z eliminatora drgañ


switch_ctrl #(10) sw_select_1 (	  //drgania styków dla przycisku select 1
    .CLK(CLK),
	.CLR(1'b0),
	.CE(CE),
	.S_IN(chn_sel_in[0]),
	.KEY_EN(chn_sel_internal[0]),
	.KEY_UP());
	
switch_ctrl #(10) sw_select_2 (	  //drgania styków dla przycisku select 2
    .CLK(CLK),
	.CLR(1'b0),
	.CE(CE),
	.S_IN(chn_sel_in[1]),
	.KEY_EN(chn_sel_internal[1]),
	.KEY_UP());
	
switch_ctrl #(10) sw_1_add (	  //drgania styków dla przycisku zwiêksz wype³nienie
    .CLK(CLK),
	.CLR(1'b0),
	.CE(CE),
	.S_IN(sw1_in),
	.KEY_EN(),
	.KEY_UP(switches_internal[0]));	

switch_ctrl #(10) sw_2_dec (	  //drgania styków dla przycisku zmniejsz wype³nienie
    .CLK(CLK),
	.CLR(1'b0),
	.CE(CE),
	.S_IN(sw2_in),
	.KEY_EN(),
	.KEY_UP(switches_internal[1]));	

selector sel(						//pod³¹czenie selector
     .DRV_IN(switches_internal),
     .SEL(chn_sel_internal),
     .DRV_OUT0(drv_ch_out0),
     .DRV_OUT1(drv_ch_out1),
     .DRV_OUT2(drv_ch_out2),
     .DRV_OUT3(drv_ch_out3)
	 

);	
	//initial $monitor($time,CLK,"  --  ",CE,"  --  ",drv_ch_out0,"  --  ",switches_internal,"  --  ",sw1_in);		
	//initial $monitor($time,"  --  ",CE);
//initial $monitor($time, "sel ",chn_sel_internal);  
//initial $monitor("sws ",switches_internal);	 
//initial $monitor("sw1_in ",sw1_in);	
endmodule


module switch_ctrl #(			   //eliminator drgañ styków
	parameter l_bit = 4
)
(
	input 			CLK,
	input 			CLR,
	input 			CE,
	input 			S_IN,
	output 	 		KEY_EN,
	output 			KEY_UP,	
);
	
reg [l_bit-1:0] P_OUT; 
reg[7:0] internal_clk_cnt = 0;
reg internal_clk = 0;


always @(posedge CLK) begin
	$monitor($time,"  ",internal_clk);		 //zmniejszenie czestotliwosci probkowania przycisku.	(TODO check in simulation internal clk)	
	internal_clk = 1'b0;
	if (CE)	
		internal_clk_cnt = internal_clk_cnt + 1;
		if (internal_clk_cnt > 8'd50) begin
			internal_clk = 1'b1;
			internal_clk_cnt = 8'd0;
			end
		else
			internal_clk_cnt = internal_clk_cnt;
	end
	
	
/*	
	if (internal_clk_cnt > 50)	
		internal_clk_cnt = 0;
		if (CE)	
			internal_clk_cnt = internal_clk_cnt + 1;
		else
			internal_clk_cnt = internal_clk_cnt;
	end
*/	
	
	
   always @(posedge CLK)
	begin
		if(CLR)
			P_OUT <= {l_bit{1'b0}};
		else
			if (internal_clk)
				P_OUT <= {P_OUT[l_bit-2:0],S_IN};
	end
				
	assign KEY_UP = (&P_OUT[l_bit-2:0]) & ~P_OUT[l_bit-1] & CE;	
	assign KEY_EN = (&P_OUT[l_bit-1:0]); 
endmodule



module selector (			 //selector - demultiplekser - rozdzielacz sygna³ów w interfejsie wejœciowym
input [1:0] DRV_IN,			 //sygna³y wejœciowe
input [1:0] SEL,			 //select - wybor wyjœcia
output reg [1:0] DRV_OUT0,	 //wyjœcia
output reg [1:0] DRV_OUT1,
output reg [1:0] DRV_OUT2,
output reg [1:0] DRV_OUT3
);

always @(SEL or DRV_IN) begin	  	 //aktywacja na zmianê wejœæ

 case (SEL)							 //rozdzielanie sygna³ów w zale¿noœci od sygna³u SEL
        2'b00: DRV_OUT0 = DRV_IN;
        2'b01: DRV_OUT1 = DRV_IN;
        2'b10: DRV_OUT2 = DRV_IN;
        2'b11: DRV_OUT3 = DRV_IN;
     endcase        

end
endmodule



module prescaler(		//preskaler - zmiana czêstotliwoœci bazowej na 500Hz
input CLK,				//zegar g³ówny
output reg C_CLK = 0	//wyjœcie 500Hz
);

reg [31:0] switch = 0;	//tu zapisuj¹ siê zliczane zbocza zegarowe

always @(negedge CLK) begin         //aktywacja zboczem CLK
    //if (switch == 32'h30D40) begin	//Wartoœæ dla dzielnika  
	if (switch == 32'd10) begin	//Wartoœæ dla dzielnika 
        C_CLK <= 1;					//ustawianie wyjœæ i iloœci zliczanych zboczy 
        switch <= 1;
        end
    else begin
        C_CLK <= 0;
        switch <= switch + 1;
        end
end
endmodule


module counter_8b(	     //zwyk³y licznik 8 bitowy zliczaj¹cy co 5 jednostek, aktywowany sygna³em CE
input CLK,				 //Zegar g³ówny
input CE,				 //sygna³ z prescalera
output reg [7:0] Q = 0,  //wyjœcie s³owa bitowego
output reg CO = 0		 //wyjœcie sygna³u przepenienia
);

    always @(posedge CLK) begin	   //wyzwalane na zbocze CLK
        if (CE) begin			   //aktywowane na CE z preskalera (zlicza z czêstotliwoœci¹ 500Hz
            Q = Q + 1;			   //inkrementacja wartoœci
            if (Q == 255)
                CO = 1'b1;		  //ustawianie sygna³u przepe³nienia
             else 
                CO = 1'b0;
             end
        else
            Q = Q;				  //nie ma aktywacji, wyjœcie bez zmian.
        end
endmodule


module register_8b(	  			//rejestr 8 bit z wpisem sterowanym przez WE
input [7:0] IN_word,
input WE,
input CLK,
output reg [7:0] OUT_word = 0
);

always @(negedge CLK) begin		//wyzwalane zboczem CLK
    if (WE)						//aktywowane przez WE
        OUT_word = IN_word;		//przepisz wartoœæ wej -> wyj
    else
        OUT_word = OUT_word;    //wyjœcie bez zmian
end

endmodule


module counter_8b_bidir(   //licznik dwukierunkowy. dodaje lub odejmuje po otrzymaniu sygna³u steruj¹cego INCR lub DEC
input CLK,
input INCR,
input DEC,
output reg [7:0] Q = 0
);

always @(posedge CLK) begin	   	  //wyzwalane zboczem CLK
	    case ({INCR,DEC})		  //Dodawanie lub odejmowanie zale¿ne od sygna³ów  wej
	        2'b01: Q = (Q == 8'd0)    ?    250   : (Q - 8'd5);		   //odejmuj, chyba ¿e zero to wartoœæ ostatnia (pêtla zliczania)
	        2'b10: Q = (Q == 8'd250)  ?    0     : (Q + 8'd5);		   //dodawaj, chyba ¿e pe³ny to wyzeruj.
	        default Q = Q;											   //w standardzie nic nie rób
		endcase 
				//$monitor($time,"  --  ",Q);						   //symulacja, monitorowanie stanu wewnêtrznego w czasie
    end
endmodule


module comparator(	  //komparator. wystawia odpowienio Q i ~Q uwzglêdniaj¹c przy tym przesuniêcie sygna³ów w stanie wysokim (czas martwy)
input [7:0] REF,	  //do podpiêcia wartoœæ referencyjna
input [7:0] ACT,	  //do podpiêcia aktualna wart. z licznika 
input [7:0] DT,		  //przechowywanie wartoœci d³ugoœci czasu martwego 
output reg [1:0] Q	= 0	   //wyjœcie Q i ~Q
);


always @(REF or ACT) begin		 //na zmianê wartoœci zdefiniuj wyjœcie
	if (REF == 8'b0)			 //dla zerowego wype³nienia, na wyjœciach Q/~Q sta³e 01
		Q = 2'b01;
    else if ((0 <= ACT) && (ACT <= REF))  //od zera do wart prze³¹czenia 
        Q = 2'b10;
    else if ((REF < ACT) && (ACT <= REF + DT))	   //czas martwy od wartoœci referencyjnej czyli zera na wyjœciach 
        Q = 2'b00;
    else if ((REF + DT < ACT) && (ACT <= 255 - DT))	   //po czasie martwym wyjœcie na 01
        Q = 2'b01;
    else if ((255 - DT < ACT) && (ACT <= 255))		   //na koniec okresu znów czas martwy czyli 00
        Q = 2'b00;
    else
        Q = 2'b00;									   
	//$display(ACT,"--",REF,"--",Q);				 //symulacja, monitorowanie wartoœci wewnêtrznych
    end
    
endmodule


