function  Analysis=AB_GoNogo_FiltersAndPlot(Analysis)
%This function can be used to generates filters based on behavior or states
%and to plot single and summary figures.
%COMMENTS TO COME
%
%function designed by Quentin 2017

%% Generates filters
% Trial types
FilterNames={'NoGo','Go1','Go2','Go3'};
for i=1:length(FilterNames)
    Analysis=AB_FilterTrialName(Analysis,FilterNames{i});
end
Analysis.Filters.Go=~Analysis.Filters.NoGo;

Analysis=AB_FilterState(Analysis,'Go','NoGo');
Analysis=AB_FilterLick(Analysis,'LicksOutcome','Outcome',Analysis.Parameters.Filters.LicksOutcome);
% Wheel
Analysis=AB_FilterRunning(Analysis,'Run',Analysis.Parameters.Filters.WheelState,Analysis.Parameters.Filters.WheelThreshold);
% Pupil
Analysis=AB_FilterPupil(Analysis,'Pupil',Analysis.Parameters.Filters.PupilState,Analysis.Parameters.Filters.PupilThreshold);
Analysis=AB_FilterPupil(Analysis,'PupilCue','CueAVG',2);
Analysis=AB_FilterPupilNaNCheck(Analysis,'PupilNaN',25);

%% Performance
if ~contains(Analysis.Parameters.Behavior.Phase,'Pavlvoian')
    AB_GoNogo_Performance(Analysis)
    saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Plot.Legend '_Performance.png']);
end
