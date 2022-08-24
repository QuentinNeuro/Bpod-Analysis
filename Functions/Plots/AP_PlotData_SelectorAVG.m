function [x,y,sem,labelY]=AP_PlotData_SelectorAVG(Analysis,thistype)

x=[];
y=[];
sem=[];
labelY=[];

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

if Analysis.Parameters.AOD.AOD
    x{1}=Analysis.(thistype).AOD.Time(:,1);
    y{1}=Analysis.(thistype).AOD.AllCells.DataAVG;
    sem{1}=Analysis.(thistype).AOD.AllCells.DataSEM;
    labelY{1}=[Analysis.Parameters.PhotoChNames{1} fluoType];
end
if Analysis.Parameters.Spikes.Spikes
    x{1}=Analysis.(thistype).Spikes.AllCells.Bin(1,:);
    y{1}=Analysis.(thistype).Spikes.AllCells.RateAVG;
    sem{1}=Analysis.(thistype).Spikes.AllCells.RateSEM;
    labelY{1}=[Analysis.Parameters.PhotoChNames{1} ' FR (Hz)'];
end

end