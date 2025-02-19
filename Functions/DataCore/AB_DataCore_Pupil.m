function Analysis=AB_DataCore_Pupil(Analysis)

%% Create Filter
Analysis=AB_FilterPupillometry(Analysis);

%% Parameters
if Analysis.Parameters.Pupillometry.Pupillometry(end)
nSessions=Analysis.Parameters.Behavior.nSessions;
nTrials=Analysis.Parameters.Behavior.nTrials(nSessions);
nTrialsOffset=0;
if nSessions>1
    sessionIdx=Analysis.Core.Session;
    nTrialsOffset=length(sessionIdx)-sum(sessionIdx==max(sessionIdx));
end
trialVector=nTrialsOffset+1:nTrialsOffset+nTrials;

%% Data extraction & Save in Analysis structure
load(Analysis.Parameters.Pupillometry.Files{end})
Analysis.Core.Pupil(trialVector,:)=Pupillometry.Pupil';
Analysis.Core.PupilSmooth(trialVector,:)=Pupillometry.PupilSmooth';
Analysis.Core.PupilBlink(trialVector,:)=Pupillometry.Blink';

end 
end