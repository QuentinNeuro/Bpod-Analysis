function [x,y,sem,labelY]=AP_PlotData_SelectorAVG(Analysis,thistype,thiscell)

x=[];
y=[];
sem=[];
labelY=[];

if nargin<3
    thiscell=[];
end

if Analysis.Parameters.Zscore
fluoType=' Z-sc';
else
fluoType=' DF/F (%)';
end

if Analysis.Parameters.Photometry
    for thisCh=1:length(Analysis.Parameters.PhotoCh)
        thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
        x{thisCh}=Analysis.(thistype).(thisChStruct).Time(1,:);
        y{thisCh}=Analysis.(thistype).(thisChStruct).DFFAVG;
        sem{thisCh}=Analysis.(thistype).(thisChStruct).DFFSEM;
        labelY{thisCh}=[Analysis.Parameters.PhotoChNames{thisCh} fluoType];
    end
end

if Analysis.Parameters.nCells
    if isempty(thiscell)
    x{1}=Analysis.(thistype).AllCells.Time(1,:);
    y{1}=Analysis.(thistype).AllCells.DataAVG;
    sem{1}=Analysis.(thistype).AllCells.DataSEM;
    labelY{1}=[Analysis.Parameters.PhotoChNames{1} fluoType];
    x{2}=Analysis.(thistype).AllCells.Time(1,:);
    y{2}=Analysis.(thistype).AllCells.DataAVG;
    sem{2}=Analysis.(thistype).AllCells.DataSEM;
    labelY{2}=[Analysis.Parameters.PhotoChNames{1} fluoType];
    else
    x{1}=Analysis.(thistype).(thiscell).Time(1,:);
    y{1}=Analysis.(thistype).(thiscell).DataAVG;
    sem{1}=Analysis.(thistype).(thiscell).DataSEM;
    labelY{1}=[Analysis.Parameters.PhotoChNames{1} fluoType];
    end
end

if Analysis.Parameters.Spikes.Spikes
    x{1}=Analysis.(thistype).Spikes.AllCells.Bin(1,:);
    y{1}=Analysis.(thistype).Spikes.AllCells.RateAVG;
    sem{1}=Analysis.(thistype).Spikes.AllCells.RateSEM;
    labelY{1}=[Analysis.Parameters.PhotoChNames{1} ' FR (Hz)'];
end

end