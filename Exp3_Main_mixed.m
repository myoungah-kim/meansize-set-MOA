%Screen('Preference', 'SkipSyncTests', 1);
clear;
addpath('lib', 'local');
ap = vcc_apparatus.Jeonil;

if ~exist('sbj', 'var') || isempty(sbj)
	sbj = strtrim(input('subject id? ', 's'));
end
matfile = fullfile('data', 'Exp3', strcat(sbj, datestr(now(), '.yyyy-mm-dd.HH_MM_SS'), '.mat'));

% exp. conditions
varType = [1; 2; 3; 4];     % 1 (L-L), 2 (H-H), 3 (L-H), 4 (H-L)

emat = expmat(varType); 


try
	% initialize psychtoolbox screen
    ListenChar(2);
    whichscreen = max(Screen('Screens'));
	[wptr, rect] = Screen('OpenWindow', whichscreen, [127, 127, 127]);
    [screenXpixels, screenYpixels] = Screen('WindowSize', wptr);
	Screen('BlendFunction', wptr, GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA);
	Screen('HideCursorHelper', wptr);
	Screen('TextFont', wptr, 'Trebuchet MS');
	Screen('TextSize', wptr, 24);
	%ApplyGammaTable;

	% workspace
	ws = Exp3_Workspace(wptr, rect, ap.pxpd);
	% DEBUG
	ws.AutoPilot = false;
	ws.DebugStim = false;

	% practice
	p_reps = 4;
	% ws.feedback = audioplayer(sind((1:600) / 8000 * 360 * 800), 8000);
	[pseq, pmat, pn] = expseq(emat, p_reps);
    psizemat = [];
    pprobesizemat = [];
    psizemat(:, 1) = pmat(:, 1);
    pprobesizemat(:, 1) = pmat(:, 1);
	SimpleTextScreen('Press SPACE to Start Practice Session', ws);
	for p = 1:pn
        % trial
		pcond = pmat(pseq(p), :);
        vws = Exp3_VariableWorkspace(wptr, rect, ap.pxpd);
		[varStimdisplay, varTestdisplay, varCongruence, resp, probeArraySize, rt, dotSize, testdotSize, stim_delay, dotPosition, testdotPosition, m, m_ps, resp_ps, bias_ps] = Exp3_Trial(pcond, ws, vws);     
        psizemat(pseq(p), 2 : length(dotSize)+1 ) = dotSize;
        pprobesizemat(pseq(p), 2 : length(probeArraySize)+1 ) = probeArraySize;
        stimdotVar = std(dotSize);
        testdotVar = std(probeArraySize);
        stimdotSkew = skewness(dotSize);
        testdotSkew = skewness(probeArraySize);
        pmat(pseq(p), 3) = varStimdisplay;
        pmat(pseq(p), 4) = varTestdisplay;
        pmat(pseq(p), 5) = varCongruence;
        pmat(pseq(p), 6) = (vws.m/2); % diameter to radius
        pmat(pseq(p), 7) = rt;
        pmat(pseq(p), 8) = stim_delay;
        pmat(pseq(p), 9) = testdotSize;
        pmat(pseq(p), 10) = resp;
		pmat(pseq(p), 11) = dotPosition;
        pmat(pseq(p), 12) = testdotPosition;
        pmat(pseq(p), 13) = stimdotVar;
        pmat(pseq(p), 14) = testdotVar;
        pmat(pseq(p), 15) = stimdotSkew;
        pmat(pseq(p), 16) = testdotSkew;
        pmat(pseq(p), 17) = m;
        pmat(pseq(p), 18) = m_ps;
        pmat(pseq(p), 19) = resp_ps;
        pmat(pseq(p), 20) = bias_ps;
	end
	%ws = rmfield(ws, 'feedback');

	% main trials
	reps = 50;
	[eseq, emat, tn] = expseq(emat, reps);
    sizemat = [];
    probesizemat = [];
    sizemat(:, 1) = emat(:, 1);
    probesizemat(:, 1) = emat(:, 1);
	SimpleTextScreen('Press SPACE to Start Main Trial', ws);
	for t = 1:tn
		% trial
		tcond = emat(eseq(t), :);
        vws = Exp3_VariableWorkspace(wptr, rect, ap.pxpd);
		[varStimdisplay, varTestdisplay, varCongruence, resp, probeArraySize, rt, dotSize, testdotSize, stim_delay, dotPosition, testdotPosition, m, m_ps, resp_ps, bias_ps] = Exp3_Trial(tcond, ws, vws);
		sizemat(eseq(t), 2 : length(dotSize)+1 ) = dotSize;
        probesizemat(eseq(t), 2 : length(probeArraySize)+1 ) = probeArraySize;
        stimdotVar = std(dotSize);
        testdotVar = std(probeArraySize);
        stimdotSkew = skewness(dotSize);
        testdotSkew = skewness(probeArraySize);
        emat(eseq(t), 3) = varStimdisplay;
        emat(eseq(t), 4) = varTestdisplay;
        emat(eseq(t), 5) = varCongruence;
        emat(eseq(t), 6) = (vws.m/2); % diameter to radius
        emat(eseq(t), 7) = rt;
        emat(eseq(t), 8) = stim_delay;
        emat(eseq(t), 9) = testdotSize;
        emat(eseq(t), 10) = resp;
		emat(eseq(t), 11) = dotPosition;
        emat(eseq(t), 12) = testdotPosition;
        emat(eseq(t), 13) = stimdotVar;
        emat(eseq(t), 14) = testdotVar;
        emat(eseq(t), 15) = stimdotSkew;
        emat(eseq(t), 16) = testdotSkew;
        emat(eseq(t), 17) = m;
        emat(eseq(t), 18) = m_ps;
        emat(eseq(t), 19) = resp_ps;
        emat(eseq(t), 20) = bias_ps;

		% break b/w blocks
		if t < tn && mod(t, 50) == 0
			SimpleTextScreen('Take a Break, then Press SPACE to Start Next Session', ws);
		end
	end

	% finalize
    %[pmat, psizemat_ps] = processData_Exp2(pmat, psizemat, ws.numDots);
    %[emat, sizemat_ps] = processData_Exp2(emat, sizemat, ws.numDots);
	%fmat = expdata(emat, 2, 3, 4, @(x) sum(x + 1) / 2);
	%rtmat = expdata(emat, 2, 3, 5, @mean);
	%clear ans pcond ptb_ConfigPath ptb_RootPath tcond;
	save(matfile);
	SimpleTextScreen('Thanks for Your Participation', ws);

	% draw & save figure
    congruent = [];
    incongruent = [];
    for i = 1:length(emat(:,1))
        if emat(i, 5) == 1
            congruent = [congruent emat(i, 20)];
        elseif emat(i, 5) == 2
            incongruent = [incongruent emat(i, 20)];
        end
    end
    congruent_bias = mean(congruent);
    incongruent_bias = mean(incongruent);
    sem_bias = [std(congruent)/sqrt(length(congruent)) std(incongruent)/sqrt(length(incongruent))];   
    
    figfile = regexprep(matfile, '\.mat$', '.fig');
    hf = figure;
    c = categorical({'congruent','incongruent'});
    hold on
    bar(c,[congruent_bias incongruent_bias]);
    errorbar(c,[congruent_bias incongruent_bias],sem_bias,'.')
    saveas(hf, figfile);
	close(hf);
	%figfile = regexprep(matfile, '\.mat$', '.fig');
	%hf = figure;
	%subplot(2, 1, 1);
	%plot(fmat(1, 2:end)', fmat(2:end, 2:end)');
	%title('N("Clockwise" response)');
	%subplot(2, 1, 2);
	%plot(rtmat(1, 2:end)', rtmat(2:end, 2:end)');
	%title('Reaction Time');
	%saveas(hf, figfile);

	% wrap up psychtoolbox screen
	%ResetGammaTable;
	Screen('CloseAll');
    ListenChar(1);
catch e
	% clear psychtoolbox screen & rethrow exception
	%ResetGammaTable;
	Screen('CloseAll');
    ListenChar(1);
	rethrow(e);
end
