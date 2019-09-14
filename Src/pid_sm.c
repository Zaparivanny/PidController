#include "pid_sm.h"
#include "pid.h"
#include "stm32f1xx_hal.h"
#include "filter_lowpass.h"

extern TIM_HandleTypeDef htim1;

#define MAX_PWM 90

typedef struct
{
	pid_t pid;
    uint32_t delay;
}pidsm_context_t;


static inline pidsm_context_t *_pidsm_context()
{
	static pidsm_context_t pidsm_context = {
		.pid = {0},
        .delay = 10 * 1000,
	};
	return &pidsm_context;
}

void pid_1ms(void)
{
    pidsm_context_t *context = _pidsm_context();
    if(context->delay)
    {
        context->delay--;
    }
}


void pid_sm_init(void)
{
	pidsm_context_t *context = _pidsm_context();
    float Kp = 10;            // <-----------------------------REGULATOR COEFFICIENT
    float Ki = 0.0;
    float Kd = 0.0;
    
    pid_init(&context->pid, Kp, Ki, Kd, 0.001);
    filter_iir_t *lowpass = filter_lowpass_instance();
    filter_irr_init(lowpass);
}

void HAL_ADC_ConvCpltCallback(ADC_HandleTypeDef* hadc)
{
    uint32_t value = HAL_ADC_GetValue(hadc);
    pid_sm_update(value);
    
}

void pid_set_pwm(uint16_t value)
{
    htim1.Instance->CCR1 = value;
}

float pid_to_temperature(uint16_t value)
{
    return value * 3.3 / 4096; // code to voltage
}

void pid_sm_update(uint16_t value)
{
    float temperature = pid_to_temperature(value);
    
    filter_iir_t *lowpass = filter_lowpass_instance();
    float temp_1hz = filter_irr_value(lowpass, temperature);
    
	pidsm_context_t *context = _pidsm_context();
    float dst_temperature = 2.1;   // <-----------------------------DISTANATION TEMPERATURE
    float err = dst_temperature - temp_1hz;
	float out = pid_exec(&context->pid, err);
	if(out > MAX_PWM)
	{
		out = MAX_PWM;
	}
	if(out < 0)
	{
		out = 0;
	}
	
    if(!context->delay)
    {
        pid_set_pwm((uint16_t)out);
    }
    else
    {
        pid_set_pwm((uint16_t)0);
    }
    
}
