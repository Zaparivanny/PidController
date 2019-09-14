function [] = gen_tf(filterid, path, filename, fd)

A = [0 2.5];
B = [0.25 1];

ks = tf(A, B);
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

helpstr{1} = ['tf = ', num2str(A(1)), ' ', num2str(A(2)), '/', num2str(B(1)), ' ', num2str(B(2))];

ccode_filter([path, filename, '_coeff.h'], [upper(filename), '_COEFF_H'], [b, a], gain, 0, fd, 'tf', fmodes, helpstr);
gen_ccode(path, filename, [filename, '_coeff.h'], filterid);


end

