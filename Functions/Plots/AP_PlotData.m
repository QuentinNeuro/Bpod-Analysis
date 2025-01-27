function Analysis=AP_PlotData(Analysis)
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

%% Legends
FigTitle='Summary-Plot';
labelx='Time (sec)';   
xTime=Analysis.Parameters.Plot.xTime;
xtickvalues=linspace(xTime(1),xTime(2),5);
labely1='Trial Number (licks)';
labely2='Licks Rate (Hz)';

%% Nb of plots
nbOfTrialTypes=Analysis.Parameters.Behavior.nbOfTrialTypes;
if nbOfTrialTypes>6
    nbOfPlotsX=nbOfTrialTypes;
else
    nbOfPlotsX=6;
end
nbOfPlotsY=3;

%% Axes
% Automatic definition of axes
maxtrial=20; maxrate=10;
for i=1:nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
    if Analysis.(thistype).nTrials
    [timeAVG,dataAVG,semAVG,labelYData]=AP_PlotData_SelectorAVG(Analysis,thistype);
    nbOfPlotsY=3+3*size(dataAVG,2);
%Raster plots y axes
    if Analysis.(thistype).nTrials > maxtrial
        maxtrial=Analysis.(thistype).nTrials;
    end
%Lick AVG y axes
    if max(Analysis.(thistype).Licks.AVG)>maxrate
        maxrate=max(Analysis.(thistype).Licks.AVG);
    end
    end
end
PlotY_photo=Analysis.Parameters.Plot.yPhoto;

%% Plot
ScrSze=get(0,'ScreenSize');
FigSze=[ScrSze(3)*1/10 ScrSze(4)*1/10 ScrSze(3)*8/10 ScrSze(4)*8/10];
figure('Name',FigTitle,'Position', FigSze, 'numbertitle','off');

Legend=uicontrol('style','text');
set(Legend,'String',Analysis.Parameters.Plot.Legend,'Position',[10,5,500,20]); 

thisplot=1;
for i=1:nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
%% Licking data
% Lick Raster
    subplot(nbOfPlotsY,nbOfPlotsX,[thisplot thisplot+nbOfPlotsX]); hold on;
    title(Analysis.(thistype).Name);
    if thisplot==1
        ylabel(labely1);
    end
if Analysis.(thistype).nTrials
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
    plot(Analysis.(thistype).Licks.Events,Analysis.(thistype).Licks.Trials,'sk',...
        'MarkerSize',2,'MarkerFaceColor','k');
    plot(Analysis.(thistype).Time.Outcome(:,1),1:Analysis.(thistype).nTrials,'.r','MarkerSize',4);
    plot(Analysis.(thistype).Time.Cue(:,1),1:Analysis.(thistype).nTrials,'.m','MarkerSize',4);  
% Lick AVG
    subplot(nbOfPlotsY,nbOfPlotsX,thisplot+(2*nbOfPlotsX)); hold on;
    if thisplot==1
        ylabel(labely2);
    end
    xlabel(labelx);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate+1]);
    shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,'-k',0);
    plot([0 0],[0 maxrate+1],'-r');
    plot(Analysis.(thistype).Time.Cue(1,:),[maxrate maxrate],'-b','LineWidth',2);
    
    counterphotoplot=[3 4 5];

%% Neuronal Data
[timeAVG,dataAVG,semAVG,labelYData]=AP_PlotData_SelectorAVG(Analysis,thistype);
[timeRaster,trialRaster,dataRaster,labelYRaster]=AP_PlotData_SelectorRaster(Analysis,thistype);

if ~isempty(dataAVG)
    if ~Analysis.Parameters.Photometry.Photometry
        maxtrial=max(trialRaster{1});
    end
    for thisCh=1:size(dataAVG,2)
% Average
	subplot(nbOfPlotsY,nbOfPlotsX,thisplot+(counterphotoplot(3)*nbOfPlotsX)); hold on;
    shadedErrorBar(timeAVG{thisCh},dataAVG{thisCh},semAVG{thisCh},'-k',0);
    if isnan(PlotY_photo(thisCh,:))
        axis tight;
        thisPlotY_photo(thisCh,:)=get(gca,'YLim');
    else
        thisPlotY_photo(thisCh,:)=PlotY_photo(thisCh,:);
    end
    plot([0 0],thisPlotY_photo(thisCh,:),'-r');
    plot(Analysis.(thistype).Time.Cue(1,:),[thisPlotY_photo(thisCh,2) thisPlotY_photo(thisCh,2)],'-b','LineWidth',2);  
    if thisplot==1
        ylabel(labelYData{thisCh});
    end
    xlabel(labelx);
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',thisPlotY_photo(thisCh,:));
    
% Raster
    subplot(nbOfPlotsY,nbOfPlotsX,[thisplot+(counterphotoplot(1)*nbOfPlotsX) thisplot+(counterphotoplot(2)*nbOfPlotsX)]); hold on;
    if thisplot==1
                ylabel(labelYRaster{thisCh});
    end
    imagesc(timeRaster{thisCh},trialRaster{thisCh},dataRaster{thisCh},thisPlotY_photo(thisCh,:));
    if Analysis.Parameters.Photometry.Photometry
    plot(Analysis.(thistype).Time.Outcome(:,1),trialRaster{thisCh},'.r','MarkerSize',4);
    plot(Analysis.(thistype).Time.Cue(:,1),trialRaster{thisCh},'.m','MarkerSize',4);
    else
    plot(Analysis.(thistype).Time.Outcome(1,1)*ones(size(trialRaster{thisCh})),trialRaster{thisCh},'.r','MarkerSize',4);
    plot(Analysis.(thistype).Time.Cue(1,1)*ones(size(trialRaster{thisCh})),trialRaster{thisCh},'.m','MarkerSize',4);
    end   
    if thisplot==nbOfTrialTypes
        pos=get(gca,'pos');
        c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
        c.Label.String = labelYData{thisCh};
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
    if trialRaster{thisCh}(end)<maxtrial
        thisYLim=[0 maxtrial];
    else
        thisYLim=[0 trialRaster{thisCh}(end)];
    end
    ylim(thisYLim);
    counterphotoplot=counterphotoplot+3;
    
    end
end 
end
    thisplot=thisplot+1;
end
end