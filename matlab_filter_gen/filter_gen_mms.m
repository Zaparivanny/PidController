close all
clear all
clc

fd = 1000;

pachdirf = '../Src/filters/';

ccode_gen_f_lowpass(1, pachdirf, 'filter_lowpass', fd, 1, 1);