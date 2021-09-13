function Analysis=Analysis_Photometry(LauncherParam)
% Main script to analyze photometry data acquired using a DAQ and Bpod 
% This function uses
%   - AP_Load : function loading Bpod or preexisting analysis files
%   - AP_Save : Save analysis file at different steps of processing
%   - AP_Process : Process the data extracted in AP_Load
%   - AP_TrialTypes_FiltersAndPlot : sort data according to trial types and
%   generates summary plots
%   - AP_#####_FiltersAndPlot : sort data according to logical filters
%   specifics to behavior
%
% function designed by QuentinC 2020

%% Load Bpod or preexisting Analysis files
Analysis=AP_Load(LauncherParam);
%% Save core data
if LauncherParam.Save==1 %&& Analysis.Parameters.Pupillometry
AP_Save(Analysis,LauncherParam);
end
if ~LauncherParam.ArchiveOnly %
Analysis=AP_DataProcess(Analysis);
%% Sorts data by trial types and generates summary plots
Analysis=AP_TrialTypes_FiltersAndPlot(Analysis);
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
    case 'Sensor'
Analysis=AP_Sensor_FiltersAndPlot(Analysis);        
end

%% Save Analysis
if LauncherParam.Save==2
AP_Save(Analysis,LauncherParam);
end
end
end