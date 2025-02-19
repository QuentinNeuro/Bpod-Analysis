function Analysis=AB_DataProcess_Wheel(Analysis)

%% Parameters
nTrials=Analysis.AllData.nTrials;
timeToZero=Analysis.AllData.Time.Zero;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
% Filter update
WheelFilter=Analysis.Filters.RecWheel(Analysis.Filters.ignoredTrials);
% Sampling Rate
sampRate=Analysis.Parameters.Wheel.SamplingRateDecimated;
sampRateDecimated=Analysis.Parameters.Data.SamplingRateDecimated;
if sampRate<sampRateDecimated
    disp('Error in decimating processed wheel data : sampling Rate is lower than requested decimated sampling rate')
    sampRateDecimated=sampRate;
end
Analysis.Parameters.Wheel.SamplingRateDecimated=sampRateDecimated;
decimateFactor=ceil(sampRate/sampRateDecimated);

testBaseline=Analysis.Parameters.Data.BaselineBefAft;
baselineTW=Analysis.Parameters.Data.BaselineTW;
baselinePts=baselineTW*sampRateDecimated;

%% Data Processing
data=Analysis.Core.Wheel(Analysis.Filters.ignoredTrials);
for t=1:nTrials
if WheelFilter(t)
    thisData=decimate(Analysis.Core.Wheel{t},decimateFactor);
    if ~Analysis.Parameters.Prime.Wheel
    thisData=thisData.*(Analysis.Parameters.Wheel.Polarity*Analysis.Parameters.Wheel.Diameter*pi/360);
    end
    [timeTW,dataTW]=myPSTH(thisData',PSTH_TW,timeToZero(t),sampRate);
    
    dataWheel(t,:)=dataTW;
    timeWheel(t,:)=timeTW;
    % baseline
    switch testBaseline
        case 1
            dataBaseline(t,:)=thisData(baselinePts(1):baselinePts(2));
        case 2
            dataBaseline(t,:)=dataTW(baselinePts(1):baselinePts(2));
    end
end
end

% Baseline AVG calculation
baselineAVG=mean(dataBaseline,2,'omitnan');
baselineSTD=std(dataBaseline,1,2,'omitnan');

%% Save in structure
Analysis.AllData.Wheel.Time          = timeWheel;          
Analysis.AllData.Wheel.Data          = dataWheel;
Analysis.AllData.Wheel.BaselineAVG   = baselineAVG;
Analysis.AllData.Wheel.BaselineSTD   = baselineSTD;
% Extra
Analysis.Filters.Wheel=WheelFilter;
% Epochs
Analysis.AllData.Wheel=AB_DataProcess_Epochs(Analysis.AllData.Wheel,Analysis);
end