function Analysis=AB_DataProcess_Pupil(Analysis)

%% Parameters
nTrials=Analysis.AllData.nTrials;
nSessions=Analysis.Parameters.Behavior.nSessions;
timeToZero=Analysis.AllData.Time.Zero;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
startState=Analysis.Parameters.Pupillometry.StartState;
% Filter update
PupilFilter=Analysis.Filters.RecPupillometry(Analysis.Filters.ignoredTrials);
% Sampling Rate
sampRate=Analysis.Parameters.Pupillometry.SamplingRate;
baselineTW=Analysis.Parameters.Data.BaselineTW;
baselinePts=baselineTW*sampRate;

%% Data Processing
% Find timing of trigger
for t=1:Analysis.Core.nTrials
     OffsetPupil(t)=Analysis.Core.States{1,t}.(startState)(1);
end
    OffsetPupil=OffsetPupil(Analysis.Filters.ignoredTrials);
% create PSTHs
dataPupilSmooth=Analysis.Core.PupilSmooth(Analysis.Filters.ignoredTrials,:);
dataPupilBlink=Analysis.Core.PupilBlink(Analysis.Filters.ignoredTrials,:);
for t=1:nTrials
    if PupilFilter(t)
        OffsetPupil(t)=Analysis.Core.States{1,t}.(startState)(1);
        timeToZero_Offset=timeToZero(t)-OffsetPupil(t);
        
        [timeTW,PupTW]  =AP_PSTH(dataPupilSmooth(t,:),PSTH_TW,timeToZero_Offset,sampRate);
        [~,BlinkTW]=AP_PSTH(dataPupilBlink(t,:),PSTH_TW,timeToZero_Offset,sampRate);
        
        dataPupil(t,:)=PupTW;
        dataBlink(t,:)=BlinkTW;
        timePupil(t,:)=timeTW;
    end
end
% Baseline
baselineAVG=mean(dataPupilSmooth(:,baselinePts(1):baselinePts(2)),2,'omitnan');
baselineAVG_N=baselineAVG;
for s=1:nSessions
    baselineAVG_N(Analysis.AllData.Session==s)=baselineAVG(Analysis.AllData.Session==s)/mean(baselineAVG(Analysis.AllData.Session==s),'omitnan');
end
% Normalize
dataPupil_Norm=(dataPupil-baselineAVG)./baselineAVG;

%% Save in structure
Analysis.AllData.Pupil.Time          = timePupil;          
Analysis.AllData.Pupil.Data          = dataPupil_Norm;
Analysis.AllData.Pupil.BaselineAVG   = baselineAVG;
Analysis.AllData.Pupil.BaselineAVG_N = baselineAVG_N;
Analysis.AllData.Pupil.DataRaw       = dataPupil;
Analysis.AllData.Pupil.DataBlink     = dataBlink;
% Extra
Analysis.Filters.Pupillometry        = PupilFilter;
Analysis.AllData.Time.PupilOffset    = OffsetPupil;
% Epochs
Analysis.AllData.Pupil=AB_DataProcess_Epochs(Analysis.AllData.Pupil,Analysis);
end