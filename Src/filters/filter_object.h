#ifndef FILTER_OBJECT_H
#define FILTER_OBJECT_H

#include "stdint.h"
#include "filter_def.h"

typedef struct
{
    const uint32_t id;
    
    const char** helpstr;
    const uint32_t helplength;
    const uint32_t *modes;
    const uint32_t modesize;
    const float *coeff_b;
    const float *coeff_a;
    const float *coeff_gain;
    const uint32_t coeff_size;
    
    uint32_t mode;
    float *delay;
    float *coeffs;
    iir_state_t iir;
}filter_iir_t;

void filter_irr_init(filter_iir_t *fobj);
float filter_irr_value(filter_iir_t *fobj, float value);
int32_t filter_irr_set_mode(filter_iir_t *fobj, uint32_t mode);
uint32_t filter_irr_id(filter_iir_t *fobj);

/*
float filter_irr_value(filter_iir_t *irr, float value);
float filter_irr_init(filter_iir_t *irr, filter_obj_t *obj);
uint32_t filter_irr_set_mode(filter_iir_t *irr, uint32_t mode);
uint32_t filter_irr_id(filter_iir_t *irr);
*/
#endif
