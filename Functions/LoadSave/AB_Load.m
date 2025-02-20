function Analysis=AB_Load(LP)
% Loading engine of Analysis Photometry Pipeline
% Function used to open preexisting analysis or bpod files
% Can do batch processing by opening one file at the time or grouping them
% This is where data are beeing extracted and parameters defined
% This function uses
%   - AB_DataCore_Merge : used to merge Analysis files
%   - AB_Parameters_Update : used to update parameters of existing analysis
%   file upon loading
%   - AB_Parameters : extracts and generates parameters for analysis
%   - AB_DataCore : extract data from the bpod files
%   - A_FilterIgnoredTrials/Wheel/Pupillometry : create filters containing
%   trials to ignore + trials with recorded wheel or pupillometry
%
% function designed by QuentinC 2020

%% Automatically test whether it is a bpodfile or an analysis file, AOD, spikes or photometry etc
LP=AB_AutoLoad(LP);
%% Loading existing analysis file
switch LP.Load
   case 'Analysis'
   FileName=LP.FileToOpen{1,1}
   cd(LP.PathName); load(FileName);
   Analysis=AB_DataCore_Load(Analysis);
for i=2:length(LP.FileToOpen)
   AnalysisTemp=Analysis;
   FileName=LP.FileToOpen{1,i}
   cd(LP.PathName); load(FileName);
   Analysis=AB_DataCore_Merge(AnalysisTemp,Analysis);
   clear AnalysisTemp
end
Analysis=AB_Load_VC(Analysis);
Analysis.Parameters=AB_Parameters_Update(Analysis.Parameters,LP);

%% Loading Bpod file    
    case 'Bpod'
Analysis.Parameters=struct();    
for i=1:length(LP.FileToOpen)
   FileName=LP.FileToOpen{1,i}
   cd(LP.PathName); load(FileName); 
   [~,FileNameNoExt]=fileparts(fullfile(LP.PathName, FileName));
% Parameters, Ignored Trials and Data extraction
% try
        Analysis.Parameters =   AB_Parameters(SessionData,LP,FileNameNoExt,Analysis.Parameters);
        Analysis            =   AB_DataCore(Analysis,SessionData);
        if LP.Archive==1
            AB_Archive(Analysis,SessionData,LP);
        end
% catch
%         disp([FileName ' NOT ANALYZED - Error in AB_Load']);
% end   
end
clear SessionData
end

%% File Name
if iscell(Analysis.Parameters.Files)
    PhaseTypeOfCue=[Analysis.Parameters.Behavior.Phase '_' Analysis.Parameters.Behavior.TypeOfCue];
    if length(Analysis.Parameters.Files)>1
    Analysis.Parameters.Plot.Legend=[Analysis.Parameters.Animal '_' Analysis.Parameters.Behavior.Behavior '_' PhaseTypeOfCue];
    else
    Analysis.Parameters.Plot.Legend=[Analysis.Parameters.Files{1} '_' PhaseTypeOfCue];
    end
    else
    Analysis.Parameters.Plot.Legend=[Analysis.Parameters.Files '_' PhaseTypeOfCue];
end
if ~isempty(LP.SaveTag)
    Analysis.Parameters.Plot.Legend=[Analysis.Parameters.Plot.Legend '_' LP.SaveTag];
end

%% Figure path
Analysis.Parameters.DirFig=[LP.PathName filesep Analysis.Parameters.Behavior.Phase filesep];
end
