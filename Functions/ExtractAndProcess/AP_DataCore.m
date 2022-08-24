function Analysis=AP_DataCore(Analysis,SessionData,Pup)
% Create a Analysis.Core data structure containing lightly pre-processed bpod data including :
% licks, photometry, running, pupillometry and timing information.
% Should be able to reload, merge and process this structure

%% Session grouping specific
if ~isfield(Analysis,'Core')
        Analysis.Core.nTrials=0;
        Analysis.Core.Session(1)=0;
end
thisSession=Analysis.Core.Session(end)+1;
Analysis.Core.BpodSettings{thisSession}=SessionData.TrialSettings(1);

%% Populate Analysis.Core
for thisTrial=1:SessionData.nTrials
    i=Analysis.Core.nTrials+1;
    Analysis.Core.nTrials=i;
    Analysis.Core.TrialNumbers(i)=i;
    Analysis.Core.Session(i)=thisSession;
    Analysis.Core.TrialTypes(i)=SessionData.TrialTypes(thisTrial);
	Analysis.Core.TrialStartTS(i)=SessionData.TrialStartTimestamp(thisTrial); 
    Analysis.Core.States{i}=SessionData.RawEvents.Trial{1,thisTrial}.States;
try
    Analysis.Core.Licks{i}           =AP_DataCore_Licks(SessionData,Analysis,thisTrial);
    Analysis.Core.Photometry{i}      =AP_DataCore_Photometry(SessionData,Analysis,thisTrial);
    Analysis.Core.Wheel{i}           =AP_DataCore_Wheel(SessionData,Analysis,thisTrial);
    Analysis.Core.Pup{i}             =AP_DataCore_Pupil(Pup,Analysis,thisTrial,i);
    [~,Analysis.Core.PupSmooth{i}]   =AP_DataCore_Pupil(Pup,Analysis,thisTrial,i);
    [~,~,Analysis.Core.PupBlink{i}]  =AP_DataCore_Pupil(Pup,Analysis,thisTrial,i);
catch
    Analysis.Filters.ignoredTrials(i)=false;
end
    switch Analysis.Parameters.Behavior
    case 'Oddball'
    Analysis.Core.Oddball_StateSeq{i}=SessionData.TrialSettings(thisTrial).StateSequence;
    Analysis.Core.Oddball_SoundSeq{i}=SessionData.TrialSettings(thisTrial).SoundSequence;
    Analysis.Parameters.Oddball_SoundITI=SessionData.TrialSettings(1).GUI.ITI;
    end
end  

if Analysis.Parameters.AOD.AOD
    Analysis=AP_DataCore_AOD(Analysis);
end

if Analysis.Parameters.Spikes.Spikes
    Analysis=AP_DataCore_Spikes(Analysis);
end
end