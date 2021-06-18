trialTypes={'CueA_Reward','CueB_Omission',...
        'Uncued_Reward','AnticipLick_CueA_Reward'};
nbOfTrials=[40 30 10 40];

for thisA=1:1
    for thisS=1:1
        for thisT=1:length(nbOfTrials)
            for i=1:3
            LicksC{thisA}(thisS,thisT)=Analysis.(trialTypes{thisT}).Licks.CueAVG;
            DFFC{thisA}(thisS,thisT)=Analysis.(trialTypes{thisT}.(thisPhoto)
            
            LicksO{thisA}(thisS,thisT)=Analysis.(trialTypes{thisT}).Licks.OutcomeAVG;
            DFFO{thisA}(thisS,thisT)
            end
        end
    end
end


