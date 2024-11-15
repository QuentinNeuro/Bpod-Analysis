function Analysis=AP_OptoTuning_FiltersAndPlot(Analysis)
%This function can be used to generates filters based on behavior or states
%and to plot single and summary figures.

%% Generates filters
% Groups
TrialTypeNames=Analysis.Parameters.TrialNames;
for i=1:length(TrialTypeNames)
    Analysis=A_FilterTrialName(Analysis,TrialTypeNames{i});
end

%% Sort and plot Filter
if Analysis.Parameters.SortFilters
    for i=1:length(TrialTypeNames)
        Analysis=AP_DataSort(Analysis,TrialTypeNames{i});
        if Analysis.Parameters.PlotFiltersSingle && Analysis.(TrialTypeNames{i}).nTrials>0
            AP_PlotData_filter(Analysis,TrialTypeNames{i});
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Legend TrialTypeNames{i} '.png']);
                if Analysis.Parameters.Illustrator
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Legend TrialTypeNames{i}],'epsc');
                end
        end
    end
end

