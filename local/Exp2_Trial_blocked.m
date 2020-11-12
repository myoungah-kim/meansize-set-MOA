function [resp, probeArraySize, rt, dotSize, init_testdotSize, stim_delay, dotPosition, testdotPosition] = Exp2_Trial_blocked(ws, vws, stimsetsize, probesetsize)
    % [meansize, resp, rt, outlier_l position, outlier_r position, all circle size per position]
	SimpleFixation(ws.wptr, ws.Fixation_Cross);
	Screen('Flip', ws.wptr);
	if ~isfield(ws, 'AutoPilot') || ~ws.AutoPilot
		%expkey(KbName('space'));
    end
    
    [cx, cy] = RectCenter(ws.rect);
    
	% exp. conditions
%     stimsetsize = cond(2);     % 1x1 (1), 2x2 (2), 3x3 (3), 4x4 (4)
%     probesetsize = cond(3);     % 1x1 (1), 2x2 (2), 3x3 (3), 4x4 (4)
    
    % fixation cross 500-1000 ms
	fixation_duration = 0.5 + rand(1) * 0.5;
	%SimpleFixation(ws.wptr, ws.Fixation_Cross);
    SimpleFixation(ws.wptr, ws.Fixation_Default);
	trial_onset = Screen('Flip', ws.wptr);
    
    % dots 100ms
    stim_duration = 0.100;
    if stimsetsize == 1
        dotRect = vws.dotRect1;
        dotSize = vws.dotSize1;
        dotPosition = vws.dotrandPick1; % dot display position
    elseif stimsetsize == 2
        dotRect = vws.dotRect2;
        dotSize = vws.dotSize2;
        dotPosition = vws.dotrandPick2;
    elseif stimsetsize == 3
        dotRect = vws.dotRect3;
        dotSize = vws.dotSize3;
        dotPosition = vws.dotrandPick3;
    elseif stimsetsize == 4
        dotRect = vws.dotRect4;
        dotSize = vws.dotSize4;
        dotPosition = vws.dotrandPick4;
    end
    
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
    if probesetsize == 1 
        testdotRect = vws.testdotRect1;
        probeArraySize = vws.testdotSize1; % entire size array (radius)
        testdotPosition = vws.testdotrandPick1; % testdot display position
    elseif probesetsize == 2 
        testdotRect = vws.testdotRect2;
        probeArraySize = vws.testdotSize2; % entire size array (radius)
        testdotPosition = vws.testdotrandPick2;
    elseif probesetsize == 3
        testdotRect = vws.testdotRect3;
        probeArraySize = vws.testdotSize3; % entire size array (radius)
        testdotPosition = vws.testdotrandPick3;
    elseif probesetsize == 4
        testdotRect = vws.testdotRect4;
        probeArraySize = vws.testdotSize4; % entire size array (radius)
        testdotPosition = vws.testdotrandPick4;
    end
    testdotSize = vws.m_t; % radius
    init_testdotSize = vws.m_t; % radius
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
            if keycode(up) && ( testdotSize <  ws.probe_max) % if smaller than outlier range (radius)
                testdotSize = testdotSize + 0.5; % size up if UpArrow
                vps = Exp2_VariableProbeSize(vws, ws.wptr, ws.rect, ws.pxpd, testdotSize, probesetsize);
                testdotRect = vps.testdotRect;
                probeArraySize = vps.testdotSizes_new; % entire size array (radius)
            elseif keycode(down) && (testdotSize > 2) % if bigger than 2px
                testdotSize = testdotSize - 0.5; % size down if DownArrow
                vps = Exp2_VariableProbeSize(vws, ws.wptr, ws.rect, ws.pxpd, testdotSize, probesetsize);
                testdotRect = vps.testdotRect;
                probeArraySize = vps.testdotSizes_new; % entire size array (radius)
            elseif keycode(space)
                rt = secs - stim_offset; % rt: measure rt at space press
                break;
            end   
        end
        resp = testdotSize; % probe mean size (radius)
	else
		[resp, rt] = ...
            deal( ...
            (testdotRect(4,1) - testdotRect(2,1))/2, ...
            GetSecs - stim_onset * randn);
	end
	%resp = rkey_desc(rkey);
    
    


	% feedback for practice trials
	if isfield(ws, 'feedback') && isa(ws.feedback, 'audioplayer')
		if rkey_desc(rkey) * gabor_tilt < 0
			play(ws.feedback);
		elseif gabor_tilt == 0 && rand < .5
			play(ws.feedback);
		end
	end
end