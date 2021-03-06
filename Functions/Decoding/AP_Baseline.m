function BaselineValue=AP_Baseline(Analysis,Data,Window)

if Analysis.Parameters.BaselineHisto
    Cutoff=Analysis.Parameters.BaselineHistoParam/100;
    BaselineData=sort(Data(Window(1):Window(2)));
    SizeBaselineData=round(length(BaselineData)*Cutoff);
    BaselineValue=nanmean(BaselineData(1:SizeBaselineData));
else    
BaselineValue=nanmean(Data(Window(1):Window(2)));
end
end