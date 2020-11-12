function [dotSize_o, outlierPos] = makeOutlier(dotSize, condOutlier, numDots, m_ps, sd_ps)
    
    if condOutlier == 1 % large outlier 
        outlierPos = randi([1 numDots], 1);
        dotSize(1, outlierPos) = m_ps + (sd_ps * 5);
        dotSize_o = dotSize;
        
        
    elseif condOutlier == 2 % small outlier -5sd
        outlierPos = randi([1 numDots], 1);
        dotSize(1, outlierPos) = m_ps - (sd_ps * 5); 
        dotSize_o = dotSize;
    end
    
end   