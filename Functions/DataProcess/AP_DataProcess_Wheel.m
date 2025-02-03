function Analysis=AP_DataProcess_Wheel(Analysis)

% Parameters
nTrials=Analysis.Parameters.Behavior.nTrials;

for t=1:nTrials
if Analysis.Filters.Wheel(t)
%% Timing
timeToZero=Analysis.AllData.Time.Zero(t);
cueTime=Analysis.AllData.Time.Cue(t,:)+Analysis.Parameters.Timing.CueTimeReset;
outcomeTime=Analysis.AllData.Time.Outcome(t,:)+Analysis.Parameters.Timing.OutcomeTimeReset;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
sampRate=Analysis.Parameters.Data.NidaqDecimatedSR;
baseline=Analysis.Parameters.Data.NidaqBaselinePoints; 

%% Data
thisDataDeg=Analysis.Core.Wheel{t};
[time,data]=AP_PSTH(thisDataDeg',PSTH_TW,timeToZero,sampRate);
if ~isfield(Analysis.Parameters,'Prime')
    DataDistance=data'.*(Analysis.Parameters.Wheel.Polarity*Analysis.Parameters.Wheel.Diameter*pi/360);
else
    DataDistance=data;
end
%% Statistics for Analysis Structure
if ~isfield(Analysis.AllData,'Wheel')
    Analysis.AllData.Wheel.Time(1:t-1,:)    =NaN(t-1,length(time));
    Analysis.AllData.Wheel.Deg(1:t-1,:)     =NaN(t-1,length(data));
    Analysis.AllData.Wheel.Distance(1:t-1,:)=NaN(t-1,length(DataDistance));
    Analysis.AllData.Wheel.Baseline(1:t-1)  =NaN(1,t-1);
    Analysis.AllData.Wheel.Cue(1:t-1)       =NaN(1,t-1);
    Analysis.AllData.Wheel.Outcome(1:t-1)   =NaN(1,t-1);
    Analysis.AllData.Time.Wheel             =time;
end
Analysis.AllData.Wheel.Time(t,:)          	=time;
Analysis.AllData.Wheel.Deg(t,:)          	=data;
Analysis.AllData.Wheel.Distance(t,:)       	=DataDistance;
Analysis.AllData.Wheel.Baseline(t)        	=mean(DataDistance(baseline(1):baseline(2)),'omitnan');
Analysis.AllData.Wheel.Cue(t)             	=mean(DataDistance(time(1,:)>cueTime(1) & time<cueTime(2)),'omitnan');
Analysis.AllData.Wheel.Outcome(t)           =mean(DataDistance(time(1,:)>outcomeTime(1) & time<outcomeTime(2)),'omitnan');
else
    if isfield(Analysis.AllData,'Wheel')
Analysis.AllData.Wheel.Time(t,:)          	=NaN(1,size(Analysis.AllData.Wheel.Time,2));
Analysis.AllData.Wheel.Deg(t,:)          	=NaN(1,size(Analysis.AllData.Wheel.Deg,2));
Analysis.AllData.Wheel.Distance(t,:)       	=NaN(1,size(Analysis.AllData.Wheel.Distance,2));
Analysis.AllData.Wheel.Baseline(t)        	=NaN;
Analysis.AllData.Wheel.Cue(t)             	=NaN;
Analysis.AllData.Wheel.Outcome(t)           =NaN;
    end
end
end
end