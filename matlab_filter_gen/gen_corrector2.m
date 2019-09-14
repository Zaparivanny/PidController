function [  ] = gen_corrector(filterid, path, filename, fd )

% параметры корректирующего звена
%0.01834 - 
%0.106 1 - 8√ц
gain(1,1) = 1;

ks = tf([0.01834 1], [0.106 1]);
kd = c2d(ks, 1/fd);
sos = [kd.num{1} 0 kd.den{1} 0];
s(1, :) = sos;

n = length(sos(:,1));
for i=1:n
    gain(1, 1) = 1;
end

fmodes(1,:) = [0 1];
helpstr{1} = ['f1=', num2str(1.5), ' f2=', num2str(8.68)];

for j = 1:10
    t1 = 0.01834;
    t2 = 0.106 / (1 + j / 5);
    ks = tf([t1 1], [t2 1]);
    kd = c2d(ks, 1/fd);
    sos = [kd.num{1} 0 kd.den{1} 0];
    
    n = length(sos(:,1));
    sn = length(s(:,1));
    s(sn + 1 : sn + n, :) = sos;
    ng = length(gain(1, :));
    for i=1:n
        gain(1, ng + i) = 1;
    end
    
    fmodes(j + 1,:) = [sn 1];
    helpstr{j + 1} = ['f1=', num2str(1.5), ' f2=', num2str(8.68 * (1 + j / 5)), ' t1=', num2str(t1), ' t2=', num2str(t2)];
end



for j = 1:10
    t1 = 0.01834 / 0.5;
    t2 = 0.106 / (1 + j / 5);
    
    ks = tf([t1 1], [t2 1]);
    kd = c2d(ks, 1/fd);
    sos = [kd.num{1} 0 kd.den{1} 0];
    
    n = length(sos(:,1));
    sn = length(s(:,1));
    s(sn + 1 : sn + n, :) = sos;
    ng = length(gain(1, :));
    for i=1:n
        gain(1, ng + i) = 1;
    end
    
    fmodes(j + 11,:) = [sn 1];
    helpstr{j + 11} = ['f1=', num2str(3), ' f2=', num2str(8.68 * (1 + j / 5)), ' t1=', num2str(t1), ' t2=', num2str(t2)];
end

for j = 1:5
    t1 = 0.01834 / j;
    t2 = 0.106 / j;
    ks = tf([t1 1], [t2 1]);
    kd = c2d(ks, 1/fd);
    sos = [kd.num{1} 0 kd.den{1} 0];
    
    n = length(sos(:,1));
    sn = length(s(:,1));
    s(sn + 1 : sn + n, :) = sos;
    ng = length(gain(1, :));
    for i=1:n
        gain(1, ng + i) = 1;
    end
    
    fmodes(j + 21,:) = [sn 1];
    helpstr{j + 21} = ['f1=', num2str(1.5 * j), ' f2=', num2str(8.68 * j), ' t1=', num2str(t1), ' t2=', num2str(t2)];
end


ks = tf([0.01834 1], [0.106 *1.5 1]);
kd = c2d(ks, 1/fd);
sos = [kd.num{1} 0 kd.den{1} 0];

n = length(sos(:,1));
sn = length(s(:,1));
s(sn + 1 : sn + n, :) = sos;
ng = length(gain(1, :));
for i=1:n
    gain(1, ng + i) = 1;
end

fmodes(27,:) = [sn 1];
helpstr{27} = ['f1=', num2str(1.5), ' f2=', num2str(8.68/1.5)];

ccode_filter([path, filename, '_coeff.h'], [upper(filename), '_COEFF_H'], s, gain, 0, fd, 'corrector', fmodes, helpstr);
gen_ccode(path, filename, [filename, '_coeff.h'], filterid);

end

