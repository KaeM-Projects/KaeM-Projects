#ifndef INCLUDES_H_
#define INCLUDES_H_

#include <avr/io.h>
#include <avr/interrupt.h>
#include <util/delay.h>
#include <avr/eeprom.h>
#include <string.h>

#include "main.h"
#include "PetitFS/integer.h"
#include "LCD/lcd44780.h"
#include "TIMER/timer.h"
#include "KEYBOARD/keyboard.h"
#include "TIME_DATE/time_date.h"
#include "SYSTEM_BASE/system_base.h"
#include "IO_INTERFACE/io_interface.h"
#include "RTC/rtc.h"
#include "LOCATOR_SIM/locator_sim.h"
#include "I2C/i2c_twi.h"
#include "PetitFS/diskio.h"
#include "PetitFS/pff.h"
#include "EEPROM_DATA/eeprom_data.h"

#endif
