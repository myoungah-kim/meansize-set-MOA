function [emat, sizemat_ps, sizemat_wo] = processData_Exp2(emat, sizemat, numDots)
    
    sizemat_ps = sizemat;
    sizemat_wo = [];
    for i = 1:length(emat)
        cue = emat(i, 2);
        outlier_type = emat(i, 3);
        attention = emat(i, 4);
        resp = emat(i, 28);
        outlierPos_L = emat(i, 10);
        outlierPos_R = emat(i, 11);
        dotSize_L = sizemat(i, 2 : 1+numDots);
        dotSize_R = sizemat(i, 2+numDots : 1+(numDots*2));
        
        % side actual
        if cue == 1 && attention == 1
            side_actual = 1; % left
        elseif cue == 1 && attention == 2
            side_actual = 2; % right
        elseif cue == 2 && attention == 1
            side_actual = 2; % right
        elseif cue == 2 && attention == 2
            side_actual = 1; % left
        end
            
        % outlier position actual
        if side_actual == 1
            outlierPos_actual = outlierPos_L; % left
        elseif side_actual == 2
            outlierPos_actual = outlierPos_R; % right
        end
        
        % condOutlier_size
        if side_actual == 1
            if outlier_type == 1 || outlier_type == 4 || outlier_type == 5
                condOutlier_size = 1;
            elseif outlier_type == 2 || outlier_type == 6 || outlier_type == 7
                condOutlier_size = 2;
            elseif outlier_type == 3 || outlier_type == 8 || outlier_type == 9
                condOutlier_size = 3; 
            end
        elseif side_actual == 2
            if outlier_type == 1 || outlier_type == 6 || outlier_type == 8
                condOutlier_size = 1;
            elseif outlier_type == 2 || outlier_type == 4 || outlier_type == 9
                condOutlier_size = 2;
            elseif outlier_type == 3 || outlier_type == 5 || outlier_type == 7
                condOutlier_size = 3; 
            end
        end
        
        % condOutlier_samediff l-l(1) s-s(2) b-b(3) l-s(4) l-b(5) s-l(6) s-b(7) b-l(8) b-s(9)
        if outlier_type == 1 || outlier_type == 2 || outlier_type == 3
            condOutlier_samediff = 1;
        else
            condOutlier_samediff = 2;
        end
        
        % condOutlier_ecc
        if side_actual == 1
            if outlierPos_actual == 0
                condOutlier_ecc = NaN;
            elseif outlierPos_actual > 0 && outlierPos_actual < 6
                condOutlier_ecc = 3; 
            elseif outlierPos_actual >= 6 && outlierPos_actual < 11
                condOutlier_ecc = 2;
            elseif outlierPos_actual >= 11
                condOutlier_ecc = 1;
            end
        elseif side_actual == 2
            if outlierPos_actual == 0
                condOutlier_ecc = NaN;
            elseif outlierPos_actual > 0 && outlierPos_actual < 6
                condOutlier_ecc = 1; 
            elseif outlierPos_actual >= 6 && outlierPos_actual < 11
                condOutlier_ecc = 2;
            elseif outlierPos_actual >= 11
                condOutlier_ecc = 3;
            end
        end
        
        % condOutlier_eccLoc
        if outlierPos_actual == 0
            condOutlier_eccLoc = NaN;
        elseif outlierPos_actual == 8
            condOutlier_eccLoc = 1; 
        elseif outlierPos_actual == 3 || outlierPos_actual == 7 || outlierPos_actual == 9 || outlierPos_actual == 13
            condOutlier_eccLoc = 2;
        elseif outlierPos_actual == 2 || outlierPos_actual == 4 || outlierPos_actual == 12 || outlierPos_actual == 14
            condOutlier_eccLoc = 3;
        else 
            condOutlier_eccLoc = 4;
        end
        
        % m_actual, m_actual_ps, m_other, m_other_ps
        if side_actual == 1
            m_actual = mean( dotSize_L );
            m_other = mean( dotSize_R );
        elseif side_actual == 2
            m_actual = mean( dotSize_R );
            m_other = mean( dotSize_L );
        end
        dotSize_L_ps = dotSize_L .^ (2*.76);
        dotSize_R_ps = dotSize_R .^ (2*.76);
        if side_actual == 1
            m_actual_ps = mean( dotSize_L_ps );
            m_other_ps = mean( dotSize_R_ps );
        elseif side_actual == 2
            m_actual_ps = mean( dotSize_R_ps );
            m_other_ps = mean( dotSize_L_ps );
        end
        sizemat_ps(i, 2:1+numDots) = dotSize_L_ps;
        sizemat_ps(i, 2+numDots:1+numDots*2) = dotSize_R_ps;
        % m_wo_actual, m_wo_actual_ps, m_wo_other, m_wo_other_ps
        dotSize_L_wo = dotSize_L;
        dotSize_R_wo = dotSize_R;
        if outlier_type == 1 || outlier_type == 2 || outlier_type == 4 || outlier_type == 6
            dotSize_L_wo(1, outlierPos_L) = 0;
            dotSize_R_wo(1, outlierPos_R) = 0; 
            numDots_L = numDots-1;
            numDots_R = numDots-1;
        elseif outlier_type == 3
            numDots_L = numDots;
            numDots_R = numDots;
        elseif outlier_type == 5
            dotSize_L_wo(1, outlierPos_L) = 0;
            numDots_L = numDots-1;
            numDots_R = numDots;
        elseif outlier_type == 7
            dotSize_L_wo(1, outlierPos_L) = 0;
            numDots_L = numDots-1;
            numDots_R = numDots;
        elseif outlier_type == 8
            dotSize_R_wo(1, outlierPos_R) = 0;
            numDots_L = numDots;
            numDots_R = numDots-1;
        elseif outlier_type == 9
            dotSize_R_wo(1, outlierPos_R) = 0;
            numDots_L = numDots;
            numDots_R = numDots-1;
        else
            break;
        end
        
        if side_actual == 1
            m_wo_actual = sum(dotSize_L_wo) / numDots_L;
            m_wo_other = sum(dotSize_R_wo) / numDots_R;
        elseif side_actual == 2
            m_wo_actual = sum(dotSize_R_wo) / numDots_R;
            m_wo_other = sum(dotSize_L_wo) / numDots_L;
        end
        dotSize_L_wo_ps = dotSize_L_wo .^ (2*.76);
        dotSize_R_wo_ps = dotSize_R_wo .^ (2*.76);
        if side_actual == 1
            m_wo_actual_ps = sum(dotSize_L_wo_ps) / numDots_L;
            m_wo_other_ps = sum(dotSize_R_wo_ps) / numDots_R;
        elseif side_actual == 2
            m_wo_actual_ps = sum(dotSize_R_wo_ps) / numDots_R;
            m_wo_other_ps = sum(dotSize_L_wo_ps) / numDots_L;
        end
        
        % relative mean ratio
        relativeMeanRatio = m_actual/m_other;
        relativeMeanRatio_ps = m_actual_ps/m_other_ps;
        
        % bias
        resp_ps = resp ^ (2*.76);
        bias = (resp - m_actual)/m_actual;
        bias_ps = (resp_ps - m_actual_ps)/m_actual_ps;
        bias_wo = (resp - m_wo_actual)/m_wo_actual;
        bias_wo_ps = (resp_ps - m_wo_actual_ps)/m_wo_actual_ps;
        
        emat(i, 9) = side_actual;
        emat(i, 12) = outlierPos_actual; 
        emat(i, 13) = condOutlier_size; 
        emat(i, 14) = condOutlier_samediff; 
        emat(i, 15) = condOutlier_ecc; 
        emat(i, 16) = condOutlier_eccLoc; 
        emat(i, 17) = m_actual; 
        emat(i, 18) = m_actual_ps;
        emat(i, 19) = m_other;
        emat(i, 20) = m_other_ps;
        emat(i, 21) = m_wo_actual;
        emat(i, 22) = m_wo_actual_ps;
        emat(i, 23) = m_wo_other;
        emat(i, 24) = m_wo_other_ps;
        emat(i, 25) = relativeMeanRatio;
        emat(i, 26) = relativeMeanRatio_ps;
        emat(i, 29) = resp_ps;
        emat(i, 30) = bias; 
        emat(i, 31) = bias_ps;
        emat(i, 32) = bias_wo; 
        emat(i, 33) = bias_wo_ps; 
        sizemat_wo(i, 1:numDots) = dotSize_L_wo;
        sizemat_wo(i, 1+numDots:numDots*2) = dotSize_R_wo;
    end

end
