function Analysis=Analysis_Photometry(LauncherParam)
% Function to analyze photometry data. 
% Generates a struct named 'Analysis' using the functions:
% AP_Parameters                 : extracts parameters of acquisition
% AP_DataOrganize               : extracts data from SessionData
% A_Filer#                      : filters out trials
% AP_DataSort                   : sort data according to trialtypes and filters
% AP_PlotData / AP_PlotSummary  : plot data
% Need to be used with Analysis_Photometry_Launcher
%
%function designed by Quentin 2017

%% Update some Parameters if loading a preexisting Analysis structure
if LauncherParam.Load==1
    FileName=LauncherParam.FileToOpen{1}
    cd(LauncherParam.PathName); load(FileName);
    Analysis.Parameters=AP_Parameters_Update(Analysis.Parameters,LauncherParam);
else
%% Loads Bpod SessionData File, Extracts and Organizes all the data
for i=1:length(LauncherParam.FileToOpen)
    FileName=LauncherParam.FileToOpen{1,i}
    cd(LauncherParam.PathName); load(FileName);
    DirName=fullfile(LauncherParam.PathName, FileName);
    [~,FileNameNoExt]=fileparts(DirName);
    % Pupillometry
if exist([FileNameNoExt '_Pupil.mat'],'file')==2 
    load([FileNameNoExt '_Pupil.mat']);
else
    disp('Could not find the pupillometry data');
    Pupillometry=[];
end
    % Parameters, Ignored Trials and Data extraction
% try
        Analysis.Parameters=AP_Parameters(SessionData,Pupillometry,LauncherParam,FileNameNoExt);
        Analysis=A_FilterIgnoredTrials(Analysis,LauncherParam.TrialToFilterOut,LauncherParam.LoadIgnoredTrials);tic
        Analysis=AP_DataOrganize(Analysis,SessionData,Pupillometry);toc
% catch
%         disp([FileName ' NOT ANALYZED - Error in Parameters extraction or Data organization']);
% end   
end
clear SessionData Pupillometry;
end

%% Sorts data by trial types and generates summary plots
Analysis=AP_TrialTypes_FiltersAndPlot(Analysis,LauncherParam);

%% Behavior specific : Sort filtered trials and generates plots
switch Analysis.Parameters.Behavior
    case 'CuedOutcome'
Analysis=AP_CuedOutcome_FiltersAndPlot(Analysis);
    case 'GoNogo'
Analysis=AP_GoNogo_FiltersAndPlot(Analysis);
    case 'AuditoryTuning'
AP_AuditoryTuning_FiltersAndPlot(Analysis);
    case 'Oddball'
Analysis=AP_OddBall_FiltersAndPlot(Analysis);
end

%% Save Analysis
if LauncherParam.Save
    Analysis.Parameters.Files=LauncherParam.FileToOpen;
    DirAnalysis=[LauncherParam.PathName 'Analysis' filesep];
    if isfolder(DirAnalysis)==0
        mkdir(DirAnalysis);
    end
FileName=[Analysis.Parameters.Name '_' Analysis.Parameters.Phase];
DirFile=[DirAnalysis FileName '.mat'];
save(DirFile,'Analysis');
end
end