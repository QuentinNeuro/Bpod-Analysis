function Analysis=AB_PlotData_Spikes(Analysis,cellID,groupTypes)

%% Cell ID
thisC_Name=Analysis.AllData.AllCells.CellName{cellID};
testTag=Analysis.Parameters.Spikes.Tag;
thisLabelTag=Analysis.AllData.(thisC_Name).LabelTag;
thisLabelCluster=Analysis.AllData.(thisC_Name).LabelClustering;

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
% Subplot All Spikes
NbOfSpikes=500;
thisSpikes_All=Analysis.Core.SpikesTS{cellID};
thislength=length(thisSpikes_All);
if thislength>=NbOfSpikes
    thisSpikes_All=decimate(thisSpikes_All,ceil(thislength/NbOfSpikes));
end  
% Waveforms
testwaveforms=0;
if isfield(Analysis.Tagging.(thisC_Name).Early,'Waveforms')
    testwaveforms=1;
    wvTag=Analysis.Tagging.(thisC_Name).Early.Waveforms;
    wvAll=Analysis.Core.SpikesWV{cellID};
% Averages
    wvTag_AVG=mean(wvTag,2);
    wvTag_SEM=std(wvTag,0,2)/sqrt(size(wvTag,2));
    wvAll_AVG=mean(wvAll,2);
    wvAll_SEM=std(wvAll,0,2)/sqrt(size(wvAll,2));
    wvTime=(1:size(wvTag,1))*1000/Analysis.Parameters.Spikes.SamplingRate;
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
if testwaveforms
shadedErrorBar(wvTime,wvAll_AVG,wvAll_SEM,'-k',1);
shadedErrorBar(wvTime,wvTag_AVG,wvTag_SEM,'-b',1);
end
xlabel('time (ms)')
title(sprintf('Channel : %.0f', Analysis.AllData.(thisC_Name).LabelChannel))
end    
%% TT Timing
subplot(6,3,2); hold on;
title([thisC_Name ' ' thisLabelCluster]);
plot(thisSpikes_All,0,'sk',...
        'MarkerSize',2,'MarkerFaceColor','k');
set(gca,'XLim',xTimeAll,'YLim',ySpikeAll);
ylabel(yLabelSpikeAll);
xlabel(xLabelAll);

%% PhotoTagging
if testTag
    % Data
raster_Spikes=cell2mat(Analysis.Tagging.(thisC_Name).SpikeTS');
raster_Trials=cell2mat(Analysis.Tagging.(thisC_Name).TrialTS');
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
        spikesAVG=Analysis.(thisType).(thisC_Name).DataAVG;
        spikesSEM=Analysis.(thisType).(thisC_Name).DataSEM;
        spikesBin=Analysis.(thisType).(thisC_Name).Time(1,:);
        raster_Spikes=cell2mat(Analysis.(thisType).(thisC_Name).SpikeTS);
        raster_Trials=cell2mat(Analysis.(thisType).(thisC_Name).TrialTS);
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