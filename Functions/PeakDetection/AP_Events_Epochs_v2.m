function peakStats=AP_Events_Epochs_v2(peakStats,epochTW,epochNames)

% test block
% peakStats=Analysis.AllData.Photo_470b_peak;
% epochTW=[-4 -3; -1.5 -1; -1 0; -1.5 0; 0 2];
% epochNames={'Baseline','Cue','Delay','CueAndDelay','Outcome'};

%% Parameters and variable definition
nEpochs=size(epochTW,1);
nTrials=max(peakStats.trials);
peakTS=peakStats.TS;

for e=1:nEpochs
    thisEIO=peakTS>=epochTW(e,1) & peakTS<=epochTW(e,2);
    peakStats.(epochNames{e}).index=thisEIO;
   for t=1:nTrials
       thisTrialIO=peakStats.trials==t;
       thisEpochTrialIO=and(thisEIO,thisTrialIO);
       if any(thisEpochTrialIO)
           thisFirstIdx(t)=find(thisTrialIO,1,"first");
       else
           thisFirstIdx(t)=NaN;
       end
   end
   peakStats.(epochNames{e}).First=thisFirstIdx;
end
end



