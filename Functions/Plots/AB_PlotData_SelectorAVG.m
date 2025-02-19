function [x,y,sem,labelY]=AB_PlotData_SelectorAVG(Analysis,thistype,thiscell)

x=[];
y=[];
sem=[];
labelY=[];

if nargin<3
    thiscell=[];
end

if any(Analysis.Parameters.Photometry.Photometry)
    nChannels=size(Analysis.Parameters.Photometry.Channels,2);
    for c=1:nChannels
        thisChStruct=sprintf('Photo_%s',Analysis.Parameters.Photometry.Channels{c});
        x{c}=Analysis.(thistype).(thisChStruct).Time(1,:);
        y{c}=Analysis.(thistype).(thisChStruct).DataAVG;
        sem{c}=Analysis.(thistype).(thisChStruct).DataSEM;
        labelY{c}=[Analysis.Parameters.Data.Label{c} Analysis.Parameters.Data.Normalize];
    end
end

if Analysis.Parameters.Data.nCells
    if isempty(thiscell)
    x{1}=Analysis.(thistype).AllCells.Time(1,:);
    y{1}=Analysis.(thistype).AllCells.DataAVG;
    sem{1}=Analysis.(thistype).AllCells.DataSEM;
    labelY{1}=[Analysis.Parameters.Data.Label Analysis.Parameters.Data.Normalize];
    x{2}=Analysis.(thistype).AllCells.Time(1,:);
    y{2}=Analysis.(thistype).AllCells.DataAVG;
    sem{2}=Analysis.(thistype).AllCells.DataSEM;
    labelY{2}=[Analysis.Parameters.Data.Label Analysis.Parameters.Data.Normalize];
    else
    x{1}=Analysis.(thistype).(thiscell).Time(1,:);
    y{1}=Analysis.(thistype).(thiscell).DataAVG;
    sem{1}=Analysis.(thistype).(thiscell).DataSEM;
    labelY{1}=[Analysis.Parameters.Data.Label Analysis.Parameters.Data.Normalize];
    end
end

end