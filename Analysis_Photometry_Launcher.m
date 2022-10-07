%% Bpod Photometry Launcher
% Launcher for an analysis pipeline originally designed for photometry
% using Bpod to control the behavior of the animal.
% 'Analysis_Photometry' is the core function used to extract, organize and
% filters the data according to the behavioral task
% 'Analysis_spike' is an addon that can be used to quickly plot PSTH from 
% spiking units clustered using MClust (TT.mat) and using TTL sync information
clear SessionData Analysis LP; close all;

%% Analysis type Single/Group/Batch etc
LP.Analysis_type='Batch';
LP.Save=0;      % 1: Core Data only     // 2: Full Analysis Structure
LP.SaveTag=[];  % string to be added to the saved analysis file name
DB.DataBase=0;
% global TuningYMAX;
%% Overwritting Parameters
LP.OW.PhotoChNames={'VIP' 'mPFC'}; %{'ACx' 'mPFC' 'ACxL' 'ACxR' 'VS' 'BLA'}
LP.OW.CueTimeReset=[];
LP.OW.OutcomeTimeReset=[]; %AOD [0 1] %GoNoGo default [0 -3];
LP.OW.NidaqBaseline=[]; 
%% Analysis Parameters
LP.P.SortFilters=1;
LP.P.EventDetection=0;
% Figures
LP.P.PlotSummary1=1;
LP.P.PlotSummary2=0;
LP.P.PlotFiltersSingle=0;               % AP_CuedOutcome_GroupToPlot Output 1
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
LP.P.BaselineMov=5;                     % 0 to not have moving baseline avg (avg and std)
LP.P.BaselineBefAft=2;                  % After not working with mov baseline
LP.P.BaselineHisto=0;                   % percentage of data from the baseline to use
LP.P.CueStats='MAXZ';                   % Options : AVG AVGZ MAX MAXZ
LP.P.OutcomeStats='MAXZ';               % Options : AVG AVGZ MAX MAXZ
LP.P.NidaqDecimatedSR=20;               % in Hz
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
LP.P.Spikes.tagging_timeW=[-0.3 0.3];
LP.P.Spikes.tagging_TTL=2;
LP.P.Spikes.pThreshold=[0.01 0.05]; %Latency / FR;
LP.P.Spikes.TTLTS_spikeTS_Factor=10000; % for MClust clustered spikes
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
%% Database
DB.Group=[];
if ~exist('DB_Stat','var')
    DB_Stat=struct();
end

%% File selection and Analysis Photometry Run
switch LP.Analysis_type
    case 'Batch'
        errorFile=AP_FileBatch(LP);
    case 'Online'
        AP_FileOnline(LP);
    otherwise
        [Analysis,DB_Stat]=AP_FileManual(LP,DB,DB_Stat);
end

% if ~LP.MEGABATCH
% [LP.FileList,LP.PathName]=uigetfile('*.mat','Select the BPod file(s)','MultiSelect', 'on');
% if iscell(LP.FileList)==0
% 	LP.FileToOpen=cellstr(LP.FileList);
%     LP.Analysis_type='Single';
% 	Analysis=Analysis_Photometry(LP); 
% else
% switch LP.Analysis_type
%     case 'Single'
%          for i=1:length(LP.FileList)
% %             TuningYMAX=[]; % for auditory tuning
%             LP.FileToOpen=LP.FileList(i);
%             try
%             Analysis=Analysis_Photometry(LP);
%             catch
%             disp([LP.FileToOpen ' NOT ANALYZED']);
%             end 
%             close all;
%             % DataBase
%             if DB_Add
%                 if ~exist('DB_Stat','var')
%                     DB_Stat=struct();
%                 end
%             DB_Stat=DB_Generate(Analysis,DB_Stat,LP.FileToOpen,LP.PathName,DB_Group);
%             DB_Stat.LP=LP;
%             disp(Analysis.Parameters.CueTimeReset)
%             end
% %             AllAnimals{i}=Analysis.Parameters.Animal;
% %             AllTuning{i}=TuningYMAX;
%          end    
% 	case 'Group'
%         LP.FileToOpen=LP.FileList;
%         Analysis=Analysis_Photometry(LP);
% end
% end
% else
% AP_MEGABATCH(LP)
% end