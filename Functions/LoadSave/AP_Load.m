function Analysis=AP_Load(LP)
% Loading engine of Analysis Photometry Pipeline
% Function used to open preexisting analysis or bpod files
% Can do batch processing by opening one file at the time or grouping them
% This is where data are beeing extracted and parameters defined
% This function uses
%   - AP_DataCore_Merge : used to merge Analysis files
%   - AP_Parameters_Update : used to update parameters of existing analysis
%   file upon loading
%   - AP_Parameters : extracts and generates parameters for analysis
%   - AP_DataCore : extract data from the bpod files
%   - A_FilterIgnoredTrials/Wheel/Pupillometry : create filters containing
%   trials to ignore + trials with recorded wheel or pupillometry
%
% function designed by QuentinC 2020
%% Automatically test whether it is a bpodfile or an analysis file
% TBD
%% Loading pre existing analysis file(s)
if LP.Load==1
   FileName=LP.FileToOpen{1,1}
   cd(LP.PathName); load(FileName); 
   Analysis=AP_DataCore_Load(Analysis);
   % add try/catch
for i=2:length(LP.FileToOpen)
   AnalysisTemp=Analysis;
   FileName=LP.FileToOpen{1,i}
   cd(LP.PathName); load(FileName);
   Analysis=AP_DataCore_Merge(AnalysisTemp,Analysis);
   clear AnalysisTemp
end
Analysis.Parameters=AP_Parameters_Update(Analysis.Parameters,LP);
else
Analysis.Parameters=struct();    
%% Loading Bpod file    
for i=1:length(LP.FileToOpen)
   FileName=LP.FileToOpen{1,i}
   cd(LP.PathName); load(FileName); 
% Check for pupillometry file
    DirName=fullfile(LP.PathName, FileName);
    [~,FileNameNoExt]=fileparts(DirName);
if exist([FileNameNoExt '_Pupil.mat'],'file')==2 
    load([FileNameNoExt '_Pupil.mat']);
else
    disp('Could not find the pupillometry data');
    Pupillometry=[];
end
% Parameters, Ignored Trials and Data extraction
% try
        Analysis.Parameters=AP_Parameters(SessionData,Pupillometry,LP,FileNameNoExt,Analysis.Parameters);
        Analysis=A_FilterIgnoredTrials(Analysis);
        Analysis=A_FilterWheel(Analysis);
        Analysis=A_FilterPupillometry(Analysis);
        tic;
        Analysis=AP_DataCore(Analysis,SessionData,Pupillometry);toc
        if LP.Archive==1
            AP_Archive(Analysis,SessionData,LP);
        end
        if isfield(SessionData,'Modulation')
            Analysis.Parameters.Modulation=SessionData.Modulation;
        end
catch
        disp([FileName ' NOT ANALYZED - Error in Parameters extraction or Data organization']);
end   
end
clear SessionData Pupillometry;
end

%% Adjust some fields upon loading completion
Analysis.Parameters.nTrials=Analysis.Core.nTrials;
if sum(Analysis.Filters.Wheel>=1)
    Analysis.Parameters.Wheel=1;
else
    Analysis.Parameters.Wheel=0;
end
if sum(Analysis.Filters.Pupillometry>=1)
    Analysis.Parameters.Pupillometry=1;
else
    Analysis.Parameters.Pupillometry=0;
end

%% File Name
if iscell(Analysis.Parameters.Files)
    if length(Analysis.Parameters.Files)>1
    Analysis.Parameters.Legend=[Analysis.Parameters.Animal '_' Analysis.Parameters.Behavior '_' Analysis.Parameters.Phase '_' Analysis.Parameters.TypeOfCue];
    else
    Analysis.Parameters.Legend=[Analysis.Parameters.Files{1} '_' Analysis.Parameters.Phase '_' Analysis.Parameters.TypeOfCue];
    end
    else
    Analysis.Parameters.Legend=[Analysis.Parameters.Files '_' Analysis.Parameters.Phase '_' Analysis.Parameters.TypeOfCue];
end
if ~isempty(LP.SaveTag)
    Analysis.Parameters.Legend=[Analysis.Parameters.Legend '_' LP.SaveTag];
end

%% Figure path
Analysis.Parameters.DirFig=[LP.PathName Analysis.Parameters.Phase filesep];
end
