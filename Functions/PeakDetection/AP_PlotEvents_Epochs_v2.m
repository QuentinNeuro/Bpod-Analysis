% function AP_PlotEvents_Epochs(peakStats,time,data,fs,trialName,epochTW,epochNames)

% test block
data=Analysis.type_1.Photo_470.DFF;
time=Analysis.type_1.Photo_470.Time;
peakStats=Analysis.type_1.Photo_470_peak;
fs=Analysis.Parameters.NidaqDecimatedSR;
trialName='CuedReward';
epochTW=Analysis.Parameters.EventEpochTW;
epochNames=Analysis.Parameters.EventEpochNames;


%%
% fig_t=randi(nTrials);
% fig_tIdx=peakStats.trials==fig_t;
% % fig_t=78;
% fig_dy=data(fig_t,:);
% fig_dy=data(fig_t,:);
% fig_py=peakStats.amp(fig_tIdx);
% fig_px=peakStats.peakIdx(fig_tIdx);
% fig_my=peakStats.min(fig_tIdx);
% fig_mx=peakStats.minIdx(fig_tIdx);

%% Parameters
nTrials=size(data,1);
trialNbs=unique(peakStats.trials);
nEpochs=size(epochTW,1);
binSize=0.5;
binFreq=0.1;
binTW=min(time(1,:)):binFreq:max(time(1,:));

%% Data preparation
% trial for illustration
aTrial=randi(length(trialNbs));
aTrialIdx=trialNbs(aTrial);
aTrialIdx=peakStats.trials==aTrialIdx;
while ~aTrialIdx
    aTrial=randi(length(trialNbs));
    aTrialIdx=trialNbs(trialNbs);
    aTrialIdx=peakStats.trials==aTrialIdx;
end
peakIdx     =   peakStats.peakIdx(aTrialIdx);
peakTS      =   peakStats.TS(aTrialIdx);
peakProm    =   peakStats.prom(aTrialIdx);
xTime=time(aTrial,:);
y=data(aTrial,:);
xPeaks      =   peakTS;
yPeaks_max  =   y(peakIdx);
yPeaks_min  =   yPeaks_max-peakProm;
% waveform
timeWF=(1:size(peakStats.waveforms,1))/fs;

%% Figure
xSP=4;
ySP=4;
%% Average fluo trace
figure()
%% example trace
subplot(ySP,xSP,1:2); hold on;
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
x=peakStats.TS;
y=peakStats.trials;
plot(x,y,'sk','MarkerSize',2,'MarkerFaceColor','k');

for e=1:nEpochs
    thisEpochIdx=peakStats.(epochNames{e}).index;
    x=peakStats.TS(thisEpochIdx);
    y=peakStats.trials(thisEpochIdx);
    plot(x,y,'s','MarkerSize',2,'MarkerFaceColor',colorEpochs(e,:));
end
ylabel('trials'); set(gca,'Ydir','reverse')

%% Frequency
x=binTW(2:end);
y=histcounts(peakStats.TS,binTW)/nTrials;

subplot(ySP,xSP,[13 14]); hold on;
plot(x,y,'-k');
for e=1:nEpochs
    plot(epochTW(e,:),[max(y) max(y)],'color',colorEpochs(e,:));
end
ylabel('Frequency (Hz?)'); xlabel('Time from outcome (s)');


%% Histogram
subplot(ySP,xSP,[15 16]); hold on;
hHandle=histogram(peakStats.promNorm);
hHandle.BinWidth=binSize;
hHandle.FaceColor=[0.6 0.6 0.6];
xlabel('Prominences'); ylabel('Count')

for e=1:nEpochs
    thisEStats=peakStats.(epochNames{e});
    thisEIdx=thisEStats.index;
    thisEFIdx=thisEStats.FirstIdx(~isnan(thisEStats.FirstIdx));
    % Waveform first Peak
    subplot(ySP,xSP,3); hold on;
    xlabel('Time (s)'); ylabel('Fluo');
    y=mean(peakStats.waveformsNorm(:,thisEFIdx),2,'omitnan');
    plot(timeWF,y,'color',colorEpochs(e,:));
    % jitter
    subplot(ySP,xSP,4); hold on;
    xlabel('Jitter (s)'); ylabel('CD')
    [x,y]=cumulative(thisEStats.Jitter);
    plot(x,y,'color',colorEpochs(e,:));
    xlHandle=xline(diff(epochTW(e,:)),'--');
    xlHandle.Color=colorEpochs(e,:);
    % cumulatives Prominence
    subplot(ySP,xSP,7); hold on;
    xlabel('norm Prominences'); ylabel('CD');
    [x,y]=cumulative(peakStats.promNorm(:,thisEFIdx));
    plot(x,y,'color',colorEpochs(e,:));
    % cumulatives AUC
    subplot(ySP,xSP,8); hold on;
    xlabel('norm AUC'); ylabel('CD');
    [x,y]=cumulative(peakStats.AUCFWHMPromNorm(:,thisEFIdx));
    plot(x,y,'color',colorEpochs(e,:));
    % data for barPlot
    nbOfPeaks{e}=sprintf('%.0d',sum(~isnan(x)));
    HistoFreqY(e)=thisEStats.Frequency;
    HistoReliabilityY(e)=thisEStats.Reliability;

    subplot(ySP,xSP,[15 16]); hold on;
    hHandle=histogram(peakStats.promNorm(:,thisEFIdx),'Normalization','pdf');
    hHandle.BinWidth=binSize;
    hHandle.FaceColor=colorEpochs(e,:);

end

subplot(ySP,xSP,11);hold on;
bHandle=bar(1:nEpochs,HistoFreqY);
title('Frequency');
ylabel('Freq (Hz)');
xticks(1:nEpochs); xticklabels(epochNames); xtickangle(45);
bHandle.FaceColor='flat';
for e=1:nEpochs
    bHandle.CData(e,:)=colorEpochs(e,:);
end

subplot(ySP,xSP,12);hold on;
title('Reliability');
ylabel('Reliability (%)');
bHandle=bar(1:nEpochs,HistoReliabilityY);
xticks(1:nEpochs); xticklabels(epochNames); xtickangle(45);
bHandle.FaceColor='flat';
for e=1:nEpochs
    bHandle.CData(e,:)=colorEpochs(e,:);
end


%     subplot(ySP,xSP,[7 8])
%     hHandle=histogram(thisE.firstProm);
%     hHandle.BinWidth=binSize;
%     hHandle.FaceColor=colorEpochs(e,:);
%     xlabel('Prominences'); ylabel('Count')
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