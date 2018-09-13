function Analysis=AP_DataOrganize(Analysis,SessionData,Pup)
%AP_DataOrganize extracts, reallocates and generates different features
%from the bpod file 'SessionData' and 'Pup' dataset. 
%The new data are extracted using the function 'AP_DataExtract' and
%are stored in the structure 'Analysis.AllData' containing :
%1) The properties of the trial succesfully analyzed (number and types)
%2) The timing of the different States and the cue and the outcome to the 'StateToZero' time
%3) The lick events
%4) the photometry, running wheel and pupil substructure (if present).
%
%function designed by Quentin 2016 for Analysis_Photometry
if isfield(Analysis,'AllData')==0
        Analysis.AllData.nTrials=0;
        Analysis.AllData.IgnoredTrials=0;
end
BaselineTime=Analysis.Parameters.NidaqBaseline;
BaselinePt=Analysis.Parameters.NidaqBaselinePoints;

%% Compute Pupil Baseline and DPP according to the Baseline timing
if Analysis.Parameters.Pupillometry
    Pup.PupilSmoothBaseline=mean(Pup.PupilSmooth(Pup.Time>BaselineTime(1) & Pup.Time<BaselineTime(2),:));
    Pup.PupilSmoothBaselineNorm=Pup.PupilSmoothBaseline/nanmean(Pup.PupilSmoothBaseline);
    Pup.PupilSmoothDPP=100*(Pup.PupilSmooth-Pup.PupilSmoothBaseline)./Pup.PupilSmoothBaseline;
    nbOfFrames=Analysis.Parameters.NidaqDuration*Pup.Parameters.frameRate;
    if nbOfFrames>Pup.Parameters.nFrames
        nbOfFrames=Pup.Parameters.nFrames;
    end
end

%% Extract and organize data 
for thisTrial=1:SessionData.nTrials
try
    if Analysis.Filters.ignoredTrials(thisTrial)==1
    [thislick,thisPhoto,thisWheel]=AP_DataExtract(SessionData,Analysis,thisTrial);
    i=Analysis.AllData.nTrials+1;
    Analysis.AllData.nTrials=i;
    Analysis.AllData.TrialNumbers(i)=i;
    Analysis.AllData.TrialTypes(i)=SessionData.TrialTypes(thisTrial);
% Timimg
    Analysis.AllData.Time.TrialStartTS(i)   =SessionData.TrialStartTimestamp(thisTrial); 
    Analysis.AllData.Time.States{i}         =SessionData.RawEvents.Trial{1,thisTrial}.States;        
    Analysis.AllData.Time.Zero(i)           =SessionData.RawEvents.Trial{1,thisTrial}.States.(Analysis.Parameters.StateToZero)(1);
    Analysis.AllData.Time.Cue(i,:)          =SessionData.RawEvents.Trial{1,thisTrial}.States.(Analysis.Parameters.StateOfCue)...
                                                -Analysis.AllData.Time.Zero(i);
    Analysis.AllData.Time.Outcome(i,:)   =SessionData.RawEvents.Trial{1,thisTrial}.States.(Analysis.Parameters.StateOfOutcome)...
                                            -Analysis.AllData.Time.Zero(i);
    CueTime     =Analysis.AllData.Time.Cue(i,:)+Analysis.Parameters.CueTimeReset;
    OutcomeTime =Analysis.AllData.Time.Outcome(i,:)+Analysis.Parameters.OutcomeTimeReset;
% Licks                                    
    Analysis.AllData.Licks.Events{i}                =thislick;
    Analysis.AllData.Licks.Trials{i}                =linspace(i,i,size(thislick,2));
    Analysis.AllData.Licks.Bin{i}                   =(Analysis.Parameters.LickEdges(1):Analysis.Parameters.Bin:Analysis.Parameters.LickEdges(2));
    Analysis.AllData.Licks.Rate(i,:)                =histcounts(thislick,Analysis.AllData.Licks.Bin{i})/Analysis.Parameters.Bin;
    Analysis.AllData.Licks.Cue(i)                   =mean(Analysis.AllData.Licks.Rate(i,Analysis.AllData.Licks.Bin{i}>CueTime(1) & Analysis.AllData.Licks.Bin{i}<CueTime(2)));
    Analysis.AllData.Licks.Outcome(i)               =mean(Analysis.AllData.Licks.Rate(i,Analysis.AllData.Licks.Bin{i}>OutcomeTime(1) & Analysis.AllData.Licks.Bin{i}<OutcomeTime(2)));
% Photometry    
    for thisCh=1:length(Analysis.Parameters.PhotoCh)
        thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
        Analysis.AllData.(thisChStruct).Name        =Analysis.Parameters.PhotoChNames{thisCh};
        Analysis.AllData.(thisChStruct).Time(i,:)	=thisPhoto{thisCh}(1,:);
        Analysis.AllData.(thisChStruct).Raw(i,:)  	=thisPhoto{thisCh}(2,:);
        Analysis.AllData.(thisChStruct).DFF(i,:)  	=thisPhoto{thisCh}(3,:);
        Analysis.AllData.(thisChStruct).Baseline(i)	=mean(thisPhoto{thisCh}(2,BaselinePt(1):BaselinePt(2)));
        Analysis.AllData.(thisChStruct).Cue(i)     	=max(thisPhoto{thisCh}(3,thisPhoto{thisCh}(1,:)>CueTime(1) & thisPhoto{thisCh}(1,:)<CueTime(2)));
        Analysis.AllData.(thisChStruct).Outcome(i)	=max(thisPhoto{thisCh}(3,thisPhoto{thisCh}(1,:)>OutcomeTime(1) & thisPhoto{thisCh}(1,:)<OutcomeTime(2)));
        Analysis.AllData.(thisChStruct).OutcomeZ(i) =Analysis.AllData.(thisChStruct).Outcome(i)-mean(thisPhoto{thisCh}(3,thisPhoto{thisCh}(1,:)>-0.01 & thisPhoto{thisCh}(1,:)<0.01));
    end
% Wheel    
    if Analysis.Parameters.Wheel==1
        Analysis.AllData.Wheel.Time(i,:)          	=thisWheel(1,:);
        Analysis.AllData.Wheel.Deg(i,:)          	=thisWheel(2,:);
        Analysis.AllData.Wheel.Distance(i,:)       	=thisWheel(3,:);
        Analysis.AllData.Wheel.Baseline(i)        	=sumabs(diff(thisWheel(3,BaselinePt(1):BaselinePt(2))));
        Analysis.AllData.Wheel.Cue(i)             	=sumabs(diff(thisWheel(3,thisWheel(1,:)>CueTime(1) & thisWheel(1,:)<CueTime(2))))/(CueTime(2)-CueTime(1));
        Analysis.AllData.Wheel.Outcome(i)           =sumabs(diff(thisWheel(3,thisWheel(1,:)>OutcomeTime(1) & thisWheel(1,:)<OutcomeTime(2))))/(OutcomeTime(2)-OutcomeTime(1));
    end
% Pupillometry
    if Analysis.Parameters.Pupillometry
        thisPupTime=Pup.Time(1:nbOfFrames)'-Analysis.AllData.Time.Zero(i);
        thisPup=Pup.Pupil(1:nbOfFrames,thisTrial)';
        thisPupilDPP=Pup.PupilSmoothDPP(1:nbOfFrames,thisTrial)';
        if Analysis.Parameters.ZeroAtZero
            thisPupilDPP=thisPupilDPP-mean(thisPupilDPP(thisPupTime>-0.01 & thisPupTime<0.01));
        end
        % Organize in the structure
        Analysis.AllData.Pupil.Time(i,:)            =thisPupTime;
        Analysis.AllData.Pupil.Pupil(i,:)           =thisPup;
        Analysis.AllData.Pupil.PupilDPP(i,:)        =thisPupilDPP;
        Analysis.AllData.Pupil.Blink(i,:)           =Pup.Blink(1:nbOfFrames,thisTrial)';
        Analysis.AllData.Pupil.Baseline(i)          =Pup.PupilSmoothBaseline(thisTrial);
        Analysis.AllData.Pupil.NormBaseline(i)      =Pup.PupilSmoothBaselineNorm(thisTrial);
        Analysis.AllData.Pupil.Cue(i)               =nanmean(thisPupilDPP(thisPupTime>CueTime(1) & thisPupTime<CueTime(2)));
        Analysis.AllData.Pupil.Outcome(i)           =nanmean(thisPupilDPP(thisPupTime>OutcomeTime(1) & thisPupTime<OutcomeTime(2)));
    end
    else
        Analysis.AllData.IgnoredTrials=Analysis.AllData.IgnoredTrials+1;
    end
    
%% Behavior Specific
switch Analysis.Parameters.Behavior
    case 'Oddball'
    Analysis.AllData.Oddball_StateSeq{i}=SessionData.TrialSettings(thisTrial).StateSequence;
    Analysis.AllData.Oddball_SoundSeq{i}=SessionData.TrialSettings(thisTrial).SoundSequence;
    Analysis.Parameters.Oddball_SoundITI=SessionData.TrialSettings(1).GUI.ITI;
end  

%% Ignored Trials
catch
        Analysis.Filters.IgnoredTrials(thisTrial)=0;
        Analysis.AllData.IgnoredTrials=Analysis.AllData.IgnoredTrials+1;
end
end

%% Spike Analysis
if Analysis.Parameters.SpikesAnalysis
    Analysis=Analysis_Spikes(Analysis,'Organize');
end

%% Bleaching calculation
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{thisCh}));
    Analysis.AllData.(thisChStruct).Bleach=Analysis.AllData.(thisChStruct).Baseline/mean(Analysis.AllData.(thisChStruct).Baseline(1:2));
    Analysis.Parameters.NidaqSTD=std2(Analysis.AllData.(thisChStruct).DFF(:,BaselinePt(1):BaselinePt(2)));
end 
end