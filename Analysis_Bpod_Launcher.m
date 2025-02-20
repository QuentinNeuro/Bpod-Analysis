%% Bpod analysis Launcher
% 'Analysis_Bpod' is the core function used to extract, organize and
% filters the data according to the behavioral task
% see also AB_Parameters / AB_DataCore / AB_DataProcess / AB_DataSort
clear SessionData Analysis LP; %close all;
warning('off','all'); warning;

%% Analysis type Single/Group/Batch/Online etc
LP.Analysis_type='Single';
LP.Save=0;              % 1: Core Data only     // 2: Full Analysis Structure
LP.SaveTag=[];          % string to be added to the saved analysis file name
LP.BatchType='';        % Spikes DataBase MegaBatch
DB.DataBase=0;          % DB_Generate
DB.Group=[];
% global TuningYMAX;
%% Overwritting Parameters
LP.P.Data.Label={}; %{'ACx' 'mPFC' 'ACxL' 'ACxR' 'VS' 'BLA'}
LP.P.Timing.ForceEpochTimeReset=[]; % cue / outcome / delay
%% Analysis Parameters
LP.P.Filters.Sort=1;
LP.P.Filters.Cells=1;
LP.P.Filters.Pairing=0;
% Figures
LP.P.Plot.TrialTypes=1;                  % Raw trial types - no filter applied
LP.P.Plot.FiltersSingle=0;               % individual raster for individual trial type
LP.P.Plot.FiltersSummary=0;              % summary plot for groups of trial type
LP.P.Plot.FiltersBehavior=0;           	 % AP_####_GroupToPlot Oupput 2
LP.P.Plot.Cells=0;                       % Generate single cell filter figures
LP.P.Plot.Cells_Spike=0;                 % Specific to spike analysis
LP.P.Plot.Illustrator=0;
LP.P.Plot.Transparency=1;
LP.P.Plot.Illustration=[0 0 0];          % #1 basic filtergroup #2 no ylim on rasters #3 arousal plots
% Axis
LP.P.Plot.xTime=[-3 4];
LP.P.Plot.yData(1,:)=[NaN NaN];     	 % Tight axis if [NaN NaN] / TBD [min max]
LP.P.Plot.yData(2,:)=[NaN NaN];          % Tight axis if [NaN NaN] / TBD [min max]
% % States and Timing
LP.P.Timing.PSTH=[-4 5];                   % PSTH
LP.P.Timing.ZeroFirstLick=0;               % Will look for licks 0 to 2 sec after state to Zero starts
LP.OW.Timing.EpochZeroPSTH=[];             % BpodState (or EpochName), load a default state if blank
LP.P.Timing.EpochNames=[];
LP.P.Timing.EpochStates=[];
LP.P.Timing.EpochTimeReset=[];
% Filters % default LicksCue=1 LicksOut=2
LP.P.Filters.PupilThreshold=1;
LP.P.Filters.PupilState='BaselineAVG_N';       	% Options : 'NormBaseline','CueAVG','OutcomeAVG'
LP.P.Filters.WheelThreshold=2;                  % Speed cm/s
LP.P.Filters.WheelState='BaselineAVG';          % Options : 'BaselineAVG','CueAVG','OutcomeAVG'
LP.P.Filters.LicksCue=1;                        % default : 1 or 2
LP.P.Filters.LicksOutcome=2;                    % default : 2
LP.P.Filters.TrialToFilterOut=[];
LP.P.Filters.LoadIgnoredTrials=1;
LP.P.Filters.Cells_Stats='';
LP.P.Filters.Cells_Threshold=[];
% Data Normalization % default Zsc=1 mov=5 befAft=1 SR=20
LP.P.Data.Normalize='Zsc';                   % 'Zsc' 'DFF' 'No or empty or Hz'
LP.P.Data.BaselineTW=[0.2 1.2];              % Baseline time
LP.P.Data.BaselineBefAft=2;                  % calculate Baseline before or after extracting desired PSTH
LP.P.Data.BaselineMov=5;                     % 
LP.P.Data.BaselineHisto=0;                   % percentage of data from the baseline to use
LP.P.Data.ZeroTW=[];                         % in sec
LP.P.Data.SamplingRateDecimated=20;         % in Hz 20 for figures 100 for archiving - DOES NOT WORK :(
LP.P.Data.BaselineFit=0;                     % To come
LP.P.Photometry.Fit_470405=0;                % To TEST
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
LP.P.AOD.timing='Bpod';                % Bpod, TTL
LP.P.AOD.smoothing=20;                 % smoothing 'Gaussian parameters' / used 20 for VIP_AOD data
LP.P.AOD.offset='auto';                % 'auto' = minimum-1 vs integer ~120 according to Z
LP.P.AOD.rewT='meanPos';               % integer vs 'mean' 'median' 'meanPos'
%% Spikes
LP.P.Spikes.TE4CellBase=0;
LP.P.Spikes.Clustering='Kilosort'; %Kilosort MClust
LP.P.Spikes.BinSize=[0.1 0.001]; %Behavior and Tagging;
LP.P.Spikes.LoadWV=1;
LP.P.Spikes.tagging_TTL=2;
LP.P.Spikes.tagging_TW=[-0.5 0.5];
LP.P.Spikes.tagging_baseline=[-0.4 -0.1];
LP.P.Spikes.tagging_EpochTW=[0 0.02; 0.01 0.1];
LP.P.Spikes.tagging_EpochNames={'Early','Late'};
LP.P.Spikes.pThreshold=[0.01 0.05 0.05]; %Latency / FR / Reliability;
LP.P.Spikes.TTLTS_spikeTS_Factor=10000; % for MClust clustered spikes
LP.P.Spikes.SamplingRate=30000;
%% PRIME
LP.P.Prime.raw=1;
LP.P.Prime.DataType='Depth'; % 'Depth' or 'Angle';
LP.P.Prime.smoothing=3;
LP.P.Prime.bin=4; % TBD
LP.P.Prime.Wheel=0;
LP.P.Prime.SiteExclusion=1;
LP.P.Prime.ProbeLength=2500; %TBD
%% Miniscope
LP.P.Miniscope.SamplingRate=10;
%% Archiving photometry data
LP.Archive=0; %
LP.ArchiveOnly=0;
LP.ArchiveOW=0;
%% Default Parameters
LP.D.Name='Unknown';
LP.D.Rig='Unknown';         
LP.D.Behavior.Behavior='Unknown';
LP.D.Behavior.Phase='Unknown';
LP.D.Behavior.CueType='Unknown';
LP.D.Behavior.TrialNames={'TT1','TT2','TT3','TT4'};
LP.D.Data.SamplingRate=2000;  %(Hz)
LP.D.Licks.Port='Port1In';
% autoload
LP.AutoLoad=1;
LP.D.Load=0;
LP.D.Data.RecordingType=[];
LP.AuthorizedRecordingTypes={'Photometry','Spikes','AOD','Prime','Miniscope'};
%% Database
if ~exist('DB_Stat','var')
    DB_Stat=struct();
end

%% File selection and Analysis Photometry Run
LP.P.LauncherVer=3;
switch LP.Analysis_type
    case 'Batch'
        [errorFile,DB_Stat]=AB_FileBatch(LP,DB,DB_Stat,LP.BatchType);
    case 'Online'
        AB_FileOnline(LP);
    case {'Single', 'Group'}
        [Analysis,DB_Stat,Feedback]=AB_FileManual(LP,DB,DB_Stat);
end