#ifndef PID_SM_H
#define PID_SM_H

#include "stdint.h"

void pid_sm_init(void);
void pid_sm_update(uint16_t value);
void pid_1ms(void);

#endif
