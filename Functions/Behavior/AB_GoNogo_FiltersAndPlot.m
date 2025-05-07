function  Analysis=AB_GoNogo_FiltersAndPlot(Analysis)
%This function can be used to generates filters based on behavior or states
%and to plot single and summary figures.
%COMMENTS TO COME
%
%function designed by Quentin 2017

%% Generates filters
% Trial types
Analysis=AB_FilterState(Analysis,'Go','Nogo');
Analysis=AB_FilterLick(Analysis,'LicksOutcome','Outcome',Analysis.Parameters.LicksOutcome);
% Wheel
Analysis=AB_FilterRunning(Analysis,'Run',Analysis.Parameters.WheelState,Analysis.Parameters.WheelThreshold);
% Pupil
Analysis=AB_FilterPupil(Analysis,'Pupil',Analysis.Parameters.PupilState,Analysis.Parameters.PupilThreshold);
Analysis=AB_FilterPupilNaNCheck(Analysis,'PupilNaN',25);

%% Plot Filters
[Group_Plot,Group_Corr]=AP_GoNogo_GroupToPlot(Analysis);

if Analysis.Parameters.PlotFiltersSummary || Analysis.Parameters.PlotFiltersSingle
for i=1:size(Group_Plot,1)
    Title=Group_Plot{i,1};
    MetaFilterGroup=cell(size(Group_Plot{i,2},1),1);
    for j=1:size(Group_Plot{i,2},1)
        MetaFilter=Group_Plot{i,2}{j,1};
        Filters=Group_Plot{i,2}{j,2};
        MetaFilterGroup{j}=MetaFilter;
        [Analysis,thisFilter]=A_FilterMeta(Analysis,MetaFilter,Filters);
        Analysis=AP_DataSort(Analysis,MetaFilter,thisFilter);
        if Analysis.Parameters.Photometry
        if Analysis.Parameters.PlotFiltersSingle && Analysis.(MetaFilter).nTrials>0
            for thisCh=1:length(Analysis.Parameters.PhotoCh)
                AP_PlotData_filter(Analysis,MetaFilter,thisCh);
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name MetaFilter char(Analysis.Parameters.PhotoChNames{thisCh}) '.png']);
                if Analysis.Parameters.Illustrator
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name MetaFilter char(Analysis.Parameters.PhotoChNames{thisCh})],'epsc');
                end
            end
        end
        end
        clear thisFilter
    end
  %  for thisCh=1:length(Analysis.Parameters.PhotoCh)
        AP_PlotSummary_filter(Analysis,Title,MetaFilterGroup);
        phototitlelabel=[];
        for thisCh=1:length(Analysis.Parameters.PhotoCh)
            phototitlelabel=[phototitlelabel '_' Analysis.Parameters.PhotoChNames{thisCh}];
        end
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name Title phototitlelabel '.png']);
        if Analysis.Parameters.Illustrator
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name Title phototitlelabel],'epsc');
        end
  %  end
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
        if Analysis.Parameters.Photometry
        if Analysis.(MetaFilter).nTrials
            for thisCh=1:length(Analysis.Parameters.PhotoCh)
                AP_PlotData_Filter_corrDFF(Analysis,MetaFilter,thisCh);
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name MetaFilter char(Analysis.Parameters.PhotoChNames{thisCh}) '.png']);
                if Analysis.Parameters.Illustrator
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name MetaFilter char(Analysis.Parameters.PhotoChNames{thisCh})],'epsc');
                end
            end
        end
        end
        clear thisFilter
    end
    if Analysis.Parameters.Photometry
    for thisCh=1:length(Analysis.Parameters.PhotoCh)
        AP_PlotSummary_Filter_corrDFF(Analysis,Title,MetaFilterGroup,thisCh);
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name Title char(Analysis.Parameters.PhotoChNames{thisCh}) '.png']);
        if Analysis.Parameters.Illustrator
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name Title char(Analysis.Parameters.PhotoChNames{thisCh})],'epsc');
        end
    end
    end
end
end
end
