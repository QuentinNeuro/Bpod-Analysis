function [Analysis,Logicals]=AB_FilterMeta(Analysis,FilterName,FiltersCell)
% Function to merge filters specified in 'FiltersCell' into one filter array (0 or 1) 
%
% function designed by Quentin 2020 for Analysis_Photometry


FiltersCell=strrep(FiltersCell,' ','_');
FilterName=strrep(FilterName,' ','_');
NbOfFilters=length(FiltersCell);
%% Check
if sum(isfield(Analysis.Filters,FiltersCell))~=NbOfFilters
    disp(['Not all the filters have been generated for metafilter ' FilterName]);
    Logicals=false(Analysis.AllData.nTrials,1);
    Analysis.Filters.(FilterName)=Logicals;
    return
end

if isfield(Analysis.Filters,FilterName)
    % disp(['Filter ' checkExist ' already generated']);
    Logicals=Analysis.Filters.(FilterName);
    return
end
   
%% Parameters
Logicals=true(Analysis.AllData.nTrials,1);

%% Filter
for i=1:NbOfFilters
            Logicals=Logicals.*Analysis.Filters.(FiltersCell{i});
end
Analysis.Filters.(FilterName)=logical(Logicals);
end