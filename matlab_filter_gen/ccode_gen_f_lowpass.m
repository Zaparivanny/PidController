function [ ] = ccode_gen_f_lowpass( filterid, path, filename, fd, orders, fs)

[z,p,k] = butter(2, fs(1) / fd * 2, 'low');
[sos, g] = zp2sos(z,p,k);

s(1, :) = sos;

n = length(sos(:,1));
for i=1:n
    gain(1, 1) = k^(1/n);
end

fmodes(1,:) = [0 1];
helpstr{1} = ['ord=', num2str(2), ' f=' num2str(fs(1)), 'Hz'];

for j = 2 : length(fs)
    [z,p,k] = butter(2, fs(j) / fd * 2, 'low');
    [sos, g] = zp2sos(z,p,k);

    n = length(sos(:,1));
    sn = length(s(:,1));
    s(sn + 1 : sn + n, :) = sos;
    ng = length(gain(1, :));
    for i=1:n
        gain(1, ng + i) = k^(1/n);
    end
    
    fmodes(j,:) = [sn 1];
    helpstr{j} = ['ord=', num2str(2), ' f=' num2str(fs(j)), 'Hz'];
end



ccode_filter(path, filename, s, gain, fs(1), fd, 'lowpass', fmodes, helpstr, filterid);
%gen_ccode(path, filename, [filename, '_coeff.h'], filterid);

end

