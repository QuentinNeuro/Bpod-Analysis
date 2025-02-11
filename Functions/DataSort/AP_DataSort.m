function Analysis=AP_DataSort(Analysis,FilterName,thisFilter)
%AP_Data sorts the data generated by AP_DataProcess based on the filter
%specified in 'FilterName'.
%
%function designed by Quentin 2016 for Analysis_Photometry

%% Parameters
% Licks

% Photometry
nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);

%% Filter
FilterName=strrep(FilterName,' ','_');
thistype=FilterName;
ignoredTrialFilter=Analysis.Filters.ignoredTrials';
% recovery of filter if not specified
if nargin==2 || isempty(thisFilter)==1
    if isfield(Analysis.Filters,thistype)
thisFilter=Analysis.Filters.(thistype);
    else
        disp(['Unable to sort data based on filter ' thistype]);
        return
    end
end
% Check whether data have already been filtered using the specified filter
if isfield(Analysis,thistype)
    disp(['Data for ' thistype ' have already been computed']);
    return
end
thisFilter=logical(thisFilter.*ignoredTrialFilter);
%% Extract Data
    Analysis.(thistype).Name                        =strrep(FilterName,'_',' ');
    Analysis.(thistype).nTrials                     =nnz(thisFilter);
    Analysis.(thistype).IgnoredTrials               =Analysis.AllData.nTrials-Analysis.(thistype).nTrials;
if Analysis.(thistype).nTrials>0
    Analysis=AP_DataSort_FieldMatch(Analysis,FilterName,thisFilter);    
%% Licks
    Analysis=AP_DataSort_Licks(Analysis,thistype);
%% Photometry
if Analysis.Parameters.Photometry.Photometry
    Analysis=AP_DataSort_Photometry(Analysis,thistype);
end

%% AOD / Miniscope / Spikes
if Analysis.Parameters.nCells
    Analysis=AP_DataSort_SingleCell(Analysis,thistype);
end
    
%% Event detection
if Analysis.Parameters.EventDetection.Detection
    Analysis=AP_DataSort_Events(Analysis,thistype);
end
%% Wheel
    if Analysis.Parameters.Wheel.Wheel
        Analysis.(thistype).Wheel.DistanceAVG            =mean(Analysis.(thistype).Wheel.Distance,1,'omitnan'); 
        Analysis.(thistype).Wheel.DistanceSEM            =std(Analysis.(thistype).Wheel.Distance,0,1,'omitnan')/sqrt(Analysis.(thistype).nTrials);
    end
%% Pupillometry
    if Analysis.Parameters.Pupillometry.Pupillometry
        Analysis.(thistype).Pupil.PupilAVG          =mean(Analysis.(thistype).Pupil.PupilDPP,1,'omitnan'); 
        Analysis.(thistype).Pupil.PupilSEM          =std(Analysis.(thistype).Pupil.PupilDPP,0,1,'omitnan')/sqrt(Analysis.(thistype).nTrials);
    end
end
end