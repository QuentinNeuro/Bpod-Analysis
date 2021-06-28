%% Use Analysis_Photometry_Launcher to keep it up to date with the pipeline
% postrec specific code can be find at the end of this script
% QC 2021
function AP_Launcher_PostRec(BpodSystem,ChannelNames,water)
global water
%% Analysis type Single/Group etc
LP.Analysis_type='Single';
LP.Save=0; % 1: Core Data only     // 2: Analysis Structure
LP.SaveTag=[]; % string to be added to the saved analysis file name
LP.Load=0; % 1: Load and reprocess
% Electrophysiology
LP.P.TE4CellBase=0;
LP.P.SpikesAnalysis=0;
LP.P.SpikesFigure=0; 
%% Overwritting Parameters
LP.OW.CueTimeReset=[];
LP.OW.OutcomeTimeReset=[]; %AOD [0 1] 
LP.OW.NidaqBaseline=[]; 
%% Analysis Parameters
% Figures
LP.P.PlotSummary1=0;
LP.P.PlotSummary2=0;
LP.P.PlotFiltersSingle=0;               % AP_####_GroupToPlot Output 1
LP.P.PlotFiltersSummary=0;
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
LP.P.ZeroAtZero=0;
LP.P.WheelState='Baseline';             %Options : 'Baseline','Cue','Outcome'
LP.P.PupilState='NormBaseline';       	%Options : 'NormBaseline','Cue','Outcome'
LP.P.ReshapedTime=[-4 4];               % use [0 180] for oddball
% Filters
LP.P.PupilThreshold=1;
LP.P.WheelThreshold=1;                  % Speed cm/s
LP.P.LicksCue=1;
LP.P.LicksOutcome=2;
LP.P.TrialToFilterOut=[];
LP.P.LoadIgnoredTrials=1;
% Photometry
LP.P.Zscore=1;
LP.P.BaselineBefAft=1;                  % Options : 1 or 2 - Before extracting time window
LP.P.BaselineHisto=0;
LP.P.CueStats='AVG';                    % Options : AVG AVGZ MAX MAXZ
LP.P.OutcomeStats='AVGZ';                % Options : AVG AVGZ MAX MAXZ
LP.P.BaselineHistoParam=20;             % percentage of data from the baseline to use
LP.P.NidaqDecimatedSR=20;               % in Hz
% Archiving photometry data
LP.Archive=0; %
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
LP.D.TrialNames={'CueA_Reward','T2','T3','T4','CueA_Omission','CueB_Omission','Uncued_Reward','T8','T9','T10'};
LP.D.LickPort='Port1In';
LP.D.StateOfCue='DeliverStimulus';
LP.D.StateOfOutcome='WaitForLick';
LP.D.CueTimeReset=[0 1];
LP.D.OutcomeTimeReset=[0 1];
LP.D.NidaqBaseline=[1 2];

%% SPECIFIC TO LAUNCHER
LP.OW.PhotoChNames=ChannelNames; %{'ACx' 'mPFC' 'ACxL' 'ACxR' 'VS' 'BLA'}
%% File path  from Bpod
[thisPath,thisName,thisExt]=fileparts(BpodSystem.DataPath);
LP.FileList=[thisName thisExt];
LP.PathName=thisPath;
LP.FileToOpen=cellstr(LP.FileList);
%% Run Analysis_Photometry
Analysis_Photometry(LP); 
end