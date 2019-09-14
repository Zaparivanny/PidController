#include "filter_def.h"

float f_iir(float *c, float *d, float v);

float f_iir(float *c, float *d, float v)
{
    float dd = v - c[0] * d[1] - c[1] * d[0];
    float y = c[2] * dd + c[3] * d[1] + c[4] * d[0];
    d[0] = d[1];
    d[1] = dd;
    return y;
}

void iir_init(iir_state_t *iir, float *coeffs, float *delay, uint32_t sections)
{
    iir->c = coeffs;
    iir->d = delay;
    iir->s = sections;
}

float iir_value(iir_state_t *iir, float value)
{
    float res = value;
    for(uint32_t i = 0; i < iir->s; i++)
    {
        res = f_iir(iir->c + i * 5 * sizeof(iir->d[0]), iir->d + i * 2 * sizeof(iir->d[0]), res);
    }
    return res;
}
