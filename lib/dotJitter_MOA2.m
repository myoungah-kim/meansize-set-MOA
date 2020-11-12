function dotPositionMatrix_jtr = dotJitter_MOA2(dotPositionMatrix, numDots, pxpd, range_max, testdotSize) 

    % add jitter to dot position matrix
    
    if ~exist('testdotSize', 'var') % stimulus display jitter
        
        for i = 1:numDots
                randomjitter_x = (0.445 * pxpd) * (rand(1) * 2 - 1) ; % random jitter 0.445
                randomjitter_y = (0.445 * pxpd) * (rand(1) * 2 - 1) ; % random jitter 0.445
                dotPositionMatrix(1, i) = dotPositionMatrix(1, i) + randomjitter_x;
                dotPositionMatrix(2, i) = dotPositionMatrix(2, i) + randomjitter_y;
                dotPositionMatrix_jtr = dotPositionMatrix;
        end
        
    else % probe display jitter
        
        if testdotSize < range_max % if testdot bigger than 3.1105 same jitter
            for i = 1:numDots
                randomjitter_x = (0.445 * pxpd) * (rand(1) * 2 - 1) ; % random jitter 0.445
                randomjitter_y = (0.445 * pxpd) * (rand(1) * 2 - 1) ; % random jitter 0.445
                dotPositionMatrix(1, i) = dotPositionMatrix(1, i) + randomjitter_x;
                dotPositionMatrix(2, i) = dotPositionMatrix(2, i) + randomjitter_y;
                dotPositionMatrix_jtr = dotPositionMatrix;
            end
        elseif testdotSize >= range_max % if testdot bigger than 3.1105 reduce jitter
            for i = 1:numDots
                testdot_sd_ps = testdotSize/8; 
                testdot_max = testdotSize + (testdot_sd_ps * 2); % the biggest possible size
                jitter = (2 * pxpd) - testdot_max;
                randomjitter_x = jitter * (rand(1) * 2 - 1) ; % random jitter by ratio
                randomjitter_y = jitter * (rand(1) * 2 - 1) ; % random jitter by ratio
                dotPositionMatrix(1, i) = dotPositionMatrix(1, i) + randomjitter_x;
                dotPositionMatrix(2, i) = dotPositionMatrix(2, i) + randomjitter_y;
                dotPositionMatrix_jtr = dotPositionMatrix;
            end
        end
        
    end
    
end
