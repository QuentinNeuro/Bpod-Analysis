function Analysis=AP_PlotData_Spikes(Analysis,cellID,groupTypes)

%% Cell ID
thisC_Name=Analysis.AllData.AllCells.CellName{cellID};
testTag=Analysis.Parameters.Spikes.Tag;
thisLabelTag=Analysis.AllData.(thisC_Name).LabelTag;
thisLabelCluster=Analysis.AllData.(thisC_Name).LabelTag;

%% Parameters
% Plot
nbOfGroups=size(groupTypes,1);
if nbOfGroups>3
nbOfGroups=3;
disp('Figure for spike data will only show the first 3 behavior group')
disp('Check AP_PlotData_Spikes for info')
end
transparency=Analysis.Parameters.Transparency;
colorplot='bgry';
%% Parameters
% Subplot All Spikes
xLabelAll='Time Session (s)';
xTimeAll=[Analysis.Core.Spikes_BehTS(1) Analysis.Core.Spikes_BehTS(end)];
yLabelSpikeAll='Spikes';
ySpikeAll=[-0.1 0.1];
% Subplot Tagging Raster
xLabelTag='Time from Laser (s)';
xTimeTag=Analysis.Parameters.Spikes.tagging_TW;
% Subplot Licks
yLabelLicks='Licks (Hz)';
yLicks=[0 10];
% Subplot Spikes Rate
yLabelSpikeRate='Spikes (Hz)';
ySpikeRate=[0 10];
% Subplot Behavior Raster
yLabelSpikeRaster='Trials';
xLabelBehav='Time (s)';
xTimeBehah=Analysis.Parameters.PlotX;

%% Data
% Subplot All Spikes
NbOfSpikes=500;
thisSpikes_All=Analysis.Core.SpikeTS{cellID};
thislength=length(thisSpikes_All);
if thislength>=NbOfSpikes
    thisSpikes_All=decimate(thisSpikes_All,ceil(thislength/NbOfSpikes));
end  

%% Figure
scrsz = get(groot,'ScreenSize');
FigureLegend=sprintf('%s_%s',Analysis.Parameters.Name,Analysis.Parameters.Rig);

figure('Name','Figure TT','Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

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
    nbOfTypes=size(thisGroupTypes,1);
    countRaster=0;
    for t=1:nbOfTypes
        subplot(5,3,4+countSP); hold on;
        plot(-10,-10,colorplot(t))
    end
    for t=1:nbOfTypes
        thisType=thisGroupTypes{t,1}; 
        if Analysis.(thisType).nTrials>0
        %% Data
        % Timing
        cueTime=Analysis.(thisType).Time.Cue;
        outcomeTime=Analysis.(thisType).Time.Outcome;
        % Licks
        licksAVG=Analysis.(thisType).Licks.AVG;
        licksSEM=Analysis.(thisType).Licks.SEM;
        licksBin=Analysis.(thisType).Licks.Bin;
        % spikes
        spikesAVG=Analysis.(thisType).(thisC_Name).DataAVG;
        spikesSEM=Analysis.(thisType).(thisC_Name).DataSEM;
        spikesBin=Analysis.(thisType).(thisC_Name).Time(1,:);
        raster_Spikes=cell2mat(Analysis.(thisType).(thisC_Name).SpikeTS');
        raster_Trials=cell2mat(Analysis.(thisType).(thisC_Name).TrialTS');
        %% Plot
        subplot(5,3,4+countSP); hold on;
        shadedErrorBar(licksBin,licksAVG,licksSEM,colorplot(t),transparency);
        subplot(5,3,7+countSP); hold on;
        shadedErrorBar(spikesBin,spikesAVG,spikesSEM,colorplot(t),transparency);
        subplot(5,3,[10 13]+countSP); hold on;
        plot(raster_Spikes,raster_Trials+countRaster,'sk','MarkerSize',2,'MarkerFaceColor','k');
        plot([xTimeBehah(2) xTimeBehah(2)],[countRaster countRaster+raster_Trials(end)],['-' colorplot(t)],'LineWidth',2);

        countRaster=countRaster+raster_Trials(end)+10;
        end
    end
    % Make plot pretty
        subplot(5,3,4+countSP)
        title(groupName)
        plot([cueTime(1,1) cueTime(1,2)],[yLicks(2) yLicks(2)],'-b','LineWidth',2);
        plot([outcomeTime(1,1) outcomeTime(1,1)],yLicks,'-r','LineWidth',2);
        set(gca,'XLim',xTimeBehah,'YLim',yLicks);
        ylabel(yLabelLicks);
        legend(thisGroupTypes{:,1})
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

%% Save
% if isfield(Analysis.AllData.Spikes,'TagStat')
%     tagStatus=find(Analysis.AllData.Spikes.TagStat.Decision(c,:));
%     if ~isempty(tagStatus)
%         tagName=['-' Analysis.AllData.Spikes.TagStat.TagNames{tagStatus}];
%     else tagName=[];
%     end
% end
% FileName=[Analysis.Parameters.Name '-' thisC_Name tagName]
% DirEvents=[pwd filesep ['Figure_Spikes' tagName] filesep];
% if isfolder(DirEvents)==0
%     mkdir(DirEvents);
% end
% DirFile=[DirEvents FileName];
% saveas(gcf,DirFile,'png');
% if Analysis.Parameters.Illustrator
% 	saveas(gcf,DirFile,'epsc');
% end
% close 'Figure TT';    
end