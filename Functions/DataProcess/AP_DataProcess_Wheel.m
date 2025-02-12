function Analysis=AP_DataProcess_Wheel(Analysis)

%% Parameters
nTrials=Analysis.Parameters.Behavior.nTrials;
timeToZero=Analysis.AllData.Time.Zero;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
sampRate=Analysis.Parameters.Data.NidaqDecimatedSR;

%% Data Processing
for t=1:nTrials
if Analysis.Filters.Wheel(t)
    data=Analysis.Core.Wheel{t};
    if ~Analysis.Parameters.Prime.Prime
    data=data.*(Analysis.Parameters.Wheel.Polarity*Analysis.Parameters.Wheel.Diameter*pi/360);
    end
    [time,data]=AP_PSTH(dataDeg',PSTH_TW,timeToZero(t),sampRate);
    
    dataTrial(t,:)=data;
    timeTrial(t,:)=time;
end
end

%% Statistics for Analysis Structure
Analysis.AllData.Wheel.Time                   =timeTrial;          
Analysis.AllData.Wheel.Data                   =dataTrial;
end