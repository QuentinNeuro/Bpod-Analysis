function Analysis=A_FilterBeforeAfter(Analysis,Number,FilterName1,FilterName2)
% Function to filter trials according to the number of trials
%
% Function designed by Quentin 2020 for Analysis_Photometry

%% Check
if isfield(Analysis.Filters,'Before') || isfield(Analysis.Filters,FilterName1)
    disp(['Before/After filter already generated']);
return
end

%% Parameters
switch nargin
    case 2
FilterName1='Before';
FilterName2='After';
    case 4
    otherwise
        disp('Needs 2 or 4 input arguments for A_FilterBeforeAfter function')
end
%% Filter
Logicals=false(Analysis.AllData.nTrials,1);
Logicals(1:Number)=true;
%% Save
Analysis.Filters.(FilterName1)=Logicals;
Analysis.Filters.(FilterName2)=~Logicals;
end