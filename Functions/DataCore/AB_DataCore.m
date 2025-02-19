function Analysis=AB_DataCore(Analysis,SessionData)
% Create a Analysis.Core data structure containing lightly pre-processed bpod data including :
% licks, photometry, running, pupillometry and timing information.
% Should be able to reload, merge and process this structure

%% Initiate Core
nSession=Analysis.Parameters.Behavior.nSessions(end);
if nSession==1
    Analysis.Core.nTrials=0;
end

%% Create a filter to ignore trials
Analysis=AB_FilterIgnoredTrials(Analysis);

%% Trial parameters
Analysis.Core.BpodSettings{nSession}=SessionData.TrialSettings(1);

for thisTrial=1:SessionData.nTrials
    i=Analysis.Core.nTrials+1;
    Analysis.Core.nTrials=i;
    Analysis.Core.TrialNumbers(i)=i;
    Analysis.Core.Session(i)=nSession;
    Analysis.Core.TrialTypes(i)=SessionData.TrialTypes(thisTrial);
	Analysis.Core.TrialStartTS(i)=SessionData.TrialStartTimestamp(thisTrial); 
    Analysis.Core.States{i}=SessionData.RawEvents.Trial{1,thisTrial}.States;

    switch Analysis.Parameters.Behavior.Behavior
    case 'Oddball'
    Analysis.Core.Oddball_StateSeq{i}=SessionData.TrialSettings(thisTrial).StateSequence;
    Analysis.Core.Oddball_SoundSeq{i}=SessionData.TrialSettings(thisTrial).SoundSequence;
    Analysis.Parameters.Oddball_SoundITI=SessionData.TrialSettings(1).GUI.ITI;
    end
end  
%% Data extraction
% Licks
Analysis=AB_DataCore_Licks(Analysis,SessionData);
% Neuronal data
switch Analysis.Parameters.Data.RecordingType
    case 'Photometry'
Analysis=AB_DataCore_Photometry(Analysis,SessionData);
    case 'AOD'
Analysis=AB_DataCore_AOD(Analysis);
    case 'Spikes'
Analysis=AB_DataCore_Spikes(Analysis);
    case 'Miniscope'
Analysis=AB_DataCore_Miniscope(Analysis);
    case 'Prime'
Analysis=AB_DataCore_Prime(Analysis);
end
% Wheels and Pupil
Analysis=AB_DataCore_Wheel(Analysis,SessionData);
Analysis=AB_DataCore_Pupil(Analysis);

end