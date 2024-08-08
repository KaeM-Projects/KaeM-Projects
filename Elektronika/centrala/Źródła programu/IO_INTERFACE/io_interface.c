#include "../includes.h"

#define PCF8574_1_ADDR 0x40
#define out_module_1 PCF8574_1_ADDR

#define SCK PB7
#define MOSI PB5
#define CS PB4
void SD_init(void){
	DDRB |= (1<<CS)|(1<<MOSI)|(1<<SCK)|(1<<CS);
	PORTB |= (1<<CS);
	SPCR |= (1<<SPE)|(1<<MSTR);
	SD_CD_set_in;
	SD_CD_pull_up;
}

void sensors_initialize(void){
	SENSOR_1_IN;
	SENSOR_1_LOW;

	SENSOR_2_IN;
	SENSOR_2_LOW;

	INTEGRITY_SENSOR_IN;
	INTEGRITY_SENSOR_LOW;

	buzzer_as_out;
	buzzer_off;
}

void set_out_module(uint8_t module, uint8_t value){
	TWI_write_exp(module,value);
}

void buzzer(buzz_type buzz){
	buzzer_delay = 10;
	switch(buzz){
	case WRONG:
		buzzer_time = 15;
		buzzer_pause = 15;
		buzzer_cnt = 2;
		buzzer_start = TRUE;
		break;
	case CORRECT:
		buzzer_time = 30;
		buzzer_pause = 1;
		buzzer_cnt = 1;
		buzzer_start = TRUE;
		break;
	case TIME_SEC:
		buzzer_time = 100;
		buzzer_pause = 1;
		buzzer_cnt = 1;
		buzzer_start = TRUE;
		break;
	case BUTTON:
		buzzer_time = 10;
		buzzer_pause = 1;
		buzzer_cnt = 1;
		buzzer_start = TRUE;
		break;
	default:
		buzzer_time = 0;
		buzzer_cnt = 0;
		buzzer_start = FALSE;
		break;
	}
}
