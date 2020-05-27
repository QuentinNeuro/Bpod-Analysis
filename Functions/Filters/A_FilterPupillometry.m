function Analysis=A_FilterPupillometry(Analysis)

%% Filter
Logicals=logical(true(Analysis.Parameters.nTrials,1)*Analysis.Parameters.Pupillometry_Parameters{end}.Pupillometry);
%% Save
if isfield(Analysis.Filters,'Pupillometry')
    Analysis.Filters.Pupillometry=[Analysis.Filters.Pupillometry;Logicals];
else
    Analysis.Filters.Pupillometry=Logicals;
end
end