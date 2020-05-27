function Analysis=A_FilterPupilNaNCheck(Analysis,FilterName,Threshold)
%
%
% Function designed by Quentin 2017 for Analysis_Photometry
%% Parameters
switch nargin
    case 1
       FilterName='PupilNaN'; 
       Threshold=25;
    case 2
       Threshold=25;
end

% Name
FilterNb=length(Analysis.Filters.Names);
Analysis.Filters.Names{FilterNb+1}=FilterName;
% Filter
Logicals=ones(Analysis.AllData.nTrials,1);
%% Filter
nbofframes=100; % to test whether nan
if Analysis.Parameters.Pupillometry==1   
    testnan=isnan(Analysis.AllData.Pupil.Pupil);
    sumnan=sum(testnan(:,1:nbofframes),2)*(nbofframes/100);
    Logicals(sumnan>Threshold)=false;
end
Analysis.Filters.Logicals=[Analysis.Filters.Logicals Logicals];
end
