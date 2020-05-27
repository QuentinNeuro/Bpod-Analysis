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
labelx='Time (s)';   
xTime=Analysis.Parameters.PlotX;
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
PlotY_photo=Analysis.Parameters.PlotY_photo;

%% Plot
scrsz = get(groot,'ScreenSize');
figure('Name',FigTitle,'Position', [25 25 scrsz(3)/4 scrsz(4)-150], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',Analysis.Parameters.Legend,'Position',[10,5,500,20]); 

% Lick Raster
subplot(6,1,[1 2]); hold on;
title(Title);
plot(Analysis.(thistype).Licks.Events,Analysis.(thistype).Licks.Trials,'sk',...
    'MarkerSize',2,'MarkerFaceColor','k');
plot(Analysis.(thistype).Time.Outcome(:,1),1:Analysis.(thistype).nTrials,'.r','MarkerSize',4);
plot(Analysis.(thistype).Time.Cue(:,1),1:Analysis.(thistype).nTrials,'.m','MarkerSize',4);  
ylabel(labely1);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial+1],'YDir','reverse');
% Lick AVG
subplot(6,1,3); hold on;
shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,'-k',transparency);
plot([0 0],[0 maxrate+1],'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[maxrate maxrate],'-b','LineWidth',2);
ylabel(labely2); xlabel(labelx);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate+1]);

%% Photometry
% Avg
if Analysis.Parameters.Photometry==1
subplot(6,1,6); hold on;
shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,'-k',transparency);
if isnan(PlotY_photo(channelnb,:))
    axis tight;
    PlotY_photo(channelnb,:)=get(gca,'YLim');
end
plot([0 0],PlotY_photo,'-r');
plot(Analysis.(thistype).Time.Cue(1,:),[PlotY_photo(channelnb,2) PlotY_photo(channelnb,2)],'-b','LineWidth',2);
ylabel(labelyFluo); xlabel(labelx);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',PlotY_photo(channelnb,:));
    
% Nidaq Raster
subplot(6,1,[4 5]); hold on;
yrasternidaq=1:Analysis.(thistype).nTrials;
imagesc(Analysis.(thistype).(thisChStruct).Time(1,:),yrasternidaq,Analysis.(thistype).(thisChStruct).DFF,PlotY_photo(channelnb,:));
plot(Analysis.(thistype).Time.Outcome(:,1),1:Analysis.(thistype).nTrials,'.r','MarkerSize',4);
plot(Analysis.(thistype).Time.Cue(:,1),1:Analysis.(thistype).nTrials,'.m','MarkerSize',4);  
pos=get(gca,'pos');
c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
c.Label.String = labelyFluo;
ylabel(labelyFluoRaster);
set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');

end    
end