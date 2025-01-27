function Analysis=AP_DataProcess_Pupil(Analysis,thisTrial)

if Analysis.Filters.Pupillometry(thisTrial)
%% Timing
thisSession=Analysis.AllData.Session(thisTrial);
timeToZero=Analysis.AllData.Time.Zero(thisTrial);
newPupilZero=Analysis.Core.States{1,thisTrial}.(Analysis.Parameters.Pupillometry.Parameters{thisSession}.StartState)(1);
timeToZero=timeToZero-newPupilZero;
cueTime=Analysis.AllData.Time.Cue(thisTrial,:)+Analysis.Parameters.Timing.CueTimeReset;
outcomeTime=Analysis.AllData.Time.Outcome(thisTrial,:)+Analysis.Parameters.Timing.OutcomeTimeReset;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
samplingRate=Analysis.Parameters.Pupillometry.Parameters{thisSession}.frameRate;
baseline=Analysis.Parameters.Data.NidaqBaselinePoints; 
% nFrames=Analysis.Parameters.Pupillometry_Parameters.nFrames;

%% Data
thisPup=Analysis.Core.Pup{thisTrial};
thisPupSmooth=Analysis.Core.PupSmooth{thisTrial};
thisBlink=Analysis.Core.PupBlink{thisTrial};
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
Analysis.AllData.Pupil.Time(thisTrial,:)            =thisTime;
Analysis.AllData.Pupil.Pupil(thisTrial,:)           =thisPupTW;
Analysis.AllData.Pupil.PupilDPP(thisTrial,:)        =thisPupDPP;
Analysis.AllData.Pupil.Blink(thisTrial,:)           =thisBlinkTW;
Analysis.AllData.Pupil.Baseline(thisTrial)          =thisBaseline;
Analysis.AllData.Pupil.NormBaseline(thisTrial)      =thisBaseline;
Analysis.AllData.Pupil.Cue(thisTrial)               =mean(thisPupDPP(thisTime>cueTime(1) & thisTime<cueTime(2)),'omitnan');
Analysis.AllData.Pupil.Outcome(thisTrial)           =mean(thisPupDPP(thisTime>outcomeTime(1) & thisTime<outcomeTime(2)),'omitnan');
end