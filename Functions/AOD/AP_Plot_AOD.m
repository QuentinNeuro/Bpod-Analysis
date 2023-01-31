function Analysis=AP_Plot_AOD(Analysis,groupToPlot,cellID)

%% Argument check
% cell check
if nargin==3
    if ~ischar(cellID)
        cellID=Analysis.AllData.AOD.CellName{cellID};
    end
else
    cellID=0;
end

% Groups
switch groupToPlot
    case 'filter'
Group_Plot{1,1}='RewardExp';
Group_Plot{1,2}={       'CueA_Reward',              {'Cue A','Reward','LicksOutcome'};...
                        'CueB_Omission',            {'Cue B'};...
                        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome'}};
    
	case 'types'
Group_Plot{1,1}='RewardExp';
Group_Plot{1,2}={       'type_1',            {'type_1'};...
                        'type_3',            {'type_6'};...
                        'type_7',            {'type_7'}};
                    
    case 'cells'
% Group_Plot{1,1}='RewardExp';
% Group_Plot{1,2}={       'CueA_Reward_posRew',              {'Cue A','Reward','LicksOutcome'};...
%                         'CueB_Omission_posRew',            {'Cue B'};...
%                         'Uncued_Reward_posRew',            {'Uncued','Reward','LicksOutcome'}};
Group_Plot{1,1}='RewardExp';
Group_Plot{1,2}={       'type_1',            {'type_1'};...
                        'type_3',            {'type_6'};...
                        'type_4',            {'type_4'}};
end
groupToPlot=Group_Plot{1,2};
%% Legends
FigTitle=[Analysis.Parameters.Files{1}];
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
nbOfPlotsX=size(groupToPlot,1);
%% Axes
% Automatic definition of axes
maxtrial=20; maxrate=10;
for i=1:nbOfPlotsX
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
PlotY_photo=Analysis.Parameters.PlotY_photo(1,:);
% maxtrial=10;

%% Plot
ScrSze=get(0,'ScreenSize');
FigSze=[ScrSze(3)*1/10 ScrSze(4)*1/10 ScrSze(3)*8/10 ScrSze(4)*8/10];
figure('Name',FigTitle,'Position', FigSze, 'numbertitle','off');

Legend=uicontrol('style','text');
set(Legend,'String',Analysis.Parameters.Legend,'Position',[10,5,500,20]); 

thisplot=1;
for i=1:nbOfPlotsX
    thistype=groupToPlot{i,1};
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
       
% Fluo AVG
    subplot(nbOfPlotsY,nbOfPlotsX,thisplot+(counterphotoplot(3)*nbOfPlotsX)); hold on;
    thisTime=Analysis.(thistype).AOD.Time(:,1);
    if cellID
        thisData=Analysis.(thistype).AOD.(cellID).DataAVG;
    else
        thisData=Analysis.(thistype).AOD.AllCells.DataAVG;
    end
    plot(thisTime,thisData,'-k');
    if thisplot==1
        ylabel(labelyFluo);
    end
    if isnan(PlotY_photo)
        axis tight;
        thisPlotY_photo=get(gca,'YLim');
    else
        thisPlotY_photo=PlotY_photo;
        ylim(thisPlotY_photo);
    end
    xlim(xTime);
    xlabel(labelx);   
    
% Nidaq Raster
    subplot(nbOfPlotsY,nbOfPlotsX,[thisplot+(counterphotoplot(1)*nbOfPlotsX) thisplot+(counterphotoplot(2)*nbOfPlotsX)]); hold on;
    yrasternidaq=1:Analysis.(thistype).nTrials;

    thisTime=Analysis.(thistype).AOD.Time(:,1);
    if cellID
        thisData=Analysis.(thistype).AOD.(cellID).Data;
    else
        thisData=Analysis.(thistype).AOD.AllCells.DataTrials;
    end
    
    thisData=thisData(thisTime>xTime(1) & thisTime<xTime(2),:);
    thisTime=thisTime(thisTime>xTime(1) & thisTime<xTime(2));
    
    imagesc(thisTime,yrasternidaq,thisData',thisPlotY_photo);
    plot(Analysis.(thistype).Time.Outcome(:,1),1:Analysis.(thistype).nTrials,'.r','MarkerSize',4);
    plot(Analysis.(thistype).Time.Cue(:,1),1:Analysis.(thistype).nTrials,'.m','MarkerSize',4);
    if thisplot==nbOfPlotsX
        pos=get(gca,'pos');
        c=colorbar('location','eastoutside','position',[pos(1)+pos(3)+0.001 pos(2) 0.01 pos(4)]);
        c.Label.String = labelyFluo;
    end
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YDir','reverse');
    
     
    counterphotoplot=counterphotoplot+3;
 
end
    thisplot=thisplot+1;
end
end