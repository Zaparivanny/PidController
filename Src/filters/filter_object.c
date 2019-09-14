#include "filter_object.h"


void filter_irr_init(filter_iir_t *fobj)
{
    float a0,a1,a2;
    float b0,b1,b2; 
    uint32_t i;
    
    if(fobj->mode == 0)
    {
        return;
    }
    uint32_t index_mode = fobj->mode - 1;
    uint32_t sections = fobj->modes[index_mode * 2 + 1];
    uint32_t offset = fobj->modes[index_mode * 2];
    
    for(i = 0; i < sections; i++) 
    {
        float g = fobj->coeff_gain[offset + i];

        a0 = fobj->coeff_a[(offset + i) * 3 + 0]; 
        a1 = fobj->coeff_a[(offset + i) * 3 + 1]; 
        a2 = fobj->coeff_a[(offset + i) * 3 + 2]; 
        fobj->coeffs[(i * 5) + 0] = (a1 / a0); 
        fobj->coeffs[(i * 5) + 1] = (a2 / a0);
        b0 = fobj->coeff_b[(offset + i * 3) + 0] * g; 
        b1 = fobj->coeff_b[(offset + i * 3) + 1] * g; 
        b2 = fobj->coeff_b[(offset + i * 3) + 2] * g; 
        fobj->coeffs[(i * 5) + 2] = b0; 
        fobj->coeffs[(i * 5) + 3] = b1; 
        fobj->coeffs[(i * 5) + 4] = b2;
    }
    
    for(i = 0; i <= (2 * sections); i++) 
    { 
        fobj->delay[i] = 0; 
    }
    
    iir_init(&fobj->iir, fobj->coeffs, fobj->delay, sections);
}

float filter_irr_value(filter_iir_t *fobj, float value)
{
    float res = value;
    if(fobj->mode)
    {
        res = iir_value(&fobj->iir, value);
    }
    return res;
}

int32_t filter_irr_set_mode(filter_iir_t *fobj, uint32_t mode)
{
    int32_t res = -1;
    if(mode <= fobj->modesize)
    {
        fobj->mode = mode;
        filter_irr_init(fobj);
        res = 0;
    }
    return res;   
}

uint32_t filter_irr_id(filter_iir_t *fobj)
{
    return fobj->id;
}
