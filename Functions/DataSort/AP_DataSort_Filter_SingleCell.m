function    Analysis=AP_DataSort_Filter_SingleCell(Analysis,FilterName,FilterCell)
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
Analysis.(thisType)=rmfield(Analysis.(thisType),cellName(~thisFilter));

fields=fieldnames(Analysis.(thisType).AllCells);
for f=1:size(fields,1)
    thisF=Analysis.(thisType).AllCells.(fields{f});
    if size(thisF)==[nCells nTrials]
        Analysis.(thisType).AllCells.(fields{f})=thisF(thisFilter,:);
    end
end
Analysis.(thisType).AllCells.CellName=cellName(thisFilter);
Analysis.(thisType).AllCells.Data_Cell=Analysis.(thisType).AllCells.Data_Cell(thisFilter,:);
Analysis.(thisType).AllCells.DataAVG=mean(Analysis.(thisType).AllCells.Data_Cell,1,'omitnan');
Analysis.(thisType).AllCells.DataSEM=std(Analysis.(thisType).AllCells.Data_Cell,0,1,'omitnan')/sqrt(nCellsF);

% this is dumb but hopefully works
Analysis.(thisType).AllCells.Data=[];
for t=1:nTrials
for c=1:nCellsF
    thisCell=Analysis.(thisType).AllCells.CellName{c};
    dataTrial(c,:)=Analysis.(thisType).(thisCell).Data(t,:);
end
Analysis.(thisType).AllCells.Data(t,:)=mean(dataTrial,1,'omitnan');
end
end
end