%%% circle size range changed 
%%% pxpd is multiplied at the very end after size extraction. 
function vws = Exp3_VariableWorkspace(wptr, rect, pxpd) %size_type
    
	ws = Exp3_Workspace(wptr, rect, pxpd);
    [cx, cy] = RectCenter(ws.rect);
    
    
    %% circle sizes - m random from 1.13 ~ 2.26
    m_min = ws.m_min; % diameter
    m_max = ws.m_max; % diameter
    m = (m_min + (m_max-m_min) * rand(1));
    vws.m = m;
    % m, sd in psychological scale
%     m_ps = ((m/2)^2) * pi; % area
    m_ps = (m/2)^(2*.76); % psychological
    sd_Low_ps = m_ps/8; % area
    sd_High_ps = m_ps/2; % area
%     sd_Low_ps = (ws.sd_Low/2); % diameter
%     sd_High_ps = (ws.sd_High/2); % diameter
    % dot range max min to 2sd range (truncated distribution)
    Low_range_max = m_ps + (sd_Low_ps * 2);
    Low_range_min = m_ps - (sd_Low_ps * 2);
    High_range_max = m_ps + (sd_High_ps * 2);
    High_range_min = m_ps - (sd_High_ps * 2);
    
    %% create cirle set array
    % Low Variability
    dotSizeLow_ps = m_ps + (sd_Low_ps * randn(1, ws.numDots4)); % circle random list - psychological scale
    while length( [ find(dotSizeLow_ps <= 0) find(dotSizeLow_ps >= Low_range_max) find(dotSizeLow_ps <= Low_range_min) ] ) >= 1 % check if all sizes are bigger than 0
        dotSizeLow_ps = m_ps + (sd_Low_ps * randn(1, ws.numDots4));
    end
%     dotSizeLow_ps = distnorm(randn(1, ws.numDots4), m_ps, sd_Low_ps); 
%     while length( [ find(dotSizeLow_ps <= 0) find(dotSizeLow_ps >= Low_range_max) find(dotSizeLow_ps <= Low_range_min) ] ) >= 1 % check if all sizes are bigger than 0
%         dotSizeLow_ps = distnorm(randn(1, ws.numDots4), m_ps, sd_Low_ps);
%     end
    % High Variability
    dotSizeHigh_ps = m_ps + (sd_High_ps * randn(1, ws.numDots4));  % circle random list - psychological scale
    while length( [ find(dotSizeHigh_ps <= 0) find(dotSizeHigh_ps >= High_range_max) find(dotSizeHigh_ps <= High_range_min) ] ) >= 1 % check if all sizes are bigger than 0
        dotSizeHigh_ps = m_ps + (sd_High_ps * randn(1, ws.numDots4));
    end
%     dotSizeHigh_ps = distnorm( randn(1, ws.numDots4) , m_ps, sd_High_ps); 
%     while length( [ find(dotSizeHigh_ps <= 0) find(dotSizeLow_ps >= High_range_max) find(dotSizeLow_ps <= High_range_min) ] ) >= 1 % check if all sizes are bigger than 0
%         dotSizeHigh_ps = distnorm(randn(1, ws.numDots4), m_ps, sd_High_ps);
%     end
    
    % circle size - scale normal
%     dotSizeLow = nthroot(dotSizeLow_ps, .76)/pi;
%     dotSizeHigh = nthroot(dotSizeHigh_ps, .76)/pi;
%     dotSizeLow = nthroot(dotSizeLow, 2);
%     dotSizeHigh = nthroot(dotSizeHigh, 2);
    dotSizeLow = nthroot(dotSizeLow_ps, 2*.76);
    dotSizeHigh = nthroot(dotSizeHigh_ps, 2*.76);
    
    % export - circle size
    vws.dotSizeLow = dotSizeLow; % radius
    vws.dotSizeHigh = dotSizeHigh; % radius
    dotSizeLow = dotSizeLow * pxpd;
    dotSizeHigh = dotSizeHigh * pxpd;
    

    %% circle position matrix with random jitter
    % 4x4
    dotPositionMatrix4 = [reshape(ws.x4, 1, ws.numDots4); reshape(ws.y4, 1, ws.numDots4)];
    dotPositionMatrix4 = dotJitter(ws, dotPositionMatrix4, ws.numDots4, pxpd, ws.probe_max); % add jitter 
    dotPositionMatrix4 = [dotPositionMatrix4; dotPositionMatrix4];
    vws.dotPositionMatrix4 = dotPositionMatrix4;
    
    
    %% make circle coordinate with dotSize & dotPositionMatrix
    dotSizeLow_scale = [-dotSizeLow; -dotSizeLow; dotSizeLow; dotSizeLow]; % size scaling matrix
    dotSizeHigh_scale = [-dotSizeHigh; -dotSizeHigh; dotSizeHigh; dotSizeHigh];
    centerShift4 = repmat([cx; cy; cx; cy], 1, ws.numDots4); % center to screen
    % location shift
    shift4 = [0 0];
%     shift3= [-.5 .5; .5 .5; -.5 -.5; .5 -.5];
%     shift2= [-1 1; 0 1; 1 1; -1 0; 0 0; 1 0; -1 -1; 0 -1; 1 -1];
%     shift1= [-1.5 1; 0 1; 1 1; -1 0; 0 0; 1 0; 1 -1; 0 -1; 1 -1];
    shift4( :, 1) = shift4( :, 1) * ws.shiftScale_w; % pixcel scale
    shift4( :, 2) = shift4( :, 2) * ws.shiftScale_h;
%     shift3( :, 1) = shift3( :, 1) * ws.shiftScale_w;
%     shift3( :, 2) = shift3( :, 2) * ws.shiftScale_h;
%     shift2( :, 1) = shift2( :, 1) * ws.shiftScale_w;
%     shift2( :, 2) = shift2( :, 2) * ws.shiftScale_h;
%     shift1( :, 1) = shift1( :, 1) * ws.shiftScale_w;
%     shift1( :, 2) = shift1( :, 2) * ws.shiftScale_h;
    vws.dotrandPick = 1; % randomly pick one
%     vws.dotrandPick3 = randi(4);
%     vws.dotrandPick2 = randi(9);
%     vws.dotrandPick1 = randi(9);
    dotRandShift4 = repmat( shift4', 2, 1); 
%     dotRandShift3 = repmat( shift3(vws.dotrandPick3, 1:2)',2, 1);
%     dotRandShift2 = repmat( shift2(vws.dotrandPick2, 1:2)', 2, 1);
%     dotRandShift1 = repmat( shift1(vws.dotrandPick1, 1:2)', 2, 1);
    dotRandShift4 = repmat(dotRandShift4, 1, ws.numDots4); % multiply by number of dots
%     dotRandShift3 = repmat(dotRandShift3, 1, ws.numDots3);
%     dotRandShift2 = repmat(dotRandShift2, 1, ws.numDots2);
%     dotRandShift1 = repmat(dotRandShift1, 1, ws.numDots1);
    vws.dotRectLow = dotPositionMatrix4 + dotSizeLow_scale + centerShift4 + dotRandShift4;
    vws.dotRectHigh = dotPositionMatrix4 + dotSizeHigh_scale + centerShift4 + dotRandShift4;
%     vws.dotRect3 = dotPositionMatrix3 + dotSize3_scale + centerShift3 + dotRandShift3;
%     vws.dotRect2 = dotPositionMatrix2 + dotSize2_scale + centerShift2 + dotRandShift2;
%     vws.dotRect1 = dotPositionMatrix1 + dotSize1_scale + centerShift1 + dotRandShift1;
    
    
    %% test display parameters
    m_t = (ws.probe_min + ( ws.probe_max - ws.probe_min) * rand(1)); % diameter (from the 5sd range of stimulus range)
    vws.m_t = m_t; % in visual digrees % diameter
    vws.testdotsize = m_t * pxpd; % in pixels % diameter
    % m, sd in psychological scale
%     m_t_ps = ((m_t/2)^2) * pi; % area
    m_t_ps = (m_t/2)^(2*0.76); % psychological
    Low_range_t_max = m_t_ps + (sd_Low_ps * 2);
    Low_range_t_min = m_t_ps - (sd_Low_ps * 2);
    High_range_t_max = m_t_ps + (sd_High_ps * 2);
    High_range_t_min = m_t_ps - (sd_High_ps * 2);
    
    % create probe set array
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
  
    %%% probe size - scale normal
%     testdotSizeLow = nthroot(testdotSizeLow_ps, .76)/pi;
%     testdotSizeHigh = nthroot(testdotSizeHigh_ps, .76)/pi;
%     testdotSizeLow = nthroot(testdotSizeLow, 2);
%     testdotSizeHigh = nthroot(testdotSizeHigh, 2);
    testdotSizeLow = nthroot(testdotSizeLow_ps, 2*.76);
    testdotSizeHigh = nthroot(testdotSizeHigh_ps, 2*.76);
   
    % export - circle size
    vws.testdotSizeLow = testdotSizeLow; % radius
    vws.testdotSizeHigh = testdotSizeHigh; % radius
    testdotSizeLow = testdotSizeLow * pxpd;
    testdotSizeHigh = testdotSizeHigh * pxpd;
    
    % circle position matrix with random jitter
    testdotPositionMatrix4 = [reshape(ws.x4, 1, ws.numDots4); reshape(ws.y4, 1, ws.numDots4)];
    testdotPositionMatrix4 = dotJitter(ws, testdotPositionMatrix4, ws.numDots4, pxpd, ws.probe_max); % add jitter 
    testdotPositionMatrix4 = [testdotPositionMatrix4; testdotPositionMatrix4];
    vws.testdotPositionMatrix4 = testdotPositionMatrix4;
    
    % make circle coordinate with dotSize & dotPositionMatrix    
    testdotSizeLow_scale = [-testdotSizeLow; -testdotSizeLow; testdotSizeLow; testdotSizeLow]; % size scaling matrix
    testdotSizeHigh_scale = [-testdotSizeHigh; -testdotSizeHigh; testdotSizeHigh; testdotSizeHigh];
   
    % location shift
    vws.testdotrandPick = 1; % randomly pick one
%     vws.testdotrandPick3 = randi(4);
%     vws.testdotrandPick2 = randi(9);
%     vws.testdotrandPick1 = randi(9);
    testdotRandShift4 = repmat( shift4', 2, 1);
%     testdotRandShift3 = repmat( shift3(vws.testdotrandPick3, 1:2)',2, 1);
%     testdotRandShift2 = repmat( shift2(vws.testdotrandPick2, 1:2)', 2, 1);
%     testdotRandShift1 = repmat( shift1(vws.testdotrandPick1, 1:2)', 2, 1);
    vws.testdotRandShift4 = repmat(testdotRandShift4, 1, ws.numDots4); % multiply by number of dots
%     testdotRandShift3 = repmat(testdotRandShift3, 1, ws.numDots3);
%     testdotRandShift2 = repmat(testdotRandShift2, 1, ws.numDots2);
%     testdotRandShift1 = repmat(testdotRandShift1, 1, ws.numDots1);
    vws.testdotRectLow = testdotPositionMatrix4 + testdotSizeLow_scale + centerShift4 + vws.testdotRandShift4;
    vws.testdotRectHigh = testdotPositionMatrix4 + testdotSizeHigh_scale + centerShift4 + vws.testdotRandShift4;
%     vws.testdotRect3 = testdotPositionMatrix3 + testdotSize3_scale + centerShift3 + vws.testdotRandShift3;
%     vws.testdotRect2 = testdotPositionMatrix2 + testdotSize2_scale + centerShift2 + vws.testdotRandShift2;
%     vws.testdotRect1 = testdotPositionMatrix1 + testdotSize1_scale + centerShift1 + vws.testdotRandShift1;
    
 

end