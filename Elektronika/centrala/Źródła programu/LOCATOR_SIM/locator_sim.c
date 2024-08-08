#include "../includes.h"

char *filenames[] = {
	"SimMod1.csv",
	"SimMod2.csv"
};

void wipe_program(uint8_t* program){
	for(uint8_t i = 0; i<48; i++){
		*program = 0;
		program++;
	}
}

BOOL import_program(char file_name[], uint8_t *program){
	char part[5];
	char bufor[64];

	WORD res;

	BOOL eof = 0;
	BYTE line_cnt=0;
	FATFS fs;
	uint8_t readed_program_lines = 0;

	res = disk_initialize();

	wipe_program(&program[0]);
	lcd_cls();

	if( res == FR_OK ) {
		res = pf_mount(&fs);
		if( res == FR_OK ) {
			res = pf_open(file_name);
			if( res == FR_OK ) {
				res = pf_readline(bufor, &eof, &line_cnt);
				if( res == FR_OK ) {
					for(BYTE i = 0; i<5; i++){
						part[i] = bufor[i];
					}
					if(!(strcmp(part,"Time;5"))){
						lcd_cls();
						lcd_str("Program reading");
					}
					else goto Fail;
				}
				else goto ERR;

				while(!(eof)){
					for(BYTE i=0;i<64;i++)bufor[i]=0;

					res = pf_readline(bufor, &eof, &line_cnt);
					if( res == FR_OK ) {
						if(line_cnt >= 21){
							for(BYTE i = 6; i<=21; i++){
								if((i%2 == 0) && ((char)(bufor[i]) == '0')){
									*program = *program & ~(1<<(((i-6)>>1)));
								}
								else if((i%2 == 0) && ((char)(bufor[i]) == '1')){
									*program = *program | (1<<((i-6)>>1));
								}
								else if((i%2 == 1) && ((char)(bufor[i]) == ';')){}
								else goto Fail;
							}

						}
						else goto Fail;
					}
					else goto ERR;
					program++;
					readed_program_lines++;
				}
				eof = 0;
				_delay_ms(1000);
				if(readed_program_lines == 48) return TRUE;
				else goto Fail;

			} else lcd_str("open file error");
		} else lcd_str("mount error");
	} else lcd_str("disk init error");
	buzzer(WRONG);
_delay_ms(1000);
return FALSE;

ERR: lcd_str("read error");
buzzer(WRONG);
_delay_ms(1000);
return FALSE;

Fail:
buzzer(WRONG);
lcd_cls();
lcd_locate(0,1);
lcd_str("Incorrect Data");
lcd_locate(1,0);
lcd_str("Process aborted");
_delay_ms(1000);
return FALSE;
}

void get_simulator_program(modules module){
	uint8_t bufor[48];
	uint8_t *ee_program;
	uint8_t *ram_program;

	if(module == sim_module_1){
		ee_program = &ee_module_1_program[0];
		ram_program = &module_1_program[0];
	}

	if(import_program(filenames[module],bufor)){

		for(uint8_t i = 0; i<48; i++){
			*ram_program = bufor[i];
			ram_program++;
		}
		ram_program -= 48;
		save_program_to_mem(ram_program,ee_program);
		if(module == sim_module_1)_status_flags.is_program_1_in_mem = 1;
		lcd_cls();
		lcd_str("Program imported");
		lcd_locate(1,2);
		lcd_str("succesfully!");
		_delay_ms(2000);
	}
	else{
		lcd_cls();
		buzzer(WRONG);
		lcd_str("Loading program");
		lcd_locate(1,5);
		lcd_str("failed");
		_delay_ms(1000);
	}
}

void get_simulator_program_from_mem(modules module){
	uint8_t bufor[48];
	uint8_t *ee_program;
	uint8_t *ram_program;

	if(module == sim_module_1){
		ee_program = &ee_module_1_program[0];
		ram_program = &module_1_program[0];
	}

	read_program_from_mem(&bufor[0], ee_program);

	for(uint8_t i = 0; i<48; i++){
		*ram_program = bufor[i];
		ram_program++;
	}
}

void import_all_programs_from_mem(void){
	if(_status_flags.is_program_1_in_mem)get_simulator_program_from_mem(sim_module_1);
}

uint8_t output_set(time_date time, uint8_t program [48]){
	uint8_t hour = ((((time.hr & 0xF0) >> 4)*10) + (time.hr & 0x0F));

	if((time.min >= 0x00) && (time.min < 0x30)){
		return program[hour*2];

	}
	else if((time.min >= 0x30) && (time.min <= 0x59)){
		return program[(hour*2)+1];
	}
	else return 0;
}

void locator_simulator_modules_set(time_date time){
	time = global_time;
		if(_status_flags.is_simulator_on){
			if(_status_flags.is_program_1_in_mem){
				if(_status_flags.is_module_1_detected){
					set_out_module(out_module_1,output_set(time,module_1_program));
				}
			}
		}
		else{
			set_out_module(out_module_1,0);

		}
}
