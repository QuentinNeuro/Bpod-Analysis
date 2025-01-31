function Analysis=AP_CuedOutcome_FiltersAndPlot(Analysis)
%This function can be used to generates filters based on behavior or states
%and to plot single and summary figures.
%
%function designed by Quentin 2017

%% Generates filters
% Groups
FilterNames={'Cue A','Cue B','Uncued','Reward','Punish','Omission','Cue C'};
for i=1:length(FilterNames)
    Analysis=A_FilterTrialName(Analysis,FilterNames{i});
end
% CS/NS matching
Analysis=A_FilterCNSMatch(Analysis);
% Licks
Analysis=A_FilterLick(Analysis,'LicksCue','Cue',Analysis.Parameters.Filters.LicksCue);
Analysis=A_FilterLick(Analysis,'LicksOutcome','Outcome',Analysis.Parameters.Filters.LicksOutcome);
% Wheel
Analysis=A_FilterRunning(Analysis,'Run',Analysis.Parameters.Filters.WheelState,Analysis.Parameters.Filters.WheelThreshold);
% Pupil
Analysis=A_FilterPupil(Analysis,'Pupil',Analysis.Parameters.Filters.PupilState,Analysis.Parameters.Filters.PupilThreshold);
Analysis=A_FilterPupil(Analysis,'CuePupil','Cue',2);
Analysis=A_FilterPupilNaNCheck(Analysis,'PupilNaN',25);
% Sequence
Analysis=A_FilterAfollowsB(Analysis,'Reward_After_Punish','Reward','Punish');
% Optogenetics
if Analysis.Parameters.Stimulation.Stimulation
    Analysis=A_FilterTrialName(Analysis,'Stim');
    Analysis.Filters.StimInv=~Analysis.Filters.Stim;
end

%% Definitions of meta filters
[Group_Plot,Group_Corr,Group_Perf]=AP_CuedOutcome_FilterGroups(Analysis);
%% Performance calculation
try
Analysis=AP_Performance(Analysis,Group_Perf);
catch
    disp('Something is wrong with the performance index')
    Analysis.Performance.Decision=NaN;
    Analysis.Performance.testIO=NaN;
end

%% Sort and plot Filter
if Analysis.Parameters.Filters.Sort
for i=1:size(Group_Plot,1)
    Title=Group_Plot{i,1};
    MetaFilterGroup={};
    for j=1:size(Group_Plot{i,2},1)
        MetaFilter=Group_Plot{i,2}{j,1};
        Filters=Group_Plot{i,2}{j,2};
        MetaFilterGroup{j}=MetaFilter;
        [Analysis,thisFilter]=A_FilterMeta(Analysis,MetaFilter,Filters);
        Analysis=AP_DataSort(Analysis,MetaFilter,thisFilter);
        if Analysis.Parameters.Plot.FiltersSingle
            AP_PlotData_Filter(Analysis,MetaFilter);
            saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Plot.Legend MetaFilter '.png']);
            if Analysis.Parameters.Plot.Illustrator
            saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Plot.Legend MetaFilter],'epsc');
            end
        end
        clear thisFilter
    end
    if Analysis.Parameters.Plot.FiltersSummary
        AP_PlotData_Filter_Summary(Analysis,Title,MetaFilterGroup);
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Plot.Legend Title '.png']);
        if Analysis.Parameters.Plot.Illustrator
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Plot.Legend Title],'epsc');
        end
    end
end
end
%% Correlations - probably not working
if Analysis.Parameters.Plot.FiltersBehavior
for i=1:size(Group_Corr,1)
    Title=Group_Corr{i,1};
    MetaFilterGroup=cell(size(Group_Corr{i,2},1),1);
    for j=1:size(Group_Corr{i,2},1)
        MetaFilter=Group_Corr{i,2}{j,1};
        Filters=Group_Corr{i,2}{j,2};
        MetaFilterGroup{j}=MetaFilter;
        [Analysis,thisFilter]=A_FilterMeta(Analysis,MetaFilter,Filters);
        Analysis=AP_DataSort(Analysis,MetaFilter,thisFilter);
        if Analysis.(MetaFilter).nTrials && Analysis.Parameters.Photometry.Photometry
            for thisCh=1:size(Analysis.Parameters.Photometry.Channels,2)
                AP_PlotData_Corr(Analysis,MetaFilter,thisCh);
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Plot.Legend MetaFilter '.png']);
                if Analysis.Parameters.Plot.Illustrator
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Plot.Legend MetaFilter],'epsc');
                end
            end
        end
        clear thisFilter
    end
    if Analysis.Parameters.Photometry.Photometry
    for thisCh=1:size(Analysis.Parameters.Photometry.Channels,2)
        AP_PlotData_Corr_Summary(Analysis,Title,MetaFilterGroup,thisCh);
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Plot.Legend Title '.png']);
        if Analysis.Parameters.Illustrator
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Plot.Legend Title],'epsc');
        end
    end
    end
end
end

%% SingleCells
if Analysis.Parameters.nCells>0 && Analysis.Parameters.Filters.Cells
    Analysis=AP_CuedOutcome_FiltersAndPlot_Cells(Analysis);
end

end