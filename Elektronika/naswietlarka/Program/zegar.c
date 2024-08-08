#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include "zegar.h"

volatile uint8_t pol_sekundy;
volatile uint8_t s1_flag;
volatile uint8_t piki;
volatile uint8_t s2_flag;



void zegar(void)
{

		piki = 0;

		//TIMER 2
		TCCR2 |= (1<<WGM21);				// timer2 ctc
        TCCR2 |= (1<<CS22)|(1<<CS20)|(1<<CS21);                // preskaler = 1024
        OCR2 = 97;                          // porównaj z 50
        TIMSK |= (1<<OCIE2);            // zezwolenie na przerwanie CompareMath
		DDRD = 0xFF;
		PORTD = 0x00;



}


ISR(TIMER2_COMP_vect)
{
s1_flag = 1;					//flaga co 10Hz
s2_flag = 1;
piki++;
if (piki == 10) piki = 0;

}
