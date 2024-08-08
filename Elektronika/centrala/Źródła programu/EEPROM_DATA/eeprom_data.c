#include "../includes.h"

time_date EEMEM ee_global_time;
uint16_t EEMEM ee_PIN;
uint8_t EEMEM ee_module_1_program[48];
uint8_t EEMEM ee_status_flags;

void export_time_eeprom(void){
	time_date _tmp_global_time = global_time;
	eeprom_write_block (&_tmp_global_time, &ee_global_time, sizeof (_tmp_global_time));
}

BOOL check_time_eeprom(void){
	time_date _tmp_global_time;
	eeprom_read_block (&_tmp_global_time, &ee_global_time, sizeof (_tmp_global_time));
	if((_tmp_global_time.sec == 0xFF) ||
		(_tmp_global_time.min == 0xFF) ||
		(_tmp_global_time.hr == 0xFF) ||
		(_tmp_global_time.day == 0xFF) ||
		(_tmp_global_time.mm == 0xFF) ||
		(_tmp_global_time.yr == 0xFF)) return FALSE;

	if(_tmp_global_time.yr < global_time.yr) return TRUE; //zle dzia³a
	else if(_tmp_global_time.yr > global_time.yr) return FALSE;
	else{
		if(_tmp_global_time.mm < global_time.mm) return TRUE;
		else if(_tmp_global_time.mm > global_time.mm) return FALSE;
		else{
			if(_tmp_global_time.day < global_time.day) return TRUE;
			else if(_tmp_global_time.day > global_time.day) return FALSE;
			else{
				if(_tmp_global_time.hr  < global_time.hr) return TRUE;
				else if(_tmp_global_time.hr  > global_time.hr) return FALSE;
				else{
					if(_tmp_global_time.min < global_time.min) return TRUE;
					if(_tmp_global_time.min > global_time.min) return FALSE;
					else{
						if(_tmp_global_time.sec <= global_time.sec) return TRUE;
					}
				}
			}
		}

	}
	return FALSE;
}

void export_pin_eeprom(void){
	uint16_t _tmp_PIN = PIN;
	eeprom_write_block (&_tmp_PIN, &ee_PIN, sizeof (_tmp_PIN));
}

void import_pin_eeprom(void){
	uint16_t _tmp_PIN;
	eeprom_read_block (&_tmp_PIN, &ee_PIN, sizeof (_tmp_PIN));
	PIN = _tmp_PIN;
}

void save_program_to_mem(uint8_t *program_ram, uint8_t *program_mem){
	eeprom_write_block (program_ram, program_mem, 48);
}

void read_program_from_mem(uint8_t *program_ram, uint8_t *program_mem){
	eeprom_read_block (program_ram, program_mem, 48);
}

void export_user_settings(void){
	uint8_t _status = (_status_flags.is_armed_flag)   |
			(_status_flags.is_module_1_detected << 2) |
			(_status_flags.is_program_1_in_mem << 3)  |
			(_status_flags.is_simulator_on << 4);

	eeprom_write_block (&_status, &ee_status_flags, sizeof (_status));
}

void import_user_settings(void){
	uint8_t _status;
	eeprom_read_block (&_status, &ee_status_flags, sizeof (_status));

	_status_flags.is_armed_flag |= (_status & 0x3);
	_status_flags.is_module_1_detected |= (_status & (1 << 2));
	_status_flags.is_program_1_in_mem |= (_status & (1 << 3));
	_status_flags.is_simulator_on |= (_status & (1 << 4));
}
