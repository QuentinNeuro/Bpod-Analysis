function Analysis=AP_DataSort_SingleCell(Analysis,thistype)

nCells=Analysis.Parameters.nCells;
nTrials=Analysis.(thistype).nTrials;
cellNames=Analysis.(thistype).AllCells.CellName;

for  c=1:nCells
    Analysis.(thistype).(cellNames{c}).DataAVG=mean(Analysis.(thistype).(cellNames{c}).Data,1,'omitnan');
    Analysis.(thistype).(cellNames{c}).DataSEM=std(Analysis.(thistype).(cellNames{c}).Data,0,1,'omitnan')/sqrt(nTrials);
    Analysis.(thistype).AllCells.Data_Cell(c,:)=Analysis.(thistype).(cellNames{c}).DataAVG;
    
    if Analysis.Parameters.Spikes.Spikes
        for t=1:nTrials
            Analysis.(thistype).(cellNames{c}).TrialTS{t}=t*ones(size(Analysis.(thistype).(cellNames{c}).TrialTS{t}));
        end
    end

end  
    Analysis.(thistype).AllCells.DataAVG=mean(Analysis.(thistype).AllCells.Data,1,'omitnan');
    Analysis.(thistype).AllCells.DataSEM=std(Analysis.(thistype).AllCells.Data,0,1,'omitnan')/sqrt(nCells);

end