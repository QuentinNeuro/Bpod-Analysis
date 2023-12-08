function [x,y,data,labelY]=AP_PlotData_SelectorRaster(Analysis,thistype)

x=[];
y=[];
data=[];
labelY=[];

if Analysis.Parameters.Photometry
    for thisCh=1:length(Analysis.Parameters.PhotoCh)
        thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
        x{thisCh}=Analysis.(thistype).(thisChStruct).Time(1,:);
        y{thisCh}=1:Analysis.(thistype).nTrials;
        data{thisCh}=Analysis.(thistype).(thisChStruct).DFF;
        labelY{thisCh}=['Trials ' Analysis.Parameters.PhotoChNames{thisCh}];
    end
end

if Analysis.Parameters.nCells
    nCells=size(Analysis.(thistype).AllCells.CellName,2);
    x{1}=Analysis.(thistype).AllCells.Time(1,:);
    y{1}=1:Analysis.(thistype).nTrials;
    data{1}=Analysis.(thistype).AllCells.Data;
    labelY{1}='Trials';
    x{2}=x{1};
    y{2}=1:nCells;
    data{2}=Analysis.(thistype).AllCells.dataAVG_Cell;
    labelY{2}='Cells';
end


if Analysis.Parameters.Spikes.Spikes
    x{1}=Analysis.(thistype).Spikes.AllCells.Bin(1,:);
    y{1}=1:Analysis.Parameters.Spikes.nCells;
    data{1}=Analysis.(thistype).Spikes.AllCells.Rate;
    labelY{1}=['Cells ' Analysis.Parameters.PhotoChNames{1}];
end

end