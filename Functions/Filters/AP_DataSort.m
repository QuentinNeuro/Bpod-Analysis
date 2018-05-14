function Analysis=AP_DataSort(Analysis,FilterName,Filter)
%AP_Data sorts the data generates by AP_DataOrganize based on the filter
%specified in 'FilterName'.
%
% TO DO : new zero
%function designed by Quentin 2016 for Analysis_Photometry

%% Parameters
thistype=FilterName;
% recovery of filter if not specified
if nargin==2 || isempty(Filter)==1
    Filter=false(Analysis.AllData.nTrials,1);
    counter=0;
    for j=1:length(Analysis.Filters.Names)
        counter=counter+1;
        if strcmp(Analysis.Filters.Names{j},FilterName)
            Filter=Analysis.Filters.Logicals(:,counter);
        end
    end
end
% Check whether data have already been filtered using the specified filter
if isfield(Analysis,thistype)
    fprintf('Data for %s have already been computed',FilterName);
    return
else
%% Extract Data
if max(Filter)<=1
    thisFilter=logical(Filter);
end
    Analysis.(thistype).Name                        =strrep(FilterName,'_',' ');
    Analysis.(thistype).nTrials                     =nnz(thisFilter);
    if Analysis.(thistype).nTrials>0
    Analysis.(thistype).IgnoredTrials               =Analysis.AllData.nTrials-Analysis.(thistype).nTrials;
    Analysis.(thistype).TrialNumbers                =Analysis.AllData.TrialNumbers(thisFilter);
% Timing
    Analysis.(thistype).CueTime=Analysis.AllData.CueTime(thisFilter,:);
    Analysis.(thistype).CueTime=Analysis.(thistype).CueTime(1,:);
    Analysis.(thistype).OutcomeTime=Analysis.AllData.OutcomeTime(thisFilter,:);
    Analysis.(thistype).OutcomeTime=Analysis.(thistype).OutcomeTime(1,:);
    
    CueTime=Analysis.(thistype).CueTime+Analysis.Properties.CueTimeReset;
    OutcomeTime=Analysis.(thistype).OutcomeTime+Analysis.Properties.OutcomeTimeReset;
% Licks    
    thisEvents                                      =Analysis.AllData.Licks.Events;
    thisEvents(thisFilter~=1) = '';
    Analysis.(thistype).Licks.Events                =cell2mat(thisEvents);
    thisTrials=cell(size(thisEvents));
    for i=1:length(thisTrials)
        thisTrials{1,i}=i*ones(length(thisEvents{1,i}),1)';
    end
    Analysis.(thistype).Licks.Trials=cell2mat(thisTrials);
    Analysis.(thistype).Licks.Bin                       =Analysis.AllData.Licks.Bin{thisFilter};
    Analysis.(thistype).Licks.Rate                      =Analysis.AllData.Licks.Rate(thisFilter,:);
	Analysis.(thistype).Licks.Cue                       =Analysis.AllData.Licks.Cue(thisFilter);
    Analysis.(thistype).Licks.Outcome                   =Analysis.AllData.Licks.Outcome(thisFilter);
    % Average
    Analysis.(thistype).Licks.AVG                       =mean(Analysis.(thistype).Licks.Rate,1);
    Analysis.(thistype).Licks.SEM                       =std(Analysis.(thistype).Licks.Rate,0,1)/sqrt(Analysis.(thistype).nTrials);
    Analysis.(thistype).Licks.Bin                       =Analysis.Properties.LickEdges(1)+Analysis.Properties.Bin:Analysis.Properties.Bin:Analysis.Properties.LickEdges(2);
    Analysis.(thistype).Licks.CueAVG                    =mean(Analysis.(thistype).Licks.Cue);
    Analysis.(thistype).Licks.OutcomeAVG                =mean(Analysis.(thistype).Licks.Outcome);
% Photometry    
    for thisCh=1:length(Analysis.Properties.PhotoCh)
        thisChStruct=sprintf('Photo_%s',char(Analysis.Properties.PhotoCh{thisCh}));
        Analysis.(thistype).(thisChStruct).Name         =Analysis.Properties.PhotoChNames{thisCh};
        Analysis.(thistype).(thisChStruct).Time         =Analysis.AllData.(thisChStruct).Time(thisFilter,:);
        Analysis.(thistype).(thisChStruct).DFF          =Analysis.AllData.(thisChStruct).DFF(thisFilter,:);
        Analysis.(thistype).(thisChStruct).Cue          =Analysis.AllData.(thisChStruct).Cue(thisFilter);
        Analysis.(thistype).(thisChStruct).Outcome      =Analysis.AllData.(thisChStruct).Outcome(thisFilter);
        Analysis.(thistype).(thisChStruct).OutcomeZ     =Analysis.AllData.(thisChStruct).OutcomeZ(thisFilter);
    % Average
        Analysis.(thistype).(thisChStruct).DFFAVG       =nanmean(Analysis.(thistype).(thisChStruct).DFF,1); 
        Analysis.(thistype).(thisChStruct).DFFSEM       =nanstd(Analysis.(thistype).(thisChStruct).DFF,0,1)/sqrt(Analysis.(thistype).nTrials);
        Analysis.(thistype).(thisChStruct).CueAVG       =nanmean(Analysis.(thistype).(thisChStruct).Cue,2);
        Analysis.(thistype).(thisChStruct).CueSEM       =nanstd(Analysis.(thistype).(thisChStruct).Cue,0,2)/sqrt(Analysis.(thistype).nTrials);
        Analysis.(thistype).(thisChStruct).CueMax       =max(Analysis.(thistype).(thisChStruct).DFFAVG(Analysis.(thistype).(thisChStruct).Time(1,:)>CueTime(1) & Analysis.(thistype).(thisChStruct).Time(1,:)<CueTime(2)));
        Analysis.(thistype).(thisChStruct).OutcomeAVG   =nanmean(Analysis.(thistype).(thisChStruct).Outcome,2);
        Analysis.(thistype).(thisChStruct).OutcomeSEM   =nanstd(Analysis.(thistype).(thisChStruct).Outcome,0,2)/sqrt(Analysis.(thistype).nTrials);
        Analysis.(thistype).(thisChStruct).OutcomeZAVG  =nanmean(Analysis.(thistype).(thisChStruct).OutcomeZ,2);
        Analysis.(thistype).(thisChStruct).OutcomeZSEM  =nanstd(Analysis.(thistype).(thisChStruct).OutcomeZ,0,2)/sqrt(Analysis.(thistype).nTrials);
        Analysis.(thistype).(thisChStruct).OutcomeMax   =max(Analysis.(thistype).(thisChStruct).DFFAVG(Analysis.(thistype).(thisChStruct).Time(1,:)>OutcomeTime(1) & Analysis.(thistype).(thisChStruct).Time(1,:)<OutcomeTime(2))); 
    end
%% Wheel
    if Analysis.Properties.Wheel==1
        Analysis.(thistype).Wheel.Time                  =Analysis.AllData.Wheel.Time(thisFilter,:);
        Analysis.(thistype).Wheel.Deg                   =Analysis.AllData.Wheel.Deg(thisFilter,:);
        Analysis.(thistype).Wheel.Distance              =Analysis.AllData.Wheel.Distance(thisFilter,:);
        Analysis.(thistype).Wheel.Baseline              =Analysis.AllData.Wheel.Baseline(thisFilter);
        Analysis.(thistype).Wheel.Cue                   =Analysis.AllData.Wheel.Cue(thisFilter);
        Analysis.(thistype).Wheel.Outcome               =Analysis.AllData.Wheel.Outcome(thisFilter);
        % Average
        Analysis.(thistype).Wheel.DistanceAVG            =nanmean(Analysis.(thistype).Wheel.Distance,1); 
        Analysis.(thistype).Wheel.DistanceSEM            =nanstd(Analysis.(thistype).Wheel.Distance,0,1)/sqrt(Analysis.(thistype).nTrials);
    end
%% Pupillometry
    if Analysis.Properties.Pupillometry
        Analysis.(thistype).Pupil.Time              =Analysis.AllData.Pupil.Time(thisFilter,:);
        Analysis.(thistype).Pupil.Blink             =Analysis.AllData.Pupil.Blink(thisFilter,:);
        Analysis.(thistype).Pupil.Pupil             =Analysis.AllData.Pupil.Pupil(thisFilter,:);
        Analysis.(thistype).Pupil.Baseline          =Analysis.AllData.Pupil.Baseline(thisFilter);
        Analysis.(thistype).Pupil.NormBaseline      =Analysis.AllData.Pupil.NormBaseline(thisFilter);
        Analysis.(thistype).Pupil.PupilDPP          =Analysis.AllData.Pupil.PupilDPP(thisFilter,:);
        Analysis.(thistype).Pupil.Cue               =Analysis.AllData.Pupil.Cue(thisFilter);
        Analysis.(thistype).Pupil.Outcome           =Analysis.AllData.Pupil.Outcome(thisFilter);
        % Average
        Analysis.(thistype).Pupil.PupilAVG          =nanmean(Analysis.(thistype).Pupil.PupilDPP,1); 
        Analysis.(thistype).Pupil.PupilSEM          =nanstd(Analysis.(thistype).Pupil.PupilDPP,0,1)/sqrt(Analysis.(thistype).nTrials);
    end
    end
end
end