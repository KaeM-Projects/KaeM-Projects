#ifndef IO_INTERFACE_IO_INTERFACE_H_
#define IO_INTERFACE_IO_INTERFACE_H_

#define SENSOR_1_PORT D
#define SENSOR_1_PIN 0

#define SENSOR_2_PORT D
#define SENSOR_2_PIN 1

#define INTEGRITY_SENSOR_PORT D
#define INTEGRITY_SENSOR_PIN 4

#define SIREN_PORT B
#define SIREN_PIN 0
#define SIREN_ON PORT(SIREN_PORT) |= (1<<SIREN_PIN)
#define SIREN_OFF PORT(SIREN_PORT) &= (1<<SIREN_PIN)

#define INTEGRITY_SENSOR_IN DDR(INTEGRITY_SENSOR_PORT) &= ~(1<<INTEGRITY_SENSOR_PIN)
#define INTEGRITY_SENSOR_LOW PORT(INTEGRITY_SENSOR_PORT) &= ~(1<<INTEGRITY_SENSOR_PIN)
#define INTEGRITY_SENSOR PIN(INTEGRITY_SENSOR_PORT) & (1<<INTEGRITY_SENSOR_PIN)
#define INTEGRITY_SENSOR_TRIGGERED !(INTEGRITY_SENSOR)

#define SENSOR_1_IN DDR(SENSOR_1_PORT) &= ~(1<<SENSOR_1_PIN)
#define SENSOR_1_LOW PORT(SENSOR_1_PORT) &= ~(1<<SENSOR_1_PIN)
#define SENSOR_1 PIN(SENSOR_1_PORT) & (1<<SENSOR_1_PIN)
#define SENSOR_1_TRIGGERED !(SENSOR_1)

#define SENSOR_2_IN DDR(SENSOR_2_PORT) &= ~(1<<SENSOR_2_PIN)
#define SENSOR_2_LOW PORT(SENSOR_2_PORT) &= ~(1<<SENSOR_2_PIN)
#define SENSOR_2 PIN(SENSOR_2_PORT) & (1<<SENSOR_2_PIN)
#define SENSOR_2_TRIGGERED !(SENSOR_2)

#define PORT(x) SPORT(x)
#define SPORT(x) (PORT##x)
// *** PIN
#define PIN(x) SPIN(x)
#define SPIN(x) (PIN##x)
// *** DDR
#define DDR(x) SDDR(x)
#define SDDR(x) (DDR##x)

#define PCF8574_1_ADDR 0x40
#define out_module_1 PCF8574_1_ADDR

#define SD_CD (1<<PB3)
#define SD_CD_set_in (DDRB &= ~SD_CD)
#define SD_CD_pull_up (PORTB |= SD_CD)
#define SD_CD_status !(PINB & SD_CD)

#define buzzer_pin (1<<PD5)
#define buzzer_as_out (DDRD |= buzzer_pin)
#define buzzer_off (PORTD &= ~buzzer_pin)
#define buzzer_on (PORTD |= buzzer_pin)

typedef enum{WRONG, CORRECT, TIME_SEC, BUTTON}buzz_type;
typedef enum {sim_module_1}modules;

void SD_init(void);
void sensors_initialize(void);
void set_out_module(uint8_t module, uint8_t value);
void buzzer(buzz_type buzz);

volatile uint8_t buzzer_time;
volatile uint8_t buzzer_pause;
volatile uint8_t buzzer_cnt;
volatile BOOL buzzer_start;
volatile uint8_t buzzer_delay;

#endif /* IO_INTERFACE_IO_INTERFACE_H_ */
