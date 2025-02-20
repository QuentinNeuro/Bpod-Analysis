function Analysis=AB_PlotData(Analysis,FigTitle,Group)
%AP_PlotData generates a figure from the licks and the photometry data
%contained in the structure 'Analysis'. The figure shows for each trial types: 
%1) a raster plot of the licks events 
%2) the average lick rate
%3) a pseudocolored raster plot of the individual photometry traces
%4) the average photometry signal
%To plot the different graph, this function is using the parameters
%specified in Analysis.Parameters
%
%function designed by Quentin 2016 for Analysis_Photometry

%% Check trialTypes inside group
nbOfTypes=size(Group,2);
testEmpty=[]; testCounter=1;
if isempty(Group)
    return
end
while isempty(testEmpty) | testCounter<=nbOfTypes
    testEmpty=Analysis.(Group{testCounter}).nTrials;
    testCounter=testCounter+1;
end
if isempty(testEmpty)
    disp(['Cannot create filter summary plot for ' FigTitle'])
    disp('Check AB_PlotData')
    return
end

%% Legends
labelx='Time (sec)';   
xTime=Analysis.Parameters.Plot.xTime;
xtickvalues=linspace(xTime(1),xTime(2),5);
labely1='Trial Number (licks)';
labely2='Licks Rate (Hz)';

%% Nb of plots
nbOfTypes=size(Group,2);
if nbOfTypes>6
    nbOfPlotsX=nbOfTypes;
else
    nbOfPlotsX=6;
end
nbOfPlotsY=3;

%% Axes
% Automatic definition of axes
maxtrial=20; maxrate=10;
for i=1:nbOfTypes
    thistype=Group{i};
    if Analysis.(thistype).nTrials
    [~,dataAVG]=AB_PlotData_SelectorAVG(Analysis,thistype);
    nbOfPlotsY=3+3*size(dataAVG,2);
%Raster plots y axes
    if Analysis.(thistype).nTrials > maxtrial
        maxtrial=Analysis.(thistype).nTrials;
    end
%Lick AVG y axes
    if max(Analysis.(thistype).Licks.DataAVG)>maxrate
        maxrate=max(Analysis.(thistype).Licks.DataAVG);
    end
    end
end
PlotY_photo=Analysis.Parameters.Plot.yData;

%% Epoch markers
epochNames=Analysis.Parameters.Timing.EpochNames;
nEpochs=size(epochNames,2);
epochColors='rgbybkm';

%% Plot
ScrSze=get(0,'ScreenSize');
FigSze=[ScrSze(3)*1/10 ScrSze(4)*1/10 ScrSze(3)*8/10 ScrSze(4)*8/10];
figure('Name',FigTitle,'Position', FigSze, 'numbertitle','off');

Legend=uicontrol('style','text');
set(Legend,'String',Analysis.Parameters.Plot.Legend,'Position',[10,5,500,20]); 

thisplot=1;
for i=1:nbOfTypes
    thistype=Group{i};
%% Licking data
% Lick Raster
    subplot(nbOfPlotsY,nbOfPlotsX,[thisplot thisplot+nbOfPlotsX]); hold on;
    title(Analysis.(thistype).Name);
    if thisplot==1
        ylabel(labely1);
    end
if Analysis.(thistype).nTrials
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
    plot(cell2mat(Analysis.(thistype).Licks.Events'),cell2mat(Analysis.(thistype).Licks.Trials'),'sk',...
        'MarkerSize',2,'MarkerFaceColor','k');
    for e=1:nEpochs
        plot(Analysis.(thistype).Time.(epochNames{e})(:,1),1:Analysis.(thistype).nTrials,['.' epochColors(e)],'MarkerSize',4)
    end
% Lick AVG
    subplot(nbOfPlotsY,nbOfPlotsX,thisplot+(2*nbOfPlotsX)); hold on;
    if thisplot==1
        ylabel(labely2);
    end
    xlabel(labelx);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate+1]);
    shadedErrorBar(Analysis.(thistype).Licks.Time(1,:), Analysis.(thistype).Licks.DataAVG, Analysis.(thistype).Licks.DataSEM,'-k',0);
    plot([0 0],[0 maxrate+1],'-r');
    for e=1:nEpochs
        plot(Analysis.(thistype).Time.(epochNames{e})(1,:),[maxrate maxrate],['-' epochColors(e)],'LineWidth',2)
    end

    counterphotoplot=[3 4 5];

%% Neuronal Data
[timeAVG,dataAVG,semAVG,labelYData]=AB_PlotData_SelectorAVG(Analysis,thistype);
[timeRaster,trialRaster,dataRaster,labelYRaster]=AB_PlotData_SelectorRaster(Analysis,thistype);

if ~isempty(dataAVG)
    if ~Analysis.Parameters.Photometry.Photometry
        maxtrial=max(trialRaster{1});
    end
    for c=1:size(dataAVG,2)
% Average
	subplot(nbOfPlotsY,nbOfPlotsX,thisplot+(counterphotoplot(3)*nbOfPlotsX)); hold on;
    shadedErrorBar(timeAVG{c},dataAVG{c},semAVG{c},'-k',0);
    if isnan(PlotY_photo(c,:))
        axis tight;
        thisPlotY_data(c,:)=get(gca,'YLim');
    else
        thisPlotY_data(c,:)=PlotY_photo(c,:);
    end
    plot([0 0],thisPlotY_data(c,:),'-r');
    for e=1:nEpochs
        plot(Analysis.(thistype).Time.(epochNames{e})(1,:),[thisPlotY_data(c,2) thisPlotY_data(c,2)],['-' epochColors(e)],'LineWidth',2)
    end
    if thisplot==1
        ylabel(labelYData{c});
    end
    xlabel(labelx);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',thisPlotY_data(c,:));
    
% Raster
    subplot(nbOfPlotsY,nbOfPlotsX,[thisplot+(counterphotoplot(1)*nbOfPlotsX) thisplot+(counterphotoplot(2)*nbOfPlotsX)]); hold on;
    if thisplot==1
                ylabel(labelYRaster{c});
    end
    imagesc(timeRaster{c},trialRaster{c},dataRaster{c},thisPlotY_data(c,:));
    for e=1:nEpochs
        plot(Analysis.(thistype).Time.(epochNames{e})(:,1),1:Analysis.(thistype).nTrials,['.' epochColors(e)],'MarkerSize',4)
    end

    if thisplot==nbOfTypes
        pos=get(gca,'pos');
        cb=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
        cb.Label.String = labelYData{c};
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
    if trialRaster{c}(end)<maxtrial
        thisYLim=[0 maxtrial];
    else
        thisYLim=[0 trialRaster{c}(end)];
    end
    ylim(thisYLim);
    counterphotoplot=counterphotoplot+3;
    
    end
end 
end
    thisplot=thisplot+1;
end
end