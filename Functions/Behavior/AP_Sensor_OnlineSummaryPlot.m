function thisfig=AP_Sensor_OnlineSummaryPlot(Analysis)
%% Summary plot - used for postrecording quick analysis - but can also be used for posthoc
%% To use with the Bpod Analysis pipeline
%% Design by QC 2018
global water
if isempty(water)
    water=NaN;
end

%% Check whether performance data exists and generate title
if isfield(Analysis,'Performance')
    Decision=int8(Analysis.Performance.Decision);
else
    Decision=NaN;
end
TitlePerfWat=sprintf('Performance = %d - Water = %d ul',Decision,water);

%% Plotting Parameters
FigureTitle='PostTraining_Plot';
nbOfTrialTypes=Analysis.Parameters.nbOfTrialTypes;
labely={'Licks',Analysis.Parameters.PhotoChNames{1},Analysis.Parameters.PhotoChNames{2},'Wheel'};
labelx='Time (s)'; 
color4plot={'-k';'-b';'-r';'-g';'-c';'-c';'-k'};
transparency=1;
% Automatic definition of axes
maxtrial=0; maxrate=10;
for i=1:nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
%Raster plots y axes
    if Analysis.(thistype).nTrials > maxtrial
        maxtrial=Analysis.(thistype).nTrials;
    end
%Lick AVG y axes
    if max(Analysis.(thistype).Licks.AVG)>maxrate
        maxrate=max(Analysis.(thistype).Licks.AVG);
    end
end

PlotY_photo=Analysis.Parameters.PlotY_photo;
WheelRange=[0 100];
xTime=Analysis.Parameters.PlotX;
xtickvalues=linspace(xTime(1),xTime(2),5);

%% Figure
FigureLegend=sprintf('%s_%s',Analysis.Parameters.Name,Analysis.Parameters.Rig);
thisfig=figure('Name',FigureTitle,'Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

%% Subplot for the different trial types
thistypeplots=0;
SubplotDimensions=[4 nbOfTrialTypes+1];

for i=1:nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
    thistypeplots=thistypeplots+1;
% Lick raster
    subplot(SubplotDimensions(1),SubplotDimensions(2),thistypeplots); hold on;
    title(Analysis.(thistype).Name);
    if thistypeplots==1
        ylabel(labely{1});
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
    plot(Analysis.(thistype).Licks.Events,Analysis.(thistype).Licks.Trials,'sk',...
        'MarkerSize',2,'MarkerFaceColor','k');
    plot([0 0],[0 maxtrial],'-r');
    plot(Analysis.(thistype).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
    
% Photometry Raster
for j=1:size(Analysis.Parameters.PhotoField,2)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{j}));
    subplot(SubplotDimensions(1),SubplotDimensions(2),thistypeplots+(j*SubplotDimensions(2))); hold on;
    if thistypeplots==1
        ylabel(labely{j+1});
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
    yrasternidaq=1:Analysis.(thistype).nTrials;
if ~isnan(PlotY_photo(j,:))
    imagesc(Analysis.(thistype).(thisChStruct).Time(1,:),yrasternidaq,Analysis.(thistype).(thisChStruct).DFF,PlotY_photo(j,:));
 else
     imagesc(Analysis.(thistype).(thisChStruct).Time(1,:),yrasternidaq,Analysis.(thistype).(thisChStruct).DFF);
 end    
    plot([0 0],[0 maxtrial],'-r');
    plot(Analysis.(thistype).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
    if thistypeplots==nbOfTrialTypes
        pos=get(gca,'pos');
        c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
    end
end

% Wheel raster
if Analysis.Parameters.Wheel
    subplot(SubplotDimensions(1),SubplotDimensions(2),thistypeplots+3*SubplotDimensions(2)); hold on;
    if thistypeplots==1
                ylabel(labely{4});
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
    yrasternidaq=1:Analysis.(thistype).nTrials;
    imagesc(Analysis.(thistype).Wheel.Time(1,:),yrasternidaq,Analysis.(thistype).Wheel.Distance,WheelRange);
    plot([0 0],[0 maxtrial],'-r');
    plot(Analysis.(thistype).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
    if thistypeplots==nbOfTrialTypes
        pos=get(gca,'pos');
        c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
    end
    xlabel(labelx);
end
end

%% Summary subplot to compare trial types
summaryplots=thistypeplots+1;
for k=1:nbOfTrialTypes
    thistype=sprintf('type_%.0d',k);
    LegendTitle{k}=Analysis.(thistype).Name;
    % Lick rate
    subplot(SubplotDimensions(1),SubplotDimensions(2),summaryplots); hold on;
    ylabel('Lick Rate (Hz)');
    xlabel(labelx);
    hs=shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,color4plot(k),transparency);
    hp(k)=hs.mainLine;
    % Photometry
    for j=1:size(Analysis.Parameters.PhotoField,2)
        thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{j}));
        subplot(SubplotDimensions(1),SubplotDimensions(2),summaryplots+(j*SubplotDimensions(2))); hold on;
        ylabel('DFF (%)');
        xlabel(labelx);
        shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,color4plot(k),transparency);
    end
    % Wheel
    if Analysis.Parameters.Wheel
    subplot(SubplotDimensions(1),SubplotDimensions(2),summaryplots+3*SubplotDimensions(2)); hold on;
        ylabel('Run (cm)');
        xlabel(labelx);
        shadedErrorBar(Analysis.(thistype).Wheel.Time(1,:),Analysis.(thistype).Wheel.DistanceAVG,Analysis.(thistype).Wheel.DistanceSEM,color4plot(k),transparency);
    end

end

% Adjust y axis and add reward and cue timing
% Licks
subplot(SubplotDimensions(1),SubplotDimensions(2),summaryplots); hold on;
title(TitlePerfWat);
axis tight
thisYLim=get(gca,'YLim');
plot([0 0],[0 thisYLim(2)],'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[thisYLim(2) thisYLim(2)],'-b','LineWidth',2);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',thisYLim);

legend(hp,LegendTitle,'Location','northwest','FontSize',8);
legend('boxoff');
clear hp hs;
% Photometry
for j=1:size(Analysis.Parameters.PhotoField,2)
    subplot(SubplotDimensions(1),SubplotDimensions(2),summaryplots+(j*SubplotDimensions(2))); hold on;
    thisYLim=get(gca,'YLim');
    plot([0 0],thisYLim,'-r');
    plot(Analysis.(thistype).Time.Cue(1,:),[thisYLim(2) thisYLim(2)],'-b','LineWidth',2);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',thisYLim);
end
% Wheel
if Analysis.Parameters.Wheel
    subplot(SubplotDimensions(1),SubplotDimensions(2),summaryplots+3*SubplotDimensions(2)); hold on;
    thisYLim=get(gca,'YLim');
    plot([0 0],thisYLim,'-r');
    plot(Analysis.(thistype).Time.Cue(1,:),[thisYLim(2) thisYLim(2)],'-b','LineWidth',2);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',thisYLim);
end
end