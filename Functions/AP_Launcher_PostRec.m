%% Use Analysis_Photometry_Launcher to keep it up to date with the pipeline
% postrec specific code can be find at the end of this script
% QC 2021
function AP_Launcher_PostRec(BpodSystem,ChannelNames,PlotSumOW)
if nargin<=2
    PlotSumOW=0;
end

%% Analysis type Single/Group etc
LP.Analysis_type='Single';
LP.Save=0;      % 1: Core Data only     // 2: Full Analysis Structure
LP.SaveTag=[];  % string to be added to the saved analysis file name
%% Overwritting Parameters
LP.OW.PhotoChNames={'ACh' 'F2'}; %{'ACx' 'mPFC' 'ACxL' 'ACxR' 'VS' 'BLA'}
LP.OW.CueTimeReset=[];
LP.OW.OutcomeTimeReset=[]; %AOD [0 1] %GoNoGo default [0 -3];
LP.OW.NidaqBaseline=[]; 
%% Analysis Parameters
LP.P.SortFilters=1;
LP.P.EventDetection=0;
% Figures
LP.P.PlotSummary1=PlotSumOW;
LP.P.PlotSummary2=0;
LP.P.PlotFiltersSingle=0;               % AP_CuedOutcome_GroupToPlot Output 1
LP.P.PlotFiltersSummary=1;
LP.P.PlotFiltersBehavior=0;           	% AP_####_GroupToPlot Oupput 2
LP.P.Illustrator=0;
LP.P.Transparency=1;
% Axis
LP.P.PlotX=[-4 4];
LP.P.PlotY_photo(1,:)=[NaN NaN];     	% Tight axis if [NaN NaN] / TBD [min max]
LP.P.PlotY_photo(2,:)=[NaN NaN];        % Tight axis if [NaN NaN] / TBD [min max]
% States and Timing
LP.P.StateToZero='StateOfOutcome';    	%'StateOfCue' 'StateOfOutcome'
LP.P.ZeroFirstLick=0;                   % Will look for licks 0 to 2 sec after state to Zero starts
LP.P.ZeroAt='Start';                    % 'Start' or 'Zero' - 0 is no zero-ing wanted
LP.P.WheelState='Baseline';             %Options : 'Baseline','Cue','Outcome'
LP.P.PupilState='NormBaseline';       	%Options : 'NormBaseline','Cue','Outcome'
LP.P.ReshapedTime=[-5 5];               % use [0 180] for oddball
% Filters
LP.P.PupilThreshold=1;
LP.P.WheelThreshold=2;                  % Speed cm/s
LP.P.LicksCue=2;
LP.P.LicksOutcome=2;
LP.P.TrialToFilterOut=[];
LP.P.LoadIgnoredTrials=1;
% Fluorescence
LP.P.Zscore=1;
LP.P.BaselineMov=0;                     % 0 to not have moving baseline avg (avg and std)
LP.P.BaselineBefAft=2;                  % After not working with mov baseline
LP.P.BaselineHisto=0;                   % percentage of data from the baseline to use
LP.P.CueStats='MAXZ';                   % Options : AVG AVGZ MAX MAXZ
LP.P.OutcomeStats='MAXZ';               % Options : AVG AVGZ MAX MAXZ
LP.P.NidaqDecimatedSR=100;              % in Hz
%% AOD
LP.P.AOD.raw=1;                        % load raw vs dff data - does not really work upon Analysis loading
LP.P.AOD.smoothing=1;                  % smoothing and decimate happen upon loading
LP.P.AOD.decimateSR=0;                 % 0 to not decimate
LP.P.AOD.offset='auto';                % 'auto' = minimum-1 vs integer ~120 according to Z
LP.P.AOD.rewT='meanPos';               % integer vs 'mean' 'median' 'meanPos'
%% Spikes
LP.P.TE4CellBase=0;
LP.P.Spikes.Figure=1;
LP.P.Spikes.Clustering='Kilosort'; %Kilosort MClust
LP.P.Spikes.BinSize=0.1;
LP.P.Spikes.tagging_timeW=[-0.1 0.2];
LP.P.Spikes.tagging_TTL=2;
LP.P.Spikes.TTLTS_spikeTS_Factor=10000; % for MClust clustered spikes
%% Database 
DB_Add=0;
DB_Group=[];
% global TuningYMAX;
%% Archiving photometry data
LP.Archive=1; %
LP.ArchiveOnly=0;
LP.ArchiveOW=0;
LP.MEGABATCH=0;
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
LP.D.StateOfCue='DeliverStimulus';
LP.D.StateOfOutcome='WaitForLick';
LP.D.CueTimeReset=[0 1];
LP.D.OutcomeTimeReset=[0 1];
LP.D.NidaqBaseline=[1 2];
% autoload deactivated
LP.AutoLoad=1;
LP.D.Load=0;
LP.D.Photometry=0;
LP.D.Spikes.Spikes=0;
LP.D.AOD.AOD=0;

%% SPECIFIC TO LAUNCHER
LP.OW.PhotoChNames=ChannelNames; %{'ACx' 'mPFC' 'ACxL' 'ACxR' 'VS' 'BLA'}
%% File path  from Bpod
[thisPath,thisName,thisExt]=fileparts(BpodSystem.DataPath);
LP.FileList=[thisName thisExt];
LP.PathName=[thisPath filesep];
LP.FileToOpen=cellstr(LP.FileList);
%% Run Analysis_Photometry
Analysis_Photometry(LP); 
end