#ifndef EEPROM_DATA_EEPROM_DATA_H_
#define EEPROM_DATA_EEPROM_DATA_H_

void export_time_eeprom(void);
BOOL check_time_eeprom(void);
void export_pin_eeprom(void);
void import_pin_eeprom(void);
void save_program_to_mem(uint8_t *program_mem, uint8_t *program_bufor);
void read_program_from_mem(uint8_t *program_mem, uint8_t *program_bufor);
void export_user_settings(void);
void import_user_settings(void);

time_date ee_global_time;
uint16_t ee_PIN;
uint8_t ee_module_1_program[48];

#endif /* EEPROM_DATA_EEPROM_DATA_H_ */
