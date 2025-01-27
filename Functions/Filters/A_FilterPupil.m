function Analysis=A_FilterPupil(Analysis,FilterName,State,threshold)
% Function to filter trials according to the running activity of the animal
% Threshold and behavioral state can be specified in the
% Analysis.Parameters structure (see parameters part).
% Generates an additional inverted filter.
%
% Function designed by Quentin 2017 for Analysis_Photometry

%% Check
checkExist=FilterName;
if isfield(Analysis.Filters,checkExist)
    disp(['Filter ' checkExist ' already generated']);
return
end
if ~Analysis.Parameters.Pupillometry.Pupillometry
    disp('Unable to generate pupillometry based filters');
    return
end

%% Filter
PupillometryFilter=Analysis.Filters.Pupillometry;
Logicals=false(Analysis.AllData.nTrials,1);
Logicals(Analysis.AllData.Pupil.(State)>threshold)=true;

Logicals=Logicals.*PupillometryFilter;
LogicalsInv=(~Logicals).*PupillometryFilter;

%% Save
Analysis.Filters.(FilterName)=Logicals;
Analysis.Filters.([FilterName 'Inv'])=LogicalsInv;
end
