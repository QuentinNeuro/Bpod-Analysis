%% Bpod Photometry Launcher
clear SessionData Analysis DefaultParam; close all;
%% Analysis type Single/Group
DefaultParam.Analysis_type='Single';
DefaultParam.Save=0;
DefaultParam.Load=0;
DefaultParam.TrialEvents4CellBase=1;
% Figures
DefaultParam.PhotoChNames={'470-BLA' 'none' '470-VS'};
DefaultParam.PlotSummary1=0;
DefaultParam.PlotSummary2=0;
DefaultParam.PlotFiltersSingle=0; %AP_Filter_GroupToPlot #1 Output
DefaultParam.PlotFiltersSummary=1;
DefaultParam.PlotFiltersBehavior=0; %AP_Filter_GroupToPlot #2 Ouput
DefaultParam.Illustrator=0;
DefaultParam.Transparency=1;
% Axis
DefaultParam.PlotYNidaq=[-2 3];
DefaultParam.PlotX=[-4 4];
% States
DefaultParam.StateToZero='StateOfOutcome'; %'StateOfCue' 'StateOfOutcome'
DefaultParam.ZeroAtZero=0;
DefaultParam.WheelState='Outcome'; %'Baseline','Cue','Outcome'
DefaultParam.PupilState='Outcome'; %'NormBaseline','Cue','Outcome'
% Filters
DefaultParam.PupilThreshold=1;
DefaultParam.WheelThreshold=2; %Speed cm/s
DefaultParam.LicksCue=1;
DefaultParam.LicksOutcome=2;
DefaultParam.TrialToFilterOut=[];
DefaultParam.LoadIgnoredTrials=1;
%% Overwrite Parameters found in AP_Parameters
DefaultParam.Name='VIP';
DefaultParam.Rig='Unknown';
DefaultParam.Behavior='CuedOutcome';
DefaultParam.Phase='RewardA';
DefaultParam.TrialNames={'T1','T2','T3','T4','T5','T6','T7','T8','T9','T10'};
DefaultParam.LickPort='Port1In';
DefaultParam.StateOfCue='Cue';
DefaultParam.StateOfOutcome='Outcome';
DefaultParam.CueTimeReset=[];     % overwrite preloaded parameters
DefaultParam.OutcomeTimeReset=[]; % overwrite preloaded parameters
DefaultParam.NidaqBaseline=[];    % overwrite preloaded parameters
% Photometry - being used if cannot find the parameters in the bpod file
DefaultParam.SamplingRate=2000;  %(Hz)
DefaultParam.NewSamplingRate=20; %(Hz)
DefaultParam.NidaqDuration=15;

%% Run Analysis_Photometry
[DefaultParam.FileList,DefaultParam.PathName]=uigetfile('*.mat','Select the BPod file(s)','MultiSelect', 'on');
if iscell(DefaultParam.FileList)==0
    DefaultParam.FileToOpen=cellstr(DefaultParam.FileList);
    DefaultParam.Analysis_type='Single';
	Analysis=Analysis_Photometry(DefaultParam); 
else
switch DefaultParam.Analysis_type
    case 'Single'
         for i=1:length(DefaultParam.FileList)
            DefaultParam.FileToOpen=DefaultParam.FileList(i);
            try
            Analysis=Analysis_Photometry(DefaultParam);
            catch
            disp([DefaultParam.FileToOpen ' NOT ANALYZED']);
            end
            close all;
         end    
	case 'Group'
        if DefaultParam.Load
            disp('Cannot group preexisting Analysis structure')
            return
        end
        DefaultParam.FileToOpen=DefaultParam.FileList;
        Analysis=Analysis_Photometry(DefaultParam);
end
end