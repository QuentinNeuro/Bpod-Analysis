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

if Analysis.Parameters.AOD.AOD
    x{1}=Analysis.(thistype).AOD.Time(:,1);
    if isnan(x{1,1}(end))
        x{1,1}(end)=x{1,1}(end-1)+x{1,1}(end-1)-x{1,1}(end-2);
    end
    y{1}=1:size(Analysis.(thistype).AOD.CellName,2);
    dataTp=Analysis.(thistype).AOD.AllCells.Data';
    dataTp(dataTp==NaN)=0;
    data{1}=dataTp;
    labelY{1}=['Cells ' Analysis.Parameters.PhotoChNames{1}];
end
if Analysis.Parameters.Spikes.Spikes
    x{1}=Analysis.(thistype).Spikes.AllCells.Bin(1,:);
    y{1}=1:Analysis.Parameters.Spikes.nCells;
    data{1}=Analysis.(thistype).Spikes.AllCells.Rate;
    labelY{1}=['Cells ' Analysis.Parameters.PhotoChNames{1}];
end
end