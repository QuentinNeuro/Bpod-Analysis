function [p, data]=A_FilterTagging(preTag,postTag,dt,tw_dur,pT)

%% Options
whatToDoWithNoSpikes='max'; %'max'
testWitLat_nnz=1;
sameTWForPrePostFR=0;

if nargin<5
    pT=[0.05 0.05];
end
rT=0.3;

%% Parameters
nTrials=size(preTag,2);

%% Latency - Will look for the first spike - if no spikes, go to zero or max ?
if size(preTag,2) > size(postTag,2)
    twL_pts=size(postTag,2);
else
    twL_pts=size(preTag,2);
end

switch whatToDoWithNoSpikes
    case 'zero'
        noSpikeLat=0;
    case 'max'
        noSpikeLat=twL_pts*dt;
end

% Adjust spiketrain dimensions
thisPre=preTag(:,1:twL_pts);
thisPost=postTag(:,1:twL_pts);

% Extract first spike latencies
[~,preLat]=max(thisPre,[],2);
preLat(preLat==1)=noSpikeLat;
preLat(find(thisPre(:,1)))=1;
preLat_nnz=preLat(preLat~=noSpikeLat);

[~,postLat]=max(thisPost,[],2);
postLat(postLat==1)=noSpikeLat;
postLat(find(thisPost(:,1)))=1;
postLat_nnz=postLat(postLat~=noSpikeLat);

 if any([isempty(preLat_nnz) isempty(postLat_nnz)])
     testWitLat_nnz=0;
 end
% ranksum test
if testWitLat_nnz
        p.pLat=ranksum(preLat_nnz,postLat_nnz);
else
    p.pLat=ranksum(preLat,postLat);
end

%% Firing Rate - this should be time window specific for the test period
endDur=int16(tw_dur/dt);
if sameTWForPrePostFR
    thisPre=preTag(:,1:endDur);
    preFR=sum(thisPre,2)/tw_dur;
else
    preFR=sum(thisPre,2)/(twL_pts*dt);
end

if size(thisPost,2)>=endDur
thisPost=postTag(:,1:endDur);
else
    thisPost=postTag;
end
postFR=sum(thisPost,2)/tw_dur;

% sign test - variable are dependent ?
p.pFR=signrank(preFR,postFR);

%% Reliability - this should be time window specific for both periods / may be I can make replicates ?
if ~sameTWForPrePostFR
    thisPre=preTag(:,1:endDur);
end
[~,preRel]=max(thisPre,[],2);
preRel(preRel==1)=0;
preRel(find(thisPre(:,1)))=1;

[~,postRel]=max(thisPost,[],2);
postRel(postRel==1)=0;
postRel(find(thisPost(:,1)))=1;

%% Average
data.preLat_avg=mean(preLat_nnz)*dt;
data.postLat_avg=mean(postLat_nnz)*dt;
data.preFR_avg=mean(preFR);
data.postFR_avg=mean(postFR);
data.preRel_pct=nnz(preRel)/nTrials;
data.postRel_pct=nnz(postRel)/nTrials;

%% Decision
p.h=(p.pLat<pT(1))*(p.pFR<pT(2));
end