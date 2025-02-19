function Analysis=AB_DataCore_Licks(Analysis,SessionData)
%% Parameters  
% Trial Nbs
nSessions=Analysis.Parameters.Behavior.nSessions;
nTrials=Analysis.Parameters.Behavior.nTrials(nSessions);
nTrialsOffset=0;
if nSessions>1
    nTrialsOffset=sum(Analysis.Parameters.Behavior.nTrials)-nTrials;
end
if isfield(Analysis.Core,'Licks')
    dataTrial=Analysis.Core.Licks;
end
% Data
LickPort=Analysis.Parameters.Licks.Port;

%% Data extraction
for t=1:nTrials
try
    dataTrial{t+nTrialsOffset}=SessionData.RawEvents.Trial{1,t}.Events.(LickPort);
catch
    dataTrial{t+nTrialsOffset}=NaN;  
end
end

%% Save in Analysis structure
Analysis.Core.Licks=dataTrial;
end