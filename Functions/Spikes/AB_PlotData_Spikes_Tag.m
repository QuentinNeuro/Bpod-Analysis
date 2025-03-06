function AB_PlotData_Spikes_Tag(Analysis,cellNb,epochNb)
% epochNb=1;
% cellNb=15;

%% Parameters
cellID=Analysis.Parameters.Spikes.CellID{cellNb};
refreactoryThreshold=2; % in ms
samplingRate=30000;
dataTS=Analysis.Core.SpikesTS{1,cellNb};
epochTime=Analysis.Parameters.Spikes.tagging_EpochTW(epochNb,:);
epochName=Analysis.Parameters.Spikes.tagging_EpochNames{epochNb};
%% Clustering info
clusterInfo=Analysis.Parameters.Spikes.clusterInfo;
clusteringLabel=Analysis.AllData.(cellID).LabelClustering;

%% Waveforms
testwaveforms=0;
if isfield(Analysis.Tagging.(cellID).(epochName),'Waveforms')
    testwaveforms=1;
wvTag=Analysis.Tagging.(cellID).(epochName).Waveforms;
wvAll=Analysis.Core.SpikesWV{cellNb};
% Averages
wvTag_AVG=mean(wvTag,2);
wvTag_SEM=std(wvTag,0,2)/sqrt(size(wvTag,2));
wvAll_AVG=mean(wvAll,2);
wvAll_SEM=std(wvAll,0,2)/sqrt(size(wvAll,2));
wvTime=(1:size(wvTag,1))*1000/samplingRate;
end
%% ISI
ISIs=diff(dataTS);
nISI=length(ISIs);
fr=1/mean(ISIs);
ISIms=1000*ISIs;
ISI_edges=0:0.2:max(50);
[ISI_histY,ISI_histX]=histcounts(ISIms,ISI_edges);
refractorySpikes=sum(find(ISIms<refreactoryThreshold))/length(ISIms);

%% Tagging
tagLabel=Analysis.AllData.(cellID).LabelTag;
tagStats=Analysis.Tagging.(cellID).(epochName).tagStats;
timeTag=Analysis.Tagging.(cellID).Time(1,:);
dataTag=Analysis.Tagging.(cellID).Data;
dataTag_AVG=mean(dataTag,1,'omitnan');
dataTag_SEM=std(dataTag,0,1)/sqrt(size(dataTag,1));

rasterTagTS=cell2mat(Analysis.Tagging.(cellID).SpikeTS');
rasterTagTrial=cell2mat(Analysis.Tagging.(cellID).TrialTS');

figure()
subplot(2,2,1); hold on;
if testwaveforms
shadedErrorBar(wvTime,wvAll_AVG,wvAll_SEM,'-k',1);
shadedErrorBar(wvTime,wvTag_AVG,wvTag_SEM,'-b',1);
end
xlabel('time (ms)')
title([cellID ' Clustering ' clusteringLabel])

subplot(2,2,3); hold on;
plot(ISI_histX(2:end),100*ISI_histY/nISI,'-k');
xlim([0 20]);
thisYlim=get(gca,'YLim');
thisYlim=[0 ceil(thisYlim(2))];
plot([refreactoryThreshold refreactoryThreshold], thisYlim,'-r')
xlabel('ISI (ms)');
ylabel('Spike count (%)');
title(sprintf('Firing Rate %.1f Hz',fr))

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
title(sprintf('Latency %.1f ms',tagStats.Latency(2)))

end
