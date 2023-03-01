function Analysis=AP_DataProcess_Wheel(Analysis,thisTrial)

if Analysis.Filters.Wheel(thisTrial)

%% Timing
timeToZero=Analysis.AllData.Time.Zero(thisTrial);
cueTime=Analysis.AllData.Time.Cue(thisTrial,:)+Analysis.Parameters.CueTimeReset;
outcomeTime=Analysis.AllData.Time.Outcome(thisTrial,:)+Analysis.Parameters.OutcomeTimeReset;
timeWindow=Analysis.Parameters.ReshapedTime;
sampRate=Analysis.Parameters.NidaqDecimatedSR;
baseline=Analysis.Parameters.NidaqBaselinePoints; 

%% Data
thisDataDeg=Analysis.Core.Wheel{thisTrial};
[time,data]=AP_TimeReshaping(thisDataDeg',timeWindow,timeToZero,sampRate);
DataDistance=data'.*(Analysis.Parameters.WheelPolarity*Analysis.Parameters.WheelDiameter*pi/360);

%% Statistics for Analysis Structure
if ~isfield(Analysis.AllData,'Wheel')
    Analysis.AllData.Wheel.Time(1:thisTrial-1,:)    =NaN(thisTrial-1,length(time));
    Analysis.AllData.Wheel.Deg(1:thisTrial-1,:)     =NaN(thisTrial-1,length(data));
    Analysis.AllData.Wheel.Distance(1:thisTrial-1,:)=NaN(thisTrial-1,length(DataDistance));
    Analysis.AllData.Wheel.Baseline(1:thisTrial-1)  =NaN(1,thisTrial-1);
    Analysis.AllData.Wheel.Cue(1:thisTrial-1)       =NaN(1,thisTrial-1);
    Analysis.AllData.Wheel.Outcome(1:thisTrial-1)   =NaN(1,thisTrial-1);
    Analysis.AllData.Time.Wheel                     =time;
end
Analysis.AllData.Wheel.Time(thisTrial,:)          	=time;
Analysis.AllData.Wheel.Deg(thisTrial,:)          	=data;
Analysis.AllData.Wheel.Distance(thisTrial,:)       	=DataDistance;
Analysis.AllData.Wheel.Baseline(thisTrial)        	=nanmean(DataDistance(baseline(1):baseline(2)));
Analysis.AllData.Wheel.Cue(thisTrial)             	=nanmean(DataDistance(time(1,:)>cueTime(1) & time<cueTime(2)));
Analysis.AllData.Wheel.Outcome(thisTrial)           =nanmean(DataDistance(time(1,:)>outcomeTime(1) & time<outcomeTime(2)));
else
    if isfield(Analysis.AllData,'Wheel')
Analysis.AllData.Wheel.Time(thisTrial,:)          	=NaN(1,size(Analysis.AllData.Wheel.Time,2));
Analysis.AllData.Wheel.Deg(thisTrial,:)          	=NaN(1,size(Analysis.AllData.Wheel.Deg,2));
Analysis.AllData.Wheel.Distance(thisTrial,:)       	=NaN(1,size(Analysis.AllData.Wheel.Distance,2));
Analysis.AllData.Wheel.Baseline(thisTrial)        	=NaN;
Analysis.AllData.Wheel.Cue(thisTrial)             	=NaN;
Analysis.AllData.Wheel.Outcome(thisTrial)           =NaN;
    end
end
end