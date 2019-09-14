function [] = ccode_filter( path, filename, s, gain, fc, fd, type, fmode, helpstr, filterid)

fid = fopen([path, filename, '.h'], 'w+');

if(fid >= 0)
    header = [upper(filename), '_COEFF_H'];
    fprintf(fid, '#ifndef %s\n', header);
    fprintf(fid, '#define %s\n\n', header);
    fprintf(fid, '#include \"filter_object.h\"\n\n');
    
    fprintf(fid, '//type: %s\n', type);
    fprintf(fid, '//fd: %i Hz\n', fd);
    fprintf(fid, '//fc: %i Hz\n', fc);
    fprintf(fid, '\n');
    
    fprintf(fid, 'static inline filter_iir_t * %s_instance(void);\n\n', filename);
    fprintf(fid, 'static inline filter_iir_t * %s_instance(void)\n', filename);
    fprintf(fid, '{\n');
    
    len = length(s(:,1));
    
    fprintf(fid, '#undef MWSPT_NSEC\n');
    fprintf(fid, '#undef MWSPT_MAX_NSEC\n');
    fprintf(fid, '#define MWSPT_NSEC %i\n', length(fmode(:, 1)));
    fprintf(fid, '#define MWSPT_MAX_NSEC %i\n\n', max(fmode(:, 2)));
    
    %help
    fprintf(fid, '    static const char* filter_helpstr[MWSPT_NSEC] = {\n');
    for i = 1:length(fmode(:,1))
        fprintf(fid, '        \"%s\",\n', helpstr{i});
    end
    fprintf(fid, '    };\n');
    fprintf(fid, '\n');
    
    %fmode
    fprintf(fid, '    static const uint32_t filter_modes[][2] = {\n');
    for i = 1:length(fmode(:,1))
        fprintf(fid, '        {%i, %i},\n', fmode(i, 1), fmode(i, 2));
    end
    fprintf(fid, '    };\n');
    fprintf(fid, '\n');
    
    %coeffs b
    fprintf(fid, '    static const float coeff_b[%i][3] = {\n', len);
    for i = 1:len
        fprintf(fid, '        {%i, %i, %i},\n', s(i, 1), s(i, 2), s(i, 3));
    end
    fprintf(fid, '    };\n');
    fprintf(fid, '\n');
    
    %coeffs a
    fprintf(fid, '    static const float coeff_a[%i][3] = {\n', len);
    for i = 1:len
        fprintf(fid, '        {%i, %i, %i},\n', s(i, 4), s(i, 5), s(i, 6));
    end
    fprintf(fid, '    };\n');
    fprintf(fid, '\n');
    
    %gain
    fprintf(fid, '    static const float coeff_gain[%i] = {\n', len);
    fprintf(fid, '        ');
    for i=1:len
        fprintf(fid, '%i, ', gain(1, i));
    end
    fprintf(fid, '    \n    };\n\n');
    fprintf(fid, '    static float delay[2 * MWSPT_MAX_NSEC];\n');
    fprintf(fid, '    static float coeffs[5 * MWSPT_MAX_NSEC];\n');
    
    fprintf(fid, '    static filter_iir_t filter_iir = \n');
    fprintf(fid, '    {\n');
    
    fprintf(fid, '        .id = %i,\n', filterid);
    fprintf(fid, '        .helpstr = filter_helpstr,\n');
    fprintf(fid, '        .helplength = MWSPT_NSEC,\n');
    fprintf(fid, '        .modes = filter_modes[0],\n');
    fprintf(fid, '        .modesize = %i,\n', length(fmode(:,1)));
    fprintf(fid, '        .coeff_b = coeff_b[0],\n');
    fprintf(fid, '        .coeff_a = coeff_a[0],\n');
    fprintf(fid, '        .coeff_gain = coeff_gain,\n');
    fprintf(fid, '        .coeff_size = %i,\n', len);
    fprintf(fid, '        .mode = 1,\n');
    fprintf(fid, '        .delay = delay,\n');
    fprintf(fid, '        .coeffs = coeffs,\n');
    
    fprintf(fid, '    };\n\n');
    
    fprintf(fid, '    return &filter_iir;\n\n');
    
    fprintf(fid, '\n');
    fprintf(fid, '}\n\n');
    
    fprintf(fid, '#endif\n');
    fclose(fid);
end


end

