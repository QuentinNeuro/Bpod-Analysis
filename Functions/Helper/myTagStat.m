function [p,h,stats]=myTagStat(preData,postData,alphas)
% postData=epochRate{1, 1}{1, 1};
% preData=baseRate{1, 1};
%% pre and post should be firing rate matrices nTrials x time
%% Options
bootstrap_Reps=100;
Opt_noSpikesLatency='max'; %'max' 'zero' 'nan'
if nargin<3
    alphas=[0.05 0.05 0.05];
end

%% Parameters
nTrials=size(preData,1);
latencyTW=1:min([size(preData,2) size(postData,2)]);
latencyNoSpikes_zmn=[0 latencyTW(end) NaN];
switch Opt_noSpikesLatency
    case 'zero'
        latencyNoSpikes=0;
    case 'max'
        latencyNoSpikes=latencyTW(end);
    case 'NaN'
        latencyNoSpikes=NaN;
end


bootstrap_Idx=randi(size(preData,2)-latencyTW(end),bootstrap_Reps,1);
bootstrap_Idx(:,2)=bootstrap_Idx(:,1)+latencyTW(end)-1;
%% Latency, Reliability and Firing Rate
preLatency=[];
preLatency_zmn=[];
preFR=[];
for b=1:bootstrap_Reps
    bootstrap_Data=preData(:,bootstrap_Idx(b,1):bootstrap_Idx(b,2));
    preFR=[preFR ; mean(bootstrap_Data,2)];
    dataLatency=bootstrap_Data>0;
    dataLatency=dataLatency.*latencyTW;
    thisPreLatency=max(dataLatency,[],2);
    preReliability(b)=length(nonzeros(thisPreLatency))/nTrials;
    %thisPreLatency(thisPreLatency==0)=latencyNoSpikes;
    preLatency=[preLatency ; thisPreLatency];
end

preLatency_zmn=preLatency*ones(1,3);
preLatency_zmn(preLatency==0,1)=latencyNoSpikes_zmn(1);
preLatency_zmn(preLatency==0,2)=latencyNoSpikes_zmn(2);
preLatency_zmn(preLatency==0,3)=latencyNoSpikes_zmn(3);
preLatency(preLatency==0)=latencyNoSpikes;

dataLatency=postData(:,latencyTW);
dataLatency=dataLatency(:,latencyTW);
dataLatency=dataLatency>0;
dataLatency=dataLatency.*latencyTW;
postLatency=max(dataLatency,[],2);
postReliability=length(nonzeros(postLatency))/nTrials;
postFR=mean(postData,2);

postLatency_zmn=postLatency*ones(1,3);
postLatency_zmn(postLatency==0,1)=latencyNoSpikes_zmn(1);
postLatency_zmn(postLatency==0,2)=latencyNoSpikes_zmn(2);
postLatency_zmn(postLatency==0,3)=latencyNoSpikes_zmn(3);
postLatency(postLatency==0)=latencyNoSpikes;

%% Test
[h(1), p(1)]=kstest2(preLatency,postLatency,'alpha',alphas(1));
[h(2), p(2)]=kstest2(preFR,postFR,'alpha',alphas(2));
[h(3), p(3)]=kstest2(preReliability,postReliability,'alpha',alphas(3));

%% stats
h=double(h);
stats.Latency(1)=mean(preLatency,'omitnan');
stats.Latency(2)=mean(postLatency,'omitnan');
stats.FiringRate(1)=mean(preFR,'omitnan');
stats.FiringRate(2)=mean(postFR,'omitnan');
stats.Reliability(1)=mean(preReliability);
stats.Reliability(2)=postReliability;
stats.Latency_zmn(1,:)=mean(preLatency_zmn,1,'omitnan');
stats.Latency_zmn(2,:)=mean(postLatency_zmn,1,'omitnan');

end