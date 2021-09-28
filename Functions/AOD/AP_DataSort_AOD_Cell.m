function    Analysis=AP_DataSort_AOD_Cell(Analysis,thistype,thisFilter,thisCellFilter)

	nFilterCells=sum(thisCellFilter);
    Analysis.(thistype).AOD.time=Analysis.AllData.AOD.time(:,thisFilter);
    Analysis.(thistype).AOD.AllCells.Data=NaN(length(Analysis.AllData.AOD.time(:,1)),nFilterCells);
    Analysis.(thistype).AOD.AllCells.DataTrials=zeros(size(Analysis.AllData.AOD.time(:,thisFilter)));
    filterCellIndex=1:Analysis.Core.AOD.nCells.*thisCellFilter;
    for thisC=1:filterCellIndex
        thisC_Name=sprintf('cell%.0d',thisC);
        Analysis.(thistype).AOD.(thisC_Name).Data=Analysis.AllData.AOD.(thisC_Name).Data(:,thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).CueAVG=Analysis.AllData.AOD.(thisC_Name).CueAVG(thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).CueMAX=Analysis.AllData.AOD.(thisC_Name).CueMAX(thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).OutcomeAVG=Analysis.AllData.AOD.(thisC_Name).OutcomeAVG(thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).OutcomeMAX=Analysis.AllData.AOD.(thisC_Name).OutcomeMAX(thisFilter);
        
        Analysis.(thistype).AOD.AllCells.Data(:,thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).Data,2);
        Analysis.(thistype).AOD.AllCells.DataTrials=Analysis.(thistype).AOD.AllCells.DataTrials + Analysis.(thistype).AOD.(thisC_Name).Data;
        Analysis.(thistype).AOD.AllCells.CueAVG(thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).CueAVG);
        Analysis.(thistype).AOD.AllCells.CueMAX(thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).CueMAX);
        Analysis.(thistype).AOD.AllCells.OutcomeAVG(thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).OutcomeAVG);
        Analysis.(thistype).AOD.AllCells.OutcomeMAX(thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).OutcomeMAX);
    end
        Analysis.(thistype).AOD.AllCells.DataTrials=Analysis.(thistype).AOD.AllCells.DataTrials/Analysis.Core.AOD.nCells;
        Analysis.(thistype).AOD.AllCells.DataAVG=nanmean(Analysis.(thistype).AOD.AllCells.Data,2);
end