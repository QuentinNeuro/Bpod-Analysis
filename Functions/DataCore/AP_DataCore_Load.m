function A_New=AP_DataCore_Load(Analysis)
% keep only core data and some filters upon loading
A_New.Parameters=Analysis.Parameters;
A_New.Filters.ignoredTrials=Analysis.Filters.ignoredTrials;
A_New.Filters.Wheel=Analysis.Filters.Wheel;
A_New.Filters.Pupillometry=Analysis.Filters.Pupillometry;
A_New.Core=Analysis.Core;
end