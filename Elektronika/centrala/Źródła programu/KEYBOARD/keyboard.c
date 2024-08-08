#include "../includes.h"

uint8_t keyboard_check() {									
	uint8_t lines = 0;

	switch (get_H_quadro){
		case (1<<4):
			kb_port_direction = (1<<4);
			while(!(0x0F^(get_L_quadro)));
			lines = (1<<4);
			lines |= get_L_quadro;
			all_K_pins_in;
			break;
		case (1<<5):
			kb_port_direction = (1<<5);
			while(!(0x0F^(get_L_quadro)));
			lines = (1<<5);
			lines |= get_L_quadro;
			all_K_pins_in;
			break;
		case (1<<6):
			kb_port_direction = (1<<6);
			while(!(0x0F^(get_L_quadro)));
	 		lines = (1<<6);
			lines |= get_L_quadro;
			all_K_pins_in;
			break;
		case (1<<7):
			kb_port_direction = (1<<7);
			while(!(0x0F^(get_L_quadro)));
			lines = (1<<7);
			lines |= get_L_quadro;
			all_K_pins_in;
			break;
		default:
			lines = 0;
			all_K_pins_in;
			break;
	}
	all_K_pins_in;
	return lines;
}


void keyboard_init (void) {
		DDRD &= ~ki_pin;
		PORTD &= ~ki_pin;
		GICR |= (1<<INT1);
		MCUCR |= (1<<ISC11)|(1<<ISC10);
		all_K_pins_in;
		L_quadro_K_pins_pull_up;
}

uint8_t get_digit(uint8_t data){
	switch(data){
		case button_1:
			return 1;
		case button_2:
			return 2;
		case button_3:
			return 3;
		case button_4:
			return 4;
		case button_5:
			return 5;
		case button_6:
			return 6;
		case button_7:
			return 7;
		case button_8:
			return 8;
		case button_9:
			return 9;
		case button_0:
			return 0;
		default:
			return 0xFF;
	}
}

ISR(INT1_vect){
	if(!(_utility_flags.kb_digit_flag || _utility_flags.kb_func_flag)){
		buzzer(BUTTON);
		button = 0;
		_utility_flags.kb_button_flag = 1;
	}
}


