function Par=AP_Parameters_Behavior(Par,SessionData,LP,Name)

Par.Behavior.nTrials=SessionData.nTrials;
Par.Behavior.nbOfTrialTypes=max(SessionData.TrialTypes);
if isfield(SessionData.TrialSettings(1),'TrialsNames')
    Par.Behavior.TrialNames=SessionData.TrialSettings(1).TrialsNames;
else
if isfield(SessionData.TrialSettings(1),'TirlasNames')
    Par.Behavior.TrialNames=SessionData.TrialSettings(1).TirlasNames;
else
    Par.Behavior.TrialNames=LP.D.TrialNames; % Default
end
end

try
    Par.Behavior.Phase=SessionData.TrialSettings(1).Names.Phase{SessionData.TrialSettings(1).GUI.Phase};
catch
    Par.Behavior.Phase=LP.D.Behavior.Phase;
end
%% Behavior specific
Par.Behavior.TypeOfCue='nc';
Par.Data.NidaqBaseline=[0.2 1.2];

if contains(Name,'Cued','IgnoreCase',true) && ~contains(Name,'Sensor','IgnoreCase',true)  && ~contains(Name,'AudCuedPavl','IgnoreCase',true)
    Par.Behavior.Behavior='CuedOutcome';
    Par.Behavior.TypeOfCue='Chirp';
    if isfield(SessionData.RawEvents.Trial{1,1}.States,'SoundDelivery')
        Par.Behavior.StateOfCue='SoundDelivery';
    elseif isfield(SessionData.RawEvents.Trial{1,1}.States,'CueDelivery')
        Par.Behavior.StateOfCue='CueDelivery';
    end
    if isfield(SessionData.TrialSettings(1),'Names')
        if isfield(SessionData.TrialSettings(1).Names,'Cue')
        Par.Behavior.TypeOfCue=SessionData.TrialSettings(1).Names.Cue{SessionData.TrialSettings(1).GUI.CueType};
        elseif isfield(SessionData.TrialSettings(1).GUI,'VisualCue')
            if SessionData.TrialSettings(1).GUI.VisualCue 
                Par.Behavior.TypeOfCue='Visual'; 
            end
        end
    end
    Par.Behavior.StateOfOutcome='Outcome';
    if isfield(SessionData.TrialSettings(1),'Delay')
        Par.Timing.CueTimeReset=[0 SessionData.TrialSettings(1).Delay];
    else
        Par.Timing.CueTimeReset=[0 1];
    end
    Par.Timing.OutcomeTimeReset=[0 2];
elseif contains(Name,'GoNogo','IgnoreCase',true)
    Par.Behavior.Behavior='GoNogo';
	Par.Behavior.StateOfCue='CueDelivery';
    Par.Behavior.StateOfOutcome='PostOutcome';
    Par.Timing.CueTimeReset=[-0.1 0];
    Par.Timing.OutcomeTimeReset=[0 -3];

elseif contains(Name,'AuditoryTuning','IgnoreCase',true)
    Par.Behavior.Behavior='AuditoryTuning';
	Par.Behavior.StateOfCue='CueDelivery';
    Par.Behavior.StateOfOutcome='CueDelivery';
    Par.Behavior.Phase='AuditoryTuning';
    Par.Plot.TrialTypes=0;
    Par.Timing.CueTimeReset=[0 1.5];
    Par.Timing.OutcomeTimeReset=[-1.6 -0.6];
    % Par.ZeroAt=0;
    Par.Data.BaselineBefAft=1;

elseif contains(Name,'OptoPsycho','IgnoreCase',true)
    Par.Behavior.Behavior='OptoPsycho';
	Par.Behavior.StateOfCue='CueDelivery';
    Par.Behavior.StateOfOutcome='PostOutcome';
    Par.Behavior.Phase='OptoPsycho';
    Par.Timing.CueTimeReset=[0 1];
    Par.Timing.OutcomeTimeReset=[0 -2];
    % Par.ZeroAt=0;
    Par.Data.BaselineBefAft=1;
    
elseif contains(Name,'VisualTuning','IgnoreCase',true)
    Par.Behavior.Behavior='VisualTuning';
	Par.Behavior.StateOfCue='CueDelivery';
    Par.Behavior.StateOfOutcome='CueDelivery';
    Par.Behavior.Phase='VisualTuning';
    Par.Timing.CueTimeReset=[0 2];
    Par.Timing.OutcomeTimeReset=[-1.5 -0.5];
    % Par.ZeroAt=0;
    Par.Timing.BaselineBefAft=1;

elseif contains(Name,'OptoTuning','IgnoreCase',true)
    Par.Behavior.Behavior='OptoTuning';
    if isfield(SessionData.RawEvents.Trial{1, 1}.States,'CueDelivery')
	    Par.Behavior.StateOfCue='CueDelivery';
        Par.Behavior.StateOfOutcome='CueDelivery';
    else
        Par.Behavior.StateOfCue='StimDelivery';
        Par.Behavior.StateOfOutcome='StimDelivery';
    end
    Par.Behavior.Phase='OptoTuning';
    Par.Timing.CueTimeReset=[-1.1 -1.1];
    Par.Timing.OutcomeTimeReset=[0 2];
    % Par.ZeroAt=-0.5;
    Par.Data.BaselineBefAft=1;
    if sum(contains(Par.TrialNames,'Train_1Hz_500s_5ms_5V'))>0
        Par.Behavior.TrialNames(contains(Par.TrialNames,'Train_1Hz_500s_5ms_5V'))={'Train_10Hz_500ms_5ms_5V'};
    end
    if sum(contains(Par.TrialNames,'Train_10Hz_500s_5ms_5V'))>0
        Par.Behavior.TrialNames(contains(Par.TrialNames,'Train_10Hz_500s_5ms_5V'))={'Train_10Hz_500ms_5ms_5V'};
    end

elseif contains(Name,'Oddball','IgnoreCase',true)
    Par.Behavior.Behavior='Oddball';
	Par.Behavior.StateOfCue='PreState';
    Par.Behavior.StateOfOutcome='PreState';
    Par.Plot.TrialTypes=0;
    Par.Timing.CueTimeReset=[0 1];
    Par.Timing.OutcomeTimeReset=[0 2];
    Par.Timing.PSTH=[0 180];
    if isfield(SessionData.TrialSettings(1).Names,'Sound')
        Par.Behavior.TypeOfCue=SessionData.TrialSettings(1).Names.Sound{SessionData.TrialSettings(1).GUI.SoundType};
    end

elseif contains(Name,'Sensor','IgnoreCase',true)
    Par.Behavior.Behavior='Sensor';
    Par.Behavior.StateOfCue='CueDelivery';
    Par.Behavior.StateOfOutcome='Outcome';
    Par.Timing.CueTimeReset=[0 1];
    Par.Timing.OutcomeTimeReset=[0 2];
    Par.Photometry.Labels={'470-BLA' '565' '470-VS'};

elseif contains(Name,'Continuous','IgnoreCase',true)
    Par.Behavior.Behavior='Continuous';
	Par.Behavior.StateOfCue='PreState';
    Par.Behavior.StateOfOutcome='Outcome';
    Par.Plot.TrialTypes=0;
    Par.Timing.CueTimeReset=[0 1];
    Par.Timing.OutcomeTimeReset=[0 2];
    Par.Timing.PSTH=[-20 150];   

elseif contains(Name,'AudCuedPavl','IgnoreCase',true)
    Par.Name='AOD_ACh';        %'AOD_ACh' - VIP-GCaMP
    Par.Rig='AOD';             %'AOD' 'NA'
    Par.Behavior.Behavior='CuedOutcome'; %CuedReward
    Par.Behavior.Phase='RewardA';
    Par.Behavior.CueType='Chirp';
    Par.Behavior.TrialNames={'Cue A Reward','T2','T3','T4','Cue A Omission','Cue B Omission','Uncued Reward','T8','T9','T10'};
    Par.Licks.Port='Port1In';
    Par.Behavior.StateOfCue='DeliverStimulus'; %DeliverStimulus
    Par.Behavior.StateOfOutcome='DeliverStimulus';
%     Par.StateToZero='StateOfCue';
    Par.Timing.CueTimeReset=[0 2];
    Par.Timing.OutcomeTimeReset=[2 4];
    Par.Timing.PSTH=[-6 6]; 

else
    Par.Behavior.Behavior=LP.D.Behavior;
	Par.Behavior.StateOfCue=LP.D.StateOfCue;
	Par.Behavior.StateOfOutcome=LP.D.StateOfOutcome; 
    Par.Timing.CueTimeReset=LP.D.CueTimeReset;
    Par.Timing.OutcomeTimeReset=LP.D.OutcomeTimeReset;
    Par.Data.NidaqBaseline=LP.D.NidaqBaseline;
    if isempty(Par.StateOfCue) || isempty(Par.StateOfOutcome) || isempty(Par.CueTimeReset) || isempty(Par.CueTimeReset) || isempty(Par.NidaqBaseline)
        disp('State names for cue and outcome delivery (or other type of states)...') ;
        disp('need to be defined in the launcher (or directly in AP_Parameters function)');
        return
    end
end
end