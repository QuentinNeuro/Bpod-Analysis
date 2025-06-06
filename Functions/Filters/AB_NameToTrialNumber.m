function TrialNumber=AB_NameToTrialNumber(Analysis,StringToSearch)
%A_NameToTrialNumber returns the trial type numbers for which the title
%contains StringToSearch. Returns NaN if no correspondance is found.
%
%function designed by Quentin 2016 for Analysis_Photometry

TrialNumber=NaN;
k=1;
for i=1:size(Analysis.Parameters.Behavior.TrialNames,2)
    if strfind(Analysis.Parameters.Behavior.TrialNames{i},StringToSearch)
        TrialNumber(k)=i;
        k=k+1;
    end
end
end
