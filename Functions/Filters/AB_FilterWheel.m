function Analysis=AB_FilterWheel(Analysis)

%% Filter
Logicals=logical(true(Analysis.Parameters.Behavior.nTrials(end),1)*Analysis.Parameters.Wheel.Wheel(end));
%% Save
if isfield(Analysis.Filters,'RecWheel')
    Analysis.Filters.RecWheel=[Analysis.Filters.RecWheel;Logicals];
else
    Analysis.Filters.RecWheel=Logicals;
end
end