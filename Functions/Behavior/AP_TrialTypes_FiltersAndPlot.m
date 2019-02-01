function Analysis=AP_TrialTypes_FiltersAndPlot(Analysis,LauncherParam)
%This function sorts the trials based on trial type numbers (A_FilterTrialType and AP_DataSort functions)
%and generates %two different summary plots (AP_PlotData and AP_PlotSummary)
%
%function designed by Quentin 2017

%% Sort Data according to the trial type number
Analysis=A_FilterTrialType(Analysis);
for i=1:Analysis.Parameters.nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
    Analysis=AP_DataSort(Analysis,thistype);
    Analysis.(thistype).Name=Analysis.Parameters.TrialNames{i};
end
% figure folder
Analysis.Parameters.DirFig=[LauncherParam.PathName Analysis.Parameters.Phase filesep];
if isdir(Analysis.Parameters.DirFig)==0
    mkdir(Analysis.Parameters.DirFig);
end
%% Summary Plot 1
if Analysis.Parameters.PlotSummary1==1
    Analysis=AP_PlotData(Analysis);
    phototitlelabel=[];
    for thisCh=1:length(Analysis.Parameters.PhotoCh)
        phototitlelabel=[phototitlelabel '_' char(Analysis.Parameters.PhotoChNames{thisCh})];
    end
    saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name '_AllData' phototitlelabel '.png']);
end

%% Summary Plot 2 (Only if Photometry)
if Analysis.Parameters.Photometry
    if Analysis.Parameters.PlotSummary2==1
        for thisCh=1:length(Analysis.Parameters.PhotoCh)
        AP_PlotSummary(Analysis,thisCh,'Cue A','Cue B','Reward','Punish');
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name '_Summary' char(Analysis.Parameters.PhotoChNames{thisCh}) '.png']);
        if Analysis.Parameters.Illustrator
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name '_Summary' char(Analysis.Parameters.PhotoChNames{thisCh}) ],'epsc');
        end
        end
    end
end

end
