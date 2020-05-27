function Analysis=A_FilterIgnoredTrials(Analysis,IT,test)
%Allows to ignore trials specified in 'IT'. 'IT' will be save as a .mat file. 
%'Test' can be used to specificy whether the function should load a .mat
%file containing the 'IT' variable (test=1 by default, test=0 will not load
%the file).
%
%function designed by Quentin 2016 for Analysis_Photometry

%% Checks and loads IT
switch nargin
    case 1
        if isfield(Analysis.Parameters,'LoadIgnoredTrials') && isfield(Analysis.Parameters,'TrialToFilterOut')
IT=Analysis.Parameters.TrialToFilterOut;
test=Analysis.Parameters.LoadIgnoredTrials;
        else
disp('Cannot find parameters for ignoredTrials filter function - Will continue with default parameters');
IT=[];
test=1;
        end
    case 2
test=1;
end

ITFile=[Analysis.Parameters.Name '_ignoredTrials.mat'];
if isempty(IT)==1 && exist(ITFile,'file') && test==1
  load(ITFile);  
end

%% Generates the filter
Analysis.Filters.ignoredTrials=true(1,Analysis.Parameters.nTrials);
Analysis.Filters.ignoredTrials(IT)=false;
%% Saves the filter
if isempty(IT)==0
    Analysis.Parameters.ignoredTrials=IT;
    save(ITFile,'IT');
end
end