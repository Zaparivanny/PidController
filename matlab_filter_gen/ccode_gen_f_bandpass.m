function [] = ccode_gen_f_bandpass(filterid, path, filename, order, fc, w, fd )

f1 = (fc - w / 2) / fd * 2;
f2 = (fc + w / 2) / fd * 2;
[z,p,k] = butter(order, [f1, f2], 'bandpass');
[sos, g] = zp2sos(z,p,k);

s = sos;
n = length(sos(:,1));
for i=1:n
    gain(1, i) = k^(1/n);
end

fmodes(1,:) = [0 order];
helpstr{1} = ['ord=', num2str(order * 2), ' f=', num2str(fc), 'Hz fw=', num2str(w), 'Hz' ];

for jj = 2:3
    order2 = order + jj - 1;
    [z,p,k] = butter(order2, [f1, f2], 'bandpass');
    [sos, g] = zp2sos(z,p,k);
    
    n = length(sos(:,1));
    sn = length(s(:,1));
    s(sn + 1 : sn + n, :) = sos;
    ng = length(gain(1, :));
    for i=1:n
        gain(1, ng + i) = k^(1/n);
    end

    fmodes(jj, :) = [sn order2];
    helpstr{jj} = ['ord=', num2str(order2 * 2), ' f=' num2str(fc), 'Hz fw=', num2str(w), 'Hz' ];
end

f1 = (fc - w) / fd * 2;
f2 = (fc + w) / fd * 2;

for jj = 4:6
    order2 = order + jj - 4;
    [z,p,k] = butter(order2, [f1, f2], 'bandpass');
    [sos, g] = zp2sos(z,p,k);
    
    n = length(sos(:,1));
    sn = length(s(:,1));
    s(sn + 1 : sn + n, :) = sos;
    ng = length(gain(1, :));
    for i=1:n
        gain(1, ng + i) = k^(1/n);
    end

    fmodes(jj, :) = [sn order2];
    helpstr{jj} = ['ord=', num2str(order2 * 2), ' f=' num2str(fc), 'Hz fw=', num2str(w * 2), 'Hz' ];
end


f1 = (fc - w) / fd * 3;
f2 = (fc + w) / fd * 3;

for jj = 7:9
    order2 = order + jj - 7;
    [z,p,k] = butter(order2, [f1, f2], 'bandpass');
    [sos, g] = zp2sos(z,p,k);
    
    n = length(sos(:,1));
    sn = length(s(:,1));
    s(sn + 1 : sn + n, :) = sos;
    ng = length(gain(1, :));
    for i=1:n
        gain(1, ng + i) = k^(1/n);
    end

    fmodes(jj, :) = [sn order2];
    helpstr{jj} = ['ord=', num2str(order2 * 2), ' f=' num2str(fc), 'Hz fw=', num2str(w * 3), 'Hz' ];
end

ccode_filter(path, filename, s, gain, fc, fd, 'bandpass', fmodes, helpstr, filterid);

end

