function AP_AuditoryTuning_FiltersAndPlot(Analysis)

%% Filters
WNtypes=A_NameToTrialNumber(Analysis,'White');
ChirpTypes=A_NameToTrialNumber(Analysis,'to');
if Analysis.Parameters.nbOfTrialTypes>3
    ToneTypes=4:1:Analysis.Parameters.nbOfTrialTypes;
else
    ToneTypes=NaN;
end

%% Data
TuningYAVG=NaN(Analysis.Parameters.nbOfTrialTypes,1);
TuningYMAX=NaN(Analysis.Parameters.nbOfTrialTypes,1);
TuningYSEM=NaN(Analysis.Parameters.nbOfTrialTypes,1);
TuningX=1:1:Analysis.Parameters.nbOfTrialTypes;

%% Plot Parameters
labelx='Time (sec)';   
xTime=Analysis.Parameters.PlotX;
xtickvalues=linspace(xTime(1),xTime(2),5);
if Analysis.Parameters.Zscore
    labelyFluo='Z-scored Fluo';
else
    labelyFluo='DF/Fo (%)';
end
color4plot={'-k';'-b';'-r';'-g';'-c';'-m';'-y'};
transparency=Analysis.Parameters.Transparency;
PlotY_photo=Analysis.Parameters.PlotY_photo;

for thisCh=1:length(Analysis.Parameters.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
    FigTitle=['Auditory Tuning Curve' char(Analysis.Parameters.PhotoCh{thisCh})];
    
%% Plot
FigureLegend=sprintf('%s_%s',Analysis.Parameters.Name,Analysis.Parameters.Rig);
figData.figure=figure('Name',FigTitle,'Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 
% WhiteNoise
subplot(2,3,1); hold on;
title('White Noise');
xlabel(labelx);
ylabel(labelyFluo);
if isnan(WNtypes)==false
    counter=1;
    thislegend=cell(length(WNtypes),1);
    for i=WNtypes
        thistype=sprintf('type_%.0d',i);
        hs=shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,color4plot{counter},transparency);
        hp(counter)=hs.mainLine;
        thislegend{counter}=Analysis.(thistype).Name;
        counter=counter+1;
        TuningYAVG(i)=Analysis.(thistype).(thisChStruct).CueAVG;
        TuningYMAX(i)=Analysis.(thistype).(thisChStruct).CueMax;
        TuningYSEM(i)=Analysis.(thistype).(thisChStruct).CueSEM;
    end
    legend(hp,thislegend,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
    if ~isnan(PlotY_photo(thisCh,:))
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',PlotY_photo(thisCh,:));
    plot([0 0],PlotY_photo(thisCh,:),'-r');
    else
    axis tight
    set(gca,'XLim',xTime,'XTick',xtickvalues);
    thisYLim=get(gca,'YLim');
    plot([0 0],thisYLim,'-r');
    end  
end

% Chirp
subplot(2,3,2); hold on
xlabel(labelx);
title('Chirp');
if isnan(ChirpTypes)==false
    counter=1;
    thislegend=cell(length(ChirpTypes),1);
    for i=ChirpTypes
        thistype=sprintf('type_%.0d',i);
        hs=shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,color4plot{counter},transparency);
        hp(counter)=hs.mainLine;
        thislegend{counter}=Analysis.(thistype).Name;
        counter=counter+1;
        TuningYAVG(i)=Analysis.(thistype).(thisChStruct).CueAVG;
        TuningYMAX(i)=Analysis.(thistype).(thisChStruct).CueMax;
        TuningYSEM(i)=Analysis.(thistype).(thisChStruct).CueSEM;
    end
	legend(hp,thislegend,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
        if ~isnan(PlotY_photo(thisCh,:))
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',PlotY_photo(thisCh,:));
    plot([0 0],PlotY_photo(thisCh,:),'-r');
    else
    axis tight
    set(gca,'XLim',xTime,'XTick',xtickvalues);
    thisYLim=get(gca,'YLim');
    plot([0 0],thisYLim,'-r');
    end  
end

% pure tones
subplot(2,3,3); hold on
xlabel(labelx);
title('Pure Tones');
if isnan(ToneTypes)==false
    counter=1;
    thislegend=cell(length(ToneTypes),1);
    for i=ToneTypes
        thistype=sprintf('type_%.0d',i);
        hs=shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DFFAVG,Analysis.(thistype).(thisChStruct).DFFSEM,color4plot{counter},transparency);
        hp(counter)=hs.mainLine;
        thislegend{counter}=Analysis.(thistype).Name;
        counter=counter+1;
        TuningYAVG(i)=Analysis.(thistype).(thisChStruct).CueAVG;
        TuningYMAX(i)=Analysis.(thistype).(thisChStruct).CueMax;
        TuningYSEM(i)=Analysis.(thistype).(thisChStruct).CueSEM;
    end
	legend(hp,thislegend,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
        if ~isnan(PlotY_photo(thisCh,:))
    set(gca,'XLim',xTime,'XTick',xtickvalues,'YLim',PlotY_photo(thisCh,:));
    plot([0 0],PlotY_photo(thisCh,:),'-r');
    else
    axis tight
    set(gca,'XLim',xTime,'XTick',xtickvalues);
    thisYLim=get(gca,'YLim');
    plot([0 0],thisYLim,'-r');
    end  
end


% AudTuning curve
subplot(2,3,[4 5]); hold on
set(gca,'XLim',[0 Analysis.Parameters.nbOfTrialTypes+1],...
                                        'XTick',TuningX,'XTickLabel',Analysis.Parameters.TrialNames,'XTickLabelRotation', 15);
title('Auditory Tuning'); ylabel(labelyFluo);
plot(TuningX,TuningYMAX,'sr'); 
plot(TuningX,TuningYAVG,'sb'); 
plot([0 Analysis.Parameters.nbOfTrialTypes+1],[0 0],'-g');
% Bleach
subplot(2,3,6); hold on
title('Bleaching'); ylabel('Norm. DF/F'); xlabel('Trial Number');
plot(Analysis.AllData.(thisChStruct).Bleach);

%% Save
saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name '_AudTun' char(Analysis.Parameters.PhotoCh{thisCh}) '.png']);
if Analysis.Parameters.Illustrator
saveas(gcf,[DAnalysis.Parameters.DirFig Analysis.Parameters.Name '_AudTun' char(Analysis.Parameters.PhotoCh{thisCh})],'epsc');
end

end
end