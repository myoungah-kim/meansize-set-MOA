function newfilename = exportdata(filename)

    %get outlier condition, m_actual, m_other to the expmat
    
    filename = ['data/Exp1/', filename, '.mat'];
    load(filename);
    filename = strrep(filename,'.mat','_MSadded');
    matfile = strcat(filename, '.mat')
    
    for t = 1:128
        numDots = 15;
        cond = emat(t, :);
        cue_type  = cond(2);  % exogenous cue left(1), right(2)
        outlier_type = cond(3);
        attention = cond(4); % attended(1), unattended(2)
        
        size_left = sizemat(t, 2:16);
        size_right = sizemat(t, 17:31);
        sum_left = 0;
        sum_right = 0;

        for i = 1 : numDots
            sum_left = sum_left + size_left(1, i);
            sum_right = sum_right + size_right(1, i);
        end

        meansize_left = sum_left/numDots;
        meansize_right = sum_right/numDots;
        
        if cue_type == 1 && attention == 1
            m_actual = meansize_left;
            m_other = meansize_right;
            if outlier_type == 1
                outlierCond = 1;
            elseif outlier_type == 2
                outlierCond = 2;
            elseif outlier_type == 3
                outlierCond = 1;
            elseif outlier_type == 4
                outlierCond = 2;
            end
        elseif cue_type == 1 && attention == 2
            m_actual = meansize_right;
            m_other = meansize_left;
            if outlier_type == 1
                outlierCond = 1;
            elseif outlier_type == 2
                outlierCond = 2;
            elseif outlier_type == 3
                outlierCond = 2;
            elseif outlier_type == 4
                outlierCond = 1;
            end
        elseif cue_type == 2 && attention == 1
            m_actual = meansize_right;
            m_other = meansize_left;
            if outlier_type == 1
                outlierCond = 1;
            elseif outlier_type == 2
                outlierCond = 2;
            elseif outlier_type == 3
                outlierCond = 2;
            elseif outlier_type == 4
                outlierCond = 1;
            end
        elseif cue_type == 2 && attention == 2
            m_actual = meansize_left;
            m_other = meansize_right;
            if outlier_type == 1
                outlierCond = 1;
            elseif outlier_type == 2
                outlierCond = 2;
            elseif outlier_type == 3
                outlierCond = 1;
            elseif outlier_type == 4
                outlierCond = 2;
            end
        end
        
        emat(t, 11) = outlierCond;
        emat(t, 12) = m_actual;
        emat(t, 13) = m_other;
        
    end
    
    %matfile2 = strcat(matfile, '_MSadded');
    save(matfile);


end
