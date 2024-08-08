#ifndef KEYBOARD_KEYBOARD_H_
#define KEYBOARD_KEYBOARD_H_

#define ki_pin (1<<PD3)			

#define kb_port_direction DDRA		

#define all_K_pins_in DDRA = 0x00
#define all_K_pins_pull_up PORTA = 0xFF
#define L_quadro_K_pins_pull_up PORTA = 0x0F
#define H_quadro_K_pins_gnd PORTA = 0xF0

#define get_L_quadro PINA & 0x0F
#define get_H_quadro PINA & 0xF0

//przycisk 1 UP (S1)
#define button_UP 0x8E
//przycisk 2 DOWN (S2)
#define button_DOWN 0x8D
//przycisk 3 LEFT (S3)
#define button_LEFT 0x8B
//przycisk 4 RIGHT (S4)
#define button_RIGHT 0x87
//przycisk 5 OK (S6)
#define button_OK 0x47
//przycisk 1 CANCEL (S1)
#define button_CANCEL 0x17
//przyciski wartoœci (cyfry)
#define button_1 0x1E
#define button_2 0x2E
#define button_3 0x4E
#define button_4 0x1D
#define button_5 0x2D
#define button_6 0x4D
#define button_7 0x1B
#define button_8 0x2B
#define button_9 0x4B
#define button_0 0x27

uint8_t keyboard_check();
uint8_t get_digit(uint8_t data);
void keyboard_init (void);

#endif /* KEYBOARD_KEYBOARD_H_ */
