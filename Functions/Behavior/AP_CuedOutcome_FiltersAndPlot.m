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
% Licks
Analysis=A_FilterLick(Analysis,'LicksCue','Cue',Analysis.Parameters.LicksCue);
Analysis=A_FilterLick(Analysis,'LicksOutcome','Outcome',Analysis.Parameters.LicksOutcome);
% Wheel
Analysis=A_FilterRunning(Analysis,'Run',Analysis.Parameters.WheelState,Analysis.Parameters.WheelThreshold);
% Pupil
Analysis=A_FilterPupil(Analysis,'Pupil',Analysis.Parameters.PupilState,Analysis.Parameters.PupilThreshold);
Analysis=A_FilterPupil(Analysis,'CuePupil','Cue',2);
Analysis=A_FilterPupilNaNCheck(Analysis,'PupilNaN',25);
% Sequence
Analysis=A_FilterAfollowsB(Analysis,'Reward_After_Punish','Reward','Punish');

%% Definitions of meta filters
[Group_Plot,Group_Corr,Group_Perf]=AP_CuedOutcome_GroupToPlot(Analysis);
%% Performance calculation
try
Analysis=AP_Performance(Analysis,Group_Perf);
catch
    disp('Something is wrong with the performance index')
    Analysis.Performance.Decision=NaN;
    Analysis.Performance.testIO=NaN;
end

%% Sort and plot Filter
if Analysis.Parameters.SortFilters
for i=1:size(Group_Plot,1)
    Title=Group_Plot{i,1};
    MetaFilterGroup=cell(size(Group_Plot{i,2},1),1);
    for j=1:size(Group_Plot{i,2},1)
        MetaFilter=Group_Plot{i,2}{j,1};
        Filters=Group_Plot{i,2}{j,2};
        MetaFilterGroup{j}=MetaFilter;
        [Analysis,thisFilter]=A_FilterMeta(Analysis,MetaFilter,Filters);
        Analysis=AP_DataSort(Analysis,MetaFilter,thisFilter);
        if Analysis.Parameters.PlotFiltersSingle && Analysis.(MetaFilter).nTrials>0
                AP_PlotData_filter(Analysis,MetaFilter);
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Legend MetaFilter '.png']);
                if Analysis.Parameters.Illustrator
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Legend MetaFilter],'epsc');
                end
        end
        clear thisFilter
    end
    if Analysis.Parameters.PlotFiltersSummary
        AP_PlotSummary_filter(Analysis,Title,MetaFilterGroup);
        phototitlelabel=[];
        for thisCh=1:length(Analysis.Parameters.PhotoCh)
            phototitlelabel=[phototitlelabel '_' Analysis.Parameters.PhotoChNames{thisCh}];
        end
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Legend Title phototitlelabel '.png']);
        if Analysis.Parameters.Illustrator
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Legend Title phototitlelabel],'epsc');
        end
    end
end
end
%% Correlations
if Analysis.Parameters.PlotFiltersBehavior
for i=1:size(Group_Corr,1)
    Title=Group_Corr{i,1};
    MetaFilterGroup=cell(size(Group_Corr{i,2},1),1);
    for j=1:size(Group_Corr{i,2},1)
        MetaFilter=Group_Corr{i,2}{j,1};
        Filters=Group_Corr{i,2}{j,2};
        MetaFilterGroup{j}=MetaFilter;
        [Analysis,thisFilter]=A_FilterMeta(Analysis,MetaFilter,Filters);
        Analysis=AP_DataSort(Analysis,MetaFilter,thisFilter);
        if Analysis.(MetaFilter).nTrials && Analysis.Parameters.Photometry
            for thisCh=1:length(Analysis.Parameters.PhotoCh)
                AP_PlotData_Filter_corrDFF(Analysis,MetaFilter,thisCh);
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Legend MetaFilter char(Analysis.Parameters.PhotoChNames{thisCh}) '.png']);
                if Analysis.Parameters.Illustrator
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Legend MetaFilter char(Analysis.Parameters.PhotoChNames{thisCh})],'epsc');
                end
            end
        end
        clear thisFilter
    end
    if Analysis.Parameters.Photometry
    for thisCh=1:length(Analysis.Parameters.PhotoCh)
        AP_PlotSummary_Filter_corrDFF(Analysis,Title,MetaFilterGroup,thisCh);
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Legend Title char(Analysis.Parameters.PhotoChNames{thisCh}) '.png']);
        if Analysis.Parameters.Illustrator
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Legend Title char(Analysis.Parameters.PhotoChNames{thisCh})],'epsc');
        end
    end
    end
end
end

%% AOD
if Analysis.Parameters.AOD.AOD
    Analysis=AP_CuedOutcome_FiltersAndPlot_AOD(Analysis);
end

%% Spikes Analysis
% TrialEvents
% if Analysis.Parameters.TE4CellBase
%     CuedEvents=A_makeTrialEvents_CuedOutcome(Analysis);
%     save('CuedEvents','CuedEvents');
% end
% 
% Figures
if Analysis.Parameters.Spikes.Spikes && Analysis.Parameters.Spikes.Figure
    for c=1:Analysis.Parameters.Spikes.nCells
        AP_CuedOutcome_FiltersAndPlot_Spikes(Analysis,c);
    end
end