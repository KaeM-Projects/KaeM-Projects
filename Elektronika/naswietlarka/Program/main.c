#include <avr/io.h>
#include <util/delay.h>
#include <avr/interrupt.h>
#include "7_segm.h"
#include "zegar.h"

#define par_MIN 0								//definiowanie do minuty i godziny
#define par_MAX 59

//przycisk 1 warto�ci zwi�ksz							
#define pin_przycisk_1 (1<<PC7)
#define przycisk_1 !(PINC & pin_przycisk_1)

//przycisk 2 warto�ci zmniejsz
#define pin_przycisk_2 (1<<PC6)
#define przycisk_2 !(PINC & pin_przycisk_2)

//przycisk 3 funkcyjny
#define pin_przycisk_3 (1<<PC5)
#define przycisk_3 !(PINC & pin_przycisk_3)

//przycisk 4 start/pauza
#define pin_przycisk_4 (1<<PC4)
#define przycisk_4 !(PINC & pin_przycisk_4)

//przycisk 5 stop
#define pin_przycisk_5 (1<<PC3)
#define przycisk_5 !(PINC & pin_przycisk_5)

//przycisk 6 �wiat�o w��cz wy��cz poza odliczaniem
#define pin_przycisk_6 (1<<PC2)
#define przycisk_6 !(PINC & pin_przycisk_6)



//�wiate�o
#define pin_swiatlo (1<<PC1)
#define swiatlo_on PORTC &= ~pin_swiatlo
#define swiatlo_off PORTC |= pin_swiatlo





#define czekaj_tyle 10000		//czekaj tyle przy wcinietym przycisku
#define od_tylu_zliczaj 9000	//od tylu zaczynaj nast�pne czekanie


#define pin_pikaczu (1<<PC0)	//definicja pinu i warto�ci g�o�ciczka
#define pikaczu_on PORTC |= pin_pikaczu
#define pikaczu_off PORTC &= ~pin_pikaczu



// zmienne dla przycisk�w

uint8_t zatrzask_1 = 0;			//zatrzaski dla przycisk�w
uint8_t zatrzask_2 = 0;
uint8_t zatrzask_3 = 0;
uint8_t zatrzask_4 = 0;
uint8_t zatrzask_5 = 0;
uint8_t zatrzask_6 = 0;

uint8_t zezwol = 1;				//zezw�l na przycisk 1,2,3
uint8_t licz = 0;



uint16_t staly_1 = 0;			//kontrolka wcisku sta�ego
uint16_t staly_2 = 0;

////////////

uint8_t par = 0;				//zmienna "parametr" dla ustawianych wartosci minut i sekund
uint8_t tryb = 1;				//tryb: ustawianie:
uint8_t	sec = 0;				//sekundy
uint8_t min = 0;				//minuty
uint8_t nima = 0;				//wcale
uint8_t tab_par[4];				//tablica dla wyswietlaczaa
uint8_t s_p = 0;				//zmienna definiuj�ca czy start czy pauza
uint8_t s_r = 0;				//zmienna czy stop czy zeruj
uint16_t licznik=0;				//licznik do zliczania czasu w funkcji odlizanie
uint16_t licznik_2=0;			//licznik do liczenia czasu w miganiu dla tryb�w
uint8_t sec_mem;				//pami�� ustawionych sekund dla powrotu przy STOP
uint8_t min_mem;				//j.w. dla minut
uint8_t s_z = 0;				//zmienna dla przerzutnika w��cz wy��cz �wiqt�o 

//////////// funkcje 



void zmiana_dla_trybu_wej()		//podmiana zmiennych w zale�no�ci od trybu dla pocz�tku funkcji
{

	if (tryb == 1)
	{
		par = nima;
	}
	if (tryb == 2)
	{
		par = min;
	}
	if (tryb == 4)
	{
		par = sec;
	}

}


void zmiana_dla_trybu_wyj()		//j.w. dla ko�ca funkcji
{

	if (tryb == 1)
	{
		nima = par;
	}
	if (tryb == 2)
	{
		min = par;
	}
	if (tryb == 4)
	{
		sec = par;
	}

}


void zmiana_parametrow()	//ustal parametry wyj�ciowe i wy�wietl
{

	uint8_t par_rob;
	uint8_t i;

	par_rob = sec;
	for(i=0; i<=1; i++)					//minuty na cyfry w tablicy [0][1]
		{
			tab_par[i]=par_rob%10;
			par_rob /=10;
   		}


	par_rob = min;						//sekundy w tablicy [2][3]
	for(i=2; i<=3; i++)
		{
			tab_par[i]=par_rob%10;
			par_rob /=10;
   		}		

						//wy�wietl


	if (tryb == 1)							//dla trybu 1 normalnie
		{
			wysw_1 = tab_par[3];
   			wysw_2 = tab_par[2];
   			wysw_3 = tab_par[1];
			wysw_4 = tab_par[0];	
		}
//////////////////////////////////////////////	
	if (tryb == 2)							//dla trybu 2 minuty migaj�
	{

		if (piki <=7)
			{
				wysw_1 = tab_par[3];
   				wysw_2 = tab_par[2];
		
			}
		if (piki >7)
			{
				wysw_1 = NIC;
   				wysw_2 = NIC;
			
			}

   		wysw_3 = tab_par[1];
		wysw_4 = tab_par[0];
	}
//////////////////////////////////////////////////////
	if (tryb == 4)							//dla trybu 4 sekundy migaj�
	{

   		wysw_1 = tab_par[3];
		wysw_2 = tab_par[2];


		if (piki <=7)
			{
				wysw_3 = tab_par[1];
   				wysw_4 = tab_par[0];
		
			}
		if (piki >7)
			{
				wysw_3 = NIC;
   				wysw_4 = NIC;
			
			}


	}

	if (tryb == 5)								//dla pauzy miga wszystko
	{
		if (piki <=5)
			{
			wysw_1 = tab_par[3];
   			wysw_2 = tab_par[2];
   			wysw_3 = tab_par[1];
			wysw_4 = tab_par[0];
		
			}
		if (piki >5)
			{
			wysw_1 = NIC;
   			wysw_2 = NIC;
   			wysw_3 = NIC;
			wysw_4 = NIC;
			
			}


	}

		

}



void zwieksz_par()					//wi�kszanie wart. par dla wcis. przycisku
{

	zmiana_dla_trybu_wej();


	if (par<par_MAX) 
	{
		par++;
	}
	else 
	{

		par = par_MIN;

	}
	zmiana_dla_trybu_wyj();
	zmiana_parametrow();

	sec_mem = sec;					//zapami�taj warto�ci ustawione
	min_mem = min;

}



void zmniejsz_par()					//zmniejsz wart par dla przycisku
{

	zmiana_dla_trybu_wej();

	if (par>par_MIN)
		{
			par--;
		}
	else 
	{

		par = par_MAX;
		
	}
	zmiana_dla_trybu_wyj();
	zmiana_parametrow();

	sec_mem = sec;					//zapami�taj warto�ci ustawione
	min_mem = min;

}


void odliczanie()			//funkcja obs�ugi odliczania
{
uint8_t bylo = 0;
uint8_t k=1;

	if (min + sec)
	{
		licz = 1;
		if (~s_p) tryb = 5;
		else tryb = 1;

		s_r = 1;
		bylo = 1;
		if (s_p)					//dla start
		{
			
			tryb = 1;
			swiatlo_on;
			zezwol = 0;					//zablokuj przyciski
		
			if (s1_flag)				//JE�ELI TYKNIE PRZERWANIE
			{
				licznik++;
				if (licznik == 10)
				{
					if (sec>0) sec--;
					else 
					{
					sec = 59;
					min--;
					}
					licznik = 0;

				}
			s1_flag = 0;
			zmiana_parametrow();
			}


		}
		else						// dla pauza
		{
		swiatlo_off;
	
		}
	}
	if (bylo)
	{
		if (!(min + sec))
		{
			swiatlo_off;
			while (k)
			{
				wysw_1 = NIC;
   				wysw_2 = 11;
   				wysw_3 = 12;
				wysw_4 = 13;
				
				if (s1_flag) 
				{
					licznik_2++;

					if (licznik_2 <= 10) pikaczu_on;
					if (licznik_2 >10 ) pikaczu_off;

					if (licznik_2 >= 13) pikaczu_on;
					if (licznik_2 >23 ) pikaczu_off;

					if (licznik_2 >= 26) pikaczu_on;
					if (licznik_2 >36 ) pikaczu_off;
				
					if (licznik_2 == 40) k=0;
					s1_flag = 0;
				}			

			}
			zezwol = 1;
			bylo = 0;
			zmiana_parametrow();
			licz = 0;
			s_p = 0;
			licznik_2 = 0;
		}
	}
}







void zatrzymaj()
{
	if (s_r)			//zatrzymaj
	{
	licz = 0;
	swiatlo_off;
	zezwol = 1;			//odblokuj przyciski
	s_r = 0;
	s_p = 0;
	tryb = 1;
	sec = sec_mem;
	min = min_mem;
	zmiana_parametrow();

	}
	else				//resetuj
	{
	sec = 0;
	min = 0;
	zmiana_parametrow();
	}


}



///////////////////////////////////


int main(void)
{
	wyswietlanie_led();

	zegar();

	swiatlo_off;

	DDRC &= ~pin_przycisk_1;	//ustawianie pin�w przycisk�w na wej�ciowe 
	PORTC |=pin_przycisk_1;		//i podci�gni�cie do VCC

	DDRC &= ~pin_przycisk_2;
	PORTC |=pin_przycisk_2;

	DDRC &= ~pin_przycisk_3;
	PORTC |=pin_przycisk_3;

	DDRC &= ~pin_przycisk_4;
	PORTC |=pin_przycisk_4;

	DDRC &= ~pin_przycisk_5;
	PORTC |=pin_przycisk_5;

	DDRC &= ~pin_przycisk_6;
	PORTC |=pin_przycisk_6;


	DDRC |= pin_pikaczu;

	DDRC |= pin_swiatlo;

	DDRB = 0xFF;				//wyj�cie na anody
	PORTB = 0xFF;

	sei();						//zezw�l na przerwania
	zmiana_parametrow();		//ustal co wy�wietla� po w��czeniu
					


	while(1)
	{	

		if (przycisk_1 && !zatrzask_1 && zezwol)	//je�li przycisk pierwszy raz
			{
			
										//funkcja w�a�ciwa
				zatrzask_1=1;			//ustawienie zatrzasku
				staly_1=0;			//zerowanie kontrolki przycisku sta�ego
				zwieksz_par();
					
						
			}


		if (!(przycisk_1) && zatrzask_1 && zezwol) 	//drgania styk�w
			{	
				zatrzask_1++;
			
			}



		if (przycisk_1 && zatrzask_1 && zezwol)		//je�li przycisk d�u�ej wci�ni�ty
			{
			
				
				if (staly_1 == czekaj_tyle)		
					{
					staly_1 = od_tylu_zliczaj;
					zwieksz_par();
						
					}		
				staly_1++;
			}					
			
///////////////////////////////////////////////////zmniejszanie temp			
			
		if (przycisk_2 && !zatrzask_2 && zezwol)	//je�li przycisk pierwszy raz
			{
			
										//funkcja w�a�ciwa
				zatrzask_2=1;			//ustawienie zatrzasku
				staly_2=0;			//zerowanie kontrolki przycisku sta�ego
				zmniejsz_par();
					
						
			}


		if (!(przycisk_2) && zatrzask_2 && zezwol) 	//drgania styk�w
			{	
				zatrzask_2++;
				
			}



		if (przycisk_2 && zatrzask_2 && zezwol)		//je�li przycisk d�u�ej wci�ni�ty
			{
			
					
				if (staly_2 == czekaj_tyle)		
					{
					staly_2 = od_tylu_zliczaj;
					zmniejsz_par();
						
					}		
				staly_2++;
			}

/////////////////////////////////////////////////////////////////////////////


		if (przycisk_3 && !zatrzask_3 && zezwol)	//je�li przycisk pierwszy raz
			{
			
										//funkcja w�a�ciwa
				zatrzask_3=1;			//ustawienie zatrzasku
				tryb = tryb << 1;
				if (tryb == 8) tryb=1;
				zmiana_parametrow();
											
			}


		if (!(przycisk_3) && zatrzask_3 && zezwol) 	//drgania styk�w
			{	
				zatrzask_3++;

			}

///////////////////////////////////////////////////////////////////////



		if (przycisk_4 && !zatrzask_4)	//je�li przycisk pierwszy raz
			{
			
											//funkcja w�a�ciwa
				zatrzask_4=1;				//ustawienie zatrzasku
				if (min + sec)s_p = ~s_p;
				
				odliczanie();						//zmiana start/pauza po kolejnych wci�ni�ciach
										//zatrzask odliczania
				
											
			}


		if (!(przycisk_4) && zatrzask_4) 	//drgania styk�w
			{	
				zatrzask_4++;

			}


////////////////////////////////////////////////////////


		if (przycisk_5 && !zatrzask_5)	//je�li przycisk pierwszy raz
			{
			
										//funkcja w�a�ciwa
				zatrzask_5=1;			//ustawienie zatrzasku
				zatrzymaj();			//zatrzymaj odliczanie i wyresetuj

				
											
			}


		if (!(przycisk_5) && zatrzask_5) 	//drgania styk�w
			{	
				zatrzask_5++;

			}


////////////////////////////////////////////////////////////


		if (przycisk_6 && !zatrzask_6 && zezwol)	//je�li przycisk pierwszy raz
			{
			
											//funkcja w�a�ciwa
				zatrzask_6=1;				//ustawienie zatrzasku
				

			if (s_z == 0) swiatlo_on;
			else swiatlo_off;
			s_z = ~s_z;
				
							        	//zmiana start/pauza po kolejnych wci�ni�ciach
										//zatrzask odliczania
				
											
			}


		if (!(przycisk_6) && zatrzask_6 && zezwol) 	//drgania styk�w
			{	
				zatrzask_6++;

			}

////////////////////////////////////////////////////////////////////
		if (licz) odliczanie();			//funkcja odliczaj�ca
	
		if (tryb>1)
		{

			if (s2_flag)
			{
				zmiana_parametrow();
				s2_flag = 0;
			}

	
		}
//////////////////////////////////////////////////////////////

	}			//koniec while
		
}		//koniec main
