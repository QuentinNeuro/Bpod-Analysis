function Analysis=AP_TrialTypes_FiltersAndPlot(Analysis,DefaultParam)
%This function sorts the trials based on trial type numbers (A_FilterTrialType and AP_DataSort functions)
%and generates %two different summary plots (AP_PlotData and AP_PlotSummary)
%
%function designed by Quentin 2017

%% Sort Data according to the trial type number
Analysis=A_FilterTrialType(Analysis);
for i=1:Analysis.Properties.nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
    Analysis=AP_DataSort(Analysis,thistype);
    Analysis.(thistype).Name=Analysis.Properties.TrialNames{i};
end
% figure folder
Analysis.Properties.DirFig=[DefaultParam.PathName Analysis.Properties.Phase filesep];
if isdir(Analysis.Properties.DirFig)==0
    mkdir(Analysis.Properties.DirFig);
end
%% Summary Plot 1
if Analysis.Properties.PlotSummary1==1
    if Analysis.Properties.Photometry==0
        Analysis=AP_PlotData(Analysis,'nophoto');
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name '_AllData.png']);
    else 
    for thisCh=1:length(Analysis.Properties.PhotoCh)
        Analysis=AP_PlotData(Analysis,thisCh);
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name '_AllData' char(Analysis.Properties.PhotoChNames{thisCh}) '.png']);
        if Analysis.Properties.Illustrator
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name '_AllData' char(Analysis.Properties.PhotoChNames{thisCh})],'epsc');
        end
    end
    end
end

%% Summary Plot 2 (Only if Photometry)
if Analysis.Properties.Photometry
    if Analysis.Properties.PlotSummary2==1
        for thisCh=1:length(Analysis.Properties.PhotoCh)
    if contains(Analysis.Properties.Phase,'Pun')
        AP_PlotSummary(Analysis,thisCh,'Cue A','Cue B','Reward','Punish');
    else
        AP_PlotSummary(Analysis,thisCh,'Cue A','Cue B','Reward');
    end
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name '_Summary' char(Analysis.Properties.PhotoChNames{thisCh}) '.png']);
        if Analysis.Properties.Illustrator
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name '_Summary' char(Analysis.Properties.PhotoChNames{thisCh}) ],'epsc');
        end
        end
    end
end

end
