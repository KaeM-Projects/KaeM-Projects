#ifndef TIME_DATE_TIME_DATE_H_
#define TIME_DATE_TIME_DATE_H_

typedef struct {								
	uint8_t hr;
	uint8_t min;
	uint8_t sec;
	uint8_t day;
	uint8_t mm;
	uint8_t yr;
}time_date;

typedef enum {hr_1,hr_0,min_1,min_0,day_1,day_0,mm_1,mm_0,yr_1,yr_0} type_date;

volatile time_date global_time;

void set_time(void);
void set_date(void);

#endif /* TIME_DATE_TIME_DATE_H_ */
