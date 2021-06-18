function Analysis=AP_DataProcess_Licks(Analysis,thisTrial,ZeroFirstLick)
% Realigns Licks and creates Lick-related statistics for 'thisTrial'
% Gets the Licks data from Analysis.Core
% ZeroFirstLick is a logical  to Align EVERYTHING on any first lick one second
% in the state used as a zero

%% Parameters and Data
TimeToZero=Analysis.AllData.Time.Zero(thisTrial);
thisLicks=Analysis.Core.Licks{thisTrial}-TimeToZero;

%% ZeroFirstLick
newZero=0;
if ZeroFirstLick
    LicksDuringZeroState=thisLicks(thisLicks> 0 & thisLicks < 1);
    if ~isempty(LicksDuringZeroState)
        newZero=LicksDuringZeroState(1);
        thisLicks=thisLicks-newZero;
    else 
        Analysis.Filters.FirstLick(thisTrial)=false;
    end
end

% Modified Analysis.Time data according to the newZero
if newZero
    TimeToZero=TimeToZero+newZero;
    Analysis.AllData.Time.Zero(thisTrial)=TimeToZero;
    Analysis.AllData.Time.Cue(thisTrial,:)=Analysis.AllData.Time.Cue(thisTrial,:)-newZero;
    Analysis.AllData.Time.Outcome(thisTrial,:)=Analysis.AllData.Time.Outcome(thisTrial,:)-newZero;
end

%% Statistics for Analysis Structure
CueTime=Analysis.AllData.Time.Cue(thisTrial,:)+Analysis.Parameters.CueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome(thisTrial,:)+Analysis.Parameters.OutcomeTimeReset;
BaselineTime=[CueTime(1)-1.5 CueTime(1)-0.5];

Analysis.AllData.Licks.Events{thisTrial}    =thisLicks;
Analysis.AllData.Licks.Trials{thisTrial}    =linspace(thisTrial,thisTrial,size(thisLicks,2));
Analysis.AllData.Licks.Bin{thisTrial}       =(Analysis.Parameters.ReshapedTime(1):Analysis.Parameters.Bin:Analysis.Parameters.ReshapedTime(2));
Analysis.AllData.Licks.Rate(thisTrial,:)    =histcounts(thisLicks,Analysis.AllData.Licks.Bin{thisTrial})/Analysis.Parameters.Bin;
Analysis.AllData.Licks.Baseline(thisTrial)  =mean(Analysis.AllData.Licks.Rate(thisTrial,Analysis.AllData.Licks.Bin{thisTrial}>BaselineTime(1) & Analysis.AllData.Licks.Bin{thisTrial}<BaselineTime(2)));
Analysis.AllData.Licks.Cue(thisTrial)       =mean(Analysis.AllData.Licks.Rate(thisTrial,Analysis.AllData.Licks.Bin{thisTrial}>CueTime(1) & Analysis.AllData.Licks.Bin{thisTrial}<CueTime(2)));
Analysis.AllData.Licks.Outcome(thisTrial)   =mean(Analysis.AllData.Licks.Rate(thisTrial,Analysis.AllData.Licks.Bin{thisTrial}>OutcomeTime(1) & Analysis.AllData.Licks.Bin{thisTrial}<OutcomeTime(2)));
end