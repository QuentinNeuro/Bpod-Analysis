function Par=AP_Parameters_Behavior(Par,SessionData,LP,Name)

Par.nTrials=SessionData.nTrials;
Par.nbOfTrialTypes=max(SessionData.TrialTypes);
if isfield(SessionData.TrialSettings(1),'TrialsNames')
    Par.TrialNames=SessionData.TrialSettings(1).TrialsNames;
else
if isfield(SessionData.TrialSettings(1),'TirlasNames')
    Par.TrialNames=SessionData.TrialSettings(1).TirlasNames;
else
    Par.TrialNames=LP.D.TrialNames; % Default
end
end

try
    Par.Phase=SessionData.TrialSettings(1).Names.Phase{SessionData.TrialSettings(1).GUI.Phase};
catch
    Par.Phase=LP.D.Phase;
end
%% Behavior specific
Par.TypeOfCue='nc';
if contains(Name,'Cued','IgnoreCase',true) && ~contains(Name,'Sensor','IgnoreCase',true)
    Par.Behavior='CuedOutcome';
    Par.TypeOfCue='Chirp';
    if isfield(SessionData.RawEvents.Trial{1,1}.States,'SoundDelivery')
        Par.StateOfCue='SoundDelivery';
    elseif isfield(SessionData.RawEvents.Trial{1,1}.States,'CueDelivery')
        Par.StateOfCue='CueDelivery';
    end
    if isfield(SessionData.TrialSettings(1),'Names')
        if isfield(SessionData.TrialSettings(1).Names,'Cue')
        Par.TypeOfCue=SessionData.TrialSettings(1).Names.Cue{SessionData.TrialSettings(1).GUI.CueType};
        elseif isfield(SessionData.TrialSettings(1).GUI,'VisualCue')
            if SessionData.TrialSettings(1).GUI.VisualCue 
                Par.TypeOfCue='Visual'; 
            end
        end
    end
    Par.StateOfOutcome='Outcome';
    if isfield(SessionData.TrialSettings(1),'Delay')
        Par.CueTimeReset=[0 SessionData.TrialSettings(1).Delay];
    else
        Par.CueTimeReset=[0 1];
    end
    Par.OutcomeTimeReset=[0 2];
    Par.NidaqBaseline=[0.2 1.2];
elseif contains(Name,'GoNogo','IgnoreCase',true)
    Par.Behavior='GoNogo';
	Par.StateOfCue='CueDelivery';
    Par.StateOfOutcome='PostOutcome';
    Par.CueTimeReset=[-0.1 0];
    Par.OutcomeTimeReset=[0 -5];
    Par.NidaqBaseline=[0.2 1.2];
%     Par.TimeReshaping=1;
elseif contains(Name,'AuditoryTuning','IgnoreCase',true)
    Par.Behavior='AuditoryTuning';
	Par.StateOfCue='CueDelivery';
    Par.StateOfOutcome='CueDelivery';
    Par.Phase='AuditoryTuning';
    Par.PlotSummary1=0;
    Par.PlotSummary2=0;
    Par.PlotFiltersSingle=0;
    Par.PlotFiltersSummary=0; 
    Par.PlotFiltersBehavior=0;
    Par.CueTimeReset=[0 1];
    Par.OutcomeTimeReset=[0 2];
    Par.NidaqBaseline=[0.2 1.2];
elseif contains(Name,'Oddball','IgnoreCase',true)
    Par.Behavior='Oddball';
	Par.StateOfCue='PreState';
    Par.StateOfOutcome='PreState';
    Par.PlotSummary1=0;
    Par.PlotSummary2=0;
    Par.PlotFiltersSingle=0;
    Par.PlotFiltersSummary=1;
    Par.PlotFiltersBehavior=0;
    Par.CueTimeReset=[0 1];
    Par.OutcomeTimeReset=[0 2];
    Par.NidaqBaseline=[0 1];
    Par.ReshapedTime=[0 180];
    if isfield(SessionData.TrialSettings(1).Names,'Sound')
        Par.TypeOfCue=SessionData.TrialSettings(1).Names.Sound{SessionData.TrialSettings(1).GUI.SoundType};
    end
elseif contains(Name,'Sensor','IgnoreCase',true)
    Par.Behavior='Sensor';
    Par.StateOfCue='CueDelivery';
    Par.StateOfOutcome='Outcome';
    Par.CueTimeReset=[0 1];
    Par.OutcomeTimeReset=[0 2];
    Par.NidaqBaseline=[0.2 1.2];
%     Par.TimeReshaping=1;
elseif contains(Name,'Continuous','IgnoreCase',true)
    Par.Behavior='Continuous';
	Par.StateOfCue='PreState';
    Par.StateOfOutcome='Outcome';
    Par.PlotSummary1=1;
    Par.PlotSummary2=0;
    Par.PlotFiltersSingle=0;
    Par.PlotFiltersSummary=0;
    Par.PlotFiltersBehavior=0;
    Par.CueTimeReset=[0 1];
    Par.OutcomeTimeReset=[0 2];
    Par.NidaqBaseline=[1 5];
    Par.ReshapedTime=[-20 100];   
else
    Par.Behavior=LP.D.Behavior;
	Par.StateOfCue=LP.D.StateOfCue;
	Par.StateOfOutcome=LP.D.StateOfOutcome; 
    Par.CueTimeReset=LP.D.CueTimeReset;
    Par.OutcomeTimeReset=LP.D.OutcomeTimeReset;
    Par.NidaqBaseline=LP.D.NidaqBaseline;
    if isempty(Par.StateOfCue) || isempty(Par.StateOfOutcome) || isempty(Par.CueTimeReset) || isempty(Par.CueTimeReset) || isempty(Par.NidaqBaseline)
        disp('State names for cue and outcome delivery (or other type of states)...') ;
        disp('need to be defined in the launcher (or directly in AP_Parameters function)');
        return
    end
end
end