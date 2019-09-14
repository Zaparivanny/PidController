#ifndef PID_H
#define PID_H

typedef struct pid_t
{
    float kp;
    float ki;
    float kd;
    float u;
    float e[2];
}pid_t;

void pid_init(pid_t *pid, float kp, float ki, float kd, float t);
float pid_exec(pid_t *pid, float value);

#endif
