#include <avr/interrupt.h>
#include <util/delay.h>

#include "../I2C/i2c_twi.h"
#include "../TIME_DATE/time_date.h"
#include "../main.h"
#include "../LCD/lcd44780.h"

#define PCF8583_ADDR 0xA2

typedef unsigned char  u08;
typedef unsigned short u16;


void rtc_init(void){
	MCUCR |= (1<<ISC01);	
	GICR |= (1<<INT0);		
	PORTD |= (1<<PD2);		
	i2cSetBitrate(100);
}

void export_time_rtc(void){
	uint8_t bufor[6];

	bufor[0] = 0;
	bufor[1] = global_time.sec;
	bufor[2] = global_time.min;
	bufor[3] = global_time.hr;
	bufor[4] = global_time.day & 0x3F;
	bufor[5] = global_time.mm & 0x3F;

	TWI_write_buf( PCF8583_ADDR, 0x01, 6, bufor );
}

void import_time_rtc(void){
	uint8_t bufor[6];

	TWI_read_buf( PCF8583_ADDR, 0x01, 6, bufor );

	global_time.sec = bufor[1];	// sekundy
	global_time.min = bufor[2];	// minuty
	global_time.hr  = bufor[3];	// godziny
	global_time.day = bufor[4] & 0x3F;
	global_time.mm  = bufor[5] & 0x3F;
}

ISR( INT0_vect ) {
	_utility_flags.rtc_int_flag = 1;
}
