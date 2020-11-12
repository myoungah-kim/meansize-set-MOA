function [varStimdisplay, varTestdisplay, varCongruence, resp, probeArraySize, rt, dotSize, init_testdotSize, stim_delay, dotPosition, testdotPosition, m, m_ps, resp_ps, bias_ps] = Exp3_Trial(cond, ws, vws)
    % [meansize, resp, rt, outlier_l position, outlier_r position, all circle size per position]
	SimpleFixation(ws.wptr, ws.Fixation_Cross);
	Screen('Flip', ws.wptr);
	if ~isfield(ws, 'AutoPilot') || ~ws.AutoPilot
		%expkey(KbName('space'));
    end
    
    [cx, cy] = RectCenter(ws.rect);
    
	% exp. conditions
    varType = cond(2);     % 1x1 (L-L), 2x2 (H-H), 3x3 (L-H), 4x4 (H-L)
    if varType == 1
        varStimdisplay = 1;
        varTestdisplay = 1;
        varCongruence = 1;
    elseif varType == 2
        varStimdisplay = 2;
        varTestdisplay = 2;
        varCongruence = 1;
    elseif varType == 3
        varStimdisplay = 1;
        varTestdisplay = 2;
        varCongruence = 2;
    elseif varType == 4
        varStimdisplay = 2;
        varTestdisplay = 1;
        varCongruence = 2;
    end
    
    % fixation cross 500-1000 ms
	fixation_duration = 0.5 + rand(1) * 0.5;
	%SimpleFixation(ws.wptr, ws.Fixation_Cross);
    SimpleFixation(ws.wptr, ws.Fixation_Default);
	trial_onset = Screen('Flip', ws.wptr);
    
    % dots 100ms
    stim_duration = 0.100;
    if varType == 1
        dotRect = vws.dotRectLow;
        dotSize = vws.dotSizeLow; % radius
    elseif varType == 3
        dotRect = vws.dotRectLow;
        dotSize = vws.dotSizeLow; % radius
    elseif varType == 2
        dotRect = vws.dotRectHigh;
        dotSize = vws.dotSizeHigh; % radius
    elseif varType == 4
        dotRect = vws.dotRectHigh;
        dotSize = vws.dotSizeHigh; % radius
    end
    dotPosition = vws.dotrandPick; % dot display position
    
    %Screen('DrawText', ws.wptr, ['stimsetsize '  num2str(stimsetsize)], 10, 30, 0);
    %Screen('DrawText', ws.wptr, ['dotPosition '  num2str(dotPosition)], 10, 90, 0);
    %Screen('DrawText', ws.wptr, ['dotSize ' mat2str(round(dotSize * 2))], 10, 120, 0);
    Screen('FrameOval', ws.wptr, ws.dotColor, dotRect, ws.borderWidth);
    stim_onset = Screen('Flip', ws.wptr, trial_onset + fixation_duration);
    stim_delay = stim_onset - trial_onset;
	
	% blank 500ms
    blank_duration = 0.50;
    SimpleFixation(ws.wptr, ws.Fixation_Cross);
    blank_onset = Screen('Flip', ws.wptr, stim_onset + stim_duration);

	% DEBUG: hold stim. display
	if isfield(ws, 'DebugStim') && ws.DebugStim
		expkey(KbName('space'));
    end

	% response display
    if varType == 1
        testdotRect = vws.testdotRectLow;
        probeArraySize = vws.testdotSizeLow; % entire size array (radius)
    elseif varType == 4
        testdotRect = vws.testdotRectLow;
        probeArraySize = vws.testdotSizeLow; % entire size array (radius)
    elseif varType == 2
        testdotRect = vws.testdotRectHigh;
        probeArraySize = vws.testdotSizeHigh; % entire size array (radius)
    elseif varType == 3
        testdotRect = vws.testdotRectHigh;
        probeArraySize = vws.testdotSizeHigh; % entire size array (radius)
    end
    testdotPosition = vws.testdotrandPick; % testdot display position
    init_testdotSize = vws.m_t; % diameter % visual degrees
    testdotSize = vws.testdotsize; % diameter % pixels
    %Screen('DrawText', ws.wptr, ['probesetsize '  num2str(probesetsize)], 10, 30, 0);
    %Screen('DrawText', ws.wptr, ['testdotPosition '  num2str(testdotPosition)], 10, 90, 0);
    %Screen('DrawText', ws.wptr, ['probeArraySize ' mat2str(round(probeArraySize * 2))], 10, 120, 0); 
    Screen('FrameOval', ws.wptr, ws.dotColor, testdotRect, ws.borderWidth);
    stim_offset = Screen('Flip', ws.wptr, blank_onset + blank_duration);
    
    % response: adjust size with arrow
    up = KbName('UpArrow');
    down = KbName('DownArrow');
    space = KbName('space');
    
    %rkey_desc = [-1, 1];
	if ~isfield(ws, 'AutoPilot') || ~ws.AutoPilot
        while 1
            Screen('FrameOval', ws.wptr, ws.dotColor, testdotRect, ws.borderWidth);
            Screen('Flip', ws.wptr);
            [secs, keycode] = KbWait;
            if keycode(up) && ( testdotSize <  ws.probe_max_px) % if smaller than outlier range (radius)
                testdotSize = testdotSize + 1; % size up if UpArrow
                vps = Exp3_VariableProbeSize(vws, ws.wptr, ws.rect, ws.pxpd, testdotSize, varType);
                testdotRect = vps.testdotRect;
                probeArraySize = vps.testdotSizes_new; % entire size array (radius)
            elseif keycode(down) && (testdotSize > 2) % if bigger than 2px
                testdotSize = testdotSize - 0.5; % size down if DownArrow
                vps = Exp3_VariableProbeSize(vws, ws.wptr, ws.rect, ws.pxpd, testdotSize, varType);
                testdotRect = vps.testdotRect;
                probeArraySize = vps.testdotSizes_new; % entire size array (radius)
            elseif keycode(space)
                rt = secs - stim_offset; % rt: measure rt at space press
                break;
            end   
        end
        resp = testdotSize / ws.pxpd; % probe mean size (diameter)
	else
		[resp, rt] = ...
            deal( ...
            (testdotRect(4,1) - testdotRect(2,1))/2, ...
            GetSecs - stim_onset * randn);
	end
	%resp = rkey_desc(rkey);
    
    m = mean(dotSize.*2); % back to diameter
    m_ps = psy_mean_size(dotSize.*2); % back to diameter
    resp_ps = psy_mean_size(probeArraySize.*2); % back to diameter
    bias_ps = (resp_ps - m_ps)/m_ps;    
    

	% feedback for practice trials
	if isfield(ws, 'feedback') && isa(ws.feedback, 'audioplayer')
		if rkey_desc(rkey) * gabor_tilt < 0
			play(ws.feedback);
		elseif gabor_tilt == 0 && rand < .5
			play(ws.feedback);
		end
	end
end