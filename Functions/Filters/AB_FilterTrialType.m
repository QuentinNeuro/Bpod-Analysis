function Analysis=AB_FilterTrialType(Analysis)
% Function to filter trials according to their type number.
% Primarly designed to be ran before Datasorting function.
%
% Function designed by Quentin 2020 for Analysis_Photometry


%% Filter
ttNbs=unique(Analysis.AllData.TrialTypes);
for i=1:Analysis.Parameters.Behavior.nbOfTrialTypes
    t=ttNbs(i);
    thistype=sprintf('type_%.0d',t);
    Logicals=false(Analysis.AllData.nTrials,1);
    Logicals(Analysis.AllData.TrialTypes==t)=true;  
    Analysis.Filters.(thistype)=Logicals;
end
end