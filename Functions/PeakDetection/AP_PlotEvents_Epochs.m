% function AP_PlotEvents_Epochs(peakStats,time,data,fs,trialName,epochTW,epochNames)

% test block
data=Analysis.type_1.Photo_470.DFF;
time=Analysis.type_1.Photo_470.Time;
peakStats=Analysis.type_1.Photo_470_peak;
fs=Analysis.Parameters.NidaqDecimatedSR;
trialName='CuedReward';
epochTW=Analysis.Parameters.EventEpochTW;
epochNames=Analysis.Parameters.EventEpochNames;

%% Parameters
nTrials=size(data,1);
nEpochs=size(epochTW,1);
aTrial=randi(nTrials);
binSize=0.5;
%% Data preparation
% waveform
timeWF=(1:length(peakStats.(epochNames{1}).firstWaveformsAVG))/fs;
% trial for illustration
peakIdx =   peakStats.peakIdx{1,aTrial};
peakProm=   peakStats.peakProm{1,aTrial};
x=time(aTrial,:);
y=data(aTrial,:);
xPeaks      =   x(peakIdx);
yPeaks_max  =   y(peakIdx);
yPeaks_min  =   yPeaks_max-peakProm;
% histogram
allProm=[];
for t=1:size(peakStats.peakProm,2)
    allProm=[allProm peakStats.peakProm{1,t}];
end


%% Figure
xSP=5;
ySP=3;
figure()
subplot(ySP,xSP,[1:3]); hold on;
title([trialName sprintf('Trial %.0d',aTrial)])
xlabel('time from outcome (s)'); ylabel('fluorescence');
for e=1:nEpochs
    pHandle=plot(epochTW(e,:),[max(y) max(y)]+e*0.1);
    colorPlot(e,:)=pHandle.Color;
end

plot(x,y,'-k');
for p=1:length(xPeaks)
    plot([xPeaks(p) xPeaks(p)],[yPeaks_min(p) yPeaks_max(p)],'-b');
end
legend(epochNames);

%% Histogram
subplot(ySP,xSP,[4 5]); hold on;
hHandle=histogram(allProm,'Normalization','pdf');
hHandle.BinWidth=binSize;
hHandle.FaceColor=[0.6 0.6 0.6];

for e=1:nEpochs
    thisE=peakStats.(epochNames{e});
    subplot(ySP,xSP,[4 5])
    hHandle=histogram(thisE.firstProm,'Normalization','pdf');
    hHandle.BinWidth=binSize;
    hHandle.FaceColor=colorPlot(e,:);
    % Waveform first Peak
    subplot(ySP,xSP,6); hold on;
    plot(timeWF,thisE.firstWaveformsAVG);
    % cumulatives Prominence
    subplot(ySP,xSP,7); hold on;
    [x,y]=cumulative(thisE.firstProm);
    plot(x,y);
    nbOfPeaks{e}=sprintf('%.0d',sum(~isnan(x)));
    % jitter
    subplot(ySP,xSP,8); hold on;
    [x,y]=cumulative(thisE.firstJitter);
    plot(x,y);
    xlHandle=xline(diff(epochTW(e,:)),'--');
    xlHandle.Color=colorPlot(e,:);
    % data for barPlot
    HistoFreqY(e)=thisE.peakFreqAVG;
    HistoReliabilityY(e)=thisE.Reliability;

end

subplot(ySP,xSP,9);hold on;
bHandle=bar(1:nEpochs,HistoFreqY);
title('Frequency');
ylabel('Freq (Hz)');
xticks(1:nEpochs); xticklabels(epochNames); xtickangle(45);
bHandle.FaceColor='flat';
for e=1:nEpochs
    bHandle.CData(e,:)=colorPlot(e,:);
end

subplot(ySP,xSP,10);hold on;
title('Reliability');
ylabel('Reliability (%)');
bHandle=bar(1:nEpochs,HistoReliabilityY);
xticks(1:nEpochs); xticklabels(epochNames); xtickangle(45);
bHandle.FaceColor='flat';
for e=1:nEpochs
    bHandle.CData(e,:)=colorPlot(e,:);
end


%% Make it pretty
subplot(ySP,xSP,[4 5]); hold on;
xlabel('Peak Prominences');
subplot(ySP,xSP,6); 
title('Average transient');
ylabel('fluorescence'); xlabel('time (s)');
legend(nbOfPeaks);
subplot(ySP,xSP,7); 
title('Prominences');
ylabel('Cumul distribution'); xlabel('fluorescence');
subplot(ySP,xSP,8); 
title('Jitter');
ylabel('Cumul distribution'); xlabel('jitter (sec)');

% end