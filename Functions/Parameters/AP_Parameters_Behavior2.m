function Par=AP_Parameters_Behavior2(Par,SessionData,LP,Name)

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
Par.Data.NidaqBaseline=[0.2 1.2];
Par.Behavior.Behavior=[];
Par.Behavior.TypeOfCue='nc';
Par.Behavior.EpochStates='';
Par.Behavior.EpochNames='';
Par.Behavior.EpochTimeReset=[];

%% CuedOutcome
switch Name
     case {'CuedOutcome' 'CuedReward' 'CuedOutcome_Sensors'}
Par.Behavior.Behavior='CuedOutcome';
Par.Behavior.TypeOfCue='Chirp';
Par.Behavior.EpochNames={'Cue' 'Outcome'};
Par.Behavior.EpochStates={'CueDelivery' 'Outcome'};
Par.Behavior.EpochTimeReset=[0 1 ; 0 2];

if isfield(SessionData.RawEvents.Trial{1,1}.States,'SoundDelivery')
    Par.Behavior.EpochStates{1}='SoundDelivery';
end
if isfield(SessionData.TrialSettings(1),'Delay')
    Par.Behavior.EpochTimeReset(1,2)=SessionData.TrialSettings(1).Delay;
end
if isfield(SessionData.TrialSettings(1),'Names') && isfield(SessionData.TrialSettings(1).Names,'Cue')
    Par.Behavior.TypeOfCue=SessionData.TrialSettings(1).Names.Cue{SessionData.TrialSettings(1).GUI.CueType};
    elseif isfield(SessionData.TrialSettings(1).GUI,'VisualCue') && SessionData.TrialSettings(1).GUI.VisualCue 
    Par.Behavior.TypeOfCue='Visual'; 
end

     case 'OptoPsycho'
Par.Behavior.Behavior='OptoPsycho';
Par.Behavior.Phase='OptoPsycho';
Par.Behavior.TypeOfCue='Chirp';
Par.Behavior.EpochNames={'Cue' 'Outcome'};
Par.Behavior.EpochStates={'CueDelivery' 'PostOutcome'};
Par.Behavior.EpochTimeReset=[0 1 ; 0 -2];

    case'GoNogo'
Par.Behavior.Behavior='GoNogo';
Par.Behavior.EpochNames={'Cue' 'Outcome'};
Par.Behavior.EpochStates={'CueDelivery' 'PostOutcome'};
Par.Behavior.EpochTimeReset=[-0.1 0 ; 0 -3];

%% Tuning protocols
    case {'AuditoryTuning', 'VisualTuning', 'OptoTuning'}
Par.Behavior.Behavior=Name;
Par.Behavior.Phase='Tuning';
Par.Behavior.EpochNames{1}='Cue';
Par.Behavior.EpochStates{1}='CueDelivery';
Par.Behavior.EpochTimeReset=[0 1.5];
Par.Data.BaselineBefAft=1;
% Adjustment for OptoTuning
if isfield(SessionData.RawEvents.Trial{1, 1}.States,'StimDelivery')
    Par.Behavior.EpochStates{1}='StimDelivery';
end
if sum(contains(Par.TrialNames,'Train_1Hz_500s_5ms_5V'))>0
    Par.Behavior.TrialNames(contains(Par.TrialNames,'Train_1Hz_500s_5ms_5V'))={'Train_10Hz_500ms_5ms_5V'};
end
if sum(contains(Par.TrialNames,'Train_10Hz_500s_5ms_5V'))>0
    Par.Behavior.TrialNames(contains(Par.TrialNames,'Train_10Hz_500s_5ms_5V'))={'Train_10Hz_500ms_5ms_5V'};
end

%% Long recordings
    case {'Oddball', 'Continuous'}
Par.Behavior.Behavior=Name;
Par.Data.BaselineBefAft=1;
Par.Timing.PSTH=[0 max(diff(SessionData.TrialStartTimestamp))];
if isfield(SessionData.TrialSettings(1).Names,'Sound')
    Par.Behavior.TypeOfCue=SessionData.TrialSettings(1).Names.Sound{SessionData.TrialSettings(1).GUI.SoundType};
end 
end

%% Other users and default parameters
if isempty(Par.Behavior.Behavior)
if contains(Name,'AudCuedPavl','IgnoreCase',true)
    Par.Name='AOD_ACh';        %'AOD_ACh' - VIP-GCaMP
    Par.Rig='AOD';             %'AOD' 'NA'
    Par.Behavior.Behavior='CuedOutcome'; %CuedReward
    Par.Behavior.Phase='RewardA';
    Par.Behavior.CueType='Chirp';
    Par.Behavior.TrialNames={'Cue A Reward','T2','T3','T4','Cue A Omission','Cue B Omission','Uncued Reward','T8','T9','T10'};
    
    Par.Behavior.EpochNames={'Cue' 'Outcome'};
    Par.Behavior.EpochStates={'DeliverStimulus' 'DeliverStimulus'};
    Par.Behavior.EpochTimeReset=[0 2 ; 2 4];
    Par.Timing.PSTH=[-6 6]; 

else
    Par.Behavior.Behavior=LP.D.Behavior;
end
end