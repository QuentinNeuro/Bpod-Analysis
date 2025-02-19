function Analysis=AB_TrialTypes_FiltersAndPlot(Analysis)
%This function sorts the trials based on trial type numbers (A_FilterTrialType and AP_DataSort functions)
%and generates %two different summary plots (AP_PlotData and AP_PlotSummary)
%
%function designed by Quentin 2017

%% Sort Data according to the trial type number
Analysis=AB_FilterTrialType(Analysis);
ttNbs=unique(Analysis.AllData.TrialTypes);
for i=1:Analysis.Parameters.Behavior.nbOfTrialTypes
    theseTypes{i}=sprintf('type_%.0d',ttNbs(i));
    Analysis=AB_DataSort(Analysis,theseTypes{i});
    Analysis.(theseTypes{i}).Name=Analysis.Parameters.Behavior.TrialNames{ttNbs(i)};
end
% figure folder
if isfolder(Analysis.Parameters.DirFig)==0
    mkdir(Analysis.Parameters.DirFig);
end
%% Figure
if Analysis.Parameters.Plot.TrialTypes
    Analysis=AB_PlotData(Analysis,'TrialTypes',theseTypes);
    saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Plot.Legend '_AllData.png']);
end
end
