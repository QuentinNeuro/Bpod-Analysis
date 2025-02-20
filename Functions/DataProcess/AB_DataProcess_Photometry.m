 function Analysis=AB_DataProcess_Photometry(Analysis)

%% Parameters
nTrials=Analysis.AllData.nTrials;
nChannels=size(Analysis.Parameters.Photometry.Channels,2);
PSTH_TW=Analysis.Parameters.Timing.PSTH;
timeToZero=Analysis.AllData.Time.Zero;
% Sampling Rate
sampRate=Analysis.Parameters.Photometry.SamplingRate;
sampRateDecimated=Analysis.Parameters.Data.SamplingRateDecimated;
if sampRate<sampRateDecimated
    disp('Error in decimating processed photometry data : sampling Rate is lower than requested decimated sampling rate')
    sampRateDecimated=sampRate;
end
Analysis.Parameters.Photometry.SamplingRateDecimated=sampRateDecimated;
decimateFactor=ceil(sampRate/sampRateDecimated);
% Baseline
testBaseline=Analysis.Parameters.Data.BaselineBefAft;
baselineTW=Analysis.Parameters.Data.BaselineTW;
baselinePts=baselineTW*sampRateDecimated;
% Label
if isempty(Analysis.Parameters.Data.Label)
    for c=1:nChannels
        Analysis.Parameters.Data.Label{c}=sprintf('Fiber%.0d',c);
    end
end

%% Fit Option
if Analysis.Parameters.Photometry.Fit_470405
    Analysis=AB_Photometry_2ChFit(Analysis);
    nChannels=size(Analysis.Parameters.Photometry.Channels,2);
end

%% PSTH and baseline extraction
data=Analysis.Core.Photometry(Analysis.Filters.ignoredTrials);
for c=1:nChannels
    dataCells=[];
    timeCells=[];
    dataBaseline=[];
    thisID=sprintf('Photo_%s',Analysis.Parameters.Photometry.Channels{c});
    for t=1:nTrials
        thisData=decimate(data{t}(c,:),decimateFactor);
        % PSTHs
        [timeTW,dataTW]=myPSTH(thisData,PSTH_TW,timeToZero(t),sampRateDecimated);
        dataCells(t,:)=dataTW;
        timeCells(t,:)=timeTW;
        % baseline
        switch testBaseline
            case 1
                dataBaseline(t,:)=thisData(baselinePts(1):baselinePts(2));
            case 2
                dataBaseline(t,:)=dataTW(baselinePts(1):baselinePts(2));
        end
    end
% Baseline calculation and data normalization
    [dataCells,baselineAVG,baselineSTD]=AB_DataProcess_Normalize(Analysis,timeCells,dataCells,dataBaseline);

%% Save in structure
    Analysis.Parameters.Photometry.CellID{c}=thisID;
    Analysis.AllData.(thisID).Name          = Analysis.Parameters.Data.Label{c};
    Analysis.AllData.(thisID).Time          = timeCells;          
    Analysis.AllData.(thisID).Data          = dataCells;
    Analysis.AllData.(thisID).BaselineAVG   = baselineAVG;
    Analysis.AllData.(thisID).BaselineSTD   = baselineSTD;

    Analysis.AllData.(thisID)=AB_DataProcess_Epochs(Analysis.AllData.(thisID),Analysis);
end
end