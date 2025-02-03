function Analysis=AP_DataProcess_Pupil(Analysis)

% Parameters
nTrials=Analysis.Parameters.Behavior.nTrials;

for t=1:nTrials
if Analysis.Filters.Pupillometry(t)
%% Timing
thisSession=Analysis.AllData.Session(t);
timeToZero=Analysis.AllData.Time.Zero(t);
newPupilZero=Analysis.Core.States{1,t}.(Analysis.Parameters.Pupillometry.Parameters{thisSession}.StartState)(1);
timeToZero=timeToZero-newPupilZero;
cueTime=Analysis.AllData.Time.Cue(t,:)+Analysis.Parameters.Timing.CueTimeReset;
outcomeTime=Analysis.AllData.Time.Outcome(t,:)+Analysis.Parameters.Timing.OutcomeTimeReset;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
samplingRate=Analysis.Parameters.Pupillometry.Parameters{thisSession}.frameRate;
baseline=Analysis.Parameters.Data.NidaqBaselinePoints; 
% nFrames=Analysis.Parameters.Pupillometry_Parameters.nFrames;

%% Data
thisPup=Analysis.Core.Pup{t};
thisPupSmooth=Analysis.Core.PupSmooth{t};
thisBlink=Analysis.Core.PupBlink{t};
% Baseline
thisBaseline=mean(thisPupSmooth(baseline(1):baseline(2)),'omitnan');

% New Time window
[thisTime,thisPupTW]=AP_PSTH(thisPup,PSTH_TW,timeToZero,samplingRate);
[time2,thisPupSmoothTW]=AP_PSTH(thisPupSmooth,PSTH_TW,timeToZero,samplingRate);
[time3,thisBlinkTW]=AP_PSTH(thisBlink,PSTH_TW,timeToZero,samplingRate);

%%%%% TO DO ADD CHECK ON TIME %%%%

% DPP
thisPupDPP=100*(thisPupSmoothTW-thisBaseline)/thisBaseline;

%% Statistics for Analysis Structure
Analysis.AllData.Pupil.Time(t,:)            =thisTime;
Analysis.AllData.Pupil.Pupil(t,:)           =thisPupTW;
Analysis.AllData.Pupil.PupilDPP(t,:)        =thisPupDPP;
Analysis.AllData.Pupil.Blink(t,:)           =thisBlinkTW;
Analysis.AllData.Pupil.Baseline(t)          =thisBaseline;
Analysis.AllData.Pupil.NormBaseline(t)      =thisBaseline;
Analysis.AllData.Pupil.Cue(t)               =mean(thisPupDPP(thisTime>cueTime(1) & thisTime<cueTime(2)),'omitnan');
Analysis.AllData.Pupil.Outcome(t)           =mean(thisPupDPP(thisTime>outcomeTime(1) & thisTime<outcomeTime(2)),'omitnan');
end
end