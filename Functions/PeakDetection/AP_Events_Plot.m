% %% test block
% trialType='HVS_Reward';
% data=Analysis.(trialType).Photo_470.DFF;
% time=Analysis.(trialType).Photo_470.Time;
% peakStats=Analysis.(trialType).Photo_470_peak;
% trialName='CuedReward';
% AP_Events_Ploti(peakStats,time,data,trialName);
% 
% clear data time peakStats trialName;

function AP_Events_Ploti(peakStats,time,data,trialName)
%% Parameters
epochTW=peakStats.epochTW;
epochNames=peakStats.epochNames;
limTime=[-6 4];
nTrials=size(data,1);
trialNbs=unique(peakStats.trials);
nEpochs=size(epochTW,1);
binFreq=0.1;
binTW=min(time(1,:)):binFreq:max(time(1,:));
nbOfSession=max(peakStats.session);
% decide to show normalized data or not
if nbOfSession>1
    promStat='promNorm'; waveStat='waveformsNorm';
    AUCStat='AUCFWHMPromNorm';
    transTitle='normalized transients';
else
    promStat='prom'; waveStat='waveforms';
    AUCStat='AUCFWHMProm';
    transTitle='transients';
end
binSize=median(peakStats.(promStat))/5;

%% Data preparation
% trial for illustration
aTrial=randi(length(trialNbs));
% aTrial=10;
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
xlim(limTime);
legend(epochNames);
%% Raster
subplot(ySP,xSP,[5 6 9 10]); hold on;
x=peakStats.TS;
y=peakStats.trials;
plot(x,y,'sk','MarkerSize',2,'MarkerFaceColor','k');

for e=1:nEpochs
    thisEpochIdx=peakStats.(epochNames{e}).index;
    x=peakStats.TS(thisEpochIdx);
    y=peakStats.trials(thisEpochIdx);
    plot(x,y,'s','MarkerSize',2,'MarkerFaceColor',colorEpochs(e,:),'MarkerEdgeColor',colorEpochs(e,:));
end

for s=1:nbOfSession
    colorSession='rg';
    evenodd=(rem(s,2)==0)+1;
    y=peakStats.trials(peakStats.session==s);
    x=limTime(2)*ones(size(y));
    plot(x,y,'color',colorSession(evenodd))
end
ylabel('trials'); set(gca,'Ydir','reverse')
xlim(limTime);
%% 'Firing rate'
% subplot(ySP,xSP,[13 14]); hold on;
% x=binTW(2:end);
% y=histcounts(peakStats.TS,binTW)/nTrials;
% plot(x,y,'-k');
% for e=1:nEpochs
%     plot(epochTW(e,:),[max(y) max(y)],'color',colorEpochs(e,:));
% end
% ylabel('Event rate (Hz?)'); xlabel('Time from outcome (s)');
% xlim(limTime);
% yyaxis right
% y=mean(data,1,'omitnan');
% plot(xTime,y);
% ylabel('Fluorescence');

%% Histogram prominences
% subplot(ySP,xSP,[15 16]); hold on;
% hHandle=histogram(peakStats.(promStat),'Normalization','probability');
% hHandle.BinWidth=binSize;
% hHandle.FaceColor=[0.9 0.9 0.9];
% xlabel('Prominences'); ylabel('Count')

for e=1:nEpochs
    thisEStats=peakStats.(epochNames{e});
    thisEIdx=thisEStats.index;
    thisEFIdx=thisEStats.FirstIdx(~isnan(thisEStats.FirstIdx));
    nbForLegend{e}=sprintf('%.0d',sum(~isnan(thisEStats.FirstIdx)));
    % Waveform first Peak
    subplot(ySP,xSP,3); hold on;
    xlabel('Time (s)'); ylabel('Fluo');
    x=peakStats.waveformTW(:,1);
    y=mean(peakStats.(waveStat)(:,thisEFIdx),2,'omitnan');
    plot(x,y,'color',colorEpochs(e,:));
    % Latency
    subplot(ySP,xSP,4); hold on;
    xlabel('Latency (s)'); ylabel('CD')
    [x,y]=cumulative(thisEStats.Latency);
    plot(x,y,'color',colorEpochs(e,:));
    xlHandle=xline(diff(epochTW(e,:)),'--');
    xlHandle.Color=colorEpochs(e,:);
    % cumulatives Prominence
    subplot(ySP,xSP,7); hold on;
    xlabel('Prominences'); ylabel('CD');
    [x,y]=cumulative(peakStats.(promStat)(:,thisEFIdx));
    plot(x,y,'color',colorEpochs(e,:));
    xlim([0 10]);
    % cumulatives AUC
    subplot(ySP,xSP,8); hold on;
    xlabel('FWHM AUC'); ylabel('CD');
    [x,y]=cumulative(peakStats.(AUCStat)(:,thisEFIdx));
    plot(x,y,'color',colorEpochs(e,:));
    % data for barPlot
    nbOfPeaks{e}=sprintf('%.0d',sum(~isnan(x)));
    HistoFreqY(e)=thisEStats.Frequency;
    HistoReliabilityY(e)=thisEStats.Reliability;

    % subplot(ySP,xSP,[15 16]); hold on;
    % hHandle=histogram(peakStats.(promStat)(:,thisEFIdx),'Normalization','probability');
    % hHandle.BinWidth=binSize;
    % hHandle.FaceColor=colorEpochs(e,:);
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

subplot(ySP,xSP,3); hold on
title(transTitle);
legend(nbForLegend);
end
% 
% function [x,y]=cumulative(data)
%     datasize=length(data);
%     step=1/datasize;
%     x=sort(data);   
%     y=nan(datasize,1);
%     y(1)=step;
%     for i=2:datasize
%         y(i)=y(i-1)+step;
%     end
% end