#include "pid.h"

void pid_init(pid_t *pid, float kp, float ki, float kd, float t)
{
    pid->kp = kp;
    pid->ki = kp * ki * t;
    pid->kd = kp * kd / t;
    pid->e[0] = 0;
    pid->e[1] = 0;
    pid->u = 0;
}

float pid_exec(pid_t *pid, float value)
{
    float u;
    u = pid->u + pid->kp * (value - pid->e[0]) + 
                 pid->ki *  value + 
                 pid->kd * (value - 2 * pid->e[0] + pid->e[1]);
    pid->e[1] = pid->e[0];
    pid->e[0] = value;
                     
    pid->u = u;
    
    return u;
}
