#ifndef SYSTEM_BASE_SYSTEM_BASE_H_
#define SYSTEM_BASE_SYSTEM_BASE_H_

volatile uint8_t _time_to_arm;

void system_initialize();
void LCD_status_update();
void LCD_time_print(uint8_t line_pos, uint8_t col_pos, time_date _time_date, BOOL no_sec);
void LCD_date_print(uint8_t line_pos, uint8_t col_pos, time_date _time_date);
void LCD_blinking(uint8_t pos_line, uint8_t pos_col, type_set status);
void LCD_initial_status(void);
void LCD_alarm_triggered(void);
void toggle_alarm_status_by_pin(void);
void trigger_alarm(void);
void main_menu(void);

#endif /* SYSTEM_BASE_SYSTEM_BASE_H_ */
