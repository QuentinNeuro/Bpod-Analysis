function Analysis=Analysis_Bpod(LauncherParam)
% Main script to analyze photometry data acquired using a DAQ and Bpod 
% This function uses
%   - AB_Load : function loading Bpod or preexisting analysis files
%   - AB_Save : Save analysis file at different steps of processing
%   - AB_Process : Process the data extracted in AB_Load
%   - AB_TrialTypes_FiltersAndPlot : sort data according to trial types and
%   generates summary plots
%   - AB_BEHAVIOR_FiltersAndPlot : sort data according to logical filters
%   specifics to behavior
%
% function designed by QuentinC 2020
close all
%% Load Bpod or preexisting Analysis files
Analysis=AB_Load(LauncherParam);
%% Save core data
if LauncherParam.Save==1 %&& Analysis.Parameters.Pupillometry
AB_Save(Analysis,LauncherParam);
end
if ~LauncherParam.ArchiveOnly
%% Process the data
Analysis=AB_DataProcess(Analysis);
%% Sorts data by trial types and generates summary plots
Analysis=AB_TrialTypes_FiltersAndPlot(Analysis);
%% Behavior specific : Sort filtered trials and generates plots
switch Analysis.Parameters.Behavior.Behavior
    case {'CuedOutcome'} %,'Sensor'
Analysis=AB_CuedOutcome_FiltersAndPlot(Analysis);
    case 'GoNogo'
% Analysis=AB_GoNogo_FiltersAndPlot(Analysis);
    case 'AuditoryTuning'
% AB_AuditoryTuning_FiltersAndPlot(Analysis);
    case 'Oddball'
Analysis=AB_OddBall_FiltersAndPlot(Analysis);
    case 'Sensor'
Analysis=AB_Sensor_FiltersAndPlot(Analysis); 
    case 'Continuous'
AB_Continuous_FiltersAndPlot(Analysis)
    case 'CuedOutcome_AC'
Analysis=AB_CuedOutcome_AC_FiltersAndPlot(Analysis); 
    case 'OptoTuning'
Analysis=AB_OptoTuning_FiltersAndPlot(Analysis);
    case 'OptoPsycho'
Analysis=AB_OptoPsycho_FiltersAndPlot(Analysis);
end
if Analysis.Parameters.Filters.Pairing
    Analysis=AB_Pairing_FiltersAndPlot(Analysis);
end
%% Save Analysis
if LauncherParam.Save==2
AB_Save(Analysis,LauncherParam);
end
end
end