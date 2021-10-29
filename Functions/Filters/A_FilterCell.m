function Analysis=A_FilterCell(Analysis,filterName,filterMetric,filterThreshold,thisType)

if ischar(filterThreshold)
    switch filterThreshold
        case 'mean'
            filterThreshold=mean(Analysis.(thisType).AOD.AllCells.(filterMetric),'omitnan');
        case 'median'
            filterThreshold=median(Analysis.(thisType).AOD.AllCells.(filterMetric),'omitnan');
    end
end
   
nCells=Analysis.Parameters.AOD.nCells;
thisFilter=false(1,nCells);

thisMetric=Analysis.(thisType).AOD.AllCells.(filterMetric);
thisFilter(thisMetric>filterThreshold)=true;

Analysis.Filters.(filterName)=thisFilter;

end