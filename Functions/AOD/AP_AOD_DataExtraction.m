S=AP_AOD_DataExtraction2(Analysis,D);
function S=AP_AOD_DataExtraction2(Analysis,D)
%% Action
dff=1;
zsc=1;

smoothing=1;
timeWindow=[-4 4];
baselinePts=[50 100];

%% Parameters
stateStart='AO_WarmUp';
stateOutcome='Outcome';
% Bpod or Analysis
nTrials=Analysis.Core.nTrials;
% AOD Data
nData=size(D,2);
nCells=nData/nTrials;
nSamples=length(D(1).y);
sampRate=1/(1000*(D(1).x(2)-D(1).x(1)));

%% Timing from Analysis structure or TTL
timeZeroIndex=linspace(1,nCells,nData);
for thisT=1:nTrials
    S.timeStart(thisT)=Analysis.Core.States{1,thisT}.(stateStart)(1);
    S.timeOutcome(thisT)=Analysis.Core.States{1,thisT}.(stateOutcome)(1);
    timeZero(thisT)=S.timeOutcome(thisT)-S.timeStart(thisT);
end

% if exist('TTL_Outcome')
%     timeZero=TTL_Outcome(:,1)';
% end


%% AOD Data
% initialize
time=NaN(nSamples,nData);
data=time;
timeW=NaN(diff(timeWindow)*ceil(sampRate)+2,nData);
dataW=timeW;

% populate
for thisCT=1:nData
   thisTime=D(thisCT).x/1000-timeZero(thisT);
   thisData=D(thisCT).y;

   if smoothing
       thisData=smooth(thisData);
   end
   
%    baseAVG=mean(thisData(baselinePts(1):baselinePts(2)));
%    baseSTD=std(thisData(baselinePts(1):baselinePts(2)));
%    thisData=(thisData-baseAVG)/baseSTD;
   
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
S.time=timeW(:,1);
% Organize data per cell
for thisC=1:nCells
    S.perCell.data{thisC}=dataW(:,thisC:nCells:nData);
end
% Organize data per trials
countT=1;
for thisT=1:nCells:nData
    S.perTrials.data{countT}=dataW(:,thisT:thisT+nCells-1);
    S.perTrials.dataAVG(:,countT)=nanmean(S.perTrials.data{1,countT},2);
    countT=countT+1;
end

end


%% reshaping structure to cell to matrix : 
%% reshape data
% dataRawC=struct2cell(D);
% dataRawC=shiftdim(dataRawC,2);
% dataRawM=cell2mat(dataRawC);
% time=reshape(dataRawM(:,1),[nSamples,nData])/1000;
% data=reshape(dataRawM(:,2),[nSamples,nData]);
% if smoothing
%     dataRawC=cellfun(@smooth,dataRawC,'UniformOutput',false);
%     dataRawM=cell2mat(dataRawC);
%     data=reshape(dataRawM(:,2),[nSamples,nData]);
% end

%% Zero and time window
% time matrix
% timeZero_nData=timeZero'*ones(1,nCells);
% timeZero_nData=reshape(timeZero_nData',[1,nData]);
% timeZ=time-timeZero_nData;
% timeIO=zeros(size(timeZ));
% timeIO(timeZ>=timeWindow(1) & timeZ<=timeWindow(2))=1;
% timeIO=logical(timeIO);
% 
% dataW=NaN(sum(timeIO(:,1))+2,nData);
% for thisCT=1:nData
%     dataW(1:sum(timeIO(:,thisCT)),thisCT)=data(timeIO(:,thisCT),thisCT);
% end