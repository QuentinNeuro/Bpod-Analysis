function Analysis=AP_DataProcess_Licks(Analysis,thisTrial,ZeroFirstLick)
% Realigns Licks and creates Lick-related statistics for 'thisTrial'
% Gets the Licks data from Analysis.Core
% ZeroFirstLick is a logical  to Align EVERYTHING on any first lick one second
% in the state used as a zero

%% Parameters and Data
timeToZero=Analysis.AllData.Time.Zero(thisTrial);
thisLicks=Analysis.Core.Licks{thisTrial}-timeToZero;
PSTH=Analysis.Parameters.Timing.PSTH;
binSize=Analysis.Parameters.Licks.BinSize;
binVector=PSTH(1):binSize:PSTH(2);
cueTimeReset=Analysis.Parameters.Timing.CueTimeLick;
if isempty(cueTimeReset)
    cueTimeReset=Analysis.Parameters.Timing.CueTimeReset;
end
outcomeTimeReset=Analysis.Parameters.Timing.OutcomeTimeReset;

%% ZeroFirstLick
newZero=0;
if ZeroFirstLick
    LicksDuringZeroState=thisLicks(thisLicks> 0 & thisLicks < 4);
    if ~isempty(LicksDuringZeroState)
        newZero=LicksDuringZeroState(1);
        thisLicks=thisLicks-newZero;
    else 
        Analysis.Filters.FirstLick(thisTrial)=false;
    end
end

% Modified Analysis.Time data according to the newZero
if newZero
    timeToZero=timeToZero+newZero;
    Analysis.AllData.Time.Zero(thisTrial)=timeToZero;
    Analysis.AllData.Time.Cue(thisTrial,:)=Analysis.AllData.Time.Cue(thisTrial,:)-newZero;
    Analysis.AllData.Time.Outcome(thisTrial,:)=Analysis.AllData.Time.Outcome(thisTrial,:)-newZero;
end

%% Statistics for Analysis Structure
CueTime=Analysis.AllData.Time.Cue(thisTrial,:)+cueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome(thisTrial,:)+outcomeTimeReset;
BaselineTime=[CueTime(1)-1.5 CueTime(1)-0.5];

Analysis.AllData.Licks.Events{thisTrial}    =thisLicks;
Analysis.AllData.Licks.Trials{thisTrial}    =linspace(thisTrial,thisTrial,size(thisLicks,2));
Analysis.AllData.Licks.Bin{thisTrial}       =binVector;
Analysis.AllData.Licks.Rate(thisTrial,:)    =histcounts(thisLicks,binVector/binSize);
Analysis.AllData.Licks.Baseline(thisTrial)  =mean(Analysis.AllData.Licks.Rate(thisTrial,binVector>BaselineTime(1) & binVector<BaselineTime(2)));
Analysis.AllData.Licks.Cue(thisTrial)       =mean(Analysis.AllData.Licks.Rate(thisTrial,binVector>CueTime(1) & binVector<CueTime(2)));
Analysis.AllData.Licks.Outcome(thisTrial)   =mean(Analysis.AllData.Licks.Rate(thisTrial,binVector>OutcomeTime(1) & binVector<OutcomeTime(2)));
end