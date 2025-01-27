function Analysis=A_FilterRunning(Analysis,FilterName,State,threshold)
% Function to filter trials according to the running activity of the animal
% Threshold and behavioral state can be specified in the
% Analysis.Parameters structure (see parameters part).
% Generates an additional inverted filter.
%
% Function designed by Quentin 2020 for Analysis_Photometry

%% Check
if nargin==1
    checkExist='Run';
else
checkExist=FilterName;
end
if isfield(Analysis.Filters,checkExist)
    disp(['Filter ' checkExist ' already generated']);
return
end
%% Filter
Logicals=false(Analysis.AllData.nTrials,1);
if Analysis.Parameters.Wheel.Wheel
    Logicals(Analysis.AllData.Wheel.(State)>threshold)=true;
    LogicalsInv=~Logicals;
else
    LogicalsInv=Logicals;
end

%% Save
Analysis.Filters.(FilterName)= Logicals;
Analysis.Filters.([FilterName 'Inv'])=LogicalsInv;
end
