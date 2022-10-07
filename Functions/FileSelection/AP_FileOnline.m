%% Use Analysis_Photometry_Launcher to keep it up to date with the pipeline
% postrec specific code can be find at the end of this script
% QC 2021

function AP_FileOnline(LP)
global BpodSystem

%% Adjust some launcher parameters just in case
LP.Analysis_type='Single';
LP.OW.PhotoChNames={'F1','F2'}; %{'ACx' 'mPFC' 'ACxL' 'ACxR' 'VS' 'BLA'}
LP.P.SortFilters=1;
LP.P.PlotSummary1=1;
LP.P.PlotSummary2=0;
LP.P.PlotFiltersSingle=0;           
LP.P.PlotFiltersSummary=0;
LP.P.PlotFiltersBehavior=0;           	
LP.P.Illustrator=0;
LP.P.Transparency=1;
% Archiving photometry data
LP.P.NidaqDecimatedSR=100; 
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
Analysis_Photometry(LP); 

end