%% Use Analysis_Photometry_Launcher to keep it up to date with the pipeline
% postrec specific code can be find at the end of this script
% QC 2021

function AB_FileOnline(LP)
global BpodSystem

%% Adjust some launcher parameters just in case
%% Overwritting Parameters
LP.Analysis_type='Single';
LP.P.Data.Label={};
%% Analysis Parameters
LP.P.Filters.Sort=0;
% Figures
LP.P.Plot.TrialTypes=1;                  % Raw trial types - no filter applied
LP.P.Plot.FiltersSingle=0;               % individual raster for individual trial type
LP.P.Plot.FiltersSummary=0;              % summary plot for groups of trial type
LP.P.Plot.FiltersBehavior=0;           	 % AP_####_GroupToPlot Oupput 2
LP.P.Plot.Illustrator=0;
LP.P.Plot.Transparency=1;
LP.P.Plot.xTime=[-4 4];
LP.P.Timing.PSTH=[-5 5];
% Data Normalization
LP.P.Data.Normalize='Zsc';                   % 'Zsc' 'DFF' 'No or empty or Hz'
LP.P.Data.BaselineTW=[0.2 1.2];              % Baseline time
LP.P.Data.BaselineBefAft=1;                  % calculate Baseline before or after extracting desired PSTH
LP.P.Data.BaselineMov=5;                     % 
LP.P.Data.SamplingRateDecimated=100;         % in Hz 20 for figures 100 for archiving
%% Archiving photometry data
LP.Archive=1; %
LP.ArchiveOnly=0;
LP.ArchiveOW=0;
LP.MEGABATCH=0;
%% File path  from Bpod
[thisPath,thisName,thisExt]=fileparts(BpodSystem.DataPath);
LP.FileList=[thisName thisExt];
LP.PathName=[thisPath filesep];
LP.FileToOpen=cellstr(LP.FileList);
%% Run Analysis_Photometry
Analysis_Bpod(LP); 
end