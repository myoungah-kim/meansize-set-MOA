% jitter increased according to reduced dotsize range
% jitter by ratio -> sd changed
function dotPositionMatrix_jtr = dotJitter(ws, dotPositionMatrix, numDots, pxpd, jitter_pivot_size, testdotSize) 

    % add jitter to dot position matrix
    
    if ~exist('testdotSize', 'var') % stimulus display jitter
        
        for i = 1:numDots
                randomjitter_x = (0.9169/2 * pxpd) * (rand(1) * 2 - 1) ; % random jitter 0.9169
                randomjitter_y = (0.9169/2 * pxpd) * (rand(1) * 2 - 1) ; % random jitter 0.9169
                dotPositionMatrix(1, i) = dotPositionMatrix(1, i) + randomjitter_x;
                dotPositionMatrix(2, i) = dotPositionMatrix(2, i) + randomjitter_y;
                dotPositionMatrix_jtr = dotPositionMatrix;
        end
        
    else % probe display jitter
        
        if testdotSize < jitter_pivot_size % if testdot less than 1.3935 same jitter
            for i = 1:numDots
                randomjitter_x = (0.9169/2 * pxpd) * (rand(1) * 2 - 1) ; % random jitter 0.9169
                randomjitter_y = (0.9169/2 * pxpd) * (rand(1) * 2 - 1) ; % random jitter 0.9169
                dotPositionMatrix(1, i) = dotPositionMatrix(1, i) + randomjitter_x;
                dotPositionMatrix(2, i) = dotPositionMatrix(2, i) + randomjitter_y;
                dotPositionMatrix_jtr = dotPositionMatrix;
            end
        elseif testdotSize >= jitter_pivot_size % if testdot bigger than 1.3935 reduce jitter
            for i = 1:numDots
                testdot_sd_ps = ws.sd_High/2; 
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
