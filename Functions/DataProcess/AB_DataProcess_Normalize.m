function [dataTW_N,baselineAVG,baselineSTD]=AB_DataProcess_Normalize(Analysis,timeTW,dataTW,dataBaseline)

%% Parameters
sessionIndex=Analysis.AllData.Session;
% Baseline
BaselineMov=Analysis.Parameters.Data.BaselineMov;
% Baseline histogram
BaselineHisto=Analysis.Parameters.Data.BaselineHisto;
BaselineHistoCutOff=Analysis.Parameters.Data.BaselineHisto/100;
% Normalization
testNormalize=Analysis.Parameters.Data.Normalize;
testZeroAt=Analysis.Parameters.Data.ZeroTW;

%% Baseline computation
% Fluorescence
switch Analysis.Parameters.Data.RecordingType
    case 'Spikes'
dataBaseline=sort(diff(dataBaseline),'descend');
if BaselineHisto
    BaselineHistoPts=round(size(dataBaseline,1)*BaselineHistoCutOff);
    dataBaseline=sort(dataBaseline,2);
    dataBaseline=dataBaseline(1:BaselineHistoPts);
end
baselineAVG=1/mean(dataBaseline,'omitnan');
baselineSTD=1/std(dataBaseline,'omitnan');

    otherwise
if BaselineHisto
    BaselineHistoPts=round(size(dataBaseline,2)*BaselineHistoCutOff);
    dataBaseline=sort(dataBaseline,2);
    dataBaseline=dataBaseline(:,1:BaselineHistoPts);
end
baselineAVG=mean(dataBaseline,2,'omitnan');
baselineSTD=std(dataBaseline,0,2,'omitnan');
if BaselineMov
    for s=unique(sessionIndex)'
        baselineAVG(sessionIndex==s)=movmean(baselineAVG(sessionIndex==s),BaselineMov,'omitnan');
        baselineSTD(sessionIndex==s)=movmean(baselineSTD(sessionIndex==s),BaselineMov,'omitnan');
    end
end

%% Data Normalization
switch testNormalize
    case 'DF'
        DataTW_N=100*(dataTW-baselineAVG);
    case 'DFF'
        dataTW_N=100*(dataTW-baselineAVG)./baselineAVG;
    case 'Zsc'
        dataTW_N=(dataTW-baselineAVG)./baselineSTD;
    otherwise
        dataTW_N=dataTW;
end

% set data to zero if requested
dataZero=0;
if ~isempty(testZeroAt)
    timeTW_ZeroIO=timeTW>testZeroAt(1) & timeTW<testZeroAt(2);
    dataTW_Zero=dataTW_N.*timeTW_ZeroIO;
    dataZero=mean(dataTW_Zero,2,'omitnan');
end
dataTW_N=dataTW_N-dataZero;

end