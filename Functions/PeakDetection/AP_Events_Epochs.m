function peakStats=AP_Events_Epochs(peakStats,time,epochTW,epochNames)
% transform points TS into time TS
% look for frequency and first peaks in baseline / cue / delay and outcome
% period

% test block
% peakStats=Analysis.AllData.Photo_470b_peak;
% time=Analysis.AllData.Photo_470b.Time;
% epochTW=[-4 -3; -1.5 -1; -1 0; -1.5 0; 0 2];
% epochNames={'Baseline','Cue','Delay','CueAndDelay','Outcome'};


%% Parameters and variable definition
nEpochs=size(epochTW,1);
nTrials=size(peakStats.peakAmp,2);
peakTS=nan(size(time));
peakProm=peakTS;
peakNb=peakTS;

%% From samples to time - idk if I want to save those ?
for t=1:nTrials
    thisPeakIdx=peakStats.peakIdx{1, t};
    peakTS(t,thisPeakIdx)       = time(t,thisPeakIdx);
    peakProm(t,thisPeakIdx)     = peakStats.peakProm{1,t};
    peakPromNorm(t,thisPeakIdx) = peakStats.peakPromNorm{1,t};
    peakNb(t,thisPeakIdx)       = 1:length(thisPeakIdx);
end
peakStats.peakTS=peakTS;
%% Epochs
thisTime=time(1,:);
for e=1:nEpochs
    thisEpochIdx=thisTime>=epochTW(e,1) & thisTime<=epochTW(e,2);
    thisPeakTS=peakTS(:,thisEpochIdx);
    thisPeakIdx=peakNb(:,thisEpochIdx);
    thisPeakProm=peakProm(:,thisEpochIdx);
    thisPeakPromNorm=peakPromNorm(:,thisEpochIdx);
    thisAUC=
    thisAUCNorm=
    thisFrequency=sum(~isnan(thisPeakTS),2)/diff(epochTW(e,:));
    thisReliability=sum(thisFrequency>0)/nTrials;

% first peak : jitter, prominences and waveforms
    for t=1:nTrials
        tempIdx=find(~isnan(thisPeakTS(t,:)));
        if ~isempty(tempIdx)
        thisJitter(t)=thisPeakTS(t,tempIdx(1))-epochTW(e,1);
        thisFirstProm(t)=thisPeakProm(t,tempIdx(1));
        thisFirstPromNorm(t)=thisPeakPromNorm(t,tempIdx(1));
        thisFirstAUC(t)=thisPeakProm(t,tempIdx(1));
        thisFirstAUCNorm(t)=thisPeakPromNorm(t,tempIdx(1));
        if isfield(peakStats,'waveforms')
            thisWV(t,:)=peakStats.waveforms{t}(thisPeakIdx(t,tempIdx(1)),:);
            thisWVNorm(t,:)=peakStats.waveformsNorm{t}(thisPeakIdx(t,tempIdx(1)),:);
        end
        else
            thisJitter(t)=diff(epochTW(e,:)) ; %epochTW(e,2)           
            thisFirstProm(t)=NaN;
            thisFirstPromNorm(t)=NaN;
        if isfield(peakStats,'waveforms')
            thisWV(t,:)=nan(size(peakStats.waveforms{1,1}(1,:)));
            thisWVNorm=thisWV(t,:);
        end
        end
    end
% save structure
    peakStats.(epochNames{e}).peakTS=thisPeakTS;
    peakStats.(epochNames{e}).peakProm=thisPeakProm;
    peakStats.(epochNames{e}).peakPromAVG=mean(thisPeakProm,'all','omitnan');
    peakStats.(epochNames{e}).peakPromNorm=thisPeakPromNorm;
    peakStats.(epochNames{e}).peakPromNormAVG=mean(thisPeakPromNorm,'all','omitnan');
    peakStats.(epochNames{e}).peakFreq=thisFrequency;
    peakStats.(epochNames{e}).peakFreqAVG=mean(thisFrequency,'omitnan');
    peakStats.(epochNames{e}).Reliability=thisReliability;
    peakStats.(epochNames{e}).firstJitter=thisJitter;
    peakStats.(epochNames{e}).firstProm=thisFirstProm;
    peakStats.(epochNames{e}).firstPromNorm=thisFirstPromNorm;
    if isfield(peakStats,'waveforms')
    peakStats.(epochNames{e}).firstWaveforms=thisWV;
    peakStats.(epochNames{e}).firstWaveformsAVG=mean(thisWV,1,'omitnan');
    peakStats.(epochNames{e}).firstWaveformsNorm=thisWVNorm;
    peakStats.(epochNames{e}).firstWaveformsAVGNorm=mean(thisWVNorm,1,'omitnan');
    end
end

end