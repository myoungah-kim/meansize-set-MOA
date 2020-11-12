function vps = Exp3_VariableProbeSize(vws, wptr, rect, pxpd, testdotSize, varType) %size_type
    
	ws = Exp3_Workspace(wptr, rect, pxpd);
    [cx, cy] = RectCenter(ws.rect);
    
    %% circle position matrix with random jitter
     testdotPositionMatrix4 = [reshape(ws.x4, 1, ws.numDots4); reshape(ws.y4, 1, ws.numDots4)];
     testdotPositionMatrix4 = dotJitter(ws, testdotPositionMatrix4, ws.numDots4, pxpd, ws.jitter_pivot_size, testdotSize); % add jitter 
     testdotPositionMatrix4 = [testdotPositionMatrix4; testdotPositionMatrix4];

    %% create probe set array
    m_t = testdotSize / pxpd; % diameter % in visual digrees
%     m_t_ps = ((m_t/2)^2) * pi; % area
    m_t_ps = (m_t/2)^(2*0.76); % psychological
    sd_Low_ps = m_t_ps/8; % sd of probe circles
    sd_High_ps = m_t_ps/2;
%     sd_Low_ps = (ws.sd_Low/2); % sd of probe circles
%     sd_High_ps = (ws.sd_High/2);
    % dot range max min to 2sd range (truncated distribution)
    Low_range_t_max = m_t_ps + (sd_Low_ps * 2);
    Low_range_t_min = m_t_ps - (sd_Low_ps * 2);
    High_range_t_max = m_t_ps + (sd_High_ps * 2);
    High_range_t_min = m_t_ps - (sd_High_ps * 2);
    
    % Low Variability   
    testdotSizeLow_ps = m_t_ps + (sd_Low_ps * randn(1, ws.numDots4));  % circle random list - psychological scale
    while length( [ find(testdotSizeLow_ps <= 0) find(testdotSizeLow_ps >= Low_range_t_max) find(testdotSizeLow_ps <= Low_range_t_min) ] ) >= 1 % check if all sizes are bigger than 0
        testdotSizeLow_ps = m_t_ps + (sd_Low_ps * randn(1, ws.numDots4));
    end
%     testdotSizeLow_ps = distnorm(randn(1, ws.numDots4), m_t_ps, sd_Low_ps); 
%     while length( [ find(testdotSizeLow_ps <= 0) find(testdotSizeLow_ps >= Low_range_t_max) find(testdotSizeLow_ps <= Low_range_t_min) ] ) >= 1 % check if all sizes are bigger than 0
%         testdotSizeLow_ps = distnorm(randn(1, ws.numDots4), m_t_ps, sd_Low_ps);
%     end
    % High Variability
    testdotSizeHigh_ps = m_t_ps + (sd_High_ps * randn(1, ws.numDots4)); % circle random list - psychological scale
    while length( [ find(testdotSizeHigh_ps <= 0) find(testdotSizeHigh_ps >= High_range_t_max) find(testdotSizeHigh_ps <= High_range_t_min) ] ) >= 1 % check if all sizes are bigger than 0
        testdotSizeHigh_ps = m_t_ps + (sd_High_ps * randn(1, ws.numDots4));
    end
%     testdotSizeHigh_ps = distnorm(randn(1, ws.numDots4), m_t_ps, sd_High_ps); % circle random list - psychological scale
%     while length( [ find(testdotSizeHigh_ps <= 0) find(testdotSizeHigh_ps >= High_range_t_max) find(testdotSizeHigh_ps <= High_range_t_min) ] ) >= 1 % check if all sizes are bigger than 0
%         testdotSizeHigh_ps = distnorm(randn(1, ws.numDots4), m_t_ps, sd_High_ps);
%     end
    
    % probe size - scale normal
%     testdotSizeLow = nthroot(testdotSizeLow_ps, .76)/pi;
%     testdotSizeHigh = nthroot(testdotSizeHigh_ps, .76)/pi;
%     testdotSizeLow = nthroot(testdotSizeLow, 2);
%     testdotSizeHigh = nthroot(testdotSizeHigh, 2);
    testdotSizeLow = nthroot(testdotSizeLow_ps, 2*.76); % radius
    testdotSizeHigh = nthroot(testdotSizeHigh_ps, 2*.76); % radius
    
    % export - circle size   
    if varType == 1
        testdotSizes_new = testdotSizeLow;
    elseif varType == 2
        testdotSizes_new = testdotSizeHigh;
    elseif varType == 3
        testdotSizes_new = testdotSizeHigh;
    elseif varType == 4
        testdotSizes_new = testdotSizeLow;
    end
    testdotSizeLow = testdotSizeLow * pxpd; % in pixels % radius
    testdotSizeHigh = testdotSizeHigh * pxpd; % in pixels % radius
    
    vps.testdotSizes_new = testdotSizes_new; % size array % in visual degrees % radius
    
    %% make probe circles coordinate with testdotSize & testdotPositionMatrix
    testdotSizeLow_scale = [-testdotSizeLow; -testdotSizeLow; testdotSizeLow; testdotSizeLow]; % size scaling matrix
    testdotSizeHigh_scale = [-testdotSizeHigh; -testdotSizeHigh; testdotSizeHigh; testdotSizeHigh];
    centerShift4 = repmat([cx; cy; cx; cy], 1, ws.numDots4); % center to screen
    testdotRectLow = testdotPositionMatrix4 + testdotSizeLow_scale + centerShift4 + vws.testdotRandShift4;
    testdotRectHigh = testdotPositionMatrix4 + testdotSizeHigh_scale + centerShift4 + vws.testdotRandShift4;
     
    if varType == 1
        vps.testdotRect = testdotRectLow; % rectangle matrix for drawing set
    elseif varType == 4
        vps.testdotRect = testdotRectLow;
    elseif varType == 2
        vps.testdotRect = testdotRectHigh;
    elseif varType == 3
        vps.testdotRect = testdotRectHigh;
    end
    
end