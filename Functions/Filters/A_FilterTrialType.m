function Analysis=A_FilterTrialType(Analysis)
% Function to filter trials according to their type number.
% Primarly designed to be ran before Datasorting function.
%
% Function designed by Quentin 2020 for Analysis_Photometry

%% Check
checkExist='type_1';
if isfield(Analysis.Filters,checkExist)
    disp('Trial type filters already generated');
return
end

%% Filter
for i=1:Analysis.Parameters.nbOfTrialTypes
    Logicals=false(Analysis.AllData.nTrials,1);
    thistype=sprintf('type_%.0d',i);
    Logicals(Analysis.AllData.TrialTypes==i)=true;  
    Analysis.Filters.(thistype)=Logicals;
end
end