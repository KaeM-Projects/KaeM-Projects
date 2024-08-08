#include "../includes.h"

void LCD_time_print(uint8_t line_pos, uint8_t col_pos, time_date _time_date, BOOL no_sec){
	lcd_locate(line_pos,col_pos);
	lcd_int(_time_date.hr >> 4);
	lcd_int(_time_date.hr & 0x0F);
	lcd_str(":");
	lcd_int(_time_date.min >> 4);
	lcd_int(_time_date.min & 0x0F);
	if(!no_sec){
		lcd_str(":");
		lcd_int(_time_date.sec >> 4);
		lcd_int(_time_date.sec & 0x0F);
	}
}

void LCD_date_print(uint8_t line_pos, uint8_t col_pos, time_date _time_date){
	lcd_locate(line_pos,col_pos);
	lcd_int(_time_date.day >> 4);
	lcd_int(_time_date.day & 0x0F);
	lcd_str("-");
	lcd_int(_time_date.mm >> 4);
	lcd_int(_time_date.mm & 0x0F);
	lcd_str("-");
	lcd_int(_time_date.yr >> 4);
	lcd_int(_time_date.yr & 0x0F);
}

void LCD_status_update(){ 
	lcd_locate(0,9);
	if (_status_flags.is_armed_flag == ARMED) lcd_str("ARMED");
	else if (_status_flags.is_armed_flag == DISARMED) lcd_str("D-ARMED");
	else lcd_str("xxxxxxx");
}

void LCD_initial_status(void){
	lcd_cls();
	LCD_time_print(0,0,global_time, FALSE);
	LCD_date_print(1,0,global_time);
	LCD_status_update();
	_utility_flags.lock_LCD_update_flag = 0;
}

void LCD_blinking(uint8_t pos_line, uint8_t pos_col, type_set status){
	static uint8_t _pos_line = 0;
	static uint8_t _pos_col = 0;
	static uint8_t _val = 0;
	if(status){

		_pos_line = pos_line;
		_pos_col = pos_col;
		lcd_locate(_pos_line, _pos_col-1);
		_val = lcd_byte_read();
		lcd_locate(0,0);
	}
			if(_foo_flags.lcd_blinks){
				lcd_locate(_pos_line, _pos_col-1);
				lcd_write_data(_val);
			}
			else {
				lcd_locate(_pos_line, _pos_col-1);
				lcd_str(" ");
			}
}

void _get_pin(uint8_t *_digit_cnt, uint16_t *_tmp_pin){
	if(_utility_flags.kb_digit_flag){
		*_tmp_pin &= ~(0x000F << ((*_digit_cnt-1) * 4));
		*_tmp_pin |= get_digit(button) << ((*_digit_cnt-1) * 4);
		(*_digit_cnt)--;
		lcd_locate(1,(9 - *_digit_cnt));
		lcd_str("*");
		_utility_flags.kb_digit_flag = 0;
	}
	if(_utility_flags.kb_func_flag){
		switch(button){
		case button_CANCEL:

			lcd_locate(1,5);
			lcd_str("[    ]");
			lcd_locate(1,6);
			*_tmp_pin = 0xFFFF;
			*_digit_cnt = 4;
			break;
		default:
			break;
		}
		_utility_flags.kb_func_flag = 0;
	}
}

uint16_t get_pin(type_set _is_set){
	_foo_flags.get_pin = 1;
	uint8_t _digit_cnt = 4;
	uint16_t _tmp_pin = 0xFFFF;

	while(_foo_flags.get_pin){
		if(_is_set){
			lcd_cls();
			lcd_locate(0,1);
			lcd_str("Input new PIN:");
		}
		lcd_locate(1,5);
		lcd_str("[    ]");
		lcd_locate(1,6);
		_digit_cnt = 4;
		while(_digit_cnt)_get_pin(&_digit_cnt, &_tmp_pin);

		_delay_ms(250);
		if(_is_set){
			_digit_cnt = 4;
			uint16_t _tmp_pin_2 = 0xFFFF;
			lcd_cls();
			lcd_locate(0,2);
			lcd_str("Confirm PIN");
			lcd_locate(1,5);
			lcd_str("[    ]");
			lcd_locate(1,6);
			while(_digit_cnt)_get_pin(&_digit_cnt, &_tmp_pin_2);
			_delay_ms(250);
			if(_tmp_pin == _tmp_pin_2){
				_is_set = 0;
				_foo_flags.get_pin = 0;
				return _tmp_pin;
				break;
			}
			else{
				lcd_cls();
				lcd_locate(0,5);
				lcd_str("PIN numbers");
				lcd_locate(1,2);
				lcd_str("inconsistent");
				_delay_ms(2000);
			}
		}
		else{
			_foo_flags.get_pin = 0;
			return _tmp_pin;
		}
	}
	_foo_flags.get_pin = 0;
	return 0xFFFF;
}

BOOL _pin_correct (uint16_t pin){
	if(((pin & 0x000F) == 0x000F) ||
	   ((pin & 0x00F0) == 0x00F0) ||
	   ((pin & 0x0F00) == 0x0F00) ||
	   ((pin & 0xF000) == 0xF000) ||
	   (pin  == 0xFFFF)
	) return FALSE;
	else return TRUE;
}

void set_PIN(void){
	while(!(_pin_correct(PIN))) PIN = get_pin(SET);
	export_pin_eeprom();
}

void change_PIN(void){
	lcd_cls();
	lcd_str("Type actual PIN:");
	if(get_pin(x) == PIN){
		PIN = get_pin(SET);
	}
	else{
		lcd_cls();
		lcd_locate(0,3);
		lcd_str("Wrong PIN");
		lcd_locate(1,3);
		lcd_str("Canceled");
		buzzer(WRONG);
		_delay_ms(2000);
	}
	LCD_initial_status();
}

void system_initialize(){
	lcd_cls();
	LCD_LED_ON;  			
	LCD_initial_status();
	_delay_ms(2000);
	set_time();
	set_date();
	set_PIN();
	LCD_initial_status();
}

void set_time_date(void){
	set_time();
	set_date();
	LCD_initial_status();
}

void LCD_alarm_triggered(void){
	lcd_cls();
	lcd_locate(0,5);
	lcd_str("ALARM");
	lcd_locate(1,3);
	lcd_str("TRIGGERED!");
}

void trigger_alarm(void){
	_utility_flags.trigger_alarm_flag = 1;
	LCD_alarm_triggered();
	SIREN_ON;
}

void toggle_alarm_status(void){
	if(_status_flags.is_armed_flag == DISARMED){
		_utility_flags.lock_LCD_update_flag = 1;
		_time_to_arm = 30;
		lcd_cls();
		_status_flags.is_armed_flag = TOGGLE;
	}
	else if(_status_flags.is_armed_flag == ARMED){
		_status_flags.is_armed_flag = DISARMED;
		_utility_flags.trigger_alarm_flag = 0;
		LCD_initial_status();
	}
	else{
		_status_flags.is_armed_flag = DISARMED;
		_utility_flags.trigger_alarm_flag = 0;
		LCD_initial_status();
	}
	export_user_settings();
}

void toggle_alarm_status_by_pin(void){
	uint8_t _attempts_cnt = 2;
	lcd_cls();
	if(get_pin(x) == PIN){
		toggle_alarm_status();
	}
	else{
		if(_status_flags.is_armed_flag == DISARMED){
			lcd_cls();
			lcd_locate(0,3);
			lcd_str("Wrong PIN");
			lcd_locate(1,3);
			lcd_str("Canceled");
			buzzer(WRONG);
			_delay_ms(2000);
			LCD_initial_status();
		}
		else{
			while(_attempts_cnt){
				lcd_locate(1,0);
				buzzer(WRONG);
				lcd_str("Attempts left: ");
				lcd_int(_attempts_cnt);
				_delay_ms(2000);
				lcd_locate(1,0);
				lcd_str("     [    ]     ");
				_attempts_cnt--;
				if(get_pin(x) == PIN){
					toggle_alarm_status();
					return;
				}
			}
			_status_flags.is_armed_flag = ARMED;
			_utility_flags.trigger_alarm_flag = 1;
			_utility_flags.lock_LCD_update_flag = 1;
			LCD_alarm_triggered();
		}
	}
}


void simulator_from_SD_menu(void){
	modules module = sim_module_1;
	_foo_flags.simul_set=1;
	lcd_cls();
	lcd_str("Load for module:");
	lcd_locate(1,0);
	lcd_str("Module 1");

	while(_foo_flags.simul_set){
		if(_utility_flags.kb_digit_flag)_utility_flags.kb_digit_flag = 0;
		if(_utility_flags.kb_func_flag){
			switch(button){
			case button_UP:
				module++;
				break;
			case button_DOWN:
				module--;
				break;
			case button_CANCEL:
				LCD_initial_status();
				_foo_flags.simul_set = 0;
				return;
			case button_OK:
				if(SD_CD_status){
					_foo_flags.simul_set = 0;
					_utility_flags.kb_func_flag = 0;
					get_simulator_program(module);
				}
				else{
				lcd_cls();
				buzzer(WRONG);
				lcd_str("SD not detected");
				lcd_locate(1,1);
				lcd_str("Insert SD card");
				_delay_ms(2000);
				}
				break;
			default:
				break;
			}
			if(module == 0) module = sim_module_1;
			else if (module == 3) module = sim_module_1;
			switch(module){
			case sim_module_1:
				lcd_cls();
				lcd_str("Load for module:");
				lcd_locate(1,0);
				lcd_str("Module 1");
				break;
			default:
				module = sim_module_1;
				break;
			}
			_utility_flags.kb_func_flag = 0;
		}
	}
}

void locator_simulator_menu(void){
	enum{
		on_off = 1,
		read_disc,
	}simulator_menu = on_off;
	_foo_flags.simul_set=1;
	lcd_cls();
	lcd_str("ON/OFF simulator");
	lcd_locate(1,3);
	lcd_str("Actual: ");
	lcd_str(_status_flags.is_simulator_on?"ON":"OFF");

	while(_foo_flags.simul_set){
		if(_utility_flags.kb_digit_flag)_utility_flags.kb_digit_flag = 0;
		if(_utility_flags.kb_func_flag){
			switch(button){
			case button_UP:
				simulator_menu++;
				break;
			case button_DOWN:
				simulator_menu--;
				break;
			case button_CANCEL:
				LCD_initial_status();
				_foo_flags.simul_set = 0;
				return;
			case button_OK:
				switch(simulator_menu){
				case on_off:
					_status_flags.is_simulator_on = ~_status_flags.is_simulator_on;
					export_user_settings();
					break;
				case read_disc:
					_foo_flags.simul_set = 0;
					_utility_flags.kb_func_flag = 0;
					simulator_from_SD_menu();
					break;
				default:
					break;
				}
				break;
			default:
				break;
			}
			if(simulator_menu == 0) simulator_menu = read_disc;
			else if (simulator_menu == 3) simulator_menu = on_off;
			switch(simulator_menu){
			case on_off:
				lcd_cls();
				lcd_str("ON/OFF simulator");
				lcd_locate(1,3);
				lcd_str("Actual: ");
				lcd_str(_status_flags.is_simulator_on?"ON":"OFF");
				break;
			case read_disc:
				lcd_cls();
				lcd_locate(0,1);
				lcd_str("Import program");

				break;
			default:
				simulator_menu = on_off;
				break;
			}
			_utility_flags.kb_func_flag = 0;
		}
	}
}

void main_menu(void){
	_foo_flags.main_menu = 1;
	enum{
		time_set=1,
		pin_set,
		simulator
	}menu = time_set;

	lcd_cls();
	lcd_locate(0,4);
	lcd_str("Set Time");

	while(_foo_flags.main_menu){
		if(_utility_flags.kb_digit_flag){
			buzzer(WRONG);
			_utility_flags.kb_digit_flag = 0;
		}
		if(_utility_flags.kb_func_flag){
			switch(button){
			case button_UP:
				menu++;
				break;
			case button_DOWN:
				menu--;
				break;
			case button_CANCEL:
				LCD_initial_status();
				_foo_flags.main_menu = 0;
				break;
			case button_OK:
				switch(menu){
				case time_set:
					_foo_flags.main_menu = 0;
					_utility_flags.kb_func_flag = 0;
					set_time_date();
					break;
				case pin_set:
					_foo_flags.main_menu = 0;
					_utility_flags.kb_func_flag = 0;
					change_PIN();
					break;
				case simulator:
					_foo_flags.main_menu = 0;
					_utility_flags.kb_func_flag = 0;
					locator_simulator_menu();
					break;
				default:
					break;
				}
				break;
			default:
				buzzer(WRONG);
				break;
			}
			if(menu == 0) menu = 3;
			else if (menu == 4) menu = 1;
			switch(menu){
			case time_set:
				lcd_cls();
				lcd_locate(0,4);
				lcd_str("Set Time");
				break;
			case pin_set:
				lcd_cls();
				lcd_locate(0,4);
				lcd_str("Set PIN");
				break;
			case simulator:
				lcd_cls();
				lcd_locate(0,4);
				lcd_str("Locator");
				lcd_locate(1,3);
				lcd_str("simulator");
				break;
			default:
				menu = time_set;
				break;
			}
			_utility_flags.kb_func_flag=0;
		}
	}
}



