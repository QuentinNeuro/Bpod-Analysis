function Analysis=A_FilterWheel(Analysis)

%% Filter
Logicals=logical(true(Analysis.Parameters.nTrials,1)*Analysis.Parameters.Wheel);
%% Save
if isfield(Analysis.Filters,'Wheel')
    Analysis.Filters.Wheel=[Analysis.Filters.Wheel;Logicals];
else
    Analysis.Filters.Wheel=Logicals;
end
end