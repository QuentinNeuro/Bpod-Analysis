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
xTime=Analysis.Parameters.PlotX;
xtickvalues=linspace(xTime(1),xTime(2),5);
labely1='Trial Number (licks)';
labely2='Licks Rate (Hz)';
if Analysis.Parameters.Zscore
    labelyFluo='Z-scored Fluo';
else
    labelyFluo='DF/Fo (%)';
end

%% Nb of plots
nbOfPlotsY=6;
for thisCh=2:length(Analysis.Parameters.PhotoCh)
    nbOfPlotsY=nbOfPlotsY+3;
end
    
nbOfTrialTypes=Analysis.Parameters.nbOfTrialTypes;
if nbOfTrialTypes>6
    nbOfPlotsX=nbOfTrialTypes;
else
    nbOfPlotsX=6;
end
%% Axes
% Automatic definition of axes
maxtrial=0; maxrate=10;
for i=1:nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
    if Analysis.(thistype).nTrials~=0
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
PlotY_photo=Analysis.Parameters.PlotY_photo;

%% Plot
FigureLegend=sprintf('%s_%s',Analysis.Parameters.Name,Analysis.Parameters.Rig);
figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

thisplot=1;
for i=1:nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
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
    plot(Analysis.(thistype).Time.Outcome(:,1),1:Analysis.(thistype).nTrials,'.r');
    plot(Analysis.(thistype).Time.Cue(:,1),1:Analysis.(thistype).nTrials,'.m');
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
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
% Nidaq Raster
    subplot(nbOfPlotsY,nbOfPlotsX,[thisplot+(counterphotoplot(1)*nbOfPlotsX) thisplot+(counterphotoplot(2)*nbOfPlotsX)]); hold on;
    if thisplot==1
                ylabel(char(Analysis.Parameters.PhotoChNames{thisCh}));
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxtrial],'YDir','reverse');
    
    yrasternidaq=1:Analysis.(thistype).nTrials;
 if ~isnan(PlotY_photo(thisCh,:))
    imagesc(Analysis.(thistype).(thisChStruct).Time(1,:),yrasternidaq,Analysis.(thistype).(thisChStruct).DFF,PlotY_photo(thisCh,:));
 else
     imagesc(Analysis.(thistype).(thisChStruct).Time(1,:),yrasternidaq,Analysis.(thistype).(thisChStruct).DFF);
 end    
    plot(Analysis.(thistype).Time.Outcome(:,1),1:Analysis.(thistype).nTrials,'.r');
    plot(Analysis.(thistype).Time.Cue(:,1),1:Analysis.(thistype).nTrials,'.m');
    if thisplot==nbOfTrialTypes
        pos=get(gca,'pos');
        c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
        c.Label.String = labelyFluo;
    end
% Nidaq AVG
    subplot(nbOfPlotsY,nbOfPlotsX,thisplot+(counterphotoplot(3)*nbOfPlotsX)); hold on;
    if thisplot==1
        ylabel(labelyFluo);
    end
    xlabel(labelx);
    shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,'-k',0);
    if ~isnan(PlotY_photo(thisCh,:))
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',PlotY_photo(thisCh,:));
    plot([0 0],PlotY_photo(thisCh,:),'-r');
    plot(Analysis.(thistype).Time.Cue(1,:),[PlotY_photo(thisCh,2) PlotY_photo(thisCh,2)],'-b','LineWidth',2);
    else
         axis tight
         set(gca,'XLim',xTime,'XTick',xtickvalues);
         thisYLim=get(gca,'YLim');
         plot([0 0],thisYLim,'-r');
         plot(Analysis.(thistype).Time.Cue(1,:),[thisYLim(2) thisYLim(2)],'-b','LineWidth',2);
    end    
    counterphotoplot=counterphotoplot+3;
end  
end
    thisplot=thisplot+1;
end
end