function Analysis=AB_DataProcess(Analysis)
% Create AllData structure from Core structure : generate PSTH, normalize
% and create epoch-related metrics
% each vector is filtered through ignoredTrials vector;

%% Trial parameters
ignoreTrialFilter=Analysis.Filters.ignoredTrials;
Analysis.AllData.nTrials=Analysis.Core.nTrials-sum(~ignoreTrialFilter);
Analysis.AllData.Session=Analysis.Core.Session(ignoreTrialFilter)';
Analysis.AllData.TrialNumbers=Analysis.Core.TrialNumbers(ignoreTrialFilter)';
Analysis.AllData.TrialTypes=Analysis.Core.TrialTypes(ignoreTrialFilter)';

%% Timing and Licks
Analysis=AB_DataProcess_Timing(Analysis,'ini');
Analysis=AB_DataProcess_Licks(Analysis);
Analysis=AB_DataProcess_Timing(Analysis,'update');
Analysis.AllData.Licks=AB_DataProcess_Epochs(Analysis.AllData.Licks,Analysis);

%% Neuronal Data
switch Analysis.Parameters.Data.RecordingType
    case 'Photometry'
Analysis=AB_DataProcess_Photometry(Analysis);
    case 'AOD'
Analysis=AB_DataProcess_AOD(Analysis);
    case 'Spikes'
Analysis=AB_DataProcess_Spikes(Analysis);
    case 'Miniscope'
Analysis=AB_DataProcess_Miniscope(Analysis);
    case 'Prime'
Analysis=AB_DataProcess_Prime(Analysis);
end

%% Wheel and Pupil
if any(Analysis.Parameters.Wheel.Wheel)
Analysis=AB_DataProcess_Wheel(Analysis);
end

if any(Analysis.Parameters.Pupillometry.Pupillometry)
Analysis=AB_DataProcess_Pupil(Analysis);
end

%% Event Detection
if Analysis.Parameters.EventDetection.Detection
    Analysis=AB_DataProcess_Events(Analysis);
end

end
