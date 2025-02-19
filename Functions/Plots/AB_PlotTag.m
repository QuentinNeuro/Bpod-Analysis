function AB_PlotTag(Analysis,cellNb,epochTime)
% cellNb=15;
% epochTime=Analysis.Parameters.Spikes.tagging_EpochTW(1,:);

%% Parameters
cellID=Analysis.Parameters.Spikes.CellID{cellNb};
refreactoryThreshold=2; % in ms
samplingRate=30000;

%% Clustering info
clusterInfo=Analysis.Parameters.Spikes.clusterInfo;
clusteringLabel=Analysis.AllData.(cellID).LabelClustering;

%% Waveforms
wvTag=Analysis.Tagging.(cellID).Early.Waveforms;
wvAll=Analysis.Core.SpikesWV{cellNb};
% Averages
wvTag_AVG=mean(wvTag,2);
wvTag_SEM=std(wvTag,0,2)/sqrt(size(wvTag,2));
wvAll_AVG=mean(wvAll,2);
wvAll_SEM=std(wvAll,0,2)/sqrt(size(wvAll,2));
wvTime=(1:size(wvTag,1))*1000/samplingRate;
%% ISI
ISI=1000*diff(Analysis.Core.SpikesTS{1,cellNb});
nISI=length(ISI);
ISIcount=(1:nISI)*100/nISI;
fr=1000/mean(ISI);
refractorySpikes=sum(ISI<refreactoryThreshold)/length(ISI);

%% Tagging
tagLabel=Analysis.AllData.(cellID).LabelTag;

timeTag=Analysis.Tagging.(cellID).Time(1,:);
dataTag=Analysis.Tagging.(cellID).Data;
dataTag_AVG=mean(dataTag,1,'omitnan');
dataTag_SEM=std(dataTag,0,1)/sqrt(size(dataTag,1));

rasterTagTS=cell2mat(Analysis.Tagging.(cellID).SpikeTS');
rasterTagTrial=cell2mat(Analysis.Tagging.(cellID).TrialTS');

figure()
subplot(2,2,1); hold on;
shadedErrorBar(wvTime,wvAll_AVG,wvAll_SEM,'-k',1);
shadedErrorBar(wvTime,wvTag_AVG,wvTag_SEM,'-b',1);
xlabel('time (ms)')
title([cellID ' Clustering ' clusteringLabel])

subplot(2,2,3); hold on;
plot(sort(ISI),ISIcount,'-k');
xlim([0 5]);
ISIThresholdY=get(gca,'YLim');
plot([refreactoryThreshold refreactoryThreshold], ISIThresholdY,'-r')
xlabel('ISI (ms)');
ylabel('Spike count (%)');
title(sprintf('Firing Rate %.1f',fr))

subplot(2,2,2); hold on;
plot(rasterTagTS,rasterTagTrial,'sk','MarkerSize',2,'MarkerFaceColor','k');
plot([0 0],[0 max(rasterTagTrial)],'-b');
plot(epochTime,[max(rasterTagTrial) max(rasterTagTrial)],'-r');
xlim([-0.02 0.1]);
ylabel('Trials')
title(tagLabel)

subplot(2,2,4)
shadedErrorBar(timeTag,dataTag_AVG,dataTag_SEM,'-k',1)
xlabel('time from stim (s)')
ylabel('firing rate (Hz)')
xlim([-0.02 0.1]);

end
