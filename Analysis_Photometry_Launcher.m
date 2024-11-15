%% Bpod Photometry Launcher
% Launcher for an analysis pipeline originally designed for photometry
% using Bpod to control the behavior of the animal. It can now be used for
% AOD or e-phy data
% 'Analysis_Photometry' is the core function used to extract, organize and
% filters the data according to the behavioral task

clear SessionData Analysis LP; %close all;

%% Analysis type Single/Group/Batch/Online etc
LP.Analysis_type='Online';
LP.Save=0;      % 1: Core Data only     // 2: Full Analysis Structure
LP.SaveTag=[];  % string to be added to the saved analysis file name
DB.DataBase=0;  % DB_Generate
DB.Group=[];
% global TuningYMAX;
%% Overwritting Parameters
LP.OW.PhotoChNames={'F1','F2'}; %{'ACx' 'mPFC' 'ACxL' 'ACxR' 'VS' 'BLA'}
LP.OW.CueTimeReset=[]; % Uncertainty : 0 0.5
LP.OW.OutcomeTimeReset=[]; %AOD [0 1] %GoNoGo default [0 -3];
LP.OW.NidaqBaseline=[]; 
%% Analysis Parameters
LP.P.SortFilters=1;
LP.P.SortCells=0;
LP.P.EventDetection=0;
LP.P.Pairing=0;
% Figures
LP.P.PlotSummary1=1;
LP.P.PlotSummary2=0;
LP.P.PlotFiltersSingle=0;               % AP_CuedOutcome_FilterGroups
LP.P.PlotFiltersSummary=0;
LP.P.PlotFiltersBehavior=0;           	% AP_####_GroupToPlot Oupput 2
LP.P.PlotCells=0;                       % Generate single cell figures
LP.P.Illustrator=0;
LP.P.Transparency=1;
LP.P.Illustration=[1 0 0];                % #1 basic filtergroup #2 no ylim on rasters #3 arousal plots
% Axis
LP.P.PlotX=[-3 4];
LP.P.PlotY_photo(1,:)=[NaN NaN];     	% Tight axis if [NaN NaN] / TBD [min max]
LP.P.PlotY_photo(2,:)=[NaN NaN];        % Tight axis if [NaN NaN] / TBD [min max]
% States and Timing
LP.P.StateToZero='StateOfOutcome';    	%'StateOfCue' 'StateOfOutcome'
LP.P.ZeroFirstLick=0;                   % Will look for licks 0 to 2 sec after state to Zero starts
LP.P.ZeroAt='none';                 % Will zero fluo for each trial to a time point : 'Zero' '2sBefCue' or a timestamp
LP.P.CueTimeLick=[];                    % Use a different window to calculate lickrate at cue; % Uncertainty : 1.5 1.9
LP.P.WheelState='Baseline';             % Options : 'Baseline','Cue','Outcome'
LP.P.PupilState='NormBaseline';       	% Options : 'NormBaseline','Cue','Outcome'
LP.P.ReshapedTime=[-5 5];               % PSTH - use [0 180] for oddball
% Filters % default LicksCue=1 LicksOut=2
LP.P.PupilThreshold=1;
LP.P.WheelThreshold=2;                  % Speed cm/s
LP.P.LicksCue=1;                        % default : 1 or 2
LP.P.LicksOutcome=2;                    % default : 2
LP.P.TrialToFilterOut=[];
LP.P.LoadIgnoredTrials=1;
% Fluorescence % default Zsc=1 mov=5 befAft=1 SR=20
LP.P.Zscore=1;                          % 
LP.P.BaselineMov=5;                     % 0 to not have moving baseline avg (avg and std)
LP.P.BaselineBefAft=2;                  % calculate Baseline before or after extracting desired PSTH
LP.P.BaselineHisto=0;                   % percentage of data from the baseline to use
LP.P.BaselineFit=0;                     % To come
LP.P.CueStats='MAXZ';                   % Options : AVG AVGZ MAX MAXZ
LP.P.OutcomeStats='MAXZ';               % Options : AVG AVGZ MAX MAXZ
LP.P.NidaqDecimatedSR=20;               % in Hz 20 for figures 100 for archiving
LP.P.Fit_470405=0;
LP.OW.PhotoCh={};                       % Force one channel only '470' - useful to group sessions with different channels
% Event detection %AP_DataProcess_Events
LP.P.EventThreshFactor=0.8;             % will be applied to the data std to detect events ACh=0.5 DA=0.8
LP.P.EventMinFactor=0.5;                % will be applied to the threshold to restrict local minima
LP.P.EventMinTW='auto';                 % TW left of the peak to find minimum. 'auto' : use the width of the peak, 0 to use time between two peaks.
LP.P.EventWV=1;                         % in sec. Time window for waveform event extraction. 0 to ignore.
LP.P.EventEpochTW=[-4.8 -2.8; -2.3 -0.3; 0 2]; % Uncertainty [-4.8 -2.8; -2.3 -0.3; 0 2] Uncertainty2 [-4.5 -4; -2.5 -2; -0.5 0];
LP.P.EventEpochNames={'Baseline','Cue','Reward'};
%% AOD
% AP_DataCore_AOD AP_DataProcess_AOD AP_DataSort_AOD AP_CuedOutcome_FiltersAndPlot_AOD
LP.P.AOD.raw=1;                        % load raw vs dff data (new Analysis only)
LP.P.AOD.timing='TTL';                 % Bpod, TTL
LP.P.AOD.smoothing=20;                 % smoothing 'Gaussian parameters' / used 20 for VIP_AOD data
LP.P.AOD.decimateSR=0;                 % does not work :/
LP.P.AOD.offset='auto';                % 'auto' = minimum-1 vs integer ~120 according to Z
LP.P.AOD.rewT='meanPos';               % integer vs 'mean' 'median' 'meanPos'
%% Spikes
LP.P.TE4CellBase=0;
LP.P.Spikes.Clustering='Kilosort'; %Kilosort MClust
LP.P.Spikes.BinSize=0.1;
LP.P.Spikes.tagging_timeW=[-0.3 0.3];
LP.P.Spikes.tagging_TTL=2;
LP.P.Spikes.pThreshold=[0.01 0.05]; %Latency / FR;
LP.P.Spikes.TTLTS_spikeTS_Factor=10000; % for MClust clustered spikes
%% Miniscope
LP.P.Miniscope.SR=10;
LP.P.Miniscope.raw=1;
%% Archiving photometry data
LP.Archive=0; %
LP.ArchiveOnly=0;
LP.ArchiveOW=0;
%% Default Parameters [Used if not found in Bpod file]
LP.D.Name='AOD_ACh';        %'AOD_ACh' - VIP-GCaMP
LP.D.Rig='AOD';             %'AOD' 'NA'
LP.D.Behavior='AOD_AudPav'; %CuedReward
LP.D.Phase='RewardA';
LP.D.CueType='Chirp';
LP.D.PhotoChNames={'470-A1L' '405-A1' '470-A1R'};%{'470-A1L' '405-A1' '470-A1R'};{'470-A1' '405-A1' '470-mPFC'}
LP.D.SamplingRate=2000;  %(Hz)
LP.D.TrialNames={'Cue A Reward','T2','T3','T4','Cue A Omission','Cue B Omission','Uncued Reward','T8','T9','T10'};
LP.D.LickPort='Port1In';
LP.D.StateOfCue='DeliverStimulus'; %DeliverStimulus
LP.D.StateOfOutcome='WaitForLick';
LP.D.CueTimeReset=[0 1];
LP.D.OutcomeTimeReset=[0 1];
LP.D.NidaqBaseline=[1 2];
LP.D.Stimulation=0;
% autoload deactivated
LP.AutoLoad=1;
LP.D.Load=0;
LP.D.Photometry=0;
LP.D.Spikes.Spikes=0;
LP.D.AOD.AOD=0;
LP.D.Miniscope.Miniscope=0;
%% Database
if ~exist('DB_Stat','var')
    DB_Stat=struct();
end

%% File selection and Analysis Photometry Run
switch LP.Analysis_type
    case 'Batch'
        [errorFile,DB_Stat]=AP_FileBatch(LP,DB,DB_Stat,'DataBase'); % Spikes DataBase MegaBatch
    case 'Online'
        AP_FileOnline(LP);
    case {'Single', 'Group'}
        [Analysis,DB_Stat]=AP_FileManual(LP,DB,DB_Stat);
end