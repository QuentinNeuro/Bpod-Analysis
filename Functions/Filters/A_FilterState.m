function Analysis=A_FilterState(Analysis,State,noState)
% Function to filter trials according to the active state 'State'.
% Also generates a noState filter.
%
% Function designed by Quentin 2017 for Analysis_Photometry

%% Check
checkExist=State;
if isfield(Analysis.Filters,checkExist)
    disp(['Filter ' checkExist ' already generated']);
return
end

%% Parameters
%Name
if nargin==2
    noState=State+'Inv';
end
%% Filter
Logicals=false(Analysis.AllData.nTrials,1);
for i=1:Analysis.AllData.nTrials
    if ~isnan(Analysis.Core.States{1,i}.(State))
        Logicals(i)=true;
    end
end

%% Save
Analysis.Filters.(State)=Logicals;
Analysis.Filters.(noState)=~Logicals;
end