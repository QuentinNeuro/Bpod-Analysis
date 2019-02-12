function Analysis=AP_PlotData_filter(Analysis,thistype,channelnb)
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

if nargin==2
    channelnb=1;
end
thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{channelnb}));
FigTitle=sprintf('Analysis-PlotSingle %s',char(Analysis.Parameters.PhotoChNames{channelnb}));

%% Close figures
try
    close FigTitle;
end

%% Plot Parameters
Title=sprintf('%s (%.0d)',strrep(Analysis.(thistype).Name,'_',' '),Analysis.(thistype).nTrials);
labelx='Time (sec)';   
xTime=[Analysis.Parameters.PlotEdges(1) Analysis.Parameters.PlotEdges(2)];
xtickvalues=linspace(xTime(1),xTime(2),5);
labely1='Trial Number (licks)';
labely2='Licks Rate (Hz)';

if Analysis.Parameters.Zscore
    labelyFluoRaster='Trial Number (z-score)';
    labelyFluo='Z-scored Fluo';
else
    labelyFluoRaster='Trial Number (DF/Fo)';
    labelyFluo='DF/Fo (%)';
end
transparency=0;
% Automatic definition of axes
maxtrial=Analysis.(thistype).nTrials;
if maxtrial<20
    maxtrial=20;
else
    maxtrial=40;
end
%Lick AVG y axes
maxrate=max(Analysis.(thistype).Licks.AVG);
if maxrate<10
    maxrate=10;
end
NidaqRange=Analysis.Parameters.NidaqRange;

%% Plot
scrsz = get(groot,'ScreenSize');
FigureLegend=sprintf('%s_%s',Analysis.Parameters.Name,Analysis.Parameters.Rig);
figData.figure=figure('Name',FigTitle,'Position', [25 25 scrsz(3)/4 scrsz(4)-150], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

% Lick Raster
subplot(6,1,[1 2]); hold on;
title(Title);
ylabel(labely1);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
plot(Analysis.(thistype).Licks.Events,Analysis.(thistype).Licks.Trials,'sk',...
    'MarkerSize',2,'MarkerFaceColor','k');
plot([0 0],[0 maxtrial],'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
% Lick AVG
subplot(6,1,3); hold on;
ylabel(labely2);
xlabel(labelx);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate+1]);
shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,'-k',transparency);
plot([0 0],[0 maxrate+1],'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[maxrate maxrate],'-b','LineWidth',2);

if Analysis.Parameters.Photometry==1    
% Nidaq Raster
subplot(6,1,[4 5]); hold on;
ylabel(labelyFluoRaster);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
yrasternidaq=1:Analysis.(thistype).nTrials;
 if ~isempty(NidaqRange)
    imagesc(Analysis.(thistype).(thisChStruct).Time(1,:),yrasternidaq,Analysis.(thistype).(thisChStruct).DFF,NidaqRange);
 else
     imagesc(Analysis.(thistype).(thisChStruct).Time(1,:),yrasternidaq,Analysis.(thistype).(thisChStruct).DFF);
 end 
plot([0 0],[0 maxtrial],'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
pos=get(gca,'pos');
c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
c.Label.String = labelyFluo;

% Nidaq AVG
subplot(6,1,6); hold on;
ylabel(labelyFluo);
xlabel(labelx);
shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,'-k',transparency);
if ~isempty(NidaqRange)
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',NidaqRange);
plot([0 0],NidaqRange,'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[NidaqRange(2) NidaqRange(2)],'-b','LineWidth',2);
else
     axis tight
     set(gca,'XLim',xTime,'XTick',xtickvalues);
     thisYLim=get(gca,'YLim');
     plot([0 0],thisYLim,'-r');
     plot(Analysis.(thistype).Time.Cue(1,:),[thisYLim(2) thisYLim(2)],'-b','LineWidth',2);
end    
end    
end