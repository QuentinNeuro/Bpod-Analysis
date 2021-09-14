function    Analysis=AP_DataSort_AOD(Analysis,thistype,thisFilter)

	Analysis.(thistype).AOD.time=Analysis.AllData.AOD.time(:,thisFilter);
    Analysis.(thistype).AOD.AllCells.Data=NaN(size(Analysis.AllData.AOD.time(:,thisFilter)));
    
    for thisC=1:Analysis.Core.AOD.nCells
        thisC_Name=sprintf('cell%.0d',thisC);
        Analysis.(thistype).AOD.(thisC_Name).Data=Analysis.AllData.AOD.(thisC_Name).Data(:,thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).CueAVG=Analysis.AllData.AOD.(thisC_Name).CueAVG(thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).CueMAX=Analysis.AllData.AOD.(thisC_Name).CueMAX(thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).OutcomeAVG=Analysis.AllData.AOD.(thisC_Name).OutcomeAVG(thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).OutcomeMAX=Analysis.AllData.AOD.(thisC_Name).OutcomeMAX(thisFilter);
        
        Analysis.(thistype).AOD.AllCells.Data(:,thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).Data,2);
        Analysis.(thistype).AOD.AllCells.CueAVG(thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).CueAVG);
        Analysis.(thistype).AOD.AllCells.CueMAX(thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).CueMAX);
        Analysis.(thistype).AOD.AllCells.OutcomeAVG(thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).OutcomeAVG);
        Analysis.(thistype).AOD.AllCells.OutcomeMAX(thisC)=nanmean(Analysis.(thistype).AOD.(thisC_Name).OutcomeMAX);
    end
    
    Analysis.(thistype).AOD.AllCells.DataAVG=nanmean(Analysis.(thistype).AOD.AllCells.Data,2);
end