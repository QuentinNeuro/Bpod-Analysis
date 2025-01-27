function Analysis=A_FilterWheel(Analysis)

%% Filter
Logicals=logical(true(Analysis.Parameters.Behavior.nTrials,1)*Analysis.Parameters.Wheel.Wheel);
%% Save
if isfield(Analysis.Filters,'Wheel')
    Analysis.Filters.Wheel=[Analysis.Filters.Wheel;Logicals];
else
    Analysis.Filters.Wheel=Logicals;
end
end