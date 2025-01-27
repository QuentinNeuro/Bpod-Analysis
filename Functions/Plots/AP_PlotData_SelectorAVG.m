function [x,y,sem,labelY]=AP_PlotData_SelectorAVG(Analysis,thistype,thiscell)

x=[];
y=[];
sem=[];
labelY=[];

if nargin<3
    thiscell=[];
end

if Analysis.Parameters.Data.Zscore
fluoType=' Z-sc';
else
fluoType=' DF/F (%)';
end

if Analysis.Parameters.Photometry.Photometry
    nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);
    for thisCh=1:nbOfChannels
        thisChStruct=sprintf('Photo_%s',Analysis.Parameters.Photometry.Channels{thisCh});
        x{thisCh}=Analysis.(thistype).(thisChStruct).Time(1,:);
        y{thisCh}=Analysis.(thistype).(thisChStruct).DataAVG;
        sem{thisCh}=Analysis.(thistype).(thisChStruct).DataSEM;
        labelY{thisCh}=[Analysis.Parameters.Data.Label{thisCh} fluoType];
    end
end

if Analysis.Parameters.nCells
    if isempty(thiscell)
    x{1}=Analysis.(thistype).AllCells.Time(1,:);
    y{1}=Analysis.(thistype).AllCells.DataAVG;
    sem{1}=Analysis.(thistype).AllCells.DataSEM;
    labelY{1}=[Analysis.Parameters.Data.Label{1} fluoType];
    x{2}=Analysis.(thistype).AllCells.Time(1,:);
    y{2}=Analysis.(thistype).AllCells.DataAVG;
    sem{2}=Analysis.(thistype).AllCells.DataSEM;
    labelY{2}=[Analysis.Parameters.Data.Label{1} fluoType];
    else
    x{1}=Analysis.(thistype).(thiscell).Time(1,:);
    y{1}=Analysis.(thistype).(thiscell).DataAVG;
    sem{1}=Analysis.(thistype).(thiscell).DataSEM;
    labelY{1}=[Analysis.Parameters.Data.Label{1} fluoType];
    end
end

end