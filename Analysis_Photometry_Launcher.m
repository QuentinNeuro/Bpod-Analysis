%% Bpod Photometry Launcher
% Launcher for an analysis pipeline originally designed for photometry
% using Bpod to control the behavior of the animal. It can now be used for
% AOD or e-phy data
% 'Analysis_Photometry' is the core function used to extract, organize and
% filters the data according to the behavioral task
clear SessionData Analysis LP; %close all;
warning('off','all'); warning;

%% Analysis type Single/Group/Batch/Online etc
LP.Analysis_type='Single';
LP.Save=0;      % 1: Core Data only     // 2: Full Analysis Structure
LP.SaveTag=[];  % string to be added to the saved analysis file name
LP.BatchType='Spikes'; %Spikes DataBase MegaBatch %%AP_FileBatch
DB.DataBase=0;  % DB_Generate
DB.Group=[];
% global TuningYMAX;
%% Overwritting Parameters
LP.P.Data.Label={'F1','F2'}; %{'ACx' 'mPFC' 'ACxL' 'ACxR' 'VS' 'BLA'} --> more to OW
LP.OW.Timing.CueTimeReset=[]; % Uncertainty : 0 0.5
LP.OW.Timing.TimeReset=[]; %AOD [0 1] %GoNoGo default [0 -3];
LP.OW.Data.NidaqBaseline=[]; 
%% Analysis Parameters
LP.P.Filters.Sort=1;
LP.P.Filters.Cells=1;
LP.P.Filters.Pairing=0;
% Figures
LP.P.Plot.TrialTypes=1;                  % Raw trial types - no filter applied
LP.P.Plot.FiltersSingle=0;               % individual raster for individual trial type
LP.P.Plot.FiltersSummary=0;              % summary plot for groups of trial type
LP.P.Plot.FiltersBehavior=0;           	 % AP_####_GroupToPlot Oupput 2
LP.P.Plot.Cells=1;                       % Generate single cell filter figures
LP.P.Plot.Cells_Spike=1;                 % Specific to spike analysis
LP.P.Plot.Illustrator=0;
LP.P.Plot.Transparency=1;
LP.P.Plot.Illustration=[0 0 0];          % #1 basic filtergroup #2 no ylim on rasters #3 arousal plots
% Axis
LP.P.Plot.xTime=[-3 4];
LP.P.Plot.yPhoto(1,:)=[NaN NaN];     	 % Tight axis if [NaN NaN] / TBD [min max]
LP.P.Plot.yPhoto(2,:)=[NaN NaN];         % Tight axis if [NaN NaN] / TBD [min max]
% States and Timing
LP.P.Timing.StateToZero='StateOfOutcome'; %'StateOfCue' 'StateOfOutcome'
LP.P.Timing.ZeroFirstLick=0;              % Will look for licks 0 to 2 sec after state to Zero starts
LP.P.Timing.ZeroAt=-3;                    % Will zero fluo for each trial to a time point : 'Zero' '2sBefCue' or a timestamp
LP.P.Timing.CueTimeLick=[];               % Use a different window to calculate lickrate at cue; % Uncertainty : 1.5 1.9
LP.P.Timing.PSTH=[-4 5];                  % PSTH - use [0 180] for oddball
% Filters % default LicksCue=1 LicksOut=2
LP.P.Filters.PupilThreshold=1;
LP.P.Filters.PupilState='NormBaseline';       	% Options : 'NormBaseline','Cue','Outcome'
LP.P.Filters.WheelThreshold=2;                  % Speed cm/s
LP.P.Filters.WheelState='Baseline';             % Options : 'Baseline','Cue','Outcome'
LP.P.Filters.LicksCue=1;                        % default : 1 or 2
LP.P.Filters.LicksOutcome=2;                    % default : 2
LP.P.Filters.TrialToFilterOut=[];
LP.P.Filters.LoadIgnoredTrials=1;
% Fluorescence % default Zsc=1 mov=5 befAft=1 SR=20
LP.P.Data.Zscore=1;                          % 
LP.P.Data.BaselineMov=1;                     % 0 to not have moving baseline avg (avg and std)
LP.P.Data.BaselineBefAft=2;                  % calculate Baseline before or after extracting desired PSTH
LP.P.Data.BaselineHisto=0;                   % percentage of data from the baseline to use
LP.P.Data.BaselineFit=0;                     % To come
LP.P.Data.NidaqDecimatedSR=20;               % in Hz 20 for figures 100 for archiving
LP.P.Photometry.Fit_470405=0;
LP.OW.Photometry.PhotoCh={};                 % Force one channel only '470' - useful to group sessions with different channels
% Event detection %AP_DataProcess_Events
LP.P.EventDetection.Detection=0;
LP.P.EventDetection.ThreshFactor=0.8;             % will be applied to the data std to detect events ACh=0.5 DA=0.8
LP.P.EventDetection.MinFactor=0.5;                % will be applied to the threshold to restrict local minima
LP.P.EventDetection.MinTW='auto';                 % TW left of the peak to find minimum. 'auto' : use the width of the peak, 0 to use time between two peaks.
LP.P.EventDetection.waveform_TW=1;                % in sec. Time window for waveform event extraction. 0 to ignore.
LP.P.EventDetection.EpochTW=[-4.8 -2.8; -2.3 -0.3; 0 2]; % Uncertainty [-4.8 -2.8; -2.3 -0.3; 0 2] Uncertainty2 [-4.5 -4; -2.5 -2; -0.5 0];
LP.P.EventDetection.EpochNames={'Baseline','Cue','Reward'};
%% AOD
LP.P.AOD.raw=1;                        % load raw vs dff data (new Analysis only)
LP.P.AOD.timing='TTL';                 % Bpod, TTL
LP.P.AOD.smoothing=20;                 % smoothing 'Gaussian parameters' / used 20 for VIP_AOD data
LP.P.AOD.decimateSR=0;                 % does not work :/
LP.P.AOD.offset='auto';                % 'auto' = minimum-1 vs integer ~120 according to Z
LP.P.AOD.rewT='meanPos';               % integer vs 'mean' 'median' 'meanPos'
%% Spikes
LP.P.Spikes.TE4CellBase=0;
LP.P.Spikes.Clustering='Kilosort'; %Kilosort MClust
LP.P.Spikes.BinSize=[0.1 0.001]; %Behavior and Tagging;
LP.P.Spikes.tagging_TTL=2;
LP.P.Spikes.tagging_TW=[-0.5 0.5];
LP.P.Spikes.tagging_baseline=[-0.4 -0.1];
LP.P.Spikes.tagging_EpochTW=[0 0.01; 0.01 0.1];
LP.P.Spikes.tagging_EpochNames={'Early','Late'};
LP.P.Spikes.pThreshold=[0.01 0.05 0.05]; %Latency / FR / Reliability;
LP.P.Spikes.TTLTS_spikeTS_Factor=10000; % for MClust clustered spikes
%% PRIME
LP.P.Prime.raw=1;
LP.P.Prime.DataType='Depth'; % 'Depth' or 'Angle';
LP.P.Prime.smoothing=3;
LP.P.Prime.bin=4;
LP.P.Prime.Wheel=1;
LP.P.Prime.SiteExclusion=1;
LP.P.Prime.ProbeLength=2500;
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
LP.D.Behavior.Behavior='AOD_AudPav'; %CuedReward
LP.D.Behavior.Phase='RewardA';
LP.D.Behavior.CueType='Chirp';
LP.D.Behavior.StateOfCue='DeliverStimulus'; %DeliverStimulus
LP.D.Behavior.StateOfOutcome='WaitForLick';
LP.D.Behavior.TrialNames={'Cue A Reward','T2','T3','T4','Cue A Omission','Cue B Omission','Uncued Reward','T8','T9','T10'};
LP.D.Data.SamplingRate=2000;  %(Hz)
LP.D.Timing.CueTimeReset=[0 1];
LP.D.Timing.OutcomeTimeReset=[0 1];
LP.D.Licks.Port='Port1In';
LP.D.Photometry.PhotoChNames={'470-A1L' '405-A1' '470-A1R'};%{'470-A1L' '405-A1' '470-A1R'};{'470-A1' '405-A1' '470-mPFC'}
LP.D.Data.NidaqBaseline=[1 2];
% autoload
LP.AutoLoad=1;
LP.D.Load=0;
LP.D.Photometry.Photometry=0;
LP.D.Spikes.Spikes=0;
LP.D.AOD.AOD=0;
LP.D.Miniscope.Miniscope=0;
LP.D.Prime.Prime=0;
LP.D.Stimulation.Stimulation=0;
%% Database
if ~exist('DB_Stat','var')
    DB_Stat=struct();
end

%% File selection and Analysis Photometry Run
LP.P.LauncherVer=2;
switch LP.Analysis_type
    case 'Batch'
        [errorFile,DB_Stat]=AP_FileBatch(LP,DB,DB_Stat,LP.BatchType);
    case 'Online'
        AP_FileOnline(LP);
    case {'Single', 'Group'}
        [Analysis,DB_Stat]=AP_FileManual(LP,DB,DB_Stat);
end