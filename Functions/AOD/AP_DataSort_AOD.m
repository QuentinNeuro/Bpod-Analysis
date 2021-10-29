function    Analysis=AP_DataSort_AOD(Analysis,FilterName,thisFilter,thisCellFilterName)
 %% check arguments
 % trial filter
FilterName=strrep(FilterName,' ','_');
thistype=FilterName;
ignoredTrialFilter=Analysis.Filters.ignoredTrials';
% recovery of filter if not specified
if nargin==2 || isempty(thisFilter)==1
    if isfield(Analysis.Filters,thistype)
thisFilter=Analysis.Filters.(thistype);
    else
        disp(['Unable to sort data based on filter ' thistype]);
        return
    end
end
% Check whether data have already been filtered using the specified filter
if ~isfield(Analysis,thistype)
    disp(['Data for ' thistype ' have not been computed for AOD analysis']);
    return
end
thisFilter=logical(thisFilter.*ignoredTrialFilter);

 % cell filter
    thisOGType=FilterName;
    if nargin==3 
        thisCIndex=1:Analysis.Parameters.AOD.nCells;
        thistype=FilterName;
    else
        thisCIndex=find(Analysis.Filters.(thisCellFilterName));
        thistype=[thistype '_' thisCellFilterName];
    end
nCells=length(thisCIndex);
%% initialize the new trial type structure based on previous one
    Analysis.(thistype)=Analysis.(thisOGType);
    Analysis.(thistype).AOD=struct();

	Analysis.(thistype).AOD.Time=Analysis.AllData.AOD.Time(:,thisFilter);
    Analysis.(thistype).AOD.AllCells.Data=NaN(length(Analysis.AllData.AOD.Time(:,1)),nCells);
    Analysis.(thistype).AOD.AllCells.DataTrials=zeros(size(Analysis.AllData.AOD.Time(:,thisFilter)));
    
    cellCounter=1;
    for thisC=thisCIndex
        thisC_Name=sprintf('cell%.0d',thisC);
        Analysis.(thistype).AOD.CellName{cellCounter}=thisC_Name;
        Analysis.(thistype).AOD.(thisC_Name).Data=Analysis.AllData.AOD.(thisC_Name).Data(:,thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).DataAVG=mean(Analysis.(thistype).AOD.(thisC_Name).Data,2,'omitnan');
        Analysis.(thistype).AOD.(thisC_Name).CueAVG=Analysis.AllData.AOD.(thisC_Name).CueAVG(thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).CueMAX=Analysis.AllData.AOD.(thisC_Name).CueMAX(thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).OutcomeAVG=Analysis.AllData.AOD.(thisC_Name).OutcomeAVG(thisFilter);
        Analysis.(thistype).AOD.(thisC_Name).OutcomeMAX=Analysis.AllData.AOD.(thisC_Name).OutcomeMAX(thisFilter);
        
        Analysis.(thistype).AOD.AllCells.Data(:,cellCounter)=Analysis.(thistype).AOD.(thisC_Name).DataAVG;
        Analysis.(thistype).AOD.AllCells.DataTrials=Analysis.(thistype).AOD.AllCells.DataTrials + Analysis.(thistype).AOD.(thisC_Name).Data;
        Analysis.(thistype).AOD.AllCells.CueAVG(cellCounter)=mean(Analysis.(thistype).AOD.(thisC_Name).CueAVG,'omitnan');
        Analysis.(thistype).AOD.AllCells.CueMAX(cellCounter)=mean(Analysis.(thistype).AOD.(thisC_Name).CueMAX,'omitnan');
        Analysis.(thistype).AOD.AllCells.OutcomeAVG(cellCounter)=mean(Analysis.(thistype).AOD.(thisC_Name).OutcomeAVG,'omitnan');
        Analysis.(thistype).AOD.AllCells.OutcomeMAX(cellCounter)=mean(Analysis.(thistype).AOD.(thisC_Name).OutcomeMAX,'omitnan');
        cellCounter=cellCounter+1;
    end
        Analysis.(thistype).AOD.AllCells.DataTrials=Analysis.(thistype).AOD.AllCells.DataTrials/Analysis.Parameters.AOD.nCells;
        Analysis.(thistype).AOD.AllCells.DataAVG=mean(Analysis.(thistype).AOD.AllCells.Data,2,'omitnan');
end