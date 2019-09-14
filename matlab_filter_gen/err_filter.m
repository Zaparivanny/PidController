clc
clear all
close all

fd = 20160;
fc = 100;
w = 400;

f1 = (fc - w / 2) / fd * 2;
f2 = (fc + w / 2) / fd * 2;
%[z,p,k] = butter(2, [f1, f2], 'bandpass');

[z,p,k] = butter(2, fc / fd * 2, 'low');
[sos, g] = zp2sos(z,p,k);

Hd = dfilt.df2sos(sos, g);

x = zeros(1, 1000)';
x(1) = 1;

q = 3.3 / 2^16 * 10^6;

v = Hd.filter(x);
h1 = sum(abs(v));
h2 = sum(v.^2);

h1
h2
