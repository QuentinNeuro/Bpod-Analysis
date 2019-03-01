function  Analysis=AP_GoNogo_FiltersAndPlot(Analysis)
%This function can be used to generates filters based on behavior or states
%and to plot single and summary figures.
%COMMENTS TO COME
%
%function designed by Quentin 2017

%% Generates filters
% Trial types
Analysis=A_FilterState(Analysis,'Go','Nogo');
% Wheel
Analysis=A_FilterWheel(Analysis,'Run',Analysis.Parameters.WheelState,Analysis.Parameters.WheelThreshold);
% Pupil
Analysis=A_FilterPupil(Analysis,'Pupil',Analysis.Parameters.PupilState,Analysis.Parameters.PupilThreshold);
Analysis=A_FilterPupilNaNCheck(Analysis,'PupilNaN',25);

%% Plot Filters
if Analysis.Parameters.PlotFiltersSummary==1
GroupToPlot=AP_GoNogo_GroupToPlot(Analysis);
for i=1:size(GroupToPlot,1)
    Title=GroupToPlot{i,1};
    MetaFilterGroup=cell(size(GroupToPlot{i,2},1),1);
    for j=1:size(GroupToPlot{i,2},1)
        MetaFilter=GroupToPlot{i,2}{j,1};
        Filters=GroupToPlot{i,2}{j,2};
        MetaFilterGroup{j}=MetaFilter;
        [Analysis,thisFilter]=A_FilterMeta(Analysis,MetaFilter,Filters);
        Analysis=AP_DataSort(Analysis,MetaFilter,thisFilter);
        if Analysis.Parameters.PlotFiltersSingle==1 && Analysis.(MetaFilter).nTrials>0
            for thisCh=1:length(Analysis.Parameters.PhotoCh)
                AP_PlotData_filter(Analysis,MetaFilter,thisCh);
                %AP_PlotData_Filter_corrDFF(Analysis,MetaFilter,thisCh);
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name MetaFilter char(Analysis.Parameters.PhotoCh{thisCh}) '.png']);
                if Analysis.Parameters.Illustrator
                saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name MetaFilter char(Analysis.Parameters.PhotoCh{thisCh})],'epsc');
                end
            end
        end
    end
    for thisCh=1:length(Analysis.Parameters.PhotoCh)
        AP_PlotSummary_filter(Analysis,Title,MetaFilterGroup,thisCh);
%        AP_PlotSummary_Filter_corrDFF(Analysis,Title,MetaFilterGroup,thisCh);
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name Title char(Analysis.Parameters.PhotoCh{thisCh}) '.png']);
        if Analysis.Parameters.Illustrator
        saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name Title char(Analysis.Parameters.PhotoCh{thisCh})],'epsc');
        end
    end
end
end
end
