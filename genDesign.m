function design = genDesign(vpcode)
%
% 2017 by Martin Rolfs
% 2019 mod by Clara Kuper

% randomize random
rand('state',sum(100*clock));

design.vpcode    = vpcode;

% hand movement required?
% 1 = move, 0 = don't move
design.sacReq = 1;
design.fixReq = 0;

% include fixation point?
% 1 = include, 0 = ommit
design.InclFix = 1;

% test trial or full experiment
% 1 = full, 0 = adjust session
design.test = 0;

% Timing %
design.fixDur    = 0.5; % Fixation duration till trial starts [s]
design.fixDurJ   = 0.5; % Additional jitter to fixation

design.iti       = 0.2; % Inter stimulus interval

if design.test
    timParams = load('subject_timParams.mat'); % load a matfile with subject name and code
    design.jumpAfter = timParams.jumpAfter;    % time when target jumps
    design.alResT    = tim.Params.alResT;      % Allowed response time
    design.alMovT    = tim.Params.alResT;      % Allowed movement time
else
    design.jumpAfter = 0;
    design.alResT    = 1.0;      % Allowed response time
    design.alMovT    = 1.0;      % Allowed movement time
end

    

% overall information %
% number of blocks
design.nBlocks = 1;
% number of trials
design.nTrials = 10;

% fixation point


% conditions
design.goalPos    = [1,2]; % 1 is left, 2 is right goal
design.ballMoved  = -100;  % ball moved relative from fixation point

design.stimsize   = 20;

% build
for b = 1:design.nBlocks
    t = 0;
    for triali = 1:design.nTrials
        for goal = design.goalPos
            t = t+1;
            % define goal position
            trial(t).goalPos = goal;
            % define jump position 
            trial(t).jumpPos = rand(1)*design.jumpAfter;
            % define fixation duration
            trial(t).fixT    = design.fixDur + rand(1)*design.fixDurJ;
        end
    end
    % randomize
    r = randperm(t);
    design.b(b).trial = trial(r);
end

design.blockOrder = 1:b;
design.nTrialsPB  = t;

% save 
save(sprintf('%s.mat',vpcode),'design');
