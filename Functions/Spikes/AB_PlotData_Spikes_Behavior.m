function Analysis=AB_PlotData_Spikes_Behavior(Analysis,cellID,groupTypes)

%% Cell ID
thisID=Analysis.AllData.AllCells.CellName{cellID};
testTag=Analysis.Parameters.Spikes.Tag;
thisLabelTag=Analysis.AllData.(thisID).LabelTag;
thisLabelCluster=Analysis.AllData.(thisID).LabelClustering;

%% Parameters
% Plot
nbOfGroups=size(groupTypes,1);
if nbOfGroups>3
nbOfGroups=3;
disp('Figure for spike data will only show the first 3 behavior group')
disp('Check AP_PlotData_Spikes for info')
end
transparency=Analysis.Parameters.Plot.Transparency;
colorplot='bgry';

%% Parameters
% Subplot All Spikes
xLabelAll='Time Session (s)';
xTimeAll=[Analysis.Core.SpikesBehTS(1) Analysis.Core.SpikesBehTS(end)];
yLabelSpikeAll='Spikes';
ySpikeAll=[-0.1 0.1];
% Subplot Tagging Raster
xLabelTag='Time from Laser (s)';
xTimeTag=Analysis.Parameters.Spikes.tagging_TW;
xTimeTag=[-0.1 0.2];
% Subplot Licks
yLabelLicks='Licks (Hz)';
yLicks=[0 10];
% Subplot Spikes Rate
yLabelSpikeRate='Spikes (Hz)';
ySpikeRate=[0 10];
% Subplot Behavior Raster
yLabelSpikeRaster='Trials';
xLabelBehav='Time (s)';
xTimeBehah=Analysis.Parameters.Plot.xTime;

%% Data
% Waveforms
testwaveforms=0;
if isfield(Analysis.Core,'SpikesWV')
    testwaveforms=1;
% Averages
    wvTag=Analysis.Tagging.(thisID).Early.Waveforms_Stats;
    wvTagCorr=Analysis.Tagging.(thisID).Early.Waveforms_Corr;
    wvAll=Analysis.AllData.(thisID).Waveforms_Stats;
    wvTime=(1:size(wvAll.WaveformAVG,2))*1000/Analysis.Parameters.Spikes.SamplingRate;
end

%% Figure
scrsz = get(groot,'ScreenSize');
FigureLegend=sprintf('%s_%s',Analysis.Parameters.Name,Analysis.Parameters.Rig);

figure('Name','Figure TT','Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

%% Waveform
if testwaveforms
subplot(6,3,1); hold on;
tadd=0;
for w=1:size(wvAll.WaveformAVG,1)
    thisTime=wvTime+tadd;
    shadedErrorBar(thisTime,wvAll.WaveformAVG(w,:),wvAll.WaveformSTD(w,:),'-k',1);
    shadedErrorBar(thisTime,wvTag.WaveformAVG(w,:),wvTag.WaveformSTD(w,:),'-b',1);
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
title(sprintf('Ch : %.0f - FWHM = %.1f ms - xtag = %.2f', Analysis.AllData.(thisID).LabelChannel, fwhm, wvTagCorr.Waveform_Corr));
end    
%% TT Timing
subplot(6,3,2); hold on;
ISI_HistoY=Analysis.AllData.AllCells.ISI_HistoY(cellID,:);
ISI_HistoX=1000*Analysis.AllData.AllCells.ISI_HistoX;
rpViolation=Analysis.AllData.AllCells.RefractoryViolation(cellID);
fr=Analysis.AllData.(thisID).BaselineAVG;
rpTime=1000*Analysis.Parameters.Spikes.RefractoryPeriod;

plot(ISI_HistoX,ISI_HistoY,'-k');
xlim([0 50]);
thisYlim=get(gca,'YLim');
thisYlim=[0 ceil(thisYlim(2))];
plot([rpTime rpTime], thisYlim,'-r')
xlabel('ISI (ms)');
ylabel('Spike count');
title(sprintf('%s  - Firing Rate %.1f Hz - RP violation %.2f %: ',thisID, fr, rpViolation))
% set(gca,'XLim',xTimeAll,'YLim',ySpikeAll);
% ylabel(yLabelSpikeAll);
% xlabel(xLabelAll);
% title([thisC_Name ' ' thisLabelCluster]);

%% PhotoTagging
if testTag
    % Data
raster_Spikes=cell2mat(Analysis.Tagging.(thisID).SpikeTS');
raster_Trials=cell2mat(Analysis.Tagging.(thisID).TrialTS');
    % Plot
subplot(6,3,3); hold on;
title(['PhotoTagging ' thisLabelTag]);
plot(raster_Spikes,raster_Trials,'sk','MarkerSize',2,'MarkerFaceColor','k');
set(gca,'XLim',xTimeTag,'YDir','reverse');
xlabel(xLabelTag);
% To do  : add line for different tagging protocol
end

%% Behavior
countSP=0;
for g=1:nbOfGroups
    groupName=groupTypes{g,1};
    thisGroupTypes=groupTypes{g,2};
    nbOfTypes=size(thisGroupTypes,2);
    countRaster=0;
    for t=1:nbOfTypes
        subplot(5,3,4+countSP); hold on;
        plot(-10,-10,colorplot(t))
    end
    for t=1:nbOfTypes
        thisType=thisGroupTypes{1,t}; 
        if Analysis.(thisType).nTrials>0
        %% Data
        % Timing
        cueTime=Analysis.(thisType).Time.Cue;
        outcomeTime=Analysis.(thisType).Time.Outcome;
        % Licks
        licksAVG=Analysis.(thisType).Licks.DataAVG;
        licksSEM=Analysis.(thisType).Licks.DataSEM;
        licksBin=Analysis.(thisType).Licks.Time(1,:);
        % spikes
        spikesAVG=Analysis.(thisType).(thisID).DataAVG;
        spikesSEM=Analysis.(thisType).(thisID).DataSEM;
        spikesBin=Analysis.(thisType).(thisID).Time(1,:);
        raster_Spikes=cell2mat(Analysis.(thisType).(thisID).SpikeTS);
        raster_Trials=cell2mat(Analysis.(thisType).(thisID).TrialTS);
        if isempty(raster_Trials)
            countRasterAdd=0;
        else
            countRasterAdd=raster_Trials(end);
        end
        %% Plot
        subplot(5,3,4+countSP); hold on;
        shadedErrorBar(licksBin,licksAVG,licksSEM,colorplot(t),transparency);
        subplot(5,3,7+countSP); hold on;
        shadedErrorBar(spikesBin,spikesAVG,spikesSEM,colorplot(t),transparency);
        subplot(5,3,[10 13]+countSP); hold on;
        plot(raster_Spikes,raster_Trials+countRaster,'sk','MarkerSize',2,'MarkerFaceColor','k');
        plot([xTimeBehah(2) xTimeBehah(2)],[countRaster countRaster+countRasterAdd],['-' colorplot(t)],'LineWidth',2);

        countRaster=countRaster+countRasterAdd+10;
        end
    end
    % Make plot pretty
        subplot(5,3,4+countSP)
        title(groupName)
        plot([cueTime(1,1) cueTime(1,2)],[yLicks(2) yLicks(2)],'-b','LineWidth',2);
        plot([outcomeTime(1,1) outcomeTime(1,1)],yLicks,'-r','LineWidth',2);
        set(gca,'XLim',xTimeBehah,'YLim',yLicks);
        ylabel(yLabelLicks);
        legend(thisGroupTypes{1,:})
        subplot(5,3,7+countSP); hold on;
        plot([cueTime(1,1) cueTime(1,2)],[ySpikeRate(2) ySpikeRate(2)],'-b','LineWidth',2);
        plot([outcomeTime(1,1) outcomeTime(1,1)],ySpikeRate,'-r','LineWidth',2);
        set(gca,'XLim',xTimeBehah);
        ylabel(yLabelSpikeRate);
        subplot(5,3,[10 13]+countSP); hold on;
        ylabel(yLabelSpikeRaster);
        set(gca,'XLim',xTimeBehah);
        xlabel(xLabelBehav);

        countSP=countSP+1;
end  
end