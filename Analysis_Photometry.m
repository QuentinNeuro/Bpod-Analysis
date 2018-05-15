function Analysis=Analysis_Photometry(DefaultParam)
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
if DefaultParam.Load==1
    FileName=DefaultParam.FileToOpen{1}
    cd(DefaultParam.PathName); load(FileName);
    Analysis.Properties=AP_ParametersUpdate(Analysis.Properties,DefaultParam);
else
%% Loads Bpod SessionData File, Extracts and Organizes all the data
for i=1:length(DefaultParam.FileToOpen)
    FileName=DefaultParam.FileToOpen{1,i}
    cd(DefaultParam.PathName); load(FileName);
    DirName=fullfile(DefaultParam.PathName, FileName);
    [~,FileNameNoExt]=fileparts(DirName);
    % Pupillometry
if exist([FileNameNoExt '_Pupil.mat'],'file')==2 
    load([FileNameNoExt '_Pupil.mat']);
else
    disp('Could not find the pupillometry data');
    Pupillometry=[];
end
    % Parameters, Ignored Trials and Data extraction
try
        Analysis.Properties=AP_Parameters(SessionData,Pupillometry,DefaultParam,FileNameNoExt);
        Analysis=A_FilterIgnoredTrials(Analysis,DefaultParam.TrialToFilterOut,DefaultParam.LoadIgnoredTrials);tic
        Analysis=AP_DataOrganize(Analysis,SessionData,Pupillometry);toc
catch
        disp([FileName ' NOT ANALYZED - Error in Parameters extraction or Data organization']);
end   
end
clear SessionData Pupillometry;
end

%% Sorts data by trial types and generates summary plots
Analysis=AP_TrialTypes_FiltersAndPlot(Analysis,DefaultParam);

%% Behavior specific : Sort filtered trials and generates plots
switch Analysis.Properties.Behavior
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
if DefaultParam.Save
    Analysis.Properties.Files=DefaultParam.FileToOpen;
    DirAnalysis=[DefaultParam.PathName 'Analysis' filesep];
    if isdir(DirAnalysis)==0
        mkdir(DirAnalysis);
    end
FileName=[Analysis.Properties.Name '_' Analysis.Properties.Phase];
DirFile=[DirAnalysis FileName];
save(DirFile,'Analysis');
end
end