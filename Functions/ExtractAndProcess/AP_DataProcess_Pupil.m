function Analysis=AP_DataProcess_Pupil(Analysis,thisTrial)

if Analysis.Filters.Pupillometry(thisTrial)
%% Timing
thisSession=Analysis.AllData.Session(thisTrial);
TimeToZero=Analysis.AllData.Time.Zero(thisTrial);
NewPupilZero=Analysis.Core.States{1,thisTrial}.(Analysis.Parameters.Pupillometry_Parameters{thisSession}.StartState)(1);
TimeToZero=TimeToZero-NewPupilZero;
CueTime=Analysis.AllData.Time.Cue(thisTrial,:)+Analysis.Parameters.CueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome(thisTrial,:)+Analysis.Parameters.OutcomeTimeReset;
TimeWindow=Analysis.Parameters.ReshapedTime;
SamplingRate=Analysis.Parameters.Pupillometry_Parameters{thisSession}.frameRate;
Baseline=Analysis.Parameters.NidaqBaselinePoints; 
% nFrames=Analysis.Parameters.Pupillometry_Parameters.nFrames;

%% Data
thisPup=Analysis.Core.Pup{thisTrial};
thisPupSmooth=Analysis.Core.PupSmooth{thisTrial};
thisBlink=Analysis.Core.PupBlink{thisTrial};
% Baseline
thisBaseline=nanmean(thisPupSmooth(Baseline(1):Baseline(2)));

% New Time window
[thisTime,thisPupTW]=AP_TimeReshaping(thisPup,TimeWindow,TimeToZero,SamplingRate);
[Time2,thisPupSmoothTW]=AP_TimeReshaping(thisPupSmooth,TimeWindow,TimeToZero,SamplingRate);
[Time3,thisBlinkTW]=AP_TimeReshaping(thisBlink,TimeWindow,TimeToZero,SamplingRate);
%%%%% ADD CHECK ON TIME %%%%

% DPP
thisPupDPP=100*(thisPupSmoothTW-thisBaseline)/thisBaseline;
if Analysis.Parameters.ZeroAtZero
    thisPupDPP=thisPupDPP-mean(thisPupDPP(thisTime>-0.01 & thisTime<0.01));
end

%% Statistics for Analysis Structure
if ~isfield(Analysis.AllData,'Pupil')
    Analysis.AllData.Pupil.Time(1:thisTrial-1,:)        =NaN(thisTrial-1,length(thisTime));
    Analysis.AllData.Pupil.Pupil(1:thisTrial-1,:)       =NaN(thisTrial-1,length(thisPupTW));
    Analysis.AllData.Pupil.PupilDPP(1:thisTrial-1,:)    =NaN(thisTrial-1,length(thisPupDPP));
    Analysis.AllData.Pupil.Blink(1:thisTrial-1,:)       =NaN(thisTrial-1,length(thisBlinkTW));
    Analysis.AllData.Pupil.Baseline(1:thisTrial-1)      =NaN(1,thisTrial-1);
    Analysis.AllData.Pupil.NormBaseline(1:thisTrial-1)  =NaN(1,thisTrial-1);
    Analysis.AllData.Pupil.Cue(1:thisTrial-1)           =NaN(1,thisTrial-1);
    Analysis.AllData.Pupil.Outcome(1:thisTrial-1)       =NaN(1,thisTrial-1);
    Analysis.AllData.Time.Pupil                         =thisTime;
end
Analysis.AllData.Pupil.Time(thisTrial,:)            =thisTime;
Analysis.AllData.Pupil.Pupil(thisTrial,:)           =thisPupTW;
Analysis.AllData.Pupil.PupilDPP(thisTrial,:)        =thisPupDPP;
Analysis.AllData.Pupil.Blink(thisTrial,:)           =thisBlinkTW;
Analysis.AllData.Pupil.Baseline(thisTrial)          =thisBaseline;
Analysis.AllData.Pupil.NormBaseline(thisTrial)      =thisBaseline;
Analysis.AllData.Pupil.Cue(thisTrial)               =nanmean(thisPupDPP(thisTime>CueTime(1) & thisTime<CueTime(2)));
Analysis.AllData.Pupil.Outcome(thisTrial)           =nanmean(thisPupDPP(thisTime>OutcomeTime(1) & thisTime<OutcomeTime(2)));
else
    if isfield(Analysis.AllData,'Pupil')
Analysis.AllData.Pupil.Time(thisTrial,:)          	=NaN(1,size(Analysis.AllData.Pupil.Time,2));
Analysis.AllData.Pupil.Pupil(thisTrial,:)          	=NaN(1,size(Analysis.AllData.Pupil.Pupil,2));
Analysis.AllData.Pupil.PupilDPP(thisTrial,:)     	=NaN(1,size(Analysis.AllData.Pupil.PupilDPP,2));
Analysis.AllData.Pupil.Blink(thisTrial,:)          	=NaN(1,size(Analysis.AllData.Pupil.Blink,2));
Analysis.AllData.Pupil.Baseline(thisTrial)          =NaN;
Analysis.AllData.Pupil.NormBaseline(thisTrial)      =NaN;
Analysis.AllData.Pupil.Cue(thisTrial)               =NaN;
Analysis.AllData.Pupil.Outcome(thisTrial)           =NaN;
    end
end
end