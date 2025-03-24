function AB_PlotData_Spikes_Tag(Analysis,cellNb,epochNb)
% epochNb=1;
% cellNb=8;

%% Parameters
cellID=Analysis.Parameters.Spikes.CellID{cellNb};
sampRate=Analysis.Parameters.Spikes.SamplingRate;
epochTime=Analysis.Parameters.Spikes.tagging_EpochTW(epochNb,:);
epochName=Analysis.Parameters.Spikes.tagging_EpochNames{epochNb};

%% Waveforms
% Waveforms
testwaveforms=0;
if isfield(Analysis.Core,'SpikesWV')
    testwaveforms=1;
% Averages
    wvTag=Analysis.Tagging.(cellID).(epochName).Waveforms_Stats;
    wvTagCorr=Analysis.Tagging.(cellID).(epochName).Waveforms_Corr;
    wvAll=Analysis.AllData.(cellID).Waveforms_Stats;
    wvTime=(1:size(wvAll.WaveformAVG,2))*1000/sampRate;
end

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
tadd=0;
for w=1:size(wvAll.WaveformAVG,1)
    thisTime=wvTime+tadd;
    shadedErrorBar(thisTime,wvAll.WaveformAVG(w,:),wvAll.WaveformSTD(w,:),'-k',0);
    shadedErrorBar(thisTime,wvTag.WaveformAVG(w,:),wvTag.WaveformSTD(w,:),'-b',0);
    if ~isnan(wvAll.peakX(w))
        plot(thisTime(wvAll.peakX(w)),wvAll.WaveformAVG(w,wvAll.peakX(w)),'xr')
        plot(thisTime(wvAll.troughX(w)),wvAll.WaveformAVG(w,wvAll.troughX(w)),'xr')
        plot(thisTime(wvAll.FWHMx(w,:)),[wvAll.FWHMy(w) wvAll.FWHMy(w)],'-r');
    end
    tadd=thisTime(end)+0.1*wvTime(end);
end
ylabel([min(min(wvAll.WaveformAVG))-10 max(max(wvAll.WaveformAVG))-10])
xlabel('time (ms)')
fwhm=1000*diff(wvAll.FWHMx(1,:))/Analysis.Parameters.Spikes.SamplingRate;
title(sprintf('Ch : %.0f - FWHM = %.1f ms - xtag = %.2f', Analysis.AllData.(cellID).LabelChannel, fwhm, wvTagCorr.Waveform_Corr));
end  

subplot(2,2,3); hold on;
ISI_HistoY=Analysis.AllData.AllCells.ISI_HistoY(cellNb,:);
ISI_HistoX=1000*Analysis.AllData.AllCells.ISI_HistoX;
rpViolation=Analysis.AllData.AllCells.RefractoryViolation(cellNb);
fr=Analysis.AllData.AllCells.FiringRate(cellNb);
rpTime=1000*Analysis.Parameters.Spikes.RefractoryPeriod;
plot(ISI_HistoX,ISI_HistoY,'-k');
xlim([0 50]);
thisYlim=get(gca,'YLim');
thisYlim=[0 ceil(thisYlim(2))];
plot([rpTime rpTime], thisYlim,'-r')
xlabel('ISI (ms)');
ylabel('Spike count');
title(sprintf('%s  - Firing Rate %.1f Hz - RP violation %.2f %: ',cellID, fr, rpViolation))

subplot(2,2,2); hold on;
plot(rasterTagTS,rasterTagTrial,'sk','MarkerSize',2,'MarkerFaceColor','k');
plot([0 0],[0 max(rasterTagTrial)],'-b');
plot(epochTime,[max(rasterTagTrial) max(rasterTagTrial)],'-r');
xlim([-0.02 0.1]);
ylabel('Trials')
title(tagLabel)

subplot(2,2,4)
shadedErrorBar(timeTag,dataTag_AVG,dataTag_SEM,'-k',0)
xlabel('time from stim (s)')
ylabel('firing rate (Hz)')
xlim([-0.02 0.1]);
title(sprintf('Latency %.1f ms',tagStats.Latency(2)))

end
