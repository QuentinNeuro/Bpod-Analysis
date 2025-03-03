function Analysis=AB_OptoTuning_FiltersAndPlot(Analysis)
%This function can be used to generates filters based on behavior or states
%and to plot single and summary figures.

%% Generates filters
% Groups
TrialTypeNames=Analysis.Parameters.Behavior.TrialNames;
for i=1:length(TrialTypeNames)
    Analysis=AB_FilterTrialName(Analysis,TrialTypeNames{i});
end

%% Sort and plot Filter
if Analysis.Parameters.Filters.Sort
    for i=1:length(TrialTypeNames)
        Analysis=AB_DataSort(Analysis,TrialTypeNames{i});
        if Analysis.Parameters.Plot.FiltersSingle && Analysis.(TrialTypeNames{i}).nTrials>0
                AB_PlotData_Filter(Analysis,TrialTypeNames{i});
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Legend TrialTypeNames{i} '.png']);
                if Analysis.Parameters.Illustrator
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Legend TrialTypeNames{i}],'epsc');
                end
        end
    end
end

