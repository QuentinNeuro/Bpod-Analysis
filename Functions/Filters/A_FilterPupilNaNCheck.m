function Analysis=A_FilterPupilNaNCheck(Analysis,FilterName,Threshold)
%
%
% Function designed by Quentin 2017 for Analysis_Photometry

%% Check
if nargin==1
    checkExist='PupilNaN';
else
checkExist=FilterName;
end
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
       FilterName='PupilNaN'; 
       Threshold=25;
    case 2
       Threshold=25;
end
PupillometryFilter=Analysis.Filters.Pupillometry;
%% Filter
Logicals=ones(Analysis.AllData.nTrials,1);
nbofframes=100; % to test whether nan
testnan=isnan(Analysis.AllData.Pupil.Pupil);
sumnan=sum(testnan(:,1:nbofframes),2)*(nbofframes/100);
Logicals(sumnan>Threshold)=false;

Logicals=Logicals.*PupillometryFilter;
LogicalsInv=(~Logicals).*PupillometryFilter;

%% Save
Analysis.Filters.(FilterName)=logical(Logicals);
Analysis.Filters.([FilterName 'Inv'])=logical(LogicalsInv);
end
