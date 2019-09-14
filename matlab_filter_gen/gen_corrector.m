function [  ] = gen_corrector(filterid, path, filename, fd )

% параметры корректирующего звена
%0.01834 - 
%0.106 1 - 8√ц
ks = tf([0.01834 1], [0.106 1]);
kd = c2d(ks, 1/fd);

b1 = kd.num{1};
a1 = kd.den{1};

a(1) = a1(1);
a(2) = a1(2);
a(3) = 0;

b(1) = b1(1);
b(2) = b1(2);
b(3) = 0;

gain(1,1) = 1;

%[u,t] = gensig('sin', 0.1, 1, 0.00001);
%[step_c, t_c] = lsim(ks, u, t);
%figure(1)
%plot(t, u, t_c, step_c); grid on;

%figure(2)
%Tend = 0.003;
%[step_c, t_c] = step(ks, Tend);
%[step_d, t_d] = step(kd, Tend);
%plot(t_c, step_c, t_d, step_d); grid on;

fmodes(1,:) = [0 1];

helpstr{1} = ['ord=', num2str(2)];

ccode_filter([path, filename, '_coeff.h'], [upper(filename), '_COEFF_H'], [b, a], gain, 0, fd, 'corrector', fmodes, helpstr);
gen_ccode(path, filename, [filename, '_coeff.h'], filterid);

end

