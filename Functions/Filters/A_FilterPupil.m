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
if ~Analysis.Parameters.Pupillometry
    disp('Unable to generate pupillometry based filters');
    return
end
%% Parameters
switch nargin
    case 1
        FilterName='Pupil';
        State=Analysis.Parameters.PupilState;
        threshold=Analysis.Parameters.PupilThreshold;
    case 2
        State=Analysis.Parameters.PupilState;
        threshold=Analysis.Parameters.PupilThreshold;
end
PupillometryFilter=Analysis.Filters.Pupillometry;
%% Filter
Logicals=false(Analysis.AllData.nTrials,1);
Logicals(Analysis.AllData.Pupil.(State)>threshold)=true;

Logicals=Logicals.*PupillometryFilter;
LogicalsInv=(~Logicals).*PupillometryFilter;

%% Save
Analysis.Filters.(FilterName)=Logicals;
Analysis.Filters.([FilterName 'Inv'])=LogicalsInv;
end
