function Analysis=A_FilterCell(Analysis,filterName,filterMetric,filterThreshold,thisType)

if ischar(filterThreshold)
    switch filterThreshold
        case 'mean'
            filterThreshold=mean(Analysis.(thisType).AllCells.(filterMetric),'omitnan');
        case 'median'
            filterThreshold=median(Analysis.(thisType).AllCells.(filterMetric),'omitnan');
        case 'meanPos'
            filterThreshold=mean(Analysis.(thisType).AllCells.(filterMetric)>0,'omitnan');
    end
end
   
nCells=Analysis.Parameters.nCells;
thisFilter=false(1,nCells);

thisMetric=Analysis.(thisType).AllCells.(filterMetric);
thisFilter(thisMetric>filterThreshold)=true;

Analysis.Filters.(filterName)=thisFilter;
filterNameInv=[filterName 'Inv'];
Analysis.Filters.(filterName)=thisFilter;
Analysis.Filters.(filterNameInv)=~thisFilter;
end