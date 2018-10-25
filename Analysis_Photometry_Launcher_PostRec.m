function Analysis=Analysis_Photometry_Launcher_PostRec(BpodSystem,ChannelNames,YPhoto,Water)

%% Check nargin
% todo

%% Analysis type Single/Group
LauncherParam.Analysis_type='Single';
LauncherParam.Save=0;
LauncherParam.Load=0;
% Electrophysiology
LauncherParam.TrialEvents4CellBase=0;
LauncherParam.SpikesAnalysis=0;
LauncherParam.SpikesFigure=0;
% Figures - Can be changed upon loading
LauncherParam.PhotoChNames=ChannelNames;%{'470-A1' '405-A1' 'fiber2'} {'470-BLA' 'none' '470-VS'};
LauncherParam.PlotSummary1=0;
LauncherParam.PlotSummary2=0;
LauncherParam.PlotFiltersSingle=0; %AP_CuedOutcome_GroupToPlot #1 Output
LauncherParam.PlotFiltersSummary=0;
LauncherParam.PlotFiltersBehavior=0; %AP_Filter_GroupToPlot #2 Ouput
LauncherParam.Illustrator=0;
LauncherParam.Transparency=1;
% Axis - Can be changed upon loading
LauncherParam.PlotYNidaq=YPhoto;
LauncherParam.PlotX=[-4 4];
% States
LauncherParam.StateToZero='StateOfOutcome'; %'StateOfCue' 'StateOfOutcome'
LauncherParam.ZeroAtZero=0;
LauncherParam.WheelState='Cue'; %'Baseline','Cue','Outcome'
LauncherParam.PupilState='NormBaseline'; %'NormBaseline','Cue','Outcome'
% Filters
LauncherParam.PupilThreshold=1;
LauncherParam.WheelThreshold=2; %Speed cm/s
LauncherParam.LicksCue=2;
LauncherParam.LicksOutcome=2;
LauncherParam.TrialToFilterOut=[];
LauncherParam.LoadIgnoredTrials=1;
%% Overwrite Parameters found in AP_Parameters
LauncherParam.Name='VIP';
LauncherParam.Rig='Unknown';
LauncherParam.Behavior='CuedOutcome';
LauncherParam.Phase='RewardA';
LauncherParam.TrialNames={'T1','T2','T3','T4','T5','T6','T7','T8','T9','T10'};
LauncherParam.LickPort='Port1In';
LauncherParam.StateOfCue='Cue';
LauncherParam.StateOfOutcome='Outcome';
LauncherParam.CueTimeReset=[];     % overwrite preloaded parameters
LauncherParam.OutcomeTimeReset=[]; % overwrite preloaded parameters
LauncherParam.NidaqBaseline=[];    % overwrite preloaded parameters
% Photometry - being used if cannot find the parameters in the bpod file
LauncherParam.SamplingRate=2000;  %(Hz)
LauncherParam.NewSamplingRate=20; %(Hz)
LauncherParam.NidaqDuration=15;

%% File path 
[thisPath,thisName,thisExt]=fileparts(BpodSystem.DataPath);
LauncherParam.FileList=[thisName thisExt];
LauncherParam.FileToOpen=cellstr(LauncherParam.FileList);
LauncherParam.PathName=thisPath;
%% Analysis Photometry
Analysis=Analysis_Photometry(LauncherParam); 
%% Figure
Analysis.Figure.PostRec=AP_Sensor_OnlineSummaryPlot(Analysis,Water);
SummaryPlotPath = [Analysis.Parameters.DirFig Analysis.Parameters.Name '_Online.png'];
tic
disp(['Saving Figure to ' SummaryPlotPath])
saveas(gcf,SummaryPlotPath);
toc

% email configuration 
setpref('Internet','E_mail','kepecslab.cshl@gmail.com')
setpref('Internet','SMTP_Server','smtp.gmail.com')
setpref('Internet','SMTP_Username','kepecslab.cshl@gmail.com')
setpref('Internet','SMTP_Password','D3cision')
props = java.lang.System.getProperties;
props.setProperty('mail.smtp.auth','true');
props.setProperty('mail.smtp.socketFactory.class', 'javax.net.ssl.SSLSocketFactory');
props.setProperty('mail.smtp.socketFactory.port','465');

ENemail = 'egibson214.3941e4d@m.evernote.com';

% note content
text2add = strcat(' ----------------------------------------------------',...
    Analysis.Parameters.Name, [' in ' Analysis.Parameters.Rig],...
    ' ----------------------------------------------------');
noteTitle = strcat(Analysis.Parameters.Animal, ' @Sensors mice +');
tic
disp('Sending summary plot to Evernote notebook');
sendmail(ENemail, noteTitle, text2add, {SummaryPlotPath});
toc

%% Pop-up water supplement reminder
water2Supplement = 800 - Water;
msgbox({['Give ' Analysis.Parameters.Animal ' ' num2str(water2Supplement) 'uL water']}, 'Water reminder')
end