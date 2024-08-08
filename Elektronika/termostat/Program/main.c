#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include "7_segm.h"
#include "zegar.h"
#include "ds18x20.h"

#define temp_MIN 10
#define temp_MAX 120
#define BLAD 3

//przycisk 1 temp w górê
#define pin_przycisk_1 (1<<PC7)
#define przycisk_1 !(PINC & pin_przycisk_1)

//przycisk 2 temp w dó³
#define pin_przycisk_2 (1<<PC6)
#define przycisk_2 !(PINC & pin_przycisk_2)

#define pin_przycisk_3 (1<<PC5)
#define przycisk_3 !(PINC & pin_przycisk_3)

#define czekaj_tyle 5000		//czekaj tyle przy wcinietym przycisku
#define od_tylu_zliczaj 4500

#define pin_pikaczu (1<<PC0)
#define pikaczu_on PORTC |= pin_pikaczu
#define pikaczu_off PORTC &= ~pin_pikaczu

#define pin_grzalka (1<<PB7)
#define grzalka_off PORTB |= pin_grzalka
#define grzalka_on PORTB &= ~pin_grzalka

#define pin_gotowy_led (1<<PB5)
#define gotowy_led_off PORTB |= pin_gotowy_led
#define gotowy_led_on PORTB &= ~pin_gotowy_led 


uint8_t	tab_temp[3];
uint8_t temp = temp_MIN;
uint8_t a = 1;
// zmienne dla przycisków


uint8_t czujniki_cnt;
uint8_t subzero, cel, cel_frac_bits;
uint8_t wynik, popr = 0;
uint8_t temp_rob = temp_MIN;
uint8_t cnt250ms = 0;
uint8_t pol_sec = 0;
uint8_t zakres_1;
uint8_t zakres_2;
uint8_t pszy_raz = 0;
////////////


//////////// funkcje
void zmiana_parametrow()
{

	uint8_t i;
	
	for(i=0; i<=2; i++)
		{
			tab_temp[i]=temp_rob%10;
			temp_rob /=10;
   		}	

	zakres_1 = (temp - 9);
	zakres_2 = (temp - 4);	
			
		if (popr)
		{
			if (tab_temp[2]>0) wysw_1 = tab_temp[2];
			else wysw_1 = NIC;
   			wysw_2 = tab_temp[1];
   			wysw_3 = tab_temp[0];
			wysw_4 = 10;
			wysw_5 = 11;
		}
		else
		{

			if(flaga_250ms_2)
			{
				if (pol_sec > 4) pol_sec = 0;		

				if (pol_sec <= 2)
				{
					if (tab_temp[2]>0) wysw_1 = tab_temp[2];
					else wysw_1 = NIC;
   					wysw_2 = tab_temp[1];
   					wysw_3 = tab_temp[0];
					wysw_4 = 10;
					wysw_5 = 11;
				}
				if (pol_sec > 2 )
				{
					wysw_1 = NIC;
					wysw_2 = E;
					wysw_3 = r;
					wysw_4 = r;
					wysw_5 = NIC;
				}
	
				pol_sec++;
				flaga_250ms_2 = 0;
			}
			

		}
}

///////////////////////////////////////////////////////////

void zwieksz_temp()
{
	if (temp<temp_MAX) 
	{
		temp++;
		a=1;
	}
	else 
	{
		if (a)
		{
			temp = temp_MAX;
			uint16_t j,k;
			for(k=0; k<=1; k++)
			{
				for(j=0; j<=5000; j++)
				{
					pikaczu_on;
		
				}
				for(j=0; j<=5000; j++)
				{
					pikaczu_off;
		
				}
			}
			a=0;
		}
	}
	temp_rob = temp;
	zmiana_parametrow();
}

//////////////////////////////////////////////////////////////////

void zmniejsz_temp()
{
	if (temp>temp_MIN)
		{
			temp--;
			a=1;
		}
	else 
	{
		if (a)
	{
		temp = temp_MIN;
		uint16_t j,k;
		for(k=0; k<=1; k++)
		{
			for(j=0; j<=5000; j++)
			{
				pikaczu_on;
		
			}

			for(j=0; j<=5000; j++)
			{
				pikaczu_off;
		
			}
		}
		a=0;
		}		
	}
	temp_rob = temp;
	zmiana_parametrow();

}

/////////////////////////////////////////////////////////////////////

void wyswietl_bierzaca()
{

	if (popr)
		{
			temp_rob = wynik;
			zmiana_parametrow();
		}
	else
		{
			wysw_1 = NIC;
			wysw_2 = E;
			wysw_3 = r;
			wysw_4 = r;
			wysw_5 = NIC;
		}


}


void grzalka()
{

	if (popr) 
	{
		if (wynik < zakres_1) grzalka_on;

		if ((wynik >= zakres_1) && (wynik <= zakres_2))
		{
			if (sekundy <= 4) grzalka_on;
			else grzalka_off;
		
		}

		if ((wynik > zakres_2) && (wynik < temp))
		{
			if (sekundy <= 2) grzalka_on;
			else grzalka_off;
		}

	

	
		if (wynik == temp)
			{
				if (sekundy <= 1) grzalka_on;
				else grzalka_off;
		
			}

		if (wynik > temp) grzalka_off;

	}
	else grzalka_off;

}

void gotowy()
{
	if ((wynik == temp) && !pszy_raz) 
	{
		gotowy_led_on;
		
	}
	if ((wynik - BLAD) == temp || (wynik + BLAD) == temp)
	{
	gotowy_led_off;
	pszy_raz = 0;
	}


}


void inicjalizacja_czujnika()
{

	czujniki_cnt = search_sensors();

	DS18X20_start_meas(DS18X20_POWER_EXTERN, NULL);

	_delay_ms(750);

	if (DS18X20_OK == DS18X20_read_meas_single( 0x28 , &subzero, &cel, &cel_frac_bits))
	{
	popr = 1;
	wynik = cel;
	}
		else popr = 0;

	_delay_ms(250);
}

///////////////////////////////////


int main(void)
{

uint8_t zatrzask = 0;
uint8_t zatrzask_2 = 0;
uint8_t zatrzask_3 = 0;
uint16_t staly = 0;				//kontrolka wcisku sta³ego
uint16_t staly_2 = 0;
uint8_t powroc = 0;
uint8_t bierz = 0;


	wyswietlanie_led();
	zegar();
	sei();

	DDRC &= ~pin_przycisk_1;	//ustawianie pinów przycisków na wejœciowe 
	PORTC |=pin_przycisk_1;		//i podci¹gniêcie do VCC

	DDRC &= ~pin_przycisk_2;
	PORTC |=pin_przycisk_2;

	DDRC &= ~pin_przycisk_3;
	PORTC |=pin_przycisk_3;

	DDRC |= pin_pikaczu;

	DDRB |= pin_grzalka;
	PORTB &= ~pin_grzalka;

	DDRB |= pin_gotowy_led;
	PORTB |= pin_gotowy_led;

	
	
//	

//	while (p1)
//	{

		wysw_1 = 8;
		wysw_2 = 8;
		wysw_3 = 8;
		wysw_4 = 8;
		wysw_5 = 8;

		pikaczu_on;


inicjalizacja_czujnika();

		pikaczu_off;

//		if (flaga_250ms_3)
//		{
//			p1++;
//			if (p1 == 7) p1 = 0;
//			flaga_250ms_3 = 0;
//		}
	
//	}

	zmiana_parametrow();


	while(1)
	{	
		

		if (przycisk_1 && !zatrzask)	//jeœli przycisk pierwszy raz
			{
			
										//funkcja w³aœciwa
				zatrzask=1;			//ustawienie zatrzasku
				staly=0;			//zerowanie kontrolki przycisku sta³ego
				zwieksz_temp();
					
						
			}


		if (!(przycisk_1) && zatrzask) 	//drgania styków
			{	
				zatrzask++;
			
			}



		if (przycisk_1 && zatrzask)		//jeœli przycisk d³u¿ej wciœniêty
			{
			
				
				if (staly == czekaj_tyle)		
					{
					staly = od_tylu_zliczaj;
					zwieksz_temp();
						
					}		
				staly++;
			}					
			
///////////////////////////////////////////////////zmniejszanie temp			
			
		if (przycisk_2 && !zatrzask_2)	//jeœli przycisk pierwszy raz
			{
			
										//funkcja w³aœciwa
				zatrzask_2=1;			//ustawienie zatrzasku
				staly_2=0;			//zerowanie kontrolki przycisku sta³ego
				zmniejsz_temp();
					
						
			}


		if (!(przycisk_2) && zatrzask_2) 	//drgania styków
			{	
				zatrzask_2++;
				
			}



		if (przycisk_2 && zatrzask_2)		//jeœli przycisk d³u¿ej wciœniêty
			{
			
					
				if (staly_2 == czekaj_tyle)		
					{
					staly_2 = od_tylu_zliczaj;
					zmniejsz_temp();
						
					}		
				staly_2++;
			}

/////////////////////////////////////////////////////////////////////////////


		if (przycisk_3 && !zatrzask_3)	//jeœli przycisk pierwszy raz
			{
			
										//funkcja w³aœciwa
				zatrzask_3=1;			//ustawienie zatrzasku
				bierz = 1;
				
					
						
			}


		if (!(przycisk_3) && zatrzask_3) 	//drgania styków
			{	
				zatrzask_3++;
				if (zatrzask_3 == 255) 
				{
					bierz = 0;
					temp_rob = temp;
					zmiana_parametrow();
				}
			}


///////////////////////////////////////////////////
		

		if (bierz) wyswietl_bierzaca();


//////////////////////////////////////////////////

		if (flaga250ms)
		{
			if (cnt250ms == 4) cnt250ms = 0;

			if (cnt250ms == 0)
			{
			//czujniki_cnt = search_sensors();
			DS18X20_start_meas(DS18X20_POWER_EXTERN, NULL);		//wysy³ ¿¹dania pomiaru
			
			}
			
			if (cnt250ms == 3)
			{
				if (DS18X20_OK == DS18X20_read_meas_single( 0x28 , &subzero, &cel, &cel_frac_bits))
				{
					popr = 1;
					wynik = cel;
				}
				else popr = 0;								//odczyt
		
			}
		cnt250ms++;
		flaga250ms = 0;

		}


	grzalka();
	gotowy();



	if (!popr) 
	{
		powroc = 1;
		temp_rob = temp;
		zmiana_parametrow();
	}
		
	if (popr && powroc) 
	{
		powroc = 0;
		temp_rob = temp;
		zmiana_parametrow();
	}




////////////////////////////////////////////////////////////////////////

	


//////////////////////////////////////////
	}  //koniec while
		
} //koniec main
