%% Event detection pipeline
% Functions : AP_Events / AP_Events_Epochs / AP_Events_Plot
% see inside AP_Events for better explanation on the input variables.
% load Eventdetection_example_data for example DA recordings
% L-DA-11 from Jan 28-29-30 / 20 Hz z-sc data, aligned to reward delivery;
% Parameters for the different functions

%% Parameters
% Event detection
testMin='miniLocal';    % for minimum methods
minTW='auto';           % will look for a local minimum within 1 peak width left of the peak 
wvTW=20*1;              % for waveform display 20Hz * 1sec
peakTFactor=0.8;        % for peak detection threshold : usually between 1 and 0.5 of std(data)
minTFactor=0.5;         % for mimimun detection threshold
show=1;                 % 1 if you want to see an example detection trace (some will also be displayed in the final plot

% epoch 
plotName='CuedReward'; %Name of your figure / trial type
epochTW=[-3 -2; -1.5 -0.5; 0 1];
epochNames={'Baseline','Cue','Outcome'};


%% detect the events :
allData=[];
allTime=[];
for s=1:size(data,2)
    thisData=data{s};
    thisTime=time{s};
    peakT=std(thisData(:),'omitnan')*peakTFactor;
    minT=peakT*minTFactor;
    newPeakStats=AP_Events(thisTime,thisData,testMin,peakT,minT,minTW,wvTW,show);
    if s==1
       peakStats=newPeakStats;
    else
        newPeakStats.trials=newPeakStats.trials+max(peakStats.trials);        %% UPDATE TRIAL INDICES FOR COMBINING SESSIONS 
        newPeakStats.session=newPeakStats.session+max(peakStats.session);     %% UPDATE SESSION INDICES FOR COMBINING SESSIONS 
        peakFields=fieldnames(peakStats);
        for thisF=1:size(peakFields,1)
            thisField=peakFields{thisF};
            peakStats.(thisField)=[peakStats.(thisField) newPeakStats.(thisField)];
        end
    end
    allData=[allData ; thisData];
    allTime=[allTime ; thisTime];
end

%% Analyze peak in specific epochs
peakStats=AP_Events_Epochs(peakStats,epochTW,epochNames);

%% Plot function
AP_Events_Plot(peakStats,allTime,allData,plotName);