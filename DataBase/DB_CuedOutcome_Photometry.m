%% Directory and Parameters
nameofdb='DB_CuedOutcome.mat';
% subDB={'RewPE_Learning','RewPE','RewPE_Rev','Reward_size',...
%        'Values','Values_Rev',...
%        'Visual_RewPE','Visual_RewPE_Rev',...
%        'Uncertainty'};
% subDB={'mPFC_RewPE','mPFC_Values','mPFC_Values_Rev'};
subDB={'PV_RewPE'}
whereisdb='C:\Users\quent\Desktop\Data\Photometry\CuedOutcome';
wherearethedata='C:\Users\quent\Desktop\Data\Photometry\CuedOutcome';
defch='Photo_470';

overwritedb=0;

%% Script
cd(whereisdb)
if isfile(nameofdb) && overwritedb==0
    load(nameofdb);
else
    DB_CuedOutcome=struct();
end
for j=1:size(subDB,2)
    thissubDB=subDB{j};
    cd([wherearethedata filesep thissubDB]);
files=dir('*.mat');
for i=1:size(files,1)
%     try
        load(files(i).name)
        DB_CuedOutcome=DB_CO_Photo_Add(DB_CuedOutcome,Analysis,thissubDB,defch);
        clear Analysis
%     end
end
end
cd(whereisdb);
save([whereisdb filesep nameofdb],'DB_CuedOutcome')

function thisDB=DB_CO_Photo_Add(thisDB,Analysis,subDB,thisch)
%% some parameters
if isnan(subDB)    
    subDB=Analysis.Parameters.Phase;
end
if isnan(thisch)
    thisch='Photo_470';
end
if isfield(thisDB,subDB)
    index=size(thisDB.(subDB).Animals,2)+1;
else
    index=1;
end
%% extract
    thisDB.(subDB).Animals{index}        =Analysis.Parameters.Animal;
    thisDB.(subDB).Sessions{index}       =Analysis.Parameters.Files;
    
GroupToDB=AP_Filter_GroupToPlot(Analysis);
for i=1:size(GroupToDB,1)
    for j=1:size(GroupToDB{i,2},1)
    thistype=GroupToDB{i,2}{j,1};
    if Analysis.(thistype).nTrials>0
%some nb
        CueTime=Analysis.(thistype).Time.Cue(1,:);
        OutcomeTime=Analysis.(thistype).Time.Outcome(1,:);
        DFFTime=Analysis.(thistype).(thisch).Time(1,:);
        DFFAVG=Analysis.(thistype).(thisch).DFFAVG;
        DFFCue=max(DFFAVG(DFFTime>=CueTime(1) & DFFTime<=CueTime(2)));
        DFFDelay=max(DFFAVG(DFFTime>=CueTime(2) & DFFTime<=OutcomeTime(1)));
        DFFOutcome=max(DFFAVG(DFFTime>OutcomeTime(1) & DFFTime<OutcomeTime(2)+2));
        DFF0Cue=mean(DFFAVG(DFFTime>CueTime(1)-0.1 & DFFTime<=CueTime(1)));
        DFF0Outcome=mean(DFFAVG(DFFTime>OutcomeTime(1)-0.1 & DFFTime<=OutcomeTime(1)));   
 %save in the struct      
    thisDB.(subDB).(thistype).Time.Cue(index,:)         =CueTime;
    thisDB.(subDB).(thistype).Time.Outcome(index,:)     =OutcomeTime;
    thisDB.(subDB).(thistype).Licks.Time(index,:)       =Analysis.(thistype).Licks.Bin;
    thisDB.(subDB).(thistype).Licks.AVG(index,:)        =Analysis.(thistype).Licks.AVG;
    thisDB.(subDB).(thistype).Licks.SEM(index,:)        =Analysis.(thistype).Licks.SEM;
    thisDB.(subDB).(thistype).Photo.Time(index,:)       =DFFTime;
    thisDB.(subDB).(thistype).Photo.DFFAVG(index,:)     =DFFAVG;
    thisDB.(subDB).(thistype).Photo.DFFSEM(index,:)     =Analysis.(thistype).(thisch).DFFSEM;  
    thisDB.(subDB).(thistype).Photo.DFFCue(index)       =DFFCue;
    thisDB.(subDB).(thistype).Photo.DFFDelay(index)     =DFFDelay;
    thisDB.(subDB).(thistype).Photo.DFFOutcome(index)   =DFFOutcome;
    thisDB.(subDB).(thistype).Photo.DFF0Cue(index)      =DFF0Cue;
    thisDB.(subDB).(thistype).Photo.DFF0Outcome(index)  =DFF0Outcome;
    end
    end
end
end