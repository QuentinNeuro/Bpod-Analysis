function Analysis=AP_OptoPsycho_FiltersAndPlot(Analysis)
%% Initialization
successRate=[];
RT=[];
nbOfTrialTypes=Analysis.Parameters.nbOfTrialTypes;
%% Create filter
Analysis=A_FilterState(Analysis,'Outcome');
%% Generate filter data
for tt=1:nbOfTrialTypes;
    thistype=sprintf('type_%.0d',tt);
    thistype_Go=[thistype '_Go'];
    trialFilter=Analysis.Filters.(thistype);
    trialFilter_Go=trialFilter.*Analysis.Filters.Outcome;

    Analysis=AP_DataSort(Analysis,thistype_Go,trialFilter_Go);
    
    trialCount_All=Analysis.(thistype).nTrials;
    trialCount_Go=Analysis.(thistype_Go).nTrials;
    
    successRate(tt)=trialCount_Go/trialCount_All;
    thisRT=diff(Analysis.(thistype).Time.Cue,[],2);
    RT{tt}=thisRT;
    RT_AVG(tt)=mean(thisRT);
end

figure()
subplot(1,2,1)
plot([1:nbOfTrialTypes],successRate,'ok');
ylabel('SuccessRate'); xlabel('TrialType');
xlim([0 nbOfTrialTypes+0.5]); ylim([0 1]);
subplot(1,2,2)
plot([1:nbOfTrialTypes],RT_AVG,'ok');
ylabel('Reaction Time (s)');  xlabel('TrialType');
xlim([0 nbOfTrialTypes+0.5]); ylim([0 1]);

end