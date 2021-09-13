function Analysis=AP_DataProcess_AOD(Analysis)

%% Action 
smoothing=Analysis.Parameters.AOD_smooth; 
timeWindow=Analysis.Parameters.ReshapedTime; 
baselinePts=Analysis.Parameters.NidaqBaselinePoints; 

%% Parameters 
stateStart='AO_WarmUp'; 
stateOutcome=Analysis.Parameters.StateOfOutcome;
% Bpod or Analysis 
nTrials=Analysis.Core.nTrials; 
% AOD Data 
nData=size(D,2); 
nCells=nData/nTrials; 
nSamples=length(D(1).y); 
sampRate=1/(1000*(D(1).x(2)-D(1).x(1))); 
 
%% Timing from Analysis structure or TTL 
timeZeroIndex=linspace(1,nCells,nData);
counter=0;
for thisT=1:nTrials 
    Analysis.Core.AOD.timeStart(thisT)=Analysis.Core.States{1,thisT}.(stateStart)(1); 
    Analysis.Core.AOD.timeOutcome(thisT)=Analysis.Core.States{1,thisT}.(stateOutcome)(1); 
    timeZero(1+counter:nCells+counter)=Analysis.Core.AOD.timeOutcome(thisT)-Analysis.Core.AOD.timeStart(thisT);
    counter=counter+nCells;
end 

try
    load(['TTL_outcome_' Analysis.Parameters.Files{1}]);
    counter=0;
    for thisT=1:nTrials
        timeZero(1+counter:nCells+counter)=TTL_Outcome(thisT,1);
        counter=counter+nCells;
    end
catch
    disp('TTL file absent, using bpod state timing instead');
end
 
 
%% AOD Data   -
% initialize 
time=NaN(nSamples,nData); 
data=time; 
timeW=NaN(diff(timeWindow)*ceil(sampRate)+2,nData); 
dataW=timeW; 
 
% populate 
for thisCT=1:nData 
   thisTime=D(thisCT).x/1000-timeZero(thisCT); 
   thisData=D(thisCT).y; 
   if offset
       thisData-offset;
   end
   if smoothing 
       thisData=smooth(thisData); 
   end 
    
   if newDFF
   baseAVG=nanmean(thisData(baselinePts(1):baselinePts(2))); 
   baseSTD=nanstd(thisData(baselinePts(1):baselinePts(2))); 
   if Analysis.Parameters.Zscore
    thisData=(thisData-baseAVG)/baseSTD;
   else
       thisData=100*(thisData-baseAVG)/baseAVG;
   end
   end
   data(:,thisCT)=thisData; 
   time(:,thisCT)=thisTime; 
  
% extract timewindow 
   thisTimeW_IO=zeros(size(thisTime)); 
   thisTimeW_IO(thisTime>=timeWindow(1) & thisTime<=timeWindow(2))=1; 
   thisTimeW_IO=logical(thisTimeW_IO); 
   timeW(1:sum(thisTimeW_IO),thisCT)=thisTime(thisTimeW_IO); 
   dataW(1:sum(thisTimeW_IO),thisCT)=thisData(thisTimeW_IO); 
end 
     
 
%% Organize data 
Analysis.Core.AOD.time=timeW(:,1); 
% Organize data per cell 
for thisC=1:nCells 
    Analysis.Core.AOD.perCell.data{thisC}=dataW(:,thisC:nCells:nData); 
end 
% Organize data per trials 
countT=1; 
for thisT=1:nCells:nData 
    Analysis.Core.AOD.perTrial.data{countT}=dataW(:,thisT:thisT+nCells-1); 
    Analysis.Core.AOD.perTrial.dataAVG(:,countT)=nanmean(Analysis.Core.AOD.perTrialAnalysis.Core.AOD.data{1,countT},2); 
    countT=countT+1; 
end 
 
end 


end