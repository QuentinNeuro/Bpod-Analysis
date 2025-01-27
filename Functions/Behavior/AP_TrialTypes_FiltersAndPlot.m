function Analysis=AP_TrialTypes_FiltersAndPlot(Analysis)
%This function sorts the trials based on trial type numbers (A_FilterTrialType and AP_DataSort functions)
%and generates %two different summary plots (AP_PlotData and AP_PlotSummary)
%
%function designed by Quentin 2017

%% Sort Data according to the trial type number
Analysis=A_FilterTrialType(Analysis);
for i=1:Analysis.Parameters.Behavior.nbOfTrialTypes
    thistype=sprintf('type_%.0d',i);
    Analysis=AP_DataSort(Analysis,thistype);
    Analysis.(thistype).Name=Analysis.Parameters.Behavior.TrialNames{i};
end
% figure folder
if isfolder(Analysis.Parameters.DirFig)==0
    mkdir(Analysis.Parameters.DirFig);
end
%% Summary Plot 1
if Analysis.Parameters.Plot.TrialTypes
    Analysis=AP_PlotData(Analysis);
    saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Plot.Legend '_AllData.png']);
end
end
