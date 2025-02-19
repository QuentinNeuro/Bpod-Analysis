function peakStats=AP_Events_Epochs(peakStats,epochTW,epochNames)

%% test block
% peakStats=Analysis.AllData.Photo_470_peak;
% epochTW=[-4 -3; -1.5 -1; -1 0; -1.5 0; 0 2];
% epochNames={'Baseline','Cue','Delay','CueAndDelay','Outcome'};

%% Parameters and variable definition
nEpochs=size(epochTW,1);
trialNb=unique(peakStats.trials);
nTrials=length(trialNb);
peakTS=peakStats.TS;
peakStats.epochNames=epochNames;
peakStats.epochTW=epochTW;
for e=1:nEpochs
    thisEIO=peakTS>=epochTW(e,1) & peakTS<=epochTW(e,2);
    peakStats.(epochNames{e}).index=thisEIO;
    thisLatency=[];
    thisFirstIdx=[];
   for t=1:nTrials
       thisTrialIO=peakStats.trials==trialNb(t);
       thisEpochTrialIO=and(thisEIO,thisTrialIO);
       if any(thisEpochTrialIO)
           thisFirstIdx(t)=find(thisEpochTrialIO,1,"first");
           thisLatency(t)=peakTS(thisFirstIdx(t))-epochTW(e,1);
       else
           thisFirstIdx(t)=NaN;
           thisLatency(t)=diff(epochTW(e,:));
       end
   end
   % Frequency
   peakStats.(epochNames{e}).Frequency=(sum(thisEIO)/nTrials)/diff(epochTW(e,:));
   % First Peak : Jitter / Reliability / Frequency
   peakStats.(epochNames{e}).FirstIdx=thisFirstIdx;
   peakStats.(epochNames{e}).Latency=thisLatency;
   peakStats.(epochNames{e}).Jitter=std(thisLatency);
   peakStats.(epochNames{e}).Reliability=sum(~isnan(thisFirstIdx))/nTrials;
end
end



