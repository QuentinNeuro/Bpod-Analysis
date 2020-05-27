function Analysis=A_FilterTrialName(Analysis,FilterName)
% This script creates a filter according to the name of the trial types. 
% 
% Function designed by Quentin 2020 for Analysis_Photometry

%% Check
FilterNameNS=strrep(FilterName,' ','_');
checkExist=strrep(FilterNameNS,' ','_');
if isfield(Analysis.Filters,checkExist)
    disp(['Filter ' checkExist ' already generated']);
return
end
%% Parameters
TypeNb=A_NameToTrialNumber(Analysis,FilterName);

%% Filter
Logicals=false(Analysis.AllData.nTrials,1);
Logicals(ismember(Analysis.AllData.TrialTypes,TypeNb))=true;

%% Save
Analysis.Filters.(FilterNameNS)=Logicals;
end