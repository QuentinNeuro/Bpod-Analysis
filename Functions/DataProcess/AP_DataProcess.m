function Analysis=AP_DataProcess(Analysis)
% Create AllData structure from Core structure + computes some statistics
% and aligns recordings to a time zero

%% Parameters
StateToZero=Analysis.Parameters.StateToZero;
StateOfCue=Analysis.Parameters.StateOfCue;
StateOfOutcome=Analysis.Parameters.StateOfOutcome;

%% Non Trial specific:
Analysis.AllData.nTrials=Analysis.Core.nTrials;
Analysis.AllData.Session=Analysis.Core.Session;
Analysis.AllData.TrialNumbers=Analysis.Core.TrialNumbers;
Analysis.AllData.TrialTypes=Analysis.Core.TrialTypes;
Analysis.Filters.FirstLick=true(Analysis.AllData.nTrials,1);
%% Oddball & Auditory Tuning % should I do that for all of it ?
switch Analysis.Parameters.Behavior
    case 'Oddball'
    maxITI=max(diff(Analysis.Core.TrialStartTS));
    Analysis.Parameters.ReshapedTime=[0 ceil(maxITI)+1];
end
%% Baseline for fiber photometry
if Analysis.Parameters.Photometry
    Analysis=AP_Photometry_Baseline(Analysis);
    if Analysis.Parameters.Fit_470405
    Analysis=AP_Photometry_2ChFit(Analysis);
    end
    if Analysis.Parameters.BaselineFit
        disp('BaselineFit is not ready yet')
    end
end
%% Trial processing
for thisTrial=1:Analysis.AllData.nTrials
	% Timing - some of these values could be modified by process% functions
    thisStates=Analysis.Core.States{1,thisTrial};
    Analysis.AllData.Time.Zero(thisTrial)           =thisStates.(StateToZero)(1);
    Analysis.AllData.Time.Cue(thisTrial,:)          =thisStates.(StateOfCue)-thisStates.(StateToZero)(1);
    Analysis.AllData.Time.Outcome(thisTrial,:)      =thisStates.(StateOfOutcome)-thisStates.(StateToZero)(1);
    % Licks
    Analysis=AP_DataProcess_Licks(Analysis,thisTrial,Analysis.Parameters.ZeroFirstLick);
    % Photometry
    if Analysis.Parameters.Photometry
    Analysis=AP_DataProcess_Photometry(Analysis,thisTrial);
    end 
    % Wheel
    if Analysis.Parameters.Wheel
    Analysis=AP_DataProcess_Wheel(Analysis,thisTrial);
    end
    % Pupil
    if Analysis.Parameters.Pupillometry
	Analysis=AP_DataProcess_Pupil(Analysis,thisTrial);
    end
end

%% Event Detection
if Analysis.Parameters.EventDetection
    Analysis=AP_DataProcess_Events(Analysis);
end

%% Spike Analysis
if Analysis.Parameters.Spikes.Spikes
    Analysis=AP_DataProcess_Spikes(Analysis);
end
%% AOD
if Analysis.Parameters.AOD.AOD
    Analysis=AP_DataProcess_AOD(Analysis);
end

%% Miniscope
if Analysis.Parameters.Miniscope.Miniscope
    Analysis=AP_DataProcess_Miniscope(Analysis);
end

%% Bleaching calculation and axis
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
    Analysis.AllData.(thisChStruct).Bleach=Analysis.AllData.(thisChStruct).BaselineAVG/mean(Analysis.AllData.(thisChStruct).BaselineAVG(1:2));
%     if ischar(Analysis.Parameters.PlotY_photo(thisCh,:))
%         thisYAxis(thisCh,1)=min(min(Analysis.AllData.(thisChStruct).DFF));
%         thisYAxis(thisCh,2)=max(max(Analysis.AllData.(thisChStruct).DFF));
%     end
end 
%% Norm Pupil
if Analysis.Parameters.Pupillometry
for thisSession=1:Analysis.AllData.Session(end)
    Analysis.AllData.Pupil.NormBaseline(Analysis.AllData.Session==thisSession)=Analysis.AllData.Pupil.NormBaseline(Analysis.AllData.Session==thisSession)/nanmean(Analysis.AllData.Pupil.NormBaseline(Analysis.AllData.Session==thisSession));
end
end
