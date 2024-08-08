#ifndef MAIN_H_
#define MAIN_H_

typedef enum{DISARMED,TOGGLE,ARMED} type_armed;

volatile struct{
	uint8_t kb_digit_flag:1;
	uint8_t kb_func_flag:1;
	uint8_t kb_button_flag:1;
	uint8_t move_sensors_activated:1;
	uint8_t trigger_alarm_flag:1;
	uint8_t rtc_int_flag:1;
	uint8_t lock_LCD_update_flag:1;

}_utility_flags;


volatile struct{
	uint8_t is_lcd_blinks:1;
	uint8_t lcd_blinks:1;
	uint8_t date_set:1;
	uint8_t get_pin:1;
	uint8_t simul_set:1;
	uint8_t locator_sim_set:1;
	uint8_t main_menu:1;
}_foo_flags;

volatile struct{
	type_armed is_armed_flag;
	uint8_t is_simulator_on:1;
	uint8_t is_program_1_in_mem:1;
	uint8_t is_module_1_detected:1;
}_status_flags;

volatile uint8_t button;

volatile uint16_t PIN;

typedef enum {x,SET} type_set;

#endif /* MAIN_H_ */
