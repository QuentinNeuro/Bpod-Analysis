function Analysis=AB_PlotData_Filter(Analysis,thistype,thiscell)
%AP_PlotData_filter generates a figure from the licks and the photometry
%data of 'channelnb' contained in the structure 'Analysis.(thistype)'. 
%The figure shows, for the sorted trial types specified by 'thistype' :
%1) a raster plot of the licks events 
%2) the average lick rate
%3) a pseudocolored raster plot of the individual photometry traces
%4) the average photometry signal
%To plot the different graph, this function is using the parameters
%specified in Analysis.Parameters
%
%function designed by Quentin 2017 for Analysis_Photometry

%% Check trialType
if Analysis.(thistype).nTrials==0
    disp(['Cannot create filter plot for' thistype])
    disp('Check AP_PlotData_Filter')
    return
end

%% 
FigTitle=['Filter ' thistype];
illustrationTest=Analysis.Parameters.Plot.Illustration(2);
if nargin==3
    if ~ischar(thiscell)
        thiscell=Analysis.(thistype).AllCells.CellName{thiscell};
    end
else
    thiscell=[];
end
%% Close existing figures
try
    close FigTitle;
end

%% Data
[timeAVG,dataAVG,semAVG,labelYData]=AB_PlotData_SelectorAVG(Analysis,thistype,thiscell);
[timeRaster,trialRaster,dataRaster,labelYRaster,cmap]=AB_PlotData_SelectorRaster(Analysis,thistype,thiscell);

%% Plot Parameters
Title=sprintf('%s (%.0d)',strrep(Analysis.(thistype).Name,'_',' '),Analysis.(thistype).nTrials);
labelx='Time (s)';   
xTime=Analysis.Parameters.Plot.xTime;
xtickvalues=linspace(xTime(1),xTime(2),5);
labely1='Trial Number (licks)';
labely2='Licks Rate (Hz)';
transparency=0;
% Automatic definition of axes
maxtrial=Analysis.(thistype).nTrials;
if ~illustrationTest
    maxTrial=20;
end
%Lick AVG y axes
maxrate=max(Analysis.(thistype).Licks.DataAVG);
if maxrate<10
    maxrate=10;
end
thisPlotY=Analysis.Parameters.Plot.yData;

nbOfPlotsY=3+3*size(dataAVG,2);
nbOfPlotsX=1;

%% Epoch markers
epochNames=Analysis.Parameters.Timing.EpochNames;
nEpochs=size(epochNames,2);
epochColors='rgbybkm';

%% Plot
scrsz = get(groot,'ScreenSize');
figure('Name',FigTitle,'Position', [25 25 scrsz(3)/4 scrsz(4)-150], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',Analysis.Parameters.Plot.Legend,'Position',[10,5,500,20]); 

%% Licking Data
subplot(nbOfPlotsY,nbOfPlotsX,[1 2]); hold on;
title(Title);
% Raster
plot(cell2mat(Analysis.(thistype).Licks.Events'),cell2mat(Analysis.(thistype).Licks.Trials'),'sk',...
    'MarkerSize',2,'MarkerFaceColor','k');
    for e=1:nEpochs
        plot(Analysis.(thistype).Time.(epochNames{e})(:,1),1:Analysis.(thistype).nTrials,['.' epochColors(e)],'MarkerSize',4)
    end
ylabel(labely1);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
% Average
subplot(nbOfPlotsY,nbOfPlotsX,3); hold on;
shadedErrorBar(Analysis.(thistype).Licks.Time(1,:), Analysis.(thistype).Licks.DataAVG, Analysis.(thistype).Licks.DataSEM,'-k',transparency);
plot([0 0],[0 maxrate+1],'-r');
    for e=1:nEpochs
        plot(Analysis.(thistype).Time.(epochNames{e})(1,:),[maxrate maxrate],['-' epochColors(e)],'LineWidth',2)
    end
ylabel(labely2); xlabel(labelx);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate+1]);

%% Neuronal Data
if ~Analysis.Parameters.Photometry.Photometry
    maxtrial=max(trialRaster{1});
end
counter=0;
for c=1:size(dataAVG,2)
% Average
    thisSubPlot=6+counter;
    subplot(nbOfPlotsY,nbOfPlotsX,thisSubPlot); hold on;
    shadedErrorBar(timeAVG{c},dataAVG{c},semAVG{c},'-k',transparency);
    if isnan(thisPlotY(c,:))
        axis tight;
        thisPlotY(c,:)=get(gca,'YLim');
    end
    plot([0 0],thisPlotY,'-r');
    for e=1:nEpochs
        plot(Analysis.(thistype).Time.(epochNames{e})(1,:),[thisPlotY(c,2) thisPlotY(c,2)],['-' epochColors(e)],'LineWidth',2)
    end
    ylabel(labelYData{c}); xlabel(labelx);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',thisPlotY(c,:));

% Raster
    thisSubPlot=[4 5]+counter;
    subplot(nbOfPlotsY,nbOfPlotsX,thisSubPlot); hold on;
    imagesc(timeRaster{c},trialRaster{c},dataRaster{c},thisPlotY(c,:));
    colormap(cmap)
    for e=1:nEpochs
        plot(Analysis.(thistype).Time.(epochNames{e})(:,1),1:Analysis.(thistype).nTrials,['.' epochColors(e)],'MarkerSize',4)
    end
    pos=get(gca,'pos');
    cb=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
    cb.Label.String = labelYRaster{c};
    ylabel(labelYRaster{c});
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YDir','reverse'); %'YLim',[0 maxtrial]
    counter=counter+3;
end  
end