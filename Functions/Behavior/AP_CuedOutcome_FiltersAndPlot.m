function Analysis=AP_CuedOutcome_FiltersAndPlot(Analysis)
%This function can be used to generates filters based on behavior or states
%and to plot single and summary figures.
%
%function designed by Quentin 2017

%% Generates filters
% Groups
FilterNames={'Cue A','Cue B','Uncued','Reward','Punish','Omission','Cue C'};
for i=1:length(FilterNames)
    Analysis=A_FilterName(Analysis,FilterNames{i});
end
% Licks
Analysis=A_FilterLick(Analysis,'LicksCue','Cue',Analysis.Properties.LicksCue);
Analysis=A_FilterLick(Analysis,'LicksOutcome','Outcome',Analysis.Properties.LicksOutcome);
% Wheel
Analysis=A_FilterWheel(Analysis,'Run',Analysis.Properties.WheelState,Analysis.Properties.WheelThreshold);
% Pupil
Analysis=A_FilterPupil(Analysis,'Pupil',Analysis.Properties.PupilState,Analysis.Properties.PupilThreshold);
Analysis=A_FilterPupilNaNCheck(Analysis,'PupilNaN',25);
% Sequence
Analysis=A_FilterAfollowsB(Analysis,'Reward_After_Punish','Reward','Punish');

%% Sort and Plot Filtered Trials specified in AP_Filter_GroupToPlot.
if Analysis.Properties.PlotFiltersSummary || Analysis.Properties.PlotFiltersSingle
[GroupToPlot]=AP_Filter_GroupToPlot(Analysis);
for i=1:size(GroupToPlot,1)
    Title=GroupToPlot{i,1};
    MetaFilterGroup=cell(size(GroupToPlot{i,2},1),1);
    for j=1:size(GroupToPlot{i,2},1)
        MetaFilter=GroupToPlot{i,2}{j,1};
        Filters=GroupToPlot{i,2}{j,2};
        MetaFilterGroup{j}=MetaFilter;
        [Analysis,thisFilter]=A_FilterMeta(Analysis,MetaFilter,Filters);
        Analysis=AP_DataSort(Analysis,MetaFilter,thisFilter);
        if Analysis.Properties.Photometry
        if Analysis.Properties.PlotFiltersSingle && Analysis.(MetaFilter).nTrials>0
            for thisCh=1:length(Analysis.Properties.PhotoCh)
                AP_PlotData_filter(Analysis,MetaFilter,thisCh);
                saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name MetaFilter char(Analysis.Properties.PhotoChNames{thisCh}) '.png']);
                if Analysis.Properties.Illustrator
                saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name MetaFilter char(Analysis.Properties.PhotoChNames{thisCh})],'epsc');
                end
            end
        end
        end
        clear thisFilter
    end
    for thisCh=1:length(Analysis.Properties.PhotoCh)
        AP_PlotSummary_filter(Analysis,Title,MetaFilterGroup,thisCh);
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name Title char(Analysis.Properties.PhotoChNames{thisCh}) '.png']);
        if Analysis.Properties.Illustrator
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name Title char(Analysis.Properties.PhotoChNames{thisCh})],'epsc');
        end
    end
end
end
%% Behavior Filters
if Analysis.Properties.PlotFiltersBehavior
[~,GroupToPlot]=AP_Filter_GroupToPlot(Analysis);
for i=1:size(GroupToPlot,1)
    Title=GroupToPlot{i,1};
    MetaFilterGroup=cell(size(GroupToPlot{i,2},1),1);
    for j=1:size(GroupToPlot{i,2},1)
        MetaFilter=GroupToPlot{i,2}{j,1};
        Filters=GroupToPlot{i,2}{j,2};
        MetaFilterGroup{j}=MetaFilter;
        [Analysis,thisFilter]=A_FilterMeta(Analysis,MetaFilter,Filters);
        Analysis=AP_DataSort(Analysis,MetaFilter,thisFilter);
        if Analysis.Properties.Photometry
        if Analysis.(MetaFilter).nTrials
            for thisCh=1:length(Analysis.Properties.PhotoCh)
                AP_PlotData_Filter_corrDFF(Analysis,MetaFilter,thisCh);
                saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name MetaFilter char(Analysis.Properties.PhotoChNames{thisCh}) '.png']);
                if Analysis.Properties.Illustrator
                saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name MetaFilter char(Analysis.Properties.PhotoChNames{thisCh})],'epsc');
                end
            end
        end
        end
        clear thisFilter
    end
    if Analysis.Properties.Photometry
    for thisCh=1:length(Analysis.Properties.PhotoCh)
        AP_PlotSummary_Filter_corrDFF(Analysis,Title,MetaFilterGroup,thisCh);
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name Title char(Analysis.Properties.PhotoChNames{thisCh}) '.png']);
        if Analysis.Properties.Illustrator
        saveas(gcf,[Analysis.Properties.DirFig Analysis.Properties.Name Title char(Analysis.Properties.PhotoChNames{thisCh})],'epsc');
        end
    end
    end
end
end

%% TrialEvents
if Analysis.Properties.TE4CellBase
    CuedEvents=A_makeTrialEvents_CuedOutcome(Analysis);
    FileName=[Analysis.Properties.Name '_CuedEvents.mat'];
    DirEvents=[pwd filesep 'Events' filesep];
    if isdir(DirEvents)==0
        mkdir(DirEvents);
    end
    DirFile=[DirEvents FileName];
    save(DirFile,'CuedEvents');
    clear CuedEvents
end