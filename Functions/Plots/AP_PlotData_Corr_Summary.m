function AP_PlotData_Corr_Summary(Analysis,Title,Group,channelnb)

thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{channelnb}));
FigTitle=sprintf('Analysis-Plot %s %s',char(Analysis.Parameters.PhotoCh{channelnb}),Title);

%% Plot Parameters
nboftypes=length(Group);
color4plot={'k';'b';'r';'g';'c';'c';'k'};

Title=strrep(Title,'_',' ');
labelx='Time (s)';   
xTime=Analysis.Parameters.PlotX;
xtickvalues=linspace(xTime(1),xTime(2),5);
transparency=Analysis.Parameters.Transparency;

%% Figure
scrsz = get(groot,'ScreenSize');
figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',Analysis.Parameters.Legend,'Position',[10,5,500,20]); 

plotIndex=[1 6 NaN NaN];
%% Group plot
k=1;
for i=1:nboftypes
	thistype=Group{i};
if Analysis.(thistype).nTrials~=0
    titleLegend{k}=sprintf('%s (%.0d)',Analysis.(thistype).Name,Analysis.(thistype).nTrials);
% row 1 DF/Fo
    subplot(4,5,1); hold on;
    shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,['-' color4plot{k}],transparency);
    xlabel(labelx); ylabel('DF/Fo(%)');
    subplot(4,5,2); hold on;
    plot(Analysis.(thistype).(thisChStruct).OutcomeStat,Analysis.(thistype).(thisChStruct).CueStat,'o','markerSize',5,'MarkerEdgeColor',color4plot{k});
    plot(Analysis.(thistype).(thisChStruct).OutcomeStat,Analysis.(thistype).(thisChStruct).Fit.YFit,['-' color4plot{k}]);
    xlabel('Outcome DF/Fo (%)'); ylabel('Cue DF/Fo (%)');
    axis tight
    subplot(4,5,3); hold on;
    title('Cumul. Cue');
    plot(Analysis.(thistype).(thisChStruct).Cumul.CueSort,Analysis.(thistype).(thisChStruct).Cumul.Prob,['-' color4plot{k}]);
    axis tight
    ylim([0 1]);
    xlabel('DF/Fo(%)')
    subplot(4,5,4); hold on;
    title('Cumul. Outcome');
    plot(Analysis.(thistype).(thisChStruct).Cumul.OutcomeSort,Analysis.(thistype).(thisChStruct).Cumul.Prob,['-' color4plot{k}]);
    axis tight
    ylim([0 1]);
    xlabel('DF/Fo(%)')
% row 2 Licks 
    subplot(4,5,6); hold on;
    shadedErrorBar(Analysis.(thistype).Licks.Bin, Analysis.(thistype).Licks.AVG, Analysis.(thistype).Licks.SEM,['-' color4plot{k}],transparency); 
    axis tight
	xlabel(labelx); ylabel('Licks (Hz)');
    subplot(4,5,7); hold on;
    title('Outcome Fluo vs Cue');
    x=Analysis.(thistype).(thisChStruct).OutcomeStat;y=Analysis.(thistype).Licks.Cue;
    model=fitlm(x,y);
    plot(x,y,'o','markerSize',5,'MarkerEdgeColor',color4plot{k});
    plot(x,model.Fitted,['-' color4plot{k}]);
    axis tight
    xlabel('Outcome DF/Fo (%)'); ylabel('Cue Licks (Hz)');
   
	subplot(4,5,8); hold on;
    title('Cue Fluo vs Cue');
    x=Analysis.(thistype).(thisChStruct).CueStat;y=Analysis.(thistype).Licks.Cue;
    model=fitlm(x,y);
    plot(x,y,'o','markerSize',5,'MarkerEdgeColor',color4plot{k});
    plot(x,model.Fitted,['-' color4plot{k}]);
    axis tight
    xlabel('Cue DF/Fo (%)'); ylabel('Cue Licks (Hz)');
    
    subplot(4,5,9); hold on;
    title('Outcome Fluo vs Outcome');
    x=Analysis.(thistype).(thisChStruct).OutcomeStat;y=Analysis.(thistype).Licks.Outcome;
    model=fitlm(x,y);
    plot(x,y,'o','markerSize',5,'MarkerEdgeColor',color4plot{k});
    plot(x,model.Fitted,['-' color4plot{k}]);
    axis tight
    xlabel('Outcome DF/Fo (%)'); ylabel('Outcome Licks (Hz)');
    
% row 3 Running
if Analysis.Parameters.Wheel
    plotIndex(3)=11;
    subplot(4,5,11); hold on;
    shadedErrorBar(Analysis.(thistype).Time.Wheel,Analysis.(thistype).Wheel.DistanceAVG,Analysis.(thistype).Wheel.DistanceSEM,['-' color4plot{k}],transparency);
    axis tight
    xlabel(labelx); ylabel('Run (cm)');
    
    subplot(4,5,12); hold on;
    x=Analysis.(thistype).(thisChStruct).OutcomeStat; y=Analysis.(thistype).Wheel.Cue;
    model=fitlm(x,y);
    plot(x,y,'o','markerSize',5,'MarkerEdgeColor',color4plot{k});
    plot(x,model.Fitted,['-' color4plot{k}]);
    axis tight
    xlabel('Outcome DF/Fo (%)'); ylabel('Cue Run (cm/sec)');
    
    subplot(4,5,13); hold on;
    x=Analysis.(thistype).(thisChStruct).CueStat;y=Analysis.(thistype).Wheel.Cue;
    model=fitlm(x,y);
    plot(x,y,'o','markerSize',5,'MarkerEdgeColor',color4plot{k});
    plot(x,model.Fitted,['-' color4plot{k}]);
    axis tight
    xlabel('Cue DF/Fo (%)'); ylabel('Cue Run (cm/sec)');
    
    subplot(4,5,14); hold on;
    x=Analysis.(thistype).(thisChStruct).OutcomeStat;y=Analysis.(thistype).Wheel.Outcome;
    model=fitlm(x,y);
    plot(x,y,'o','markerSize',5,'MarkerEdgeColor',color4plot{k});
    plot(x,model.Fitted,['-' color4plot{k}]);
    axis tight
    xlabel('Outcome DF/Fo (%)'); ylabel('Outcome Run (cm/sec)');
end
% row 4 Pupillometry
if Analysis.Parameters.Pupillometry  
    plotIndex(4)=16;
    subplot(4,5,16); hold on;
	shadedErrorBar(Analysis.(thistype).Time.Pupil,Analysis.(thistype).Pupil.PupilAVG,Analysis.(thistype).Pupil.PupilSEM,['-' color4plot{k}],transparency);
    axis tight
    xlabel(labelx); ylabel('Pupil DP/Po (%)');
    
    subplot(4,5,17); hold on;
    x=Analysis.(thistype).(thisChStruct).OutcomeStat;y=Analysis.(thistype).Pupil.Cue;
    model=fitlm(x,y);
    plot(x,y,'o','markerSize',5,'MarkerEdgeColor',color4plot{k});
    plot(x,model.Fitted,['-' color4plot{k}]);
    axis tight
    xlabel('Outcome DF/Fo (%)'); ylabel('Cue Pupil (%)');
    
    subplot(4,5,18); hold on;
    x=Analysis.(thistype).(thisChStruct).CueStat;y=Analysis.(thistype).Pupil.Cue;
    model=fitlm(x,y);
    plot(x,y,'o','markerSize',5,'MarkerEdgeColor',color4plot{k});
    plot(x,model.Fitted,['-' color4plot{k}]);
    axis tight
    xlabel('Cue DF/Fo (%)'); ylabel('Cue Pupil (%)');
    
    subplot(4,5,19); hold on;
    x=Analysis.(thistype).(thisChStruct).OutcomeStat;y=Analysis.(thistype).Pupil.Outcome;
    model=fitlm(x,y);
    plot(x,y,'o','markerSize',5,'MarkerEdgeColor',color4plot{k});
    plot(x,model.Fitted,['-' color4plot{k}]);
    axis tight
    xlabel('Outcome DF/Fo (%)'); ylabel('Outcome Pupil (%)');
    
end
k=k+1;
end  
end

%% Make Plot pretty
for i=1:4
    if ~isnan(plotIndex(i))
    thisSubPlot=plotIndex(i);
    subplot(4,5,thisSubPlot); hold on;
    thisYLim=get(gca,'YLim');
	plot(Analysis.(thistype).Time.Cue(1,:),[thisYLim(2) thisYLim(2)],'-b','LineWidth',1);
	plot([Analysis.(thistype).Time.Outcome(1,1) Analysis.(thistype).Time.Outcome(1,1)],thisYLim,'-b','LineWidth',1);
    set(gca,'XLim',xTime,'XTick',xtickvalues);
    end
end
subplot(4,5,1); hold on;
title(Title);
xlabel('Outcome DF/Fo (%)'); ylabel('Cue DF/Fo (%)');
subplot(4,5,4); hold on;
legend(titleLegend,'Location','southwest','FontSize',8);
legend('boxoff');
end