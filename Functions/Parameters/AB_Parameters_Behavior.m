function Par=AB_Parameters_Behavior(Par,SessionData,LP,Name)

%% General parameters
% Animal Name
USindex=strfind(Name,'_');
if ~isempty(USindex)
    Par.Animal=Name(1:USindex(1)-1);
else
    Par.Animal=LP.D.Name; % Default
end
switch LP.Analysis_type
    case 'Group'
Par.Name=Par.Animal;
    otherwise
Par.Name=Name;
end
% Rig Name
try
    Par.Rig=SessionData.TrialSettings(1).Names.Rig;
catch
    Par.Rig=LP.D.Rig; %Default
end
% File
if ~isfield(Par,'Files')
    Par.Files{1}=Name;
else
    Par.Files{end+1}=Name;
end


%% Task parameters
if isfield(Par,'Behavior')
    Par.Behavior.nSessions=Par.Behavior.nSessions+1;
else
    Par.Behavior.nSessions=1;
end

Par.Behavior.nTrials(Par.Behavior.nSessions)=SessionData.nTrials;
Par.Behavior.nbOfTrialTypes(Par.Behavior.nSessions)=length(unique(SessionData.TrialTypes));

if isfield(SessionData.TrialSettings(1),'TrialsNames')
    Par.Behavior.TrialNames=SessionData.TrialSettings(1).TrialsNames;
else
if isfield(SessionData.TrialSettings(1),'TirlasNames')
    Par.Behavior.TrialNames=SessionData.TrialSettings(1).TirlasNames;
else
    Par.Behavior.TrialNames=LP.D.Behavior.TrialNames; % Default
end
end

try
    Par.Behavior.Phase=SessionData.TrialSettings(1).Names.Phase{SessionData.TrialSettings(1).GUI.Phase};
catch
    Par.Behavior.Phase=LP.D.Behavior.Phase;
end

%% Behavior parameters
Par.Behavior.Behavior=[];
Par.Behavior.TypeOfCue='nc';
Par.Timing.EpochStates=[];
Par.Timing.EpochNames=[];
Par.Timing.EpochTimeReset_auto=[];
Par.Timing.EpochZeroPSTH=[];

%% CuedOutcome
% Pavlovian
if contains(Name, {'CuedOutcome' 'CuedReward' 'CuedOutcome_Sensors'})
Par.Behavior.Behavior='CuedOutcome';
Par.Behavior.TypeOfCue='Chirp';
Par.Timing.EpochNames={'Cue' 'Outcome' 'Delay'};
Par.Timing.EpochStates={'CueDelivery' 'Outcome' 'Delay'};
Par.Timing.EpochTimeReset_auto=[0 1 ; 0 2 ; 0 0];
Par.Timing.EpochZeroPSTH='Outcome';

if isfield(SessionData.RawEvents.Trial{1,1}.States,'SoundDelivery')
    Par.Timing.EpochStates{1}='SoundDelivery';
end
if isfield(SessionData.TrialSettings(1),'Delay')
    Par.Timing.EpochTimeReset_auto(1,2)=SessionData.TrialSettings(1).Delay;
end
if isfield(SessionData.TrialSettings(1),'Names') && isfield(SessionData.TrialSettings(1).Names,'Cue')
    Par.Behavior.TypeOfCue=SessionData.TrialSettings(1).Names.Cue{SessionData.TrialSettings(1).GUI.CueType};
    elseif isfield(SessionData.TrialSettings(1).GUI,'VisualCue') && SessionData.TrialSettings(1).GUI.VisualCue 
    Par.Behavior.TypeOfCue='Visual'; 
end
end
% optoPsycho
if contains(Name,'OptoPsycho')
Par.Behavior.Behavior='OptoPsycho';
Par.Behavior.Phase='OptoPsycho';
Par.Behavior.TypeOfCue='Chirp';
Par.Timing.EpochNames={'Cue' 'Outcome'};
Par.Timing.EpochStates={'CueDelivery' 'PostOutcome'};
Par.Timing.EpochTimeReset_auto=[0 1 ; 0 -2];
Par.Timing.EpochZeroPSTH='PostOutcome';
end
% GoNogo
if contains(Name,'GoNogo')
Par.Behavior.Behavior='GoNogo';
Par.Behavior.TypeOfCue='NC';
Par.Behavior.Phase='NC';
if isfield(SessionData.TrialSettings(1),'Names') && isfield(SessionData.TrialSettings(1).Names,'Cue')
    Par.Behavior.TypeOfCue=SessionData.TrialSettings(1).Names.Cue{SessionData.TrialSettings(1).GUI.CueType};
end
if isfield(SessionData.TrialSettings(1),'Names') && isfield(SessionData.TrialSettings(1).Names,'Phase')
    Par.Behavior.Phase=[SessionData.TrialSettings(1).Names.Phase{SessionData.TrialSettings(1).GUI.Phase}...
        ' ' SessionData.TrialSettings(1).Names.Type{SessionData.TrialSettings(1).GUI.Type}];
end
Par.Timing.EpochNames={'Cue' 'Outcome'};
Par.Timing.EpochStates={'CueDelivery' 'PostOutcome'};
Par.Timing.EpochTimeReset_auto=[-0.1 0 ; 0 -3];
Par.Timing.EpochZeroPSTH='PostOutcome';
end

%% Tuning protocols
if contains(Name,'AuditoryTuning')
Par.Behavior.Behavior='AuditoryTuning';
Par.Behavior.Phase='AuditoryTuning';
Par.Timing.EpochNames{1}='Cue';
Par.Timing.EpochStates{1}='CueDelivery';
Par.Timing.EpochTimeReset_auto=[0 1.5];
Par.Data.BaselineBefAft=1;
Par.Timing.EpochZeroPSTH='CueDelivery';
end

if contains(Name,'VisualTuning')
Par.Behavior.Behavior='VisualTuning';
Par.Behavior.Phase='VisualTuning';
Par.Timing.EpochNames{1}='Cue';
Par.Timing.EpochStates{1}='CueDelivery';
Par.Timing.EpochTimeReset_auto=[0 1.5];
Par.Data.BaselineBefAft=1;
Par.Timing.EpochZeroPSTH='CueDelivery';
end

if contains(Name,'OptoTuning')
Par.Behavior.Behavior='OptoTuning';
Par.Behavior.Phase='OptoTuning';
Par.Timing.EpochNames{1}='Cue';
Par.Timing.EpochStates{1}='CueDelivery';
Par.Timing.EpochTimeReset_auto=[0 1.5];
Par.Data.BaselineBefAft=1;
Par.Timing.EpochZeroPSTH='CueDelivery';
if isfield(SessionData.RawEvents.Trial{1, 1}.States,'StimDelivery')
    Par.Timing.EpochStates{1}='StimDelivery';
    Par.Timing.EpochZeroPSTH='StimDelivery';
end
if sum(contains(Par.Behavior.TrialNames,'Train_1Hz_500s_5ms_5V'))>0
    Par.Behavior.TrialNames(contains(Par.TrialNames,'Train_1Hz_500s_5ms_5V'))={'Train_10Hz_500ms_5ms_5V'};
end
if sum(contains(Par.Behavior.TrialNames,'Train_10Hz_500s_5ms_5V'))>0
    Par.Behavior.TrialNames(contains(Par.TrialNames,'Train_10Hz_500s_5ms_5V'))={'Train_10Hz_500ms_5ms_5V'};
end
end

%% Long recordings
if contains(Name,'Continuous')
Par.Behavior.Behavior='Continuous';
Par.Data.BaselineBefAft=1;
Par.Timing.PSTH=[0 max(diff(SessionData.TrialStartTimestamp))];
Par.Timing.EpochZeroPSTH='Outcome';
if isfield(SessionData.TrialSettings(1).Names,'Sound')
    Par.Behavior.TypeOfCue=SessionData.TrialSettings(1).Names.Sound{SessionData.TrialSettings(1).GUI.SoundType};
end 
end
if contains(Name,'Oddball')
Par.Behavior.Behavior='Oddball';
Par.Data.BaselineBefAft=1;
Par.Timing.EpochZeroPSTH='PreState';
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
    Par.Timing.EpochNames={'Cue' 'Outcome' 'Delay'};
    Par.Timing.EpochStates={'DeliverStimulus' 'DeliverStimulus' 'DeliverStimulus'};
    Par.Timing.EpochZeroPSTH='Cue';
    Par.Timing.EpochTimeReset_auto=[0 1 ; 1.5 3.5 ; 1 2];
    Par.Timing.PSTH=[-6 6]; 
else
    disp('Could not autodetect the behavior protocol')
    Par.Behavior=LP.D.Behavior;
end
end
%% Add Launcher Parameters
% Define PSTH Zero
if ~isempty(LP.OW.Timing.EpochZeroPSTH) & isempty(Par.Timing.EpochZeroPSTH)
     Par.Timing.EpochZeroPSTH=SessionData.RawData.OriginalStateNamesByNumber{1, 1}{1, 2};
end

% Add user specified epochs
if ~isempty(LP.P.Timing.EpochStates) | ~isempty(LP.P.Timing.EpochNames)
    Par.Timing.EpochNames=[Par.Timing.EpochNames LP.P.Timing.EpochNames];
    Par.Timing.EpochStates=[Par.Timing.EpochStates LP.P.Timing.EpochStates];
    Par.Timing.EpochTimeReset_auto=[Par.Timing.EpochTimeReset_auto ; LP.P.Timing.EpochTimeReset];
end


end