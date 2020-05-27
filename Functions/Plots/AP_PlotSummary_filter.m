function AP_PlotSummary_filter(Analysis,Title,Group)


%% Plot Parameters
nboftypes=length(Group);
color4plot={'-k';'-b';'-r';'-g';'-c';'-c';'-k'};
Title=strrep(Title,'_',' ');
labelx='Time (sec)';   
xTime=Analysis.Parameters.PlotX;
xtickvalues=linspace(xTime(1),xTime(2),5);
transparency=Analysis.Parameters.Transparency;
labely1='Licks Rate (Hz)';
maxrate=10;
nbofsubplots=1;
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    nbofsubplots=nbofsubplots+1;
if Analysis.Parameters.Zscore
    labelyFluo{thisCh}=sprintf('Z-scored Fluo - %s',Analysis.Parameters.PhotoChNames{thisCh});
else
    labelyFluo{thisCh}=sprintf('DF/Fo - %s',Analysis.Parameters.PhotoChNames{thisCh});
end
end
PlotY_photo=Analysis.Parameters.PlotY_photo;

%% Figure
phototitlelabel=[];
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    phototitlelabel=[phototitlelabel '_' Analysis.Parameters.PhotoChNames{thisCh}];
end
FigTitle=[Title '_' phototitlelabel];
scrsz = get(groot,'ScreenSize');

figure('Name',FigTitle,'Position', [25 25 scrsz(3)/4 scrsz(4)-150], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',Analysis.Parameters.Legend,'Position',[10,5,500,20]); 

%% Group plot
k=1;
for i=1:nboftypes
	thistype=Group{i};
if Analysis.(thistype).nTrials~=0
    handle.title{k}=sprintf('%s (%.0d)',Analysis.(thistype).Name,Analysis.(thistype).nTrials);
    subplot(nbofsubplots,1,1); hold on;
    hs=shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,color4plot{k},transparency); 
    hp(k)=hs.mainLine;
    for thisCh=1:length(Analysis.Parameters.PhotoCh)
        thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
        subplot(nbofsubplots,1,thisCh+1); hold on;
        shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,color4plot{k},transparency);
    end
    k=k+1;
end
end
% Makes Plot pretty
    subplot(nbofsubplots,1,1); hold on;
	ylabel(labely1);
    plot([0 0],[0 maxrate],'-r');
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate]);
	title(Title);
    legend(hp,handle.title,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
    
    for thisCh=1:length(Analysis.Parameters.PhotoCh)
        subplot(nbofsubplots,1,thisCh+1); hold on;
        ylabel(labelyFluo{thisCh});
        xlabel(labelx);
        if isnan(PlotY_photo(thisCh,:))
            axis tight
            PlotY_photo(thisCh,:)=get(gca,'YLim');
        end
        plot([0 0],PlotY_photo(thisCh,:),'-r');
        plot(Analysis.AllData.Time.Cue(1,:),[PlotY_photo(thisCh,2) PlotY_photo(thisCh,2)],'-b','LineWidth',2);
        set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',PlotY_photo(thisCh,:));
    end 
end