%% test block
Group_Plot=AB_CuedOutcome_FilterGroups(Analysis);
thisGroup=Group_Plot{1, 2};

% for thisCh=1
    thisChData='Photo_470';
    thisChStats='Photo_470_peak';
for g=1:size(thisGroup,1)
    thisType{g}=thisGroup{g};
    time{g}=Analysis.(thisType{g}).(thisChData).Time;
    data{g}=Analysis.(thisType{g}).(thisChData).DFF;
    groupStats{g}=Analysis.(thisType{g}).(thisChStats)
end
    AB_Events_GroupPloti(groupStats,time,data,thisType);
% end

clear data time peakStats groupStats thisType Group_Plot thisGroup;

function AB_Events_GroupPloti(groupStats,time,data,typeNames)
%% Parameters
colorGroup=[1 0 0; 0 1 0; 0 0 1; 1 0 1; 0 1 1];
epochTW=groupStats{1}.epochTW;
epochNames=groupStats{1}.epochNames;
nbOfTypes=size(data,2);
nEpochs=size(epochTW,1);
nbOfSession=max(groupStats{1}.session);
for g=1:nbOfTypes
    nTrials(g+1)=size(data{g},1);
end

normData=1;
limTime=[-4 4];
binSize=0.5;
binFreq=0.1;
binTW=min(time{g}(1,:)):binFreq:max(time{g}(1,:));

% decide to show normalized data or not
if normData
    promStat='promNorm'; waveStat='waveformsNorm';
    AUCStat='AUCFWHMPromNorm';
    transTitle='normalized transients';
else
    promStat='prom'; waveStat='waveforms';
    AUCStat='AUCFWHMProm';
    transTitle='transients';
end

%% Figure
ySP=5;
xSP=2+nEpochs;
rasterSP=[1+2*xSP 2+2*xSP 1+3*xSP 2+3*xSP 1+4*xSP 2+4*xSP];
freqSP=[1 2 1+xSP 2+xSP];
%% Average fluo trace
figure()
%% Raster
subplot(ySP,xSP,rasterSP); hold on;
for e=1:nEpochs
    pHandle=plot(epochTW(e,:),[0 0]+e*0.1);
    colorEpochs(e,:)=pHandle.Color;
end
for g=1:nbOfTypes
    % ALL EVENTS
    x=groupStats{g}.TS;
    y=groupStats{g}.trials+sum(nTrials(1:g));
    plot(x,y,'sk','MarkerSize',2,'MarkerFaceColor','k');
    % EPOCH EVENTS
    for e=1:nEpochs
        thisEpochIdx=groupStats{g}.(epochNames{e}).index;
        x=groupStats{g}.TS(thisEpochIdx);
        y=groupStats{g}.trials(thisEpochIdx)+sum(nTrials(1:g));
        plot(x,y,'s','MarkerSize',2,'MarkerFaceColor',colorEpochs(e,:),'MarkerEdgeColor',colorEpochs(e,:));
    end
    % COLORS SESSION AND TYPES 
    for s=1:nbOfSession
        colorSession=[colorGroup(g,:) ; colorGroup(g,:)*0.5];
        evenodd=(rem(s,2)==0)+1;
        y=groupStats{g}.trials(groupStats{g}.session==s)+sum(nTrials(1:g));
        x=limTime(2)*ones(size(y));
        plot(x,y,'color',colorSession(evenodd,:))
    end

end

ylabel('trials'); set(gca,'Ydir','reverse')
xlim(limTime);

%% 'Firing rate'
subplot(ySP,xSP,freqSP); hold on;
x=binTW(2:end);
for g=1:nbOfTypes
    y=histcounts(groupStats{g}.TS,binTW)/nTrials(g+1);
    plot(x,y,'color',colorGroup(g,:)*0.8);
end
for e=1:nEpochs
    plot(epochTW(e,:),[0.01 0.01],'color',colorEpochs(e,:));
end
ylabel('Event rate (Hz?)'); xlabel('Time from outcome (s)');
xlim(limTime); legend(typeNames)

%% Average data
for g=1:nbOfTypes
    for e=1:nEpochs
        thisEStats=groupStats{g}.(epochNames{e});
        thisEIdx=thisEStats.index;
        thisEFIdx=thisEStats.FirstIdx(~isnan(thisEStats.FirstIdx));
% waveform
        subplot(ySP,xSP,2+e); hold on
        title(epochNames{e});
        xlabel('time (s)'); ylabel('norm transient fluo');
        x=groupStats{g}.waveformTW(:,1);
        y=mean(groupStats{g}.waveformsNorm(:,thisEFIdx),2,'omitnan');
        plot(x,y,'color',colorGroup(g,:)*0.8);
        ylim([0 2]);
% Prominences
        subplot(ySP,xSP,xSP+2+e); hold on;
        xlabel('norm. prominences'); ylabel('CD');
        [x,y]=cumulative(groupStats{g}.promNorm(:,thisEFIdx));
        plot(x,y,'color',colorGroup(g,:)*0.8);
% jitter
        subplot(ySP,xSP,2*xSP+2+e); hold on;
        xlabel('Jitter (s)'); ylabel('CD')
        [x,y]=cumulative(thisEStats.Jitter);
        plot(x,y,'color',colorGroup(g,:)*0.8);
        
        HistoFreqY(g,e)=thisEStats.Frequency;
        HistoReliabilityY(g,e)=thisEStats.Reliability;        
    end
end

for e=1:nEpochs
    subplot(ySP,xSP,3*xSP+2+e);hold on;
    bHandle=bar(1:nbOfTypes,HistoFreqY(:,e));
    ylabel('Freq (Hz)');
    xticks(1:nbOfTypes); xticklabels(typeNames); xtickangle(45);
    bHandle.FaceColor='flat';
    for g=1:nbOfTypes
        bHandle.CData(g,:)=colorGroup(g,:)*0.8;
    end
    
    subplot(ySP,xSP,4*xSP+2+e);hold on;
    ylabel('Reliability (%)');
    bHandle=bar(1:nbOfTypes,HistoReliabilityY(:,e));
    xticks(1:nbOfTypes); xticklabels(typeNames); xtickangle(45);
    bHandle.FaceColor='flat';
    for g=1:nbOfTypes
        bHandle.CData(g,:)=colorGroup(g,:)*0.8;
    end
end


% %% Histogram prominences
% subplot(ySP,xSP,[15 16]); hold on;
% hHandle=histogram(peakStats.(promStat),'Normalization','probability');
% hHandle.BinWidth=binSize;
% hHandle.FaceColor=[0.9 0.9 0.9];
% xlabel('Prominences'); ylabel('Count')
% 
% for e=1:nEpochs
%     thisEStats=peakStats.(epochNames{e});
%     thisEIdx=thisEStats.index;
%     thisEFIdx=thisEStats.FirstIdx(~isnan(thisEStats.FirstIdx));
%     nbForLegend{e}=sprintf('%.0d',sum(~isnan(thisEStats.FirstIdx)));
%     % Waveform first Peak
%     subplot(ySP,xSP,3); hold on;
%     xlabel('Time (s)'); ylabel('Fluo');
%     x=peakStats.waveformTW(:,1);
%     y=mean(peakStats.(waveStat)(:,thisEFIdx),2,'omitnan');
%     plot(x,y,'color',colorEpochs(e,:));
%     % jitter
%     subplot(ySP,xSP,4); hold on;
%     xlabel('Jitter (s)'); ylabel('CD')
%     [x,y]=cumulative(thisEStats.Jitter);
%     plot(x,y,'color',colorEpochs(e,:));
%     xlHandle=xline(diff(epochTW(e,:)),'--');
%     xlHandle.Color=colorEpochs(e,:);
%     % cumulatives Prominence
%     subplot(ySP,xSP,7); hold on;
%     xlabel('Prominences'); ylabel('CD');
%     [x,y]=cumulative(peakStats.(promStat)(:,thisEFIdx));
%     plot(x,y,'color',colorEpochs(e,:));
%     % cumulatives AUC
%     subplot(ySP,xSP,8); hold on;
%     xlabel('FWHM AUC'); ylabel('CD');
%     [x,y]=cumulative(peakStats.(AUCStat)(:,thisEFIdx));
%     plot(x,y,'color',colorEpochs(e,:));
%     % data for barPlot
%     nbOfPeaks{e}=sprintf('%.0d',sum(~isnan(x)));
%     HistoFreqY(e)=thisEStats.Frequency;
%     HistoReliabilityY(e)=thisEStats.Reliability;
% 
%     subplot(ySP,xSP,[15 16]); hold on;
%     hHandle=histogram(peakStats.prom(:,thisEFIdx),'Normalization','probability');
%     hHandle.BinWidth=binSize;
%     hHandle.FaceColor=colorEpochs(e,:);
% end
% 
% subplot(ySP,xSP,11);hold on;
% bHandle=bar(1:nEpochs,HistoFreqY);
% title('Frequency');
% ylabel('Freq (Hz)');
% xticks(1:nEpochs); xticklabels(epochNames); xtickangle(45);
% bHandle.FaceColor='flat';
% for e=1:nEpochs
%     bHandle.CData(e,:)=colorEpochs(e,:);
% end
% 
% subplot(ySP,xSP,12);hold on;
% title('Reliability');
% ylabel('Reliability (%)');
% bHandle=bar(1:nEpochs,HistoReliabilityY);
% xticks(1:nEpochs); xticklabels(epochNames); xtickangle(45);
% bHandle.FaceColor='flat';
% for e=1:nEpochs
%     bHandle.CData(e,:)=colorEpochs(e,:);
% end
% 
% subplot(ySP,xSP,3); hold on
% title(transTitle);
% legend(nbForLegend);
end