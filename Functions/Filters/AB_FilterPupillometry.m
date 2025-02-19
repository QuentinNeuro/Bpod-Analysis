function Analysis=AB_FilterPupillometry(Analysis)

%% Filter
Logicals=logical(true(Analysis.Parameters.Behavior.nTrials(end),1)*Analysis.Parameters.Pupillometry.Pupillometry(end));
%% Save
if isfield(Analysis.Filters,'RecPupillometry')
    Analysis.Filters.RecPupillometry=[Analysis.Filters.RecPupillometry;Logicals];
else
    Analysis.Filters.RecPupillometry=Logicals;
end
end