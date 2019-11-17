trialnb=[2 10 15 20]; %[5 46 72 115];[5 23 46 75];
trialtype='type_1';%'AnticipLick_CueA_Reward'; %'Uncued_Reward'
nboftrials=length(trialnb);
DualCh=1;
counter=1;
LimY=[-2 2];
figure()
for i=trialnb  
    subplot(nboftrials,1,counter)
    title(sprintf('trial nb %.0d',i))
    plot(Analysis.(trialtype).Photo_470.Time(i,:),Analysis.(trialtype).Photo_470.DFF(i,:),'-k')
    hold on
    if DualCh
    plot(Analysis.(trialtype).Photo_470b.Time(i,:),Analysis.(trialtype).Photo_470b.DFF(i,:),'-b')
    end
    plot(Analysis.(trialtype).Time.Cue(i,:),[LimY(2) LimY(2)],'-r');
    xlim([-4 4]);
    ylim(LimY);
    counter=counter+1;
end

% findpeaks(Analysis.(trialtype).Photo_470.DFF(1,:))
