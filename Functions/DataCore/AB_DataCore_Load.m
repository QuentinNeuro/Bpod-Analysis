function A_New=AB_DataCore_Load(Analysis)
% keep only core data and some filters upon loading
A_New.Parameters=Analysis.Parameters;
A_New.Core=Analysis.Core;
A_New.Filters.ignoredTrials=Analysis.Filters.ignoredTrials;
A_New.Filters.RecWheel=Analysis.Filters.RecWheel;
A_New.Filters.RecPupillometry=Analysis.Filters.RecPupillometry;
end