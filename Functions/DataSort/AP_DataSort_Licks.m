function Analysis=AP_DataSort_Licks(Analysis,thistype)
%% Parameters
PSTH=Analysis.Parameters.Timing.PSTH;
binSize=Analysis.Parameters.Licks.BinSize;
binVector=PSTH(1):binSize:PSTH(2);
idxSession=Analysis.(thistype).Session;
%% Data
    thisEvents=Analysis.(thistype).Licks.Events;
    for i=1:length(thisEvents)
        thisTrials{1,i}=i*ones(length(thisEvents{1,i}),1)';
    end
    Analysis.(thistype).Licks.Events=cell2mat(thisEvents);
    Analysis.(thistype).Licks.Trials=cell2mat(thisTrials);
% Average
    Analysis.(thistype).Licks.DataAVG                   =mean(Analysis.(thistype).Licks.Data,1);
    Analysis.(thistype).Licks.DataSEM                   =std(Analysis.(thistype).Licks.Data,0,1)/sqrt(Analysis.(thistype).nTrials);
    Analysis.(thistype).Licks.CueAVG                    =mean(Analysis.(thistype).Licks.Cue);
    Analysis.(thistype).Licks.OutcomeAVG                =mean(Analysis.(thistype).Licks.Outcome);
    if length(idxSession)>1
    for thisS=1:max(idxSession)
        Analysis.(thistype).Licks.CueAVG_S(thisS)=mean(Analysis.(thistype).Licks.Cue(idxSession==thisS),2,'omitnan');
        Analysis.(thistype).Licks.OutcomeAVG_S(thisS)=mean(Analysis.(thistype).Licks.Outcome(idxSession==thisS),2,'omitnan');
    end
    else
        Analysis.(thistype).Licks.CueAVG_S=Analysis.(thistype).Licks.Cue;
        Analysis.(thistype).Licks.OutcomeAVG_S=Analysis.(thistype).Licks.Outcome;
    end

end