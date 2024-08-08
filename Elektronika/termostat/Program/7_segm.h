#ifndef     _7_segm_h_
#define     _7_segm_h_


#define			wysw_cyfry		PORTA
#define			wysw_cyfry_kier	DDRA
#define			port_anody		PORTB
#define			anody_kier		DDRB

#define			anoda_1		(1<<PB0)
#define			anoda_2		(1<<PB1)
#define			anoda_3		(1<<PB2)
#define			anoda_4		(1<<PB3)
#define			anoda_5		(1<<PB4)

#define SEG_A (1<<0)
#define SEG_B (1<<1)
#define SEG_C (1<<2)
#define SEG_D (1<<3)
#define SEG_E (1<<4)
#define SEG_F (1<<5)
#define SEG_G (1<<6)
#define SEG_DP (1<<7)

#define NIC 12
#define E 13
#define r 14


extern volatile uint8_t wysw_1;
extern volatile uint8_t wysw_2;
extern volatile uint8_t wysw_3;
extern volatile uint8_t wysw_4;
extern volatile uint8_t wysw_5;



void wyswietlanie_led(void); //obszar deklaracji fukcji udostêpnionych dla innych modu³ów

#endif //koniec _d_led_h
