function Analysis=AB_FilterAfollowsB(Analysis,FilterName,TypeA,TypeB)
% Function to filter trials according to a trial type sequence
%
% function designed by Quentin 2020 for Analysis_Photometry

%% Check
checkExist=FilterName;
if isfield(Analysis.Filters,checkExist)
    disp(['Filter ' checkExist ' already generated']);
return
end
%% Parameters
if ischar(TypeA)
    TypeA=AB_NameToTrialNumber(Analysis,TypeA);
elseif iscell(TypeA)
    n=size(TypeA,1);
    TempTypeA=[];
    for i=1:n
        TempTypeA=[TempTypeA A_NameToTrialNumber(Analysis,TypeA{i})];
    end
    TypeA=TempTypeA;
end

if ischar(TypeB)
    TypeB=AB_NameToTrialNumber(Analysis,TypeB);
elseif iscell(TypeB)
    n=size(TypeB,1);
    TempTypeB=[];
    for i=1:n
        TempTypeB=[TempTypeB A_NameToTrialNumber(Analysis,TypeB{i})];
    end
    TypeB=TempTypeB;
end

%% Filter
Logicals=false(Analysis.AllData.nTrials,1);
for i=1:Analysis.AllData.nTrials-1
    if ismember(Analysis.AllData.TrialTypes(i),TypeB) && ismember (Analysis.AllData.TrialTypes(i+1),TypeA) 
        Logicals(i+1)=true;
    end
end
%% Save
Analysis.Filters.(FilterName)=Logicals;
end