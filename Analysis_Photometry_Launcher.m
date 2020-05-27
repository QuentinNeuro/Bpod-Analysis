%% Bpod Photometry Launcher
% Launcher for an analysis pipeline originally designed for photometry
% using Bpod to control the behavior of the animal.
% 'Analysis_Photometry' is the core function used to extract, organize and
% filters the data according to the behavioral task
% 'Analysis_spike' is an addon that can be used to quickly plot PSTH from 
% spiking units clustered using MClust (TT.mat) and using TTL sync information

clear SessionData Analysis LP; close all;
% DB_Stat=struct();
DB_Stat_Group=[];
%% Analysis type Single/Group etc
LP.Analysis_type='Group';
LP.Save=0; % 1: Core Data only     // 2: Analysis Structure
LP.SaveTag=[]; % string to be added to the saved analysis file name
LP.Load=1; % 1: Load and reprocess
%% Overwritting Parameters
LP.OW.PhotoChNames={'ACx' 'mPFC'}; %{'ACx' 'mPFC' 'ACxL' ACxR'}
LP.OW.CueTimeReset=[];
LP.OW.OutcomeTimeReset=[]; 
LP.OW.NidaqBaseline=[]; 
%% Analysis Parameters
% Figures
LP.P.PlotSummary1=1;
LP.P.PlotSummary2=0;
LP.P.PlotFiltersSingle=0;               % AP_####_GroupToPlot Output 1
LP.P.PlotFiltersSummary=1;
LP.P.PlotFiltersBehavior=1;           	% AP_####_GroupToPlot Oupput 2
LP.P.Illustrator=0;
LP.P.Transparency=0;
% Axis
LP.P.PlotX=[-3 4];
LP.P.PlotY_photo(1,:)=[NaN NaN];     	% Tight axis if [NaN NaN] / TBD [min max]
LP.P.PlotY_photo(2,:)=[NaN NaN];        % Tight axis if [NaN NaN] / TBD [min max]
% States and Timing
LP.P.StateToZero='StateOfOutcome';    	%'StateOfCue' 'StateOfOutcome'
LP.P.ZeroFirstLick=0;                   % Will look for licks 0 to 2 sec after state to Zero starts
LP.P.ZeroAtZero=0;
LP.P.WheelState='Baseline';             %Options : 'Baseline','Cue','Outcome'
LP.P.PupilState='NormBaseline';       	%Options : 'NormBaseline','Cue','Outcome'
LP.P.ReshapedTime=[-4 5];
% Filters
LP.P.PupilThreshold=1;
LP.P.WheelThreshold=5;                  % Speed cm/s
LP.P.LicksCue=1;
LP.P.LicksOutcome=2;
LP.P.TrialToFilterOut=[];
LP.P.LoadIgnoredTrials=1;
% Photometry
LP.P.Zscore=0;
LP.P.BaselineBefAft=2;                  % Options : 1 or 2 - Before extracting time window
LP.P.BaselineHisto=0;
LP.P.CueStats='AVG';                    % Options : AVG AVGZ MAX MAXZ
LP.P.OutcomeStats='MAX';                % Options : AVG AVGZ MAX MAXZ
LP.P.BaselineHistoParam=20;             % percentage of data from the baseline to use
LP.P.NidaqDecimatedSR=20;               % in Hz
% Electrophysiology
LP.P.TE4CellBase=0;
LP.P.SpikesAnalysis=0;
LP.P.SpikesFigure=0; 
%% Default Parameters [Used if not found in Bpod file]
LP.D.Name='VIP';
LP.D.Rig='Unknown';
LP.D.Behavior='CuedOutcome';
LP.D.Phase='RewardA';
LP.D.CueType='Chirp';
LP.D.PhotoChNames={'470-A1L' '405-A1' '470-A1R'};%{'470-A1L' '405-A1' '470-A1R'};{'470-A1' '405-A1' '470-mPFC'}
LP.D.SamplingRate=2000;  %(Hz)
LP.D.TrialNames={'T1','T2','T3','T4','T5','T6','T7','T8','T9','T10'};
LP.D.LickPort='Port1In';
LP.D.StateOfCue='Cue';
LP.D.StateOfOutcome='Outcome';
%% Run Analysis_Photometry
[LP.FileList,LP.PathName]=uigetfile('*.mat','Select the BPod file(s)','MultiSelect', 'on');
if iscell(LP.FileList)==0
    LP.FileToOpen=cellstr(LP.FileList);
    LP.Analysis_type='Single';
	Analysis=Analysis_Photometry(LP); 
else
switch LP.Analysis_type
    case 'Single'
         for i=1:length(LP.FileList)
            LP.FileToOpen=LP.FileList(i);
            try
            Analysis=Analysis_Photometry(LP);
            catch
            disp([LP.FileToOpen ' NOT ANALYZED']);
            end
            close all;
            %DB_Stat=DB_StatExtract(Analysis,DB_Stat,LP.FileToOpen,DB_Stat_Group);
         end    
	case 'Group'
        LP.FileToOpen=LP.FileList;
        Analysis=Analysis_Photometry(LP);
end
end