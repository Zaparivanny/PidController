function [ ] = ccode_gen_f_notch(filterid, path, filename, fc, fd, bw)

wo = fc / (fd / 2); 
q = fc / bw(1);
wb = wo/q;
[b,a] = iirnotch(wo, wb);
sos = [b, a];

s(1, :) = sos;
n = length(sos(:,1));
for i=1:n
    gain(1, 1) = 1;
end
fmodes(1,:) = [0 1];

helpstr{1} = [' f=' num2str(fc), 'Hz', ' Bw=' num2str(bw(1)), 'Hz'];

for j = 2:length(bw)
    
    q = fc / bw(j);
    wb = wo/q;
    [b,a] = iirnotch(wo, wb);
    sos = [b, a];
    
    n = length(sos(:,1));
    sn = length(s(:,1));
    s(sn + 1 : sn + n, :) = sos;
    ng = length(gain(1, :));
    for i=1:n
        gain(1, ng + i) = 1;
    end
    
    fmodes(j,:) = [sn 1];
    helpstr{j} = [' f=' num2str(fc), 'Hz', ' Bw=' num2str(bw(j)), 'Hz'];
end

ccode_filter(path, filename, s, gain, fc, fd, 'notch', fmodes, helpstr, filterid);

end

