%% Load csv file from Salea
digital=readtable('digital.csv');
%% Salea reader
% convert from binary
stateBin=zeros(size(digital.Time_s_));
chNbs=0:6;
for c=chNbs
    thisCh=sprintf('Channel%.0f',c);
    stateBin=stateBin+digital.(thisCh).*2^c;
end
% trial start
trialStart=strfind(stateBin',[0 1]);
% outcome state
stateToZero=5;
zeroTS=digital.Time_s_(strfind(stateBin',[stateToZero-1 stateToZero]));
nTrials=length(zeroTS);
if length(trialStart)~=nTrials
    trialStart=trialStart(1:end-1);
end
trialStartTS=digital.Time_s_(trialStart);

% frame time stamp
frameTS=digital.Time_s_(strfind(digital.Channel7',[0 1]));
frameIdx=1:length(frameTS);
% frame trial start
frameStartIdx=[];
nTrials=length(zeroTS);
for t=1:nTrials
    thisTS=frameIdx(frameTS>=trialStartTS(t));
    frameStartIdx(t)=thisTS(1);
end

save('trialStartFrame.mat',"frameStartIdx");
save('trialStartTS.mat',"trialStartTS");
save('trialZeroTS.mat',"zeroTS");

% %% cell/trial parser
% load('rec_extract.mat')
% % per trial
% for t=1:nbOfTrial-1
%     data.trial{t}=traces(frameStartIdx(t):frameStartIdx(t+1),:);
% end
% data.trial{t+1}=traces(frameStartIdx(t+1):end,:);
% 
% nbOfCells=size(traces,2);
