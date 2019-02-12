function AP_PlotSummary_filter(Analysis,Title,Group,channelnb)

thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{channelnb}));
FigTitle=sprintf('Analysis-Plot %s %s',char(Analysis.Parameters.PhotoChNames{channelnb}),Title);

%% Plot Parameters
nboftypes=length(Group);
color4plot={'-k';'-b';'-r';'-g';'-c';'-c';'-k'};
Title=strrep(Title,'_',' ');
labelx='Time (sec)';   
xTime=[Analysis.Parameters.PlotEdges(1) Analysis.Parameters.PlotEdges(2)];
xtickvalues=linspace(xTime(1),xTime(2),5);
transparency=Analysis.Parameters.Transparency;
labely1='Licks Rate (Hz)';
maxrate=10;
if Analysis.Parameters.Zscore
    labelyFluo='Z-scored Fluo';
else
    labelyFluo='DF/Fo (%)';
end
NidaqRange=Analysis.Parameters.NidaqRange;

%% Figure
scrsz = get(groot,'ScreenSize');
FigureLegend=sprintf('%s_%s',Analysis.Parameters.Name,Analysis.Parameters.Rig);
figData.figure=figure('Name',FigTitle,'Position', [25 25 scrsz(3)/4 scrsz(4)-150], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

%% Group plot
k=1;
for i=1:nboftypes
	thistype=Group{i};
if Analysis.(thistype).nTrials~=0
    handle.title{k}=sprintf('%s (%.0d)',Analysis.(thistype).Name,Analysis.(thistype).nTrials);
    subplot(2,1,1); hold on;
    hs=shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,color4plot{k},transparency); 
    hp(k)=hs.mainLine;
	subplot(2,1,2); hold on;
    shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,color4plot{k},transparency);
	k=k+1;
end
end
% Makes Plot pretty
    subplot(2,1,1); hold on;
	ylabel(labely1);
    plot([0 0],[0 maxrate],'-r');
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',[0 maxrate]);
	title(Title);
    legend(hp,handle.title,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
    
    subplot(2,1,2); hold on;
	ylabel(labelyFluo);
    xlabel(labelx);
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