%% Event detection pipeline
% AP_Events / AP_Events_Epochs / AP_Events_Plot
% see inside each functions for explanation on the input variables.

%% detect the event :
% see inside function for explanation on the variables.
peakStats=AP_Events(time,data,testMin,peakT,minT,minTW,wvTW,show);

% can be looped over multiple sessions with per session normalization :
% need to update  peakStats.trials and peakStats.session at every session
newPeaksStats.trials=newPeaksStats.trials+max(oldPeakStats.trials);
newPeaksStats.session=newPeaksStats.session+max(oldPeakStats.session);
peakFields=fieldnames(newPeaksStats);
for thisF=1:size(peakFields,1)
    thisField=peakFields{thisF};
    combinedPeaksStats=[oldPeakStats.(thisField) newPeaksStats.(thisField)];
end

%% Analyze peak in specific epochs
% epochTW=[-4 -3; -1.5 -1; -1 0; -1.5 0; 0 2];
% epochNames={'Baseline','Cue','Delay','CueAndDelay','Outcome'};
peakStats=AP_Events_Epochs(peakStats,epochTW,epochNames);

%% Plot function
AP_Events_Plot(peakStats,time,data,plotName,epochTW,epochNames);