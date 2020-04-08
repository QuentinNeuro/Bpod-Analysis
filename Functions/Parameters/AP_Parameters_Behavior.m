function handles=AP_Parameters_Behavior(handles,SessionData,DefaultParam,Name)
%% Time reshaping Part1
% See end of the function to overwrite based on defaultParam
handles.TimeReshaping=0;

% Phase
try
    handles.Phase=SessionData.TrialSettings(1).Names.Phase{SessionData.TrialSettings(1).GUI.Phase};
catch
    handles.Phase=DefaultParam.Phase;
end

%% Behavior specific
handles.TypeOfCue='na';
if contains(Name,'Cued','IgnoreCase',true) && ~contains(Name,'Sensor','IgnoreCase',true)
    handles.Behavior='CuedOutcome';
    if isfield(SessionData.RawEvents.Trial{1,1}.States,'SoundDelivery')
        handles.StateOfCue='SoundDelivery';
    elseif isfield(SessionData.RawEvents.Trial{1,1}.States,'CueDelivery')
        handles.StateOfCue='CueDelivery';
    end
    if isfield(SessionData.TrialSettings(1),'Names')
        handles.TypeOfCue=SessionData.TrialSettings(1).Names.Cue{SessionData.TrialSettings(1).GUI.CueType};
    end
    handles.StateOfOutcome='Outcome';
    handles.CueTimeReset=[0 1];
    handles.OutcomeTimeReset=[0 2];
    handles.NidaqBaseline=[0.2 1.2];
elseif contains(Name,'GoNogo','IgnoreCase',true)
    handles.Behavior='GoNogo';
	handles.StateOfCue='CueDelivery';
    handles.StateOfOutcome='PostOutcome';
    handles.CueTimeReset=[-0.1 0];
    handles.OutcomeTimeReset=[0 -3];
    handles.NidaqBaseline=[0.2 1.2];
    handles.TimeReshaping=1;
elseif contains(Name,'AuditoryTuning','IgnoreCase',true)
    handles.Behavior='AuditoryTuning';
	handles.StateOfCue='CueDelivery';
    handles.StateOfOutcome='CueDelivery';
    handles.Phase='AuditoryTuning';
    handles.PlotSummary1=0;
    handles.PlotSummary2=0;
    handles.PlotFiltersSingle=0;
    handles.PlotFiltersSummary=0; 
    handles.PlotFiltersBehavior=0;
    handles.CueTimeReset=[0 1];
    handles.OutcomeTimeReset=[0 2];
    handles.NidaqBaseline=[0.2 1.2];
elseif contains(Name,'Oddball','IgnoreCase',true)
    handles.Behavior='Oddball';
	handles.StateOfCue='PreState';
    handles.StateOfOutcome='PreState';
    handles.PlotSummary1=0;
    handles.PlotSummary2=0;
    handles.PlotFiltersSingle=0;
    handles.PlotFiltersSummary=1;
    handles.PlotFiltersBehavior=0;
    handles.CueTimeReset=[0 1];
    handles.OutcomeTimeReset=[0 2];
    handles.NidaqBaseline=[0 1];
elseif contains(Name,'Sensor','IgnoreCase',true)
    handles.Behavior='Sensor';
    handles.StateOfCue='CueDelivery';
    handles.StateOfOutcome='Outcome';
    handles.CueTimeReset=[0 1];
    handles.OutcomeTimeReset=[0 2];
    handles.NidaqBaseline=[0.2 1.2];
    handles.TimeReshaping=1;
else
    handles.Behavior=DefaultParam.Behavior;
	handles.StateOfCue=DefaultParam.StateOfCue;
	handles.StateOfOutcome=DefaultParam.StateOfOutcome; 
    handles.CueTimeReset=DefaultParam.CueTimeReset;
    handles.CueTimeReset=DefaultParam.CueTimeReset;
    handles.NidaqBaseline=DefaultParam.NidaqBaseline;
    if isempty(handles.StateOfCue) || isempty(handles.StateOfOutcome) || isempty(handles.CueTimeReset) || isempty(handles.CueTimeReset) || isempty(handles.NidaqBaseline)
        disp('State names for cue and outcome delivery (or other type of states)...') ;
        disp('need to be defined in the launcher (or directly in AP_Parameters function)');
        return
    end
end

%% Time reshaping Part2
if ~isempty(DefaultParam.TimeReshaping)
handles.TimeReshaping=DefaultParam.TimeReshaping;
end
if DefaultParam.ZeroFirstLick
    handles.TimeReshaping=1;
end

end