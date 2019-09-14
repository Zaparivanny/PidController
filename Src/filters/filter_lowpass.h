#ifndef FILTER_LOWPASS_COEFF_H
#define FILTER_LOWPASS_COEFF_H

#include "filter_object.h"

//type: lowpass
//fd: 1000 Hz
//fc: 1 Hz

static inline filter_iir_t * filter_lowpass_instance(void);

static inline filter_iir_t * filter_lowpass_instance(void)
{
#undef MWSPT_NSEC
#undef MWSPT_MAX_NSEC
#define MWSPT_NSEC 1
#define MWSPT_MAX_NSEC 1

    static const char* filter_helpstr[MWSPT_NSEC] = {
        "ord=2 f=1Hz",
    };

    static const uint32_t filter_modes[][2] = {
        {0, 1},
    };

    static const float coeff_b[1][3] = {
        {1, 2, 1},
    };

    static const float coeff_a[1][3] = {
        {1, -1.991114e+00, 9.911536e-01},
    };

    static const float coeff_gain[1] = {
        9.825917e-06,     
    };

    static float delay[2 * MWSPT_MAX_NSEC];
    static float coeffs[5 * MWSPT_MAX_NSEC];
    static filter_iir_t filter_iir = 
    {
        .id = 1,
        .helpstr = filter_helpstr,
        .helplength = MWSPT_NSEC,
        .modes = filter_modes[0],
        .modesize = 1,
        .coeff_b = coeff_b[0],
        .coeff_a = coeff_a[0],
        .coeff_gain = coeff_gain,
        .coeff_size = 1,
        .mode = 1,
        .delay = delay,
        .coeffs = coeffs,
    };

    return &filter_iir;


}

#endif
