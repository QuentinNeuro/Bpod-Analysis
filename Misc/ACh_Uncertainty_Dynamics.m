cueTypes={'CueA' 'CueB' 'CueC'};
rewTypes={'CueA_Rew' 'CueB_Rew' 'CueC_Rew'};

figure()
subplot(3,1,1); hold on;
ylabel('Cue Licks')
subplot(3,1,2); hold on;
ylabel('Cue fluo')
subplot(3,1,3); hold on;
ylabel('Rew fluo')
xlabel('trials')

for i=1:size(cueTypes,2)
    thisCueType=cueTypes{i};
    thisRewType=rewTypes{i};
    Cue_Trials{i}=Analysis.(thisCueType).TrialNumbers;
    Rew_Trials{i}=Analysis.(thisRewType).TrialNumbers;
	Cue_Licks{i}=Analysis.(thisCueType).Licks.Cue;
    Cue_FluoMAX{i}=Analysis.(thisCueType).Photo_470.CueMAX;
    Cue_FluoAVG{i}=Analysis.(thisCueType).Photo_470.CueAVG;
    Rew_FluoMAX{i}=Analysis.(thisRewType).Photo_470.OutcomeMAXZ;
    Rew_FluoAVG{i}=Analysis.(thisRewType).Photo_470.OutcomeAVGZ;
    
    subplot(3,1,1);
    plot(Cue_Trials{i},smooth(Cue_Licks{i}));
	subplot(3,1,2);
    plot(Cue_Trials{i},smooth(Cue_FluoAVG{i}));
	subplot(3,1,3);
    plot(Rew_Trials{i},smooth(Rew_FluoMAX{i}));
end

subplot(3,1,1); hold on;
legend({'75%' '50%' '25%'})
scatter(1:length(Analysis.AllData.Session),10*ones(1,length(Analysis.AllData.Session)),1,Analysis.AllData.Session)
