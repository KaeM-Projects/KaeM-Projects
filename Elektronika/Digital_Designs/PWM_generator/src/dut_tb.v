`timescale 1ns / 1ps

/*
module presc_tb(    );
reg CLK;
wire C_CLK;
reg [3:0] tmp = 0;


    prescaler pres_1(
                     .CLK   (CLK),
                     .C_CLK (C_CLK)
                     );
                     
    initial CLK = 1'b0;
    always #1 CLK = ~CLK;
    
    always @(posedge C_CLK) begin
        tmp = tmp+1;
        if (tmp == 4) $stop;
    
    end
    
    initial
//	$monitor($time, " Output CLK = %d, C_CLK = %d",  CLK, C_CLK);
	$monitor($time, " Output C_CLK = %d", C_CLK);
endmodule
*/
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

/*
module sel_tb(    );
reg [1:0] DRV_IN;
reg [1:0] SEL;
wire [1:0] DRV_OUT0;
wire [1:0] DRV_OUT1;
wire [1:0] DRV_OUT2;
wire [1:0] DRV_OUT3;



    selector sel_1(
        .DRV_IN(DRV_IN),
		.DRV_OUT0(DRV_OUT0),
		.DRV_OUT1(DRV_OUT1),
		.DRV_OUT2(DRV_OUT2),
		.DRV_OUT3(DRV_OUT3),
        .SEL(SEL)
                     );
                     
    initial begin
        SEL = 2'b00;
        #1;
        DRV_IN = 2'b00;
        #1;
        DRV_IN = 2'b01;
        #1;
        DRV_IN = 2'b10;
        #1;
        DRV_IN = 2'b11;
        #1;
        //DRV_IN = 2'b00;
        #1;
    	        SEL = 2'b01;
        #1;
        DRV_IN = 2'b00;
        #1;
        DRV_IN = 2'b01;
        #1;
        DRV_IN = 2'b10;
        #1;
        DRV_IN = 2'b11;
        #1;
        //DRV_IN = 2'b00;
        #1;
		        SEL = 2'b10;
        #1;
        DRV_IN = 2'b00;
        #1;
        DRV_IN = 2'b01;
        #1;
        DRV_IN = 2'b10;
        #1;
        DRV_IN = 2'b11;
        #1;
       // DRV_IN = 2'b00;
        #1;
		        SEL = 2'b11;
        #1;
        DRV_IN = 2'b00;
        #1;
        DRV_IN = 2'b01;
        #1;
        DRV_IN = 2'b10;
        #1;
        DRV_IN = 2'b11;
        #1;
       // DRV_IN = 2'b00;
        #1;
    end

    
 //   initial
//	$monitor($time, " Output CLK = %d, C_CLK = %d",  CLK, C_CLK);
//	$monitor($time, " Output C_CLK = %d", C_CLK);
endmodule
*/

/*  
	  
module pwm_tb(    );
   	reg CLK;
	reg CE;
	reg [1:0] DRV;
	wire [1:0] Q;  


pwm_gen_ch pwm(
.CLK(CLK),
.CE(CE),
.DRV(DRV),
.Q(Q)
);
                
    initial begin 
    CLK = 1'b0;
    CE = 1'b0;
    DRV = 2'b00;
    end
    
    always #1 CLK = ~CLK;
    always begin  
		#1
		CE = ~CE;
		#1;
		CE = ~CE;
		#8;
		end
    
    initial begin
    #50
    DRV = 2'b00;
    #100
    DRV = 2'b01;
    #2
    DRV = 2'b00;
    #100
    DRV = 2'b01;
     #2 
    DRV = 2'b00;
    #100
    DRV = 2'b01;
    #2
    DRV = 2'b00;
    #100
    DRV = 2'b01;
        #2
    DRV = 2'b00;
    #100
    DRV = 2'b01;
        #20
    DRV = 2'b00;
	#10000 
	
	    #100
    DRV = 2'b01;
        #20
    DRV = 2'b00;
	#10000 	 
	
		    #100
    DRV = 2'b01;
        #20
    DRV = 2'b00;
	#10000 	  
	
			    #100
    DRV = 2'b01;
        #20
    DRV = 2'b00;
	#10000 
	
				    #100
    DRV = 2'b01;
        #10
    DRV = 2'b00;
	#5000 
	
	$stop;
    
    end
    
 //   initial
//	$monitor($time, " Output CLK = %d, C_CLK = %d",  CLK, C_CLK);
//	$monitor($time, " Output C_CLK = %d", C_CLK);
endmodule

*/		   
		   
/*		   
module 	comparator_tb();		 
reg [7:0] REF;
reg [7:0] ACT;
reg [7:0] DT;
reg CLK;
wire [1:0] Q;	
	
	
	
comparator comp(
.REF(REF),
.ACT(ACT),
.DT(DT),
.Q(Q)
);
	
initial begin
ACT = 0;
DT = 0;
REF = 0;

DT = 1'b1;
REF = 8'd150;
#5	
ACT = 8'd148;
#5	
ACT = 8'd149;
#5	
ACT = 8'd150;
#5	
ACT = 8'd151;		
#5	
ACT = 8'd152;
#5	
ACT = 8'd180;
end


	
	
	
	
endmodule

/*


/*	 
module counter_bdir_tb();
reg CLK; 
reg INCR;
reg DEC;
wire [7:0] Q;	
	
	
counter_8b_bidir cnt_bdir(
.CLK(CLK),
.INCR(INCR),
.DEC(DEC),
.Q(Q)
);		 

always #5 CLK = ~CLK;
	
initial begin
CLK = 0;
INCR = 0;
DEC = 0;

#4
INCR = 1;
#500;
INCR = 0;
#20
DEC = 1;
#500
DEC = 0;
#5
$stop;

end
	
endmodule	*/		
		   /*
module regtb();
reg [7:0] IN_word;
reg WE;
reg CLK;
wire [7:0] OUT_word;
	

register_8b register(
.IN_word(IN_word),
.WE(WE),
.CLK(CLK),
.OUT_word(OUT_word)
);		 

always #5 CLK = ~CLK;
	
initial begin
CLK = 0;
IN_word = 0;
WE = 0;


IN_word = 8'd125;
#20;
WE = 1;
#20
IN_word = 8'd15;
 #20;
WE = 0;
#20
 IN_word = 8'd55;
 #20;
WE = 01	;
#20

$stop;

end
	
endmodule	*/		

/////////////////////////////////////////////////////////////////////////////////////
/*
module cnt_tb();
reg CLK;
reg CE;
wire [7:0] Q; 
wire CO;
	

counter_8b cnt(
.CLK(CLK),
.CE(CE),
.Q(Q),
.CO(CO)
);		 

always #5 CLK = ~CLK;
	
initial begin
CLK = 0;
CE = 0;

#4
CE = 1;
#10
CE = 0;
#20
CE = 1;
#10
CE = 0;
#20	
CE = 1;
#10
CE = 0;
#20
CE = 1;
#10
CE = 0;
#20
CE = 1;



#2600;



$stop;

end
	
endmodule		


*/

//////////////////////////////////////////////////////////////////////////////////////////////	


module PWM_gen_tb();
	reg [1:0] chn_sel_in;
	reg sw1_in;				
	reg sw2_in;				
	reg CLK;					
	wire [1:0] Q_ch_0;
	wire [1:0] Q_ch_1;
	wire [1:0] Q_ch_2;
	wire [1:0] Q_ch_3;
	wire C_CLK_out;
	
	generator_4_ch pwm_0( 	
	.chn_sel_in(chn_sel_in),	//input selektor sterowanego kana³u 
	.sw1_in(sw1_in),				//switch + (zwiêksz szerokoœæ impulsu)
	.sw2_in(sw2_in),				//switch - (zmniejsz szerokoœæ imp.)
	.CLK(CLK),					//zegar g³ówny CLK	
	.Q_ch_0(Q_ch_0),
	.Q_ch_1(Q_ch_1),
	.Q_ch_2(Q_ch_2),
	.Q_ch_3(Q_ch_3)
	);
	
	
	always #5 CLK = ~CLK;
	
		
	initial begin
	CLK = 0;
	chn_sel_in = 2'b00;
	sw1_in = 1'b0;
	sw2_in = 1'b0;	
	
	repeat (1) begin
		repeat (52) begin 
			#1000;
			sw1_in = 1;
			#1000;
			sw1_in = 0;
			#235000;
		end
		chn_sel_in = chn_sel_in + 1'b1;
	end
		

	#1000000
	$stop;
		
		
	end	 
	//initial $monitor(sw1_in);
endmodule	 



/*
module in_itf_tb();
reg [1:0] chn_sel_in;	//input selektor sterowanego kana³u 
reg sw1_in;				//switch + (zwiêksz szerokoœæ impulsu)
reg sw2_in;				//switch - (zmniejsz szerokoœæ imp.)
reg CLK;					//zegar g³ówny CLK
reg CE;					//Sygna³steruj¹cy z preskalera
wire [1:0] drv_ch_out0;	//wyjœcia dla poszczególnych generatorów (kanaów pwm)
wire [1:0] drv_ch_out1;
wire [1:0] drv_ch_out2;
wire [1:0] drv_ch_out3;	



in_interface itf(
.chn_sel_in(chn_sel_in),	
.sw1_in(sw1_in),				
.sw2_in(sw2_in),				
.CLK(CLK),				
.CE(CE),					
.drv_ch_out0(drv_ch_out0),
.drv_ch_out1(drv_ch_out1),
.drv_ch_out2(drv_ch_out2),
.drv_ch_out3(drv_ch_out3)
);	

initial begin 
	
chn_sel_in = 2'b00;
sw1_in = 0;			
sw2_in = 0;				
CLK = 0;				
CE = 0;		

#200
sw1_in = 1;	
#100 ; 
sw1_in = 0;	
sw2_in = 1;	
 #100	 ; 
sw2_in = 0;	
#100	 ; 

chn_sel_in = 2'b01; 
 #200
sw1_in = 1;	
#100 ; 
sw1_in = 0;	
sw2_in = 1;	
 #100	 ; 
sw2_in = 0;	
#100	 ; 

 chn_sel_in = 2'b10; 
 
 #200
sw1_in = 1;	
#100 ; 
sw1_in = 0;	
sw2_in = 1;	
#100	 ; 
sw2_in = 0;	
#100	 ; 

chn_sel_in = 2'b11; 

#200
sw1_in = 1;	
#100 ; 
sw1_in = 0;	
sw2_in = 1;	
#100	 ; 
sw2_in = 0;	
#100	 ; 
 
 
 $stop;
end	   


    always #1 CLK = ~CLK;
    always begin  
		#1
		CE = ~CE;
		#1;
		CE = ~CE;
		#8;
	end
	
	
endmodule	

*/		

/*

module debnc_tb(); 
	reg CLK;
	reg CLR;
	reg CE;
	reg S_IN;
	wire KEY_EN;
	wire KEY_UP; 
	wire [9:0] P_OUT_i;
	
	switch_ctrl #(10) swctr(
	.CLK(CLK),
	.CLR(CLR),
	.CE(CE),
	.S_IN(S_IN),
	.KEY_EN(KEY_EN),
	.KEY_UP(KEY_UP)
	);
	
	always #1 CLK = ~CLK;
	always begin  
		CE = ~CE;
		#8;
		CE = ~CE;
		#2;
	end	
		
	initial begin  
		CLK = 0;
		CLR = 0;
		CE = 0;
		S_IN = 0;
	
	
		#10
		S_IN = 1;
		#100
		S_IN = 0;
		#100
		$stop;
	end
	
	
endmodule 

 */
