function Analysis=AP_DataProcess_Wheel(Analysis,thisTrial)

if Analysis.Filters.Wheel(thisTrial)

%% Timing
TimeToZero=Analysis.AllData.Time.Zero(thisTrial);
CueTime=Analysis.AllData.Time.Cue(thisTrial,:)+Analysis.Parameters.CueTimeReset;
OutcomeTime=Analysis.AllData.Time.Outcome(thisTrial,:)+Analysis.Parameters.OutcomeTimeReset;
TimeWindow=Analysis.Parameters.ReshapedTime;
SamplingRate=Analysis.Parameters.NidaqDecimatedSR;
Baseline=Analysis.Parameters.NidaqBaselinePoints; 

%% Data
thisDataDeg=Analysis.Core.Wheel{thisTrial};
[Time,Data]=AP_TimeReshaping(thisDataDeg,TimeWindow,TimeToZero,SamplingRate);
DataDistance=Data.*(Analysis.Parameters.WheelPolarity*Analysis.Parameters.WheelDiameter*pi/360);

%% Statistics for Analysis Structure
if ~isfield(Analysis.AllData,'Wheel')
    Analysis.AllData.Wheel.Time(1:thisTrial-1,:)    =NaN(thisTrial-1,length(Time));
    Analysis.AllData.Wheel.Deg(1:thisTrial-1,:)     =NaN(thisTrial-1,length(Data));
    Analysis.AllData.Wheel.Distance(1:thisTrial-1,:)=NaN(thisTrial-1,length(DataDistance));
    Analysis.AllData.Wheel.Baseline(1:thisTrial-1)  =NaN(1,thisTrial-1);
    Analysis.AllData.Wheel.Cue(1:thisTrial-1)       =NaN(1,thisTrial-1);
    Analysis.AllData.Wheel.Outcome(1:thisTrial-1)   =NaN(1,thisTrial-1);
    Analysis.AllData.Time.Wheel                     =Time;
end
Analysis.AllData.Wheel.Time(thisTrial,:)          	=Time;
Analysis.AllData.Wheel.Deg(thisTrial,:)          	=Data;
Analysis.AllData.Wheel.Distance(thisTrial,:)       	=DataDistance;
Analysis.AllData.Wheel.Baseline(thisTrial)        	=nanmean(DataDistance(Baseline(1):Baseline(2)));
Analysis.AllData.Wheel.Cue(thisTrial)             	=nanmean(DataDistance(Time(1,:)>CueTime(1) & Time<CueTime(2)));
Analysis.AllData.Wheel.Outcome(thisTrial)           =nanmean(DataDistance(Time(1,:)>OutcomeTime(1) & Time<OutcomeTime(2)));
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