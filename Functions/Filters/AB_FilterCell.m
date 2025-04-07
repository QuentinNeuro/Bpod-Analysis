function Analysis=AB_FilterCell(Analysis,filterName,filterMetric,filterThreshold,thisType)

%% General Parameters
nTrials=Analysis.AllData.nTrials;
recType=Analysis.Parameters.Data.RecordingType;
nCells=Analysis.Parameters.Data.nCells;
cellID=Analysis.Parameters.(recType).CellID;
%% Filter initiation
thisFilter=false(1,nCells);

%% Filter
for c=1:nCells
    thisID=cellID{c};
    thisMetric=mean(Analysis.(thisType).(thisID).(filterMetric),'omitnan');
    switch filterThreshold
        case 'mean'
            filterThreshold=mean(Analysis.(thisType).(thisID).(filterMetric),'omitnan');
        case 'median'
            filterThreshold=median(Analysis.(thisType).(thisID).(filterMetric),'omitnan');
        case 'meanPos'
            filterThreshold=mean(Analysis.(thisType).(thisID).(filterMetric)>0,'omitnan');
        case 'preAVG'
            filterThreshold=mean(Analysis.AllData.(thisID).BaselineAVG,'omitnan')*2;
        case 'preSTD'
            filterThreshold=mean(Analysis.AllData.(thisID).BaselineSTD,'omitnan')*3;
    end

    if thisMetric>filterThreshold
        thisFilter(c)=true;
    end
end

Analysis.Filters.(filterName)=thisFilter;
filterNameInv=[filterName 'Inv'];
Analysis.Filters.(filterName)=thisFilter;
Analysis.Filters.(filterNameInv)=~thisFilter;
end