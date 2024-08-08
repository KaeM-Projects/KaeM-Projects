#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include "zegar.h"

volatile uint8_t flaga250ms;
//volatile uint8_t piki;
//volatile uint8_t s2_flag;
volatile uint8_t flaga_250ms_2;
volatile uint8_t flaga_250ms_3;
volatile uint8_t sekundy;


void zegar(void)
{

	//	piki = 0;

		//TIMER 2
		TCCR2 |= (1<<WGM21);				// timer2 ctc
        TCCR2 |= (1<<CS22)|(1<<CS20)|(1<<CS21);                // preskaler = 1024
        OCR2 = 244;                          // porównaj z 244
        TIMSK |= (1<<OCIE2);            // zezwolenie na przerwanie CompareMath
		



}


ISR(TIMER2_COMP_vect)
{
flaga250ms = 1;	
flaga_250ms_2 = 1;				//flaga co 250ms
flaga_250ms_3 = 1;

if (sekundy > 8) sekundy = 0;
sekundy++;
//s2_flag = 1;
//piki++;
//if (piki == 10) piki = 0;

}
