#ifndef LOCATOR_SIM_H_
#define LOCATOR_SIM_H_

uint8_t module_1_program[48];
uint8_t module_2_program[48];

void wipe_program(uint8_t* program);
void get_simulator_program(modules module);
void locator_simulator_modules_set(time_date time);
void import_all_programs_from_mem(void);

#endif /* LOCATOR_SIM_H_ */
