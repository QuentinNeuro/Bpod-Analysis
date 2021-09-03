% function Analysis=Analysis_Photometry_Event_Detection(Analysis)
%% Bpod Photometry Event Detection
% Transform trial-based Bpod photometry data into concatenated trace for
% event detection via sparse non-negative deconvolution utilizing Online 
% Active Set method to Infer Spikes (OASIS; c.f. Friedrich et al., 2017).

%% Initialize Data Structure
%  Determine # fibers
oneFiber = ~(isfield(Analysis.AllData,'Photo_470') & ...
             isfield(Analysis.AllData,'Photo_470b'));

if oneFiber
    traceStruct.params.numFibers = 1;
else
    traceStruct.params.numFibers = 2;
end

%  Fill struct
traceStruct.allTraces.raw = Analysis.Core.Photometry;
traceStruct.allTraces.Z   = Analysis.Core.Photometry;

%% Determine Baseline(s)
%  Set params
traceStruct.params.slidingWindow     = 1;      % bool
traceStruct.params.windowSize        = 10;     % trials (each side)
traceStruct.params.samplingRate      = 20;     % hz
traceStruct.params.baselineStart     = 1;      % time (s)
traceStruct.params.baselineEnd       = 2;      % time (s)
traceStruct.params.zProminence       = 0.40;   % unitless

%  Calculate baselines
for f = 1:traceStruct.params.numFibers
    eval(['traceStruct.baselines.fiber' num2str(f)             ...
          '= cell(1,Analysis.Core.nTrials)']); % pre-allocated for speed
    eval(['traceStruct.stds.fiber' num2str(f)                  ...
          '= cell(1,Analysis.Core.nTrials)']); % pre-allocated for speed
    for i = 1:Analysis.Core.nTrials
        trialData = traceStruct.allTraces.raw{1,i}{f,1};
        trueStart = traceStruct.params.baselineStart *         ...
                    traceStruct.params.samplingRate + 1;
        trueStop  = traceStruct.params.baselineEnd   *         ...
                    traceStruct.params.samplingRate;
        baseline  = mean(trialData(trueStart:trueStop));
        stdvar    = std(trialData(trueStart:trueStop));
        eval(['traceStruct.baselines.fiber' num2str(f) '{1,i}' ...
                 '=' num2str(baseline)]);   
        eval(['traceStruct.stds.fiber' num2str(f) '{1,i}'      ...
                 '=' num2str(stdvar)]);
    end
end

%% Calculate Z scores
for f = 1:traceStruct.params.numFibers
    eval(['baselines = cell2mat(traceStruct.baselines.fiber' ...  
           num2str(f) ')']);
    eval(['traceStruct.mbaselines.fiber' num2str(f)             ...
              '= movmean(baselines,'                            ...
              '[traceStruct.params.windowSize,'                 ...
              'traceStruct.params.windowSize])']);   
    eval(['traceStruct.mstds.fiber' num2str(f)                  ...
              '= movstd(baselines,'                             ...
              '[traceStruct.params.windowSize,'                 ...
              'traceStruct.params.windowSize])']);   
    for i = 1:Analysis.Core.nTrials
        eval(['baseline = traceStruct.mbaselines.fiber'         ...
               num2str(f) '(i)'])                               
        eval(['stdvar = traceStruct.mstds.fiber'                ...
               num2str(f) '(i)'])      
        traceStruct.allTraces.Z{1,i}{f,1} =                     ...
               (traceStruct.allTraces.Z{1,i}{f,1} - baseline) / ...
               stdvar;
    end
end

%% Find Peaks
for f = 1:traceStruct.params.numFibers
    eval(['traceStruct.peaks.fiber' num2str(f)                       ...
          '= cell(1,Analysis.Core.nTrials)']); % pre-allocated for speed
    eval(['traceStruct.proms.fiber' num2str(f)                       ...
          '= cell(1,Analysis.Core.nTrials)']); % pre-allocated for speed
    for i = 1:Analysis.Core.nTrials
        [pks,locs,widths,proms] = findpeaks(                         ...
                                  traceStruct.allTraces.Z{1,i}{f,1}, ...
                                  'MinPeakProminence',               ...
                                  traceStruct.params.zProminence);
        eval(['traceStruct.peaks.fiber' num2str(f) '{1,i}'           ...
                 '= zeros(size(traceStruct.allTraces.Z{1,i}{f,1}))']); 
        eval(['traceStruct.peaks.fiber' num2str(f) '{1,i}(locs)'     ...
                 '= 1']); 
        eval(['traceStruct.proms.fiber' num2str(f) '{1,i}'           ...
                 '= proms']); 
    end
end


randtrial = round((200)*rand(1))
yyaxis left
plot(traceStruct.allTraces.Z{1,randtrial}{1,1})
hold on
% yyaxis right
% plot(traceStruct.allTraces.raw{1,randtrial}{f,1})
verticalLines(find(traceStruct.peaks.fiber1{1, randtrial}))
hold off