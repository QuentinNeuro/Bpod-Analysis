function Analysis=AB_FilterState(Analysis,State,noState)
% Function to filter trials according to the active state 'State'.
% Also generates a noState filter.
%
% Function designed by Quentin 2017 for Analysis_Photometry

%% FilterName
FilterName=[State '_State'];
if nargin==3
    FilterNameInv=[noState '_State'];
else
    FilterNameInv=[FilterName 'Inv'];
end
%% Check
if isfield(Analysis.Filters,FilterName)
    disp(['Filter ' checkExist ' already generated']);
return
end

%% Filter
Logicals=false(Analysis.AllData.nTrials,1);
for i=1:Analysis.AllData.nTrials
    if ~isnan(Analysis.Core.States{1,i}.(State))
        Logicals(i)=true;
    end
end

%% Save
Analysis.Filters.(FilterName)=Logicals;
Analysis.Filters.(FilterNameInv)=~Logicals;
end