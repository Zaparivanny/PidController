#ifndef FILTER_DEF_H
#define FILTER_DEF_H

#include "stdint.h"

typedef struct
{
    float *c;
    float *d;
    uint32_t s;
}iir_state_t;

void iir_init(iir_state_t *iir, float *coeffs, float *delay, uint32_t sections);
float iir_value(iir_state_t *iir, float value);

#endif
