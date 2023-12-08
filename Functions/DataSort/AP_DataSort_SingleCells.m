function    Analysis=AP_DataSort_SingleCells(Analysis,FilterName,FilterCell)
% Take the pseudo trial structure of 'FilterName' and select data for the cells
% specified in 'FilterCell

%% check arguments
% Check whether data have already been filtered using the specified filter
if ~isfield(Analysis,FilterName) || ~isfield(Analysis.Filters,FilterCell)
    disp(['Data for ' FilterName ' have not been computed for single cell sorting']);
    return
end

%% Parameters
thisType=[FilterName '_' FilterCell];
thisFilter=Analysis.Filters.(FilterCell);
nTrials=Analysis.(FilterName).nTrials;
nCells=Analysis.Parameters.nCells;
nCellsF=sum(thisFilter);
cellName=Analysis.AllData.AllCells.CellName;
if ~nCellsF
    disp(['no cells found with filter ' thisType]);
    disp('returning the unfiltered trial type');
    Analysis.(thisType)=Analysis.(FilterName);
    Analysis.(thisType).Name=[thisType '_NOCELLFOUND'];
else
%% Sort data based on cell filter
% initialize the new trial type structure based on previous one
Analysis.(thisType)=Analysis.(FilterName);
Analysis.(thisType).Name=thisType;
% Generate new average AllCells data and remove cells from structure
dataCells={};
cCounter=0;
for c=1:nCells
    thisCell=cellName{c};
    if thisFilter(c)
        cCounter=cCounter+1;
        cellList{cCounter}=thisCell;
        dataCells{cCounter}     =Analysis.(thisType).(thisCell).Data;
        dataAVG_Cell(cCounter,:)=Analysis.(thisType).(thisCell).DataAVG;
        preCueAVG(:,cCounter)   =Analysis.(thisType).(thisCell).preCueAVG;
        CueAVG(:,cCounter)      =Analysis.(thisType).(thisCell).CueAVG;
        CueMAX(:,cCounter)      =Analysis.(thisType).(thisCell).CueMAX;
        OutcomeAVG(:,cCounter)  =Analysis.(thisType).(thisCell).OutcomeAVG;
        OutcomeMAX(:,cCounter)  =Analysis.(thisType).(thisCell).OutcomeMAX;
    else
        Analysis.(thisType)=rmfield(Analysis.(thisType),thisCell);
    end
end
for t=1:nTrials
    for c=1:nCellsF
        dataThisTrial(c,:)=dataCells{c}(t,:);
    end
    dataTrialAVG(t,:)=mean(dataThisTrial,1,'omitnan');
end

% Save new average AllCells data
Analysis.(thisType).AllCells.CellName       =cellList;
Analysis.(thisType).AllCells.Data           =dataTrialAVG;
Analysis.(thisType).AllCells.DataAVG        =mean(dataTrialAVG,1,'omitnan');
Analysis.(thisType).AllCells.DataSEM        =std(dataTrialAVG,1,'omitnan')/sqrt(nTrials);
Analysis.(thisType).AllCells.preCueAVG      =mean(preCueAVG,2,'omitnan');
Analysis.(thisType).AllCells.CueAVG         =mean(CueAVG,2,'omitnan');
Analysis.(thisType).AllCells.CueMAX         =mean(CueMAX,2,'omitnan');
Analysis.(thisType).AllCells.OutcomeAVG	    =mean(OutcomeAVG,2,'omitnan');
Analysis.(thisType).AllCells.OutcomeMAX	    =mean(OutcomeMAX,2,'omitnan');
Analysis.(thisType).AllCells.dataAVG_Cell   =dataAVG_Cell;

Analysis.(thisType).AllCells.CueAVG_Cell    =mean(CueAVG,1,'omitnan');
Analysis.(thisType).AllCells.CueMAX_Cell    =mean(CueMAX,1,'omitnan');
Analysis.(thisType).AllCells.OutcomeAVG_Cell=mean(OutcomeAVG,1,'omitnan');
Analysis.(thisType).AllCells.OutcomeMAX_Cell=mean(OutcomeMAX,1,'omitnan');
end
end