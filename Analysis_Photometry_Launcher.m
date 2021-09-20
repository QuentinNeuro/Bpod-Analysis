%% Bpod Photometry Launcher
% Launcher for an analysis pipeline originally designed for photometry
% using Bpod to control the behavior of the animal.
% 'Analysis_Photometry' is the core function used to extract, organize and
% filters the data according to the behavioral task
% 'Analysis_spike' is an addon that can be used to quickly plot PSTH from 
% spiking units clustered using MClust (TT.mat) and using TTL sync information
clear SessionData Analysis LP; %close all;
%% Database 
DB_Add=0;
DB_Group=[];
% global TuningYMAX;
%% Analysis type Single/Group etc
LP.Analysis_type='Group';
LP.Save=0; % 1: Core Data only     // 2: Analysis Structure
LP.SaveTag=[]; % string to be added to the saved analysis file name
LP.Load=0; % 1: Load and reprocess
% Electrophysiology
LP.P.TE4CellBase=0;
LP.P.SpikesAnalysis=0;
LP.P.SpikesFigure=0; 
% AOD
LP.P.AOD=0;
LP.P.AOD_raw=1;
LP.P.AOD_smooth=1;
LP.P.AOD_offset=120;
%% Overwritting Parameters
LP.OW.PhotoChNames={'F1' 'F2'}; %{'ACx' 'mPFC' 'ACxL' 'ACxR' 'VS' 'BLA'}
LP.OW.CueTimeReset=[0 1];
LP.OW.OutcomeTimeReset=[0 3]; %AOD [0 1] 
LP.OW.NidaqBaseline=[]; 
%% Analysis Parameters
% Figures
LP.P.PlotSummary1=1;
LP.P.PlotSummary2=0;
LP.P.PlotFiltersSingle=1;               % AP_####_GroupToPlot Output 1
LP.P.PlotFiltersSummary=0;
LP.P.PlotFiltersBehavior=0;           	% AP_####_GroupToPlot Oupput 2
LP.P.Illustrator=0;
LP.P.Transparency=0;
% Axis
LP.P.PlotX=[-2 5];
LP.P.PlotY_photo(1,:)=[NaN NaN];     	% Tight axis if [NaN NaN] / TBD [min max]
LP.P.PlotY_photo(2,:)=[NaN NaN];        % Tight axis if [NaN NaN] / TBD [min max]
% States and Timing
LP.P.StateToZero='StateOfOutcome';    	%'StateOfCue' 'StateOfOutcome'
LP.P.ZeroFirstLick=0;                   % Will look for licks 0 to 2 sec after state to Zero starts
LP.P.ZeroAtZero=0;
LP.P.WheelState='Baseline';             %Options : 'Baseline','Cue','Outcome'
LP.P.PupilState='NormBaseline';       	%Options : 'NormBaseline','Cue','Outcome'
LP.P.ReshapedTime=[-5 5];               % use [0 180] for oddball
% Filters
LP.P.PupilThreshold=1;
LP.P.WheelThreshold=1;                  % Speed cm/s
LP.P.LicksCue=1;
LP.P.LicksOutcome=2;
LP.P.TrialToFilterOut=[];
LP.P.LoadIgnoredTrials=1;
% Photometry
LP.P.Zscore=1;
LP.P.BaselineMov=5;                     % 0 to not have moving baseline avg (avg and std)
LP.P.BaselineBefAft=1;                  % Depricated Not working anymore : Only before
LP.P.BaselineHisto=0;
LP.P.CueStats='AVG';                    % Options : AVG AVGZ MAX MAXZ
LP.P.OutcomeStats='AVGZ';                % Options : AVG AVGZ MAX MAXZ
LP.P.BaselineHistoParam=20;             % percentage of data from the baseline to use
LP.P.NidaqDecimatedSR=100;               % in Hz
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
%% Run Analysis_Photometry
if ~LP.MEGABATCH
[LP.FileList,LP.PathName]=uigetfile('*.mat','Select the BPod file(s)','MultiSelect', 'on');
if iscell(LP.FileList)==0
	LP.FileToOpen=cellstr(LP.FileList);
    LP.Analysis_type='Single';
	Analysis=Analysis_Photometry(LP); 
else
switch LP.Analysis_type
    case 'Single'
         for i=1:length(LP.FileList)
%             TuningYMAX=[]; % for auditory tuning
            LP.FileToOpen=LP.FileList(i);
            try
            Analysis=Analysis_Photometry(LP);
            catch
            disp([LP.FileToOpen ' NOT ANALYZED']);
            end 
            close all;
            % DataBase
            if DB_Add
                if exist('DB_Stat')~=1
                    DB_Stat=struct();
                end
            DB_Stat=DB_Generate(Analysis,DB_Stat,LP.FileToOpen,LP.PathName,DB_Group);
            disp(Analysis.Parameters.CueTimeReset)
            end
%             AllAnimals{i}=Analysis.Parameters.Animal;
%             AllTuning{i}=TuningYMAX;
         end    
	case 'Group'
        LP.FileToOpen=LP.FileList;
        Analysis=Analysis_Photometry(LP);
end
end
else
AP_MEGABATCH(LP)
end