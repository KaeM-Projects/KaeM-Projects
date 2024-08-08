#include "../includes.h"

volatile time_date global_time = {0, 0, 0, 0x01, 0x01, 0x24};

time_date max_date_vals(time_date date/*, type_date *unit, uint8_t val*/){

	time_date _max_vals;

	_max_vals.hr = 0x23;
	_max_vals.min = 0x59;
	_max_vals.mm = 0x12;

	if((date.mm == 0x01) ||
	   (date.mm == 0x03) ||
	   (date.mm == 0x05) ||
	   (date.mm == 0x07) ||
	   (date.mm == 0x08) ||
	   (date.mm == 0x10) ||
	   (date.mm == 0x12)){
		_max_vals.day = 0x31;
	}
	else if((date.mm == 0x04) ||
		    (date.mm == 0x06) ||
		    (date.mm == 0x09) ||
		    (date.mm == 0x11)){
		_max_vals.day = 0x30;
	}
	else if((date.mm == 0x02)){
		if(!((date.yr + 4) %4)){
			_max_vals.day = 0x29;
		}
		else _max_vals.day = 0x28;
	}
	return _max_vals;
}

void set_time(void){
	_foo_flags.date_set = 1;
	type_date unit = hr_1;
	time_date _tmp_time = global_time;
	uint8_t _tmp_blink [4] = {6,7,9,10};  //pozycje cyfr na lcd
	uint8_t *pos;
	pos = &_tmp_blink[0];

	lcd_cls();
	lcd_locate(0,3);
	lcd_str("Set time:");
	LCD_time_print(1,5,_tmp_time, TRUE);
	LCD_blinking(1,*pos,SET);
	_foo_flags.is_lcd_blinks = 1;

	while(_foo_flags.date_set){
		if(_utility_flags.kb_digit_flag){
			_foo_flags.is_lcd_blinks = 0;
			switch(unit){
				case hr_1:
					if(get_digit(button)<=2){
							_tmp_time.hr &= 0x0F;
							_tmp_time.hr |= get_digit(button) << 4;
							unit++;
							pos++;
							}
					if(((_tmp_time.hr>>4) == 2) && ((_tmp_time.hr & 0x0F) > 3)) _tmp_time.hr = 0x23;
					break;
				case hr_0:
					if(!(((_tmp_time.hr >> 4) == 2) && (get_digit(button)>3))){
						_tmp_time.hr &= 0xF0;
						_tmp_time.hr |= get_digit(button);
						pos++;
						_utility_flags.kb_digit_flag = 0;
						unit++;
					}
					break;
				case min_1:
					if(get_digit(button)<=5){
							_tmp_time.min &= 0x0F;
							_tmp_time.min |= get_digit(button) << 4;
							unit++;
							pos++;
							}
					break;
				case min_0:
						_tmp_time.min &= 0xF0;
						_tmp_time.min |= get_digit(button);
						unit = hr_1;
						pos -= 3;
					break;
				default:
					break;
			}
			LCD_time_print(1,5,_tmp_time, TRUE);
			LCD_blinking(1,*pos,SET);
			_foo_flags.is_lcd_blinks = 1;
			_utility_flags.kb_digit_flag = 0;
		}
		if(_utility_flags.kb_func_flag){
			_foo_flags.is_lcd_blinks = 0;
			switch(button){
				case button_UP:
				case button_RIGHT:
					if(unit == min_0){
						unit = hr_1;
						pos -=3;
					}
					else{
						unit++;
						pos++;
					}
					break;
				case button_DOWN:
				case button_LEFT:
					if(unit == hr_1){
						unit = min_0;
						pos += 3;
					}
					else{
						unit--;
						pos--;
					}
					break;
				case button_OK:
					lcd_cls();
					global_time = _tmp_time;
					export_time_rtc();
					export_time_eeprom();
					LCD_initial_status();
					_foo_flags.date_set = 0;
					_utility_flags.kb_func_flag = 0;
					_foo_flags.is_lcd_blinks = 0;
					return;
				case button_CANCEL:
					lcd_cls();
					LCD_initial_status();
					_foo_flags.date_set = 0;
					_utility_flags.kb_func_flag = 0;
					_foo_flags.is_lcd_blinks = 0;
					return;
				default:
					buzzer(WRONG);
					break;
			}
			LCD_time_print(1,5,_tmp_time, TRUE);
			LCD_blinking(1,*pos,SET);
			_foo_flags.is_lcd_blinks = 1;
			_utility_flags.kb_func_flag = 0;
		}
	}
}

void set_date(void){
	_foo_flags.date_set = 1;
	type_date _unit = day_1;
	time_date _tmp_time = global_time;
	uint8_t _tmp_blink [6] = {4,5,7,8,10,11};
	uint8_t _tmp_digit = 0;

	uint8_t *pos = &_tmp_blink[0];

	lcd_cls();
	lcd_locate(0,3);
	lcd_str("Set date:");
	lcd_locate(1,3);
	lcd_str("DD-MM-YR");
	_delay_ms(2000);
	LCD_date_print(1,3,_tmp_time);
	LCD_blinking(1,*pos,SET);
	_foo_flags.is_lcd_blinks = 1;

	while(_foo_flags.date_set){
		//korekcja daty?
		if(_utility_flags.kb_digit_flag){
			_tmp_digit = get_digit(button);
			_foo_flags.is_lcd_blinks = 0;
			time_date _max_vals = max_date_vals(_tmp_time);
			switch(_unit){
				case day_1:
					if(_tmp_digit <= ((_max_vals.day & 0xF0)>>4)){
						_tmp_time.day &= 0x0F;
						_tmp_time.day |= (_tmp_digit << 4);
						_unit++;
						pos++;
					}
					break;
				case day_0:
					if(((_tmp_time.day & 0xF0) | _tmp_digit) <= _max_vals.day){
						_tmp_time.day &= 0xF0;
						_tmp_time.day |= _tmp_digit;
						_unit++;
						pos++;
					}
					break;
				case mm_1:
					if(_tmp_digit <= ((_max_vals.mm & 0xF0)>>4)){
						_tmp_time.mm &= 0x0F;
						_tmp_time.mm |= (_tmp_digit << 4);
						_unit++;
						pos++;
					}
					break;
				case mm_0:
					if(((_tmp_time.mm & 0xF0) | _tmp_digit) <= _max_vals.mm ){
						_tmp_time.mm &= 0xF0;
						_tmp_time.mm |= _tmp_digit;
						_unit++;
						pos++;
					}
					break;
				case yr_1:
					_tmp_time.yr &= 0x0F;
					_tmp_time.yr |= (_tmp_digit << 4);
					_unit++;
					pos++;
					break;
				case yr_0:
					_tmp_time.yr &= 0xF0;
					_tmp_time.yr |= _tmp_digit;
					_unit = day_1;
					pos -= 5;
					break;
				default:
					break;
			}
			if(_tmp_time.day == 0) _tmp_time.day = 0x01;
			if(_tmp_time.mm == 0) _tmp_time.mm = 0x01;
			_max_vals = max_date_vals(_tmp_time);
			if(_max_vals.day < _tmp_time.day)  _tmp_time.day = _max_vals.day;
			LCD_date_print(1,3,_tmp_time);
			LCD_blinking(1,*pos,SET);
			_foo_flags.is_lcd_blinks = 1;
			_utility_flags.kb_digit_flag = 0;
			}
		else if(_utility_flags.kb_func_flag){
			_utility_flags.kb_func_flag = 0;
			_foo_flags.is_lcd_blinks = 0;
			switch(button){
				case button_UP:
				case button_RIGHT:
					if(_unit == yr_0){
						_unit = day_1;
						pos -=5;
					}
					else{
						_unit++;
						pos++;
					}
					break;
				case button_DOWN:
				case button_LEFT:
					if(_unit == day_1){
						_unit = yr_0;
						pos += 5;
					}
					else{
						_unit--;
						pos--;
					}
					break;
				case button_OK:
					lcd_cls();
					global_time = _tmp_time;
					export_time_rtc();
					export_time_eeprom();
					LCD_time_print(0,0,global_time, FALSE);
					LCD_date_print(1,0,global_time);
					LCD_status_update();
					_foo_flags.date_set = 0;
					_utility_flags.kb_func_flag = 0;
					return;
				case button_CANCEL:
					lcd_cls();
					LCD_time_print(0,0,global_time, FALSE);
					LCD_date_print(1,0,global_time);
					LCD_status_update();
					_foo_flags.date_set = 0;
					_utility_flags.kb_func_flag = 0;
					return;
				default:
					buzzer(WRONG);
					break;
			}
			LCD_date_print(1,3,_tmp_time);
			LCD_blinking(1,*pos,SET);
			_foo_flags.is_lcd_blinks = 1;
			_utility_flags.kb_func_flag = 0;
		}
	}
}
