 % dotsize range reduced
function ws = Exp3_Workspace(wptr, rect, pxpd)
	ws = base_workspace(wptr, rect);
    ws.rect = rect;
    ws.pxpd = pxpd;
    
	%% grid parameters
    % 4x4
    dim_w = 4; 
    dim_h = 4;
    x4 = repmat([-1.5 -.5 .5 1.5], 4, 1); % 4 rows of [-1.5; -.5; .5; 1.5]
    y4 = repmat([-1.5; -.5; .5; 1.5], 1, 4); % 4 colums of [-1.5; -.5; .5; 1.5]
    pixelScale_w = 4 * pxpd; % unit width 4
    pixelScale_h = 4 * pxpd; % unit height 4
    ws.x4 = x4 .* pixelScale_w;
    ws.y4 = y4 .* pixelScale_h;
    ws.shiftScale_w = 4 * pxpd;
    ws.shiftScale_h = 4 * pxpd;
   
    %% circle parameters
    ws.numDots4 = 16; % 4x4
    ws.dotColor = [0, 0, 0]; % dot color: black
    ws.borderWidth = 0.05 * pxpd; % dot border width: 0.05
    
    %% circle sizes - m random from 1.13 ~ 2.26, sd low = 0.107, sd high = 0.536
%     ws.m_min = 1.13; 
%     ws.m_max = 2.26;
%     ws.sd_Low = 0.15;
%     ws.sd_High = 0.45;
    ws.m_min = 0.7; 
    ws.m_max = 1.4;
%     ws.sd_Low = 0.1;
%     ws.sd_High = 0.35;
    % probe size range 2sd (radius)
    probe_min = (ws.m_min/2)^(2*.76);
    probe_max = (ws.m_max/2)^(2*.76);
    probe_min_sd = probe_min/3;
    probe_max_sd = probe_max/3;
%     probe_sd = (ws.sd_High/2);
    if probe_min - (2 * probe_min_sd) <= 0
        probe_min = 0;
    else
        probe_min = nthroot(probe_min - (2 * probe_min_sd), 2*.76) * 2; % diameter
    end
    probe_max = nthroot(probe_max + (2 * probe_max_sd), 2*.76) * 2; % diameter
    ws.probe_min = probe_min; % diameter
    ws.probe_max = probe_max; % diameter
    ws.probe_max_px = probe_max * pxpd; % in pixels % diameter
    ws.jitter_pivot_size = (nthroot((dim_w/2)^(2*.76) - (2 * probe_max_sd), 2*.76) * 2) * pxpd; % diameter
	%% fixation parameters
    ws.tex_size = round(4 * pxpd);
	ws.SimpleText_Offset = [0, (ws.tex_size / 2) + 80];
    ws.SimpleText_Color  = [255 255 255];
	ws.Fixation_Default  = struct('cr', 10, 'cc', [0 0 0], 'lr', 6, 'lc', [127 127 127]);
	ws.Fixation_Cross    = struct('lr', 6, 'lc', [0 0 0]);
	ws.Fixation_Response = struct('lr', 6, 'lc', [255 0 0]);
end