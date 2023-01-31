function AP_PlotEvents_Epochs(peakStats,time,data,fs,trialName,epochTW,epochNames)

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
binFreq=0.1;
binTW=min(time(aTrial,:)):binFreq:max(time(aTrial,:));
%% Data preparation
% waveform
timeWF=(1:length(peakStats.(epochNames{1}).firstWaveformsAVG))/fs;
% trial for illustration
peakIdx =   peakStats.peakIdx{1,aTrial};
peakProm=   peakStats.peakProm{1,aTrial};
xTime=time(aTrial,:);
y=data(aTrial,:);
xPeaks      =   xTime(peakIdx);
yPeaks_max  =   y(peakIdx);
yPeaks_min  =   yPeaks_max-peakProm;
% histogram
allProm=[];
for t=1:size(peakStats.peakProm,2)
    allProm=[allProm peakStats.peakProm{1,t}];
end


%% Figure
xSP=4;
ySP=4;
%% Average fluo trace
figure()
% subplot(ySP,xSP,[1:2]); hold on;
% title([trialName sprintf('Trial %.0d',aTrial)])
% xlabel('time from outcome (s)'); ylabel('fluorescence');
% for e=1:nEpochs
%     pHandle=plot(epochTW(e,:),[max(y) max(y)]+e*0.1);
%     colorPlot(e,:)=pHandle.Color;
% end
% plot(xTime,mean(data,1,'omitnan'),'-k');
% legend(epochNames);

%% example trace
subplot(ySP,xSP,[1:2]); hold on;
title([trialName sprintf('Trial %.0d',aTrial)])
ylabel('fluorescence');
for e=1:nEpochs
    pHandle=plot(epochTW(e,:),[max(y) max(y)]+e*0.1);
    colorEpochs(e,:)=pHandle.Color;
end
plot(xTime,y,'-k');
for p=1:length(xPeaks)
    plot([xPeaks(p) xPeaks(p)],[yPeaks_min(p) yPeaks_max(p)],'-b');
end
for p=1:length(xPeaks)
    plot([xPeaks(p) xPeaks(p)],[yPeaks_min(p) yPeaks_max(p)],'-b');
end

%% Raster
subplot(ySP,xSP,[5 6 9 10]); hold on;
thisTS=peakStats.peakTS;
x=thisTS(~isnan(thisTS));
y=nonzeros((1:nTrials)'.*(~isnan(thisTS)));
plot(x,y,'sk','MarkerSize',2,'MarkerFaceColor','k');

for e=1:nEpochs
    thisTS=peakStats.(epochNames{e}).peakTS;
    x=thisTS(~isnan(thisTS));
    y=nonzeros((1:nTrials)'.*(~isnan(thisTS)));
    plot(x,y,'s','MarkerSize',2,'MarkerFaceColor',colorEpochs(e,:));
end
ylabel('trials'); set(gca,'Ydir','reverse')
%% Frequency
thisTS=peakStats.peakTS;
x=binTW(2:end);
y=histcounts(thisTS(~isnan(thisTS)),binTW)/nTrials;

subplot(ySP,xSP,[13 14]); hold on;
plot(x,y,'-k');
for e=1:nEpochs
    plot(epochTW(e,:),[max(y) max(y)],'color',colorEpochs(e,:));
end
ylabel('Frequency (Hz?)'); xlabel('Time from outcome (s)');


%% Histogram
subplot(ySP,xSP,[15 16]); hold on;
hHandle=histogram(allProm);
hHandle.BinWidth=binSize;
hHandle.FaceColor=[0.6 0.6 0.6];
xlabel('Prominences'); ylabel('Count')

for e=1:nEpochs
    thisE=peakStats.(epochNames{e});
    % Waveform first Peak
    subplot(ySP,xSP,3); hold on;
    xlabel('Time (s)'); ylabel('Fluo');
    plot(timeWF,thisE.firstWaveformsAVG);
    % jitter
    subplot(ySP,xSP,4); hold on;
    xlabel('Jitter (s)'); ylabel('CD')
    [x,y]=cumulative(thisE.firstJitter);
    plot(x,y);
    xlHandle=xline(diff(epochTW(e,:)),'--');
    xlHandle.Color=colorEpochs(e,:);
    % cumulatives Prominence
    subplot(ySP,xSP,11); hold on;
    xlabel('norm Prominences'); ylabel('CD');
    [x,y]=cumulative(thisE.firstPromNorm);
    plot(x,y);
    % cumulatives AUC
    subplot(ySP,xSP,12); hold on;
    xlabel('norm AUC'); ylabel('CD');
    [x,y]=cumulative(thisE.AUCPromNorm);
    plot(x,y);
    % data for barPlot
    nbOfPeaks{e}=sprintf('%.0d',sum(~isnan(x)));
    HistoFreqY(e)=thisE.peakFreqAVG;
    HistoReliabilityY(e)=thisE.Reliability;

    subplot(ySP,xSP,[15 16])
    hHandle=histogram(thisE.firstProm,'Normalization','pdf');
    hHandle.BinWidth=binSize;
    hHandle.FaceColor=colorEpochs(e,:);

end

    subplot(ySP,xSP,[7 8])
    hHandle=histogram(thisE.firstProm);
    hHandle.BinWidth=binSize;
    hHandle.FaceColor=colorEpochs(e,:);
    xlabel('Prominences'); ylabel('Count')
% 
% subplot(ySP,xSP,9);hold on;
% bHandle=bar(1:nEpochs,HistoFreqY);
% title('Frequency');
% ylabel('Freq (Hz)');
% xticks(1:nEpochs); xticklabels(epochNames); xtickangle(45);
% bHandle.FaceColor='flat';
% for e=1:nEpochs
%     bHandle.CData(e,:)=colorPlot(e,:);
% end
% 
% subplot(ySP,xSP,10);hold on;
% title('Reliability');
% ylabel('Reliability (%)');
% bHandle=bar(1:nEpochs,HistoReliabilityY);
% xticks(1:nEpochs); xticklabels(epochNames); xtickangle(45);
% bHandle.FaceColor='flat';
% for e=1:nEpochs
%     bHandle.CData(e,:)=colorPlot(e,:);
% end
% 
% 
% %% Make it pretty
% subplot(ySP,xSP,[4 5]); hold on;
% xlabel('Peak Prominences');
% subplot(ySP,xSP,6); 
% title('Average transient');
% ylabel('fluorescence'); xlabel('time (s)');
% legend(nbOfPeaks);
% subplot(ySP,xSP,7); 
% title('Prominences');
% ylabel('Cumul distribution'); xlabel('fluorescence');
% subplot(ySP,xSP,8); 
% title('Jitter');
% ylabel('Cumul distribution'); xlabel('jitter (sec)');

% end