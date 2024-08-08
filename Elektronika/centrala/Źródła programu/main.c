#include "includes.h"

volatile uint16_t PIN = 0xFFFF;

BOOL is_bussy(void){
	if(
	_foo_flags.date_set ||
	_foo_flags.get_pin ||
	_utility_flags.trigger_alarm_flag
	)return TRUE;
	else return FALSE;
}

int main (void) {
	sei();
	timer_init();
	keyboard_init();
	sensors_initialize();
	rtc_init();
	SD_init();

	lcd_init();

	_status_flags.is_module_1_detected = 1;

	import_time_rtc();
	if(!(check_time_eeprom())){
		system_initialize();
		export_user_settings();
	}
	else {
		import_pin_eeprom();
		import_user_settings();
		import_all_programs_from_mem();
		LCD_initial_status();
	}

	while(1){
		if(_utility_flags.rtc_int_flag && !(_utility_flags.lock_LCD_update_flag)){

			import_time_rtc();
			LCD_initial_status();
			locator_simulator_modules_set(global_time);
			_utility_flags.rtc_int_flag = 0;
		}

		if(_utility_flags.kb_digit_flag){
			toggle_alarm_status_by_pin();

			_utility_flags.kb_digit_flag = 0;
		}
		else if(_utility_flags.kb_func_flag){
			switch(button){
			case button_UP:
			case button_DOWN:
				_utility_flags.kb_func_flag = 0;
				main_menu();
				break;
			default:
				buzzer(WRONG);
				break;
			}
			_utility_flags.kb_func_flag = 0;
		}
	}
return 0;
}
