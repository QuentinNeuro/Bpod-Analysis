function Analysis=AP_DataProcess(Analysis)
% Create AllData structure from Core structure : generate PSTH, normalize
% and create epoch-related metrics

%% Parameters
StateToZero=Analysis.Parameters.Timing.StateToZero;
nTrials=Analysis.Core.nTrials;

%% Non Trial specific:
Analysis.AllData.nTrials=nTrials;
Analysis.AllData.Session=Analysis.Core.Session;
Analysis.AllData.TrialNumbers=Analysis.Core.TrialNumbers;
Analysis.AllData.TrialTypes=Analysis.Core.TrialTypes;

%% Timing
for t=1:nTrials
    Analysis.AllData.Time.Zero(t)=Analysis.Core.States{1,t}.(StateToZero)(1);
end

%% Licks and Data processing
Analysis=AP_DataProcess_Licks(Analysis);

switch Analysis.Parameters.Data.RecordingType
    case 'Photometry'
Analysis=AP_DataProcess_Photometry(Analysis,SessionData);
    case 'AOD'
Analysis=AP_DataProcess_AOD(Analysis);
    case 'Spikes'
Analysis=AP_DataProcess_Spikes(Analysis);
    case 'Miniscope'
Analysis=AP_DataProcess_Miniscope(Analysis);
    case 'Prime'
Analysis=AP_DataProcess_Prime(Analysis);
end

%% Data Normalize
Analysis=AP_DataProcess_Normalize(Analysis);

%% Event Detection
if Analysis.Parameters.EventDetection.Detection
    Analysis=AP_DataProcess_Events(Analysis);
end

%% Wheel and Pupil
% Wheel
if Analysis.Parameters.Wheel.Wheel
Analysis=AP_DataProcess_Wheel(Analysis);
end
% Pupil
if Analysis.Parameters.Pupillometry.Pupillometry
Analysis=AP_DataProcess_Pupil(Analysis);
end

%% Norm Pupil
if Analysis.Parameters.Pupillometry.Pupillometry
for thisSession=1:Analysis.AllData.Session(end)
    Analysis.AllData.Pupil.NormBaseline(Analysis.AllData.Session==thisSession)=Analysis.AllData.Pupil.NormBaseline(Analysis.AllData.Session==thisSession)/mean(Analysis.AllData.Pupil.NormBaseline(Analysis.AllData.Session==thisSession),'omitnan');
end
end
