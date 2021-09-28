function Analysis=A_FilterAODCell(Analysis,FilterName,FilterType,FilterMetric)

%% Parameters
threshold=2;
nCells=Analysis.Core.AOD.nCells;

data4filter=Analysis.(FilterType).AOD.AllCells.(FilterMetric);

cellfilter=logical(nCells);
cellfilter(data4filter>threshold)=true;
Analysis.Filters.(FilterName)=cellfilter;

end