function Analysis=A_FilterCell(Analysis,filterName,filterMetric,filterThreshold,thisType)

if ischar(filterThreshold)
    switch filterThreshold
        case 'mean'
            filterThreshold=mean(Analysis.(thisType).AllCells.(filterMetric),'omitnan');
        case 'median'
            filterThreshold=median(Analysis.(thisType).AllCells.(filterMetric),'omitnan');
        case 'meanPos'
            filterThreshold=mean(Analysis.(thisType).AllCells.(filterMetric)>0,'omitnan');
        case 'preCue'
            filterThreshold=Analysis.(thisType).AllCells.preCueAVG*2;
    end
end
   
nCells=Analysis.Parameters.nCells;
thisFilter=false(1,nCells);

thisMetric=Analysis.(thisType).AllCells.(filterMetric);
if size(filterThreshold,1)>1
    for c=1:nCells
        if thisMetric(c)>filterThreshold(c)
        thisFilter(c)=true;
        end
    end
else
thisFilter(thisMetric>filterThreshold)=true;
end

Analysis.Filters.(filterName)=thisFilter;
filterNameInv=[filterName 'Inv'];
Analysis.Filters.(filterName)=thisFilter;
Analysis.Filters.(filterNameInv)=~thisFilter;
end