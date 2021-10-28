function Analysis=A_FilterCell(Analysis,filterName,filterMetric,filterThreshold,filterType)

nCells=Analysis.Parameters.AOD.nCells;
thisFilter=false(1,nCells);
thisMetric=nan(1,nCells);

for thisC=1:nCells
    thisCName=sprintf('cell%.0d',thisC);
    thisMetric(thisC)=nanmean(Analysis.(filterType).AOD.(thisCName).(filterMetric));
end
    thisFilter(thisMetric>filterThreshold)=true;

    Analysis.Filters.(filterName)=thisFilter;
end