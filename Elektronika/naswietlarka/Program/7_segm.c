    #include <avr/io.h>
    #include <avr/interrupt.h>
    #include <avr/pgmspace.h>

    #include "7_segm.h"

    volatile uint8_t wysw_1;
    volatile uint8_t wysw_2;
    volatile uint8_t wysw_3;
	volatile uint8_t wysw_4;
//	volatile uint8_t wysw_5;


    uint8_t tablica_znakow[15] PROGMEM = {
        ~(SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F),            // 0
        ~(SEG_B|SEG_C),                                    // 1
        ~(SEG_A|SEG_B|SEG_D|SEG_E|SEG_G),                  // 2
        ~(SEG_A|SEG_B|SEG_C|SEG_D|SEG_G),                  // 3
        ~(SEG_B|SEG_C|SEG_F|SEG_G),                        // 4
        ~(SEG_A|SEG_C|SEG_D|SEG_F|SEG_G),                  // 5
        ~(SEG_A|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G),            // 6
        ~(SEG_A|SEG_B|SEG_C|SEG_F),                        // 7
        ~(SEG_A|SEG_B|SEG_C|SEG_D|SEG_E|SEG_F|SEG_G),      // 8
        ~(SEG_A|SEG_B|SEG_C|SEG_D|SEG_F|SEG_G),            // 9
		0xFF,												//nic 
		~(SEG_A|SEG_F|SEG_G|SEG_E|SEG_D),					//E
		~(SEG_E|SEG_G|SEG_C),								//n
		~(SEG_B|SEG_G|SEG_E|SEG_D|SEG_C),					//d
    };

    // funkcja inicjalizuj¹ca pracê z wyœwietlaczem
    void wyswietlanie_led(void)
    {
       
        wysw_cyfry_kier = 0XFF;
        wysw_cyfry = 0XFF;
       
       
        anody_kier |= anoda_1 | anoda_2 | anoda_3 | anoda_4; //| anoda_5;
        port_anody |= anoda_1 | anoda_2 | anoda_3 | anoda_4; //| anoda_5;


       
        //TIMER 0
		TCCR0 |= (1<<WGM01);				// timer0 ctc
        TCCR0 |= (1<<CS02);                // preskaler = 256
        OCR0 = 15;                          // porównaj z 15
        TIMSK |= (1<<OCIE0);            // zezwolenie na przerwanie CompareMath

    }
		
		

ISR(TIMER0_COMP_vect)
{
	static uint8_t licznik=1;		// zmienna do prze³¹czania kolejno anod wyrwietlacza

	port_anody = (port_anody & 0xE0);	// wygaszenie wszystkich wyœwietlaczy


	if(licznik==1)      wysw_cyfry = pgm_read_byte( &tablica_znakow[wysw_1] );    // gdy zapalony wyœw.1 podaj stan zmiennej c1
        else if(licznik==2) wysw_cyfry = pgm_read_byte( &tablica_znakow[wysw_2] );    // gdy zapalony wyœw.2 podaj stan zmiennej c2
        else if(licznik==4) wysw_cyfry = pgm_read_byte( &tablica_znakow[wysw_3] );    // gdy zapalony wyœw.3 podaj stan zmiennej c3
		else if(licznik==8) wysw_cyfry = pgm_read_byte( &tablica_znakow[wysw_4] );
	//	else if(licznik==16) wysw_cyfry = pgm_read_byte( &tablica_znakow[wysw_5] );


	port_anody = (port_anody & 0xE0) | (~licznik & 0x1F);			// cykliczne prze³¹czanie kolejnej anody w ka¿dym przerwaniu

	// operacje cyklicznego przesuwania bitu zapalaj¹cego anody w zmiennej licznik
	licznik <<= 1;					// przesuniêcie zawartoœci bitów licznika o 1 w lewo
	if(licznik>8) licznik = 1;		// jeœli licznik wiêkszy ni¿ 16 to ustaw na 1
}
