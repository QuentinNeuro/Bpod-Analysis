function Analysis=AP_DataProcess_Pupil(Analysis,thisTrial)

if Analysis.Filters.Pupillometry(thisTrial)
%% Timing
thisSession=Analysis.AllData.Session(thisTrial);
timeToZero=Analysis.AllData.Time.Zero(thisTrial);
newPupilZero=Analysis.Core.States{1,thisTrial}.(Analysis.Parameters.Pupillometry_Parameters{thisSession}.StartState)(1);
timeToZero=timeToZero-newPupilZero;
cueTime=Analysis.AllData.Time.Cue(thisTrial,:)+Analysis.Parameters.CueTimeReset;
outcomeTime=Analysis.AllData.Time.Outcome(thisTrial,:)+Analysis.Parameters.OutcomeTimeReset;
timeWindow=Analysis.Parameters.ReshapedTime;
samplingRate=Analysis.Parameters.Pupillometry_Parameters{thisSession}.frameRate;
baseline=Analysis.Parameters.NidaqBaselinePoints; 
% nFrames=Analysis.Parameters.Pupillometry_Parameters.nFrames;

%% Data
thisPup=Analysis.Core.Pup{thisTrial};
thisPupSmooth=Analysis.Core.PupSmooth{thisTrial};
thisBlink=Analysis.Core.PupBlink{thisTrial};
% Baseline
thisBaseline=mean(thisPupSmooth(baseline(1):baseline(2)),'omitnan');

% New Time window
[thisTime,thisPupTW]=AP_PSTH(thisPup,timeWindow,timeToZero,samplingRate);
[time2,thisPupSmoothTW]=AP_PSTH(thisPupSmooth,timeWindow,timeToZero,samplingRate);
[time3,thisBlinkTW]=AP_PSTH(thisBlink,timeWindow,timeToZero,samplingRate);
%%%%% ADD CHECK ON TIME %%%%

% DPP
thisPupDPP=100*(thisPupSmoothTW-thisBaseline)/thisBaseline;
a=[];
% if Analysis.Parameters.ZeroAt
%     thisPupDPP=thisPupDPP-mean(thisPupDPP(thisTime>-0.01 & thisTime<0.01),'omitnan');
% end

%% Statistics for Analysis Structure
% if ~isfield(Analysis.AllData,'Pupil')
%     Analysis.AllData.Pupil.Time(1:thisTrial-1,:)        =NaN(thisTrial-1,length(thisTime));
%     Analysis.AllData.Pupil.Pupil(1:thisTrial-1,:)       =NaN(thisTrial-1,length(thisPupTW));
%     Analysis.AllData.Pupil.PupilDPP(1:thisTrial-1,:)    =NaN(thisTrial-1,length(thisPupDPP));
%     Analysis.AllData.Pupil.Blink(1:thisTrial-1,:)       =NaN(thisTrial-1,length(thisBlinkTW));
%     Analysis.AllData.Pupil.Baseline(1:thisTrial-1)      =NaN(1,thisTrial-1);
%     Analysis.AllData.Pupil.NormBaseline(1:thisTrial-1)  =NaN(1,thisTrial-1);
%     Analysis.AllData.Pupil.Cue(1:thisTrial-1)           =NaN(1,thisTrial-1);
%     Analysis.AllData.Pupil.Outcome(1:thisTrial-1)       =NaN(1,thisTrial-1);
%     Analysis.AllData.Time.Pupil                         =thisTime;
% end
Analysis.AllData.Pupil.Time(thisTrial,:)            =thisTime;
Analysis.AllData.Pupil.Pupil(thisTrial,:)           =thisPupTW;
Analysis.AllData.Pupil.PupilDPP(thisTrial,:)        =thisPupDPP;
Analysis.AllData.Pupil.Blink(thisTrial,:)           =thisBlinkTW;
Analysis.AllData.Pupil.Baseline(thisTrial)          =thisBaseline;
Analysis.AllData.Pupil.NormBaseline(thisTrial)      =thisBaseline;
Analysis.AllData.Pupil.Cue(thisTrial)               =nanmean(thisPupDPP(thisTime>cueTime(1) & thisTime<cueTime(2)));
Analysis.AllData.Pupil.Outcome(thisTrial)           =nanmean(thisPupDPP(thisTime>outcomeTime(1) & thisTime<outcomeTime(2)));

% else
%     if isfield(Analysis.AllData,'Pupil')
% Analysis.AllData.Pupil.Time(thisTrial,:)          	=NaN(1,size(Analysis.AllData.Pupil.Time,2));
% Analysis.AllData.Pupil.Pupil(thisTrial,:)          	=NaN(1,size(Analysis.AllData.Pupil.Pupil,2));
% Analysis.AllData.Pupil.PupilDPP(thisTrial,:)     	=NaN(1,size(Analysis.AllData.Pupil.PupilDPP,2));
% Analysis.AllData.Pupil.Blink(thisTrial,:)          	=NaN(1,size(Analysis.AllData.Pupil.Blink,2));
% Analysis.AllData.Pupil.Baseline(thisTrial)          =NaN;
% Analysis.AllData.Pupil.NormBaseline(thisTrial)      =NaN;
% Analysis.AllData.Pupil.Cue(thisTrial)               =NaN;
% Analysis.AllData.Pupil.Outcome(thisTrial)           =NaN;
%     end
% end
end