%% Bpod Photometry Launcher
% Launcher for an analysis pipeline originally designed for photometry
% using Bpod to control the behavior of the animal.
% 'Analysis_Photometry' is the core function used to extract, organize and
% filters the data according to the behavioral task
% 'Analysis_spike' is an addon that can be used to quickly plot PSTH from 
% spiking units clustered using MClust (TT.mat) and using TTL sync information

clear SessionData Analysis LauncherParam; close all;
%% Analysis type Single/Group
LauncherParam.Analysis_type='Single';
LauncherParam.Save=0;
LauncherParam.Load=0;
LauncherParam.Zscore=0;
LauncherParam.BaselineHisto=0;
LauncherParam.CueStats='AVG';       %'AVG' or 'MAX'
LauncherParam.OutcomeStats='MAX';   %'AVG' or 'MAX'
% Electrophysiology
LauncherParam.TrialEvents4CellBase=0;
LauncherParam.SpikesAnalysis=0;
LauncherParam.SpikesFigure=0;
% Figures - Can be changed upon loading
LauncherParam.PlotSummary1=1;
LauncherParam.PlotSummary2=0;
LauncherParam.PlotFiltersSingle=0;              %AP_CuedOutcome_GroupToPlot #1 Output
LauncherParam.PlotFiltersSummary=0;
LauncherParam.PlotFiltersBehavior=0;           	%AP_Filter_GroupToPlot #2 Ouput
LauncherParam.Illustrator=0;
LauncherParam.Transparency=1;
% Axis - Can be changed upon loading
LauncherParam.PlotX=[-4 4];
LauncherParam.PlotY_photo(1,:)=[NaN NaN];     	% Tight axis if [NaN NaN]
LauncherParam.PlotY_photo(2,:)=[NaN NaN];        % Tight axis if [NaN NaN].
% States and Timing
LauncherParam.StateToZero='StateOfOutcome';    	%'StateOfCue' 'StateOfOutcome'
LauncherParam.ZeroFirstLick=0;                 	% Will activate TimeReshaping
LauncherParam.ZeroAtZero=0;
LauncherParam.WheelState='Baseline';                 %'Baseline','Cue','Outcome'
LauncherParam.PupilState='NormBaseline';       	%'NormBaseline','Cue','Outcome'
LauncherParam.ReshapedTime=[-4 4];
% Filters
LauncherParam.PupilThreshold=1;
LauncherParam.WheelThreshold=5;             	%Speed cm/s
LauncherParam.LicksCue=2;
LauncherParam.LicksOutcome=2;
LauncherParam.TrialToFilterOut=[];
LauncherParam.LoadIgnoredTrials=1;
%% Parameters being used if cannot be extracted from the bpod file
LauncherParam.Name='VIP';
LauncherParam.Rig='Unknown';
LauncherParam.Behavior='CuedOutcome';
LauncherParam.CueType='Chirp';
LauncherParam.PhotoChNames={'470-A1' '405-A1' '470-mPFC'};%{'470-A1L' '405-A1' '470-A1R'};{'470-A1' '405-A1' '470-mPFC'}
LauncherParam.Phase='RewardA';
LauncherParam.TrialNames={'T1','T2','T3','T4','T5','T6','T7','T8','T9','T10'};
LauncherParam.LickPort='Port1In';
LauncherParam.StateOfCue='Outcome';
LauncherParam.StateOfOutcome='Outcome2';
LauncherParam.TimeReshaping=1;          % overwrite preloaded parameters; 0 or 1;
LauncherParam.CueTimeReset=[];       % overwrite preloaded parameters
LauncherParam.OutcomeTimeReset=[];      % overwrite preloaded parameters
LauncherParam.NidaqBaseline=[];         % overwrite preloaded parameters
% Photometry - being used if cannot find the parameters in the bpod file
LauncherParam.BaselineHistoParam=20; % percentage of data from the baseline to use
LauncherParam.SamplingRate=2000;  %(Hz)
LauncherParam.NewSamplingRate=20; %(Hz)
LauncherParam.NidaqDuration=60;

%% Run Analysis_Photometry
[LauncherParam.FileList,LauncherParam.PathName]=uigetfile('*.mat','Select the BPod file(s)','MultiSelect', 'on');
if iscell(LauncherParam.FileList)==0
    LauncherParam.FileToOpen=cellstr(LauncherParam.FileList);
    LauncherParam.Analysis_type='Single';
	Analysis=Analysis_Photometry(LauncherParam); 
else
switch LauncherParam.Analysis_type
    case 'Single'
         for i=1:length(LauncherParam.FileList)
            LauncherParam.FileToOpen=LauncherParam.FileList(i);
            try
            Analysis=Analysis_Photometry(LauncherParam);
            catch
            disp([LauncherParam.FileToOpen ' NOT ANALYZED']);
            end
            close all;
         end    
	case 'Group'
        if LauncherParam.Load
            disp('Cannot group preexisting Analysis structure')
            return
        end
        LauncherParam.FileToOpen=LauncherParam.FileList;
        Analysis=Analysis_Photometry(LauncherParam);
end
end