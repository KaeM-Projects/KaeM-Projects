#include "../includes.h"

static uint8_t _cnt_1 = 0;
static uint8_t _lines[10];

static uint8_t _tmp = 0;
static uint16_t _lcd_led_cnt = 0;
static uint16_t _blink_cnt = 0;
static uint16_t _arm_cnt = 0;

static uint8_t _time_cnt = 0;
static uint8_t _time_to = 0;

static uint8_t time_play = 0;
static uint8_t time_pause = 0;
static uint8_t buzz_cnt = 0;

void timer_init(void)
{
	TCCR0 |= (1<<WGM01);				
	TCCR0 |= (1<<CS02)|(1<<CS00);		
	OCR0 = 38;							
	TIMSK |= (1<<OCIE0);
}

ISR(TIMER0_COMP_vect)
{

	if(_status_flags.is_armed_flag == ARMED){
		if(SENSOR_1_TRIGGERED)_utility_flags.move_sensors_activated = 1;
	}
	else{
		_utility_flags.move_sensors_activated = 0;
	}

///////////////////////////////////////////////////////
//---------------------------------------------------//
//////////////// alarm trigger /////////////////////////

	if((_status_flags.is_armed_flag == ARMED) && (_utility_flags.trigger_alarm_flag == 0)){
		if(_utility_flags.move_sensors_activated){
			if(_time_to == 0 && _time_cnt == 0) {
				_utility_flags.lock_LCD_update_flag = 1;
				lcd_cls();
			}
			if(_time_to < 30){
				if(_time_cnt == 0){
					lcd_locate(0,1);
					lcd_str("Time left:      ");
					lcd_locate(0,12);
					lcd_int(30 - _time_to);
					lcd_str("s");
					_time_cnt++;
				}
				else if(_time_cnt == 200){
					_time_to++;
					_time_cnt = 0;
				}
				else{
					_time_cnt++;
				}
			}
			else{
				trigger_alarm();
				_time_to = 0;
				_time_cnt = 0;
			}
		}
	}
	else{
		_time_to = 0;
	}

///////////////////////////////////////////////////////
//---------------------------------------------------//
//////////////// alarm toggle /////////////////////////

	if(_status_flags.is_armed_flag == TOGGLE){
		if(_time_to_arm > 0){
			if(_arm_cnt == 0){
				lcd_locate(0,1);
				lcd_str("Time left:      ");
				lcd_locate(0,12);
				lcd_int(_time_to_arm);
				lcd_str("s");
				_arm_cnt++;
			}
			else if(_arm_cnt == 200){
				if(_time_to_arm % 2)buzzer(TIME_SEC);
				_time_to_arm--;
				_arm_cnt = 0;
			}
			else{
				_arm_cnt++;
			}
		}
		else{
			_status_flags.is_armed_flag = ARMED;
			_time_to_arm = 0;
			_arm_cnt = 0;
			LCD_initial_status();
		}
	}
	else{
		_time_to_arm = 0;
		_arm_cnt = 0;
	}

///////////////////////////////////////////////////////
//---------------------------------------------------//
//////////////// LCD blinking /////////////////////////

	if(_foo_flags.is_lcd_blinks){
		if(_blink_cnt < 150){
			_blink_cnt++;
		}
		else if(_blink_cnt == 150){
			_foo_flags.lcd_blinks = 1;
			LCD_blinking(0,0,x);
			_blink_cnt++;
		}
		else if((_blink_cnt > 150) && (_blink_cnt < 300)){
			_blink_cnt++;
		}
		else if(_blink_cnt == 300){
			_foo_flags.lcd_blinks = 0;
			LCD_blinking(0,0,x);
			_blink_cnt++;
		}
		else _blink_cnt = 0;
	}
	else{
		_blink_cnt = 0;
	}

///////////////////////////////////////////////////////
//---------------------------------------------------//
//////////////// LCD backlight ////////////////////////

	if(_lcd_led_cnt == 0x7D0){
		LCD_LED_OFF;
		_lcd_led_cnt += 1;
	}
	else if(_lcd_led_cnt < 0x7D0){
		_lcd_led_cnt += 1;
	}
	else{}


///////////////////////////////////////////////////////
//---------------------------------------------------//
//////////////// Keyboard usage ///////////////////////

	if(_utility_flags.kb_button_flag){
		LCD_LED_ON;
		_lcd_led_cnt = 0;
		_tmp +=1;
		if(_cnt_1 < 10){
			_lines[_cnt_1] = keyboard_check();
			_cnt_1 += 1;
			}
		else{
			if((_lines[9] == _lines[8]) && (_lines[9] == _lines[7]) && (_lines[9] == _lines[6])){
				button = _lines[9];
				if (get_digit(button) == 0xFF){
					_utility_flags.kb_digit_flag = 0;
					_utility_flags.kb_func_flag = 1;
				}
				else {
					_utility_flags.kb_func_flag = 0;
					_utility_flags.kb_digit_flag = 1;
				}
				}
			_cnt_1 = 0;
			for(uint8_t i = 0; i < 10; i +=1){
				_lines[i] = 0;
			}
			_utility_flags.kb_button_flag = 0;
			}
		}

///////////////////////////////////////////////////////
//---------------------------------------------------//
////////////////    Buzzer    /////////////////////////

	if(buzzer_start){//50 0 1
		time_play = buzzer_time;
		time_pause = buzzer_pause;
		buzzer_start = FALSE;
	}

	if(buzzer_delay == 1){
		buzz_cnt = buzzer_cnt;
	}
	if(buzzer_delay > 0) buzzer_delay--;

	if(buzz_cnt>0){
		if(time_play == buzzer_time){
			buzzer_on;
			time_play--;
		}
		else if((time_play<buzzer_time) && (time_play > 0)){
			time_play--;
		}
		else{
			buzzer_off;
		}

		if((time_play == 0) && (time_pause > 0)){
			time_pause--;
		}
		else if((time_play == 0) && (time_pause == 0) && (buzz_cnt > 0)){
			buzz_cnt--;
			if(buzz_cnt)buzzer_start = TRUE;
		}

	}
}
