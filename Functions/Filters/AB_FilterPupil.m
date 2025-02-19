function Analysis=AB_FilterPupil(Analysis,FilterName,State,threshold)
% Function to filter trials according to the running activity of the animal
% Threshold and behavioral state can be specified in the
% Analysis.Parameters structure (see parameters part).
% Generates an additional inverted filter.
%
% Function designed by Quentin 2017 for Analysis_Photometry

%% Check
if isempty(FilterName)
    FilterName=['Pupil' State];
end
checkExist=FilterName;
if isfield(Analysis.Filters,checkExist)
    disp(['Filter ' checkExist ' already generated']);
return
end
if ~Analysis.Parameters.Pupillometry.Pupillometry
    % disp('Unable to generate pupillometry based filters');
    return
end

%% Filter
PupillometryFilter=Analysis.Filters.Pupillometry;
Logicals=false(Analysis.AllData.nTrials,1);
Logicals(Analysis.AllData.Pupil.(State)>threshold)=true;

Logicals=Logicals.*PupillometryFilter;
LogicalsInv=(~Logicals).*PupillometryFilter;

%% Save
Analysis.Filters.(FilterName)=logical(Logicals);
Analysis.Filters.([FilterName 'Inv'])=logical(LogicalsInv);
end
