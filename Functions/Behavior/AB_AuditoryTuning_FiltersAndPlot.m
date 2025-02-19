function AB_AuditoryTuning_FiltersAndPlot(Analysis)
global TuningYMAX;
if Analysis.Parameters.Photometry.Photometry
    nbOfTrialTypes=Analysis.Parameters.Behavior.nbOfTrialTypes;
    trialNames=Analysis.Parameters.Behavior.TrialNames;
%% Filters
WNtypes=AB_NameToTrialNumber(Analysis,'White');
ChirpTypes=AB_NameToTrialNumber(Analysis,'to');
if nbOfTrialTypes>3
    ToneTypes=4:1:nbOfTrialTypes;
else
    ToneTypes=NaN;
end

%% Data
TuningYAVG=NaN(nbOfTrialTypes,1);
TuningYMAX=NaN(nbOfTrialTypes,1);
TuningYSEM=NaN(nbOfTrialTypes,1);
TuningX=1:1:nbOfTrialTypes;

%% Plot Parameters
labelx='Time (sec)';   
xTime=Analysis.Parameters.Plot.xTime;
xtickvalues=linspace(xTime(1),xTime(2),5);
labelyFluo=Analysis.Parameters.Data.Normalize;

color4plot={'-k';'-b';'-r';'-g';'-c';'-m';'-y'};
transparency=Analysis.Parameters.Plot.Transparency;
PlotY_photo=Analysis.Parameters.Plot.yData;

for thisCh=1:size(Analysis.Parameters.Photometry.Channels,2)
    thisChStruct=sprintf('Photo_%s',Analysis.Parameters.Photometry.Channels{thisCh});
    FigTitle=['Auditory Tuning Curve' Analysis.Parameters.Photometry.Channels{thisCh}];
    
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
        hs=shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DataAVG,Analysis.(thistype).(thisChStruct).DataSEM,color4plot{counter},transparency);
        hp(counter)=hs.mainLine;
        thislegend{counter}=Analysis.(thistype).Name;
        counter=counter+1;
        TuningYAVG(i)=Analysis.(thistype).(thisChStruct).CueAVG_AVG;
        TuningYMAX(i)=Analysis.(thistype).(thisChStruct).CueAVGZ_AVG; %AVG_MAXZ %AVGZ_AVG
        TuningYSEM(i)=Analysis.(thistype).(thisChStruct).CueAVG_SEM;
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
        hs=shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DataAVG,Analysis.(thistype).(thisChStruct).DataSEM,color4plot{counter},transparency);
        hp(counter)=hs.mainLine;
        thislegend{counter}=Analysis.(thistype).Name;
        counter=counter+1;
        TuningYAVG(i)=Analysis.(thistype).(thisChStruct).CueAVG_AVG;
        TuningYMAX(i)=Analysis.(thistype).(thisChStruct).CueMAX_AVG;
        TuningYSEM(i)=Analysis.(thistype).(thisChStruct).CueAVG_SEM;
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
        hs=shadedErrorBar(Analysis.(thistype).(thisChStruct).Time(1,:),Analysis.(thistype).(thisChStruct).DataAVG,Analysis.(thistype).(thisChStruct).DataSEM,color4plot{counter},transparency);
        hp(counter)=hs.mainLine;
        thislegend{counter}=Analysis.(thistype).Name;
        counter=counter+1;
        TuningYAVG(i)=Analysis.(thistype).(thisChStruct).CueAVG_AVG;
        TuningYMAX(i)=Analysis.(thistype).(thisChStruct).CueMAX_AVG;
        TuningYSEM(i)=Analysis.(thistype).(thisChStruct).CueAVG_SEM;
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
set(gca,'XLim',[0 nbOfTrialTypes+1],...
                                        'XTick',TuningX,'XTickLabel',trialNames,'XTickLabelRotation', 15);
title('Auditory Tuning'); ylabel(labelyFluo);
plot(TuningX,TuningYMAX,'sr'); 
plot(TuningX,TuningYAVG,'sb'); 
plot([0 nbOfTrialTypes+1],[0 0],'-g');
% Bleach
subplot(2,3,6); hold on
title('Bleaching'); ylabel('Norm. DF/F'); xlabel('Trial Number');
plot(Analysis.AllData.(thisChStruct).BaselineAVG./mean(Analysis.AllData.(thisChStruct).BaselineAVG(1:2)));

%% Save
saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name '_AudTun' thisChStruct '.png']);
if Analysis.Parameters.Plot.Illustrator
saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name '_AudTun' thisChStruct],'epsc');
end

end
end
end