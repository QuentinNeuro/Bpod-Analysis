% function Analysis=AP_PlotData_All(Analysis,channelnb)
%AP_PlotData generates a figure from the licks and 405 photometry data
%contained in the structure 'Analysis'. The figure shows for each trial types: 
%1) a raster plot of the licks events 
%2) the average lick rate
%3) a pseudocolored raster plot of the individual photometry traces
%4) the average photometry signal
%To plot the different graph, this function is using the parameters
%specified in Analysis.Properties
%
%function designed by Quentin 2016 for Analysis_Photometry

%% Plot Parameters
thisChStruct='Photo_470';
labelx='Time (sec)';   
xTime=[Analysis.Properties.PlotEdges(1) Analysis.Properties.PlotEdges(2)];
xtickvalues=linspace(xTime(1),xTime(2),5);

nbOfTrialTypes=Analysis.Properties.nbOfTrialTypes;
if nbOfTrialTypes>6
    nbOfPlots=nbOfTrialTypes;
else
    nbOfPlots=6;
end

% definition of axes
maxtrial=0;
for i=1:nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
%Raster plots y axes
    if Analysis.(thistype).nTrials > maxtrial
        maxtrial=Analysis.(thistype).nTrials;
    end
end
maxtrial=Analysis.(thistype).nTrials;
maxrate=10;
NidaqRange=Analysis.Properties.NidaqRange;
RunRange=[0 100];
PupilRange=[-5 20];


%% Plot
FigureLegend=sprintf('%s_%s',Analysis.Properties.Name,Analysis.Properties.Rig);
figData.figure=figure('Name','Figure','Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

thisplot=1;
for i=1:nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
% Lick Raster
    subplot(8,nbOfPlots,[thisplot thisplot+nbOfPlots]); hold on;
    title(Analysis.(thistype).Name);
    if thisplot==1
        ylabel('Trial # Licks');
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
    plot(Analysis.(thistype).Licks.Events,Analysis.(thistype).Licks.Trials,'sk',...
        'MarkerSize',2,'MarkerFaceColor','k');
    plot([0 0],[0 maxtrial],'-r');
    plot(Analysis.(thistype).CueTime,[0 0],'-b','LineWidth',2);

% Nidaq Raster
    subplot(8,nbOfPlots,[thisplot+(2*nbOfPlots) thisplot+(3*nbOfPlots)]); hold on;
    if thisplot==1
        ylabel('Trial # DFF');
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
    yrasterrun=1:Analysis.(thistype).nTrials;
    imagesc(Analysis.(thistype).(thisChStruct).Time(1,:),yrasterrun,Analysis.(thistype).(thisChStruct).DFF,NidaqRange);
    plot([0 0],[0 maxtrial],'-r');
    plot(Analysis.(thistype).CueTime,[0 0],'-b','LineWidth',2);
    if thisplot==nbOfTrialTypes
        pos=get(gca,'pos');
        c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
        c.Label.String = 'DFF (%)';
    end
    xlabel(labelx);
% Running Raster
    subplot(8,nbOfPlots,[thisplot+(4*nbOfPlots) thisplot+(5*nbOfPlots)]); hold on;
    if thisplot==1
        ylabel('Trial # Run');
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
    yrasterrun=1:Analysis.(thistype).nTrials;
    imagesc(Analysis.(thistype).Wheel.Time(1,:),yrasterrun,Analysis.(thistype).Wheel.Distance,RunRange);
    plot([0 0],[0 maxtrial],'-r');
    plot(Analysis.(thistype).CueTime,[0 0],'-b','LineWidth',2);
    if thisplot==nbOfTrialTypes
        pos=get(gca,'pos');
        c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
        c.Label.String = 'Run (cm)';
    end
% Pupil Raster
    subplot(8,nbOfPlots,[thisplot+(6*nbOfPlots) thisplot+(7*nbOfPlots)]); hold on;
    if thisplot==1
        ylabel('Trial # Pupil');
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
    yrasterpupil=1:Analysis.(thistype).nTrials;
    imagesc(Analysis.(thistype).Pupil.Time(1,:),yrasterpupil,Analysis.(thistype).Pupil.PupilDPP,PupilRange);
    plot([0 0],[0 maxtrial],'-r');
    plot(Analysis.(thistype).CueTime,[0 0],'-b','LineWidth',2);
    if thisplot==nbOfTrialTypes
        pos=get(gca,'pos');
        c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
        c.Label.String = 'Pupil (%)';
    end
    thisplot=thisplot+1;
end
% end