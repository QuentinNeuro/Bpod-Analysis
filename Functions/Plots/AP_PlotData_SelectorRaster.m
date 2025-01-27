function [x,y,data,labelY,cmap]=AP_PlotData_SelectorRaster(Analysis,thistype,thiscell)

x=[];
y=[];
data=[];
labelY=[];
cmap=parula;

if nargin<3
    thiscell=[];
end

if Analysis.Parameters.Photometry.Photometry
    nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);
    for thisCh=1:nbOfChannels
        thisChStruct=sprintf('Photo_%s',Analysis.Parameters.Photometry.Channels{thisCh});
        x{thisCh}=Analysis.(thistype).(thisChStruct).Time(1,:);
        y{thisCh}=1:Analysis.(thistype).nTrials;
        data{thisCh}=Analysis.(thistype).(thisChStruct).Data;
        labelY{thisCh}=['Trials ' Analysis.Parameters.Data.Label{thisCh}];
    end
end

if Analysis.Parameters.nCells
    if isempty(thiscell)
    nCells=size(Analysis.(thistype).AllCells.CellName,2);
    x{1}=Analysis.(thistype).AllCells.Time(1,:);
    y{1}=1:Analysis.(thistype).nTrials;
    data{1}=Analysis.(thistype).AllCells.Data;
    labelY{1}='Trials';
    x{2}=x{1};
    y{2}=1:nCells;
    data{2}=Analysis.(thistype).AllCells.Data_Cell;
    labelY{2}='Cells';
    else
    x{1}=Analysis.(thistype).(thiscell).Time(1,:);
    y{1}=1:Analysis.(thistype).nTrials;
    data{1}=Analysis.(thistype).(thiscell).Data;
    labelY{1}='Trials';    
    end
    if Analysis.Parameters.AOD.AOD
        cmap=[summer ; flip(autumn)];
    end
    if Analysis.Parameters.Prime.Prime
        labelY{2}=Analysis.Parameters.Prime.DataType;
    end
end
end