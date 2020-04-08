% Parameters
RewTimeWindow=[-0.5 2];
Baseline=1:20;
TimeVector=0:1/20:200;
% Initialization
ACh_Coherence=struct();
ACh_Coherence.Param.Fiber1='ACx';
ACh_Coherence.Param.Fiber2='mPFC';
ACh_Coherence.Param.SamplingRate='20';
ACh_Coherence.Param.RewTimeWindow=RewTimeWindow;
ACh_Coherence.Param.TimeVector=TimeVector;
ACh_Coherence.Param.Baseline=[Baseline(1) Baseline(end)];
% Loading
[FileList,PathName]=uigetfile('*.mat','Select the Analysis BPod file(s)','MultiSelect', 'on');
cd(PathName)

counterRewFluo=1;
for i=1:length(FileList)
    FileName=FileList{1,i};
    load(FileName);
    thisShortName=strrep(FileName(1:13),'-','_');
    thisRaw=Analysis.AllData.Raw;

for j=1:Analysis.AllData.nTrials
    thisTrial=sprintf('Trial%.0d',j)
    ACh_Coherence.(thisShortName).(thisTrial)=thisRaw{1,j};
    thisPhoto1=Analysis.AllData.Raw{1,j}.Photometry{1,1};
    thisPhoto2=Analysis.AllData.Raw{1,j}.Photometry{1,2};
    %zscore
    thisPhoto1=(thisPhoto1-mean(thisPhoto1(Baseline)))/std(thisPhoto1(Baseline));
    thisPhoto2=(thisPhoto2-mean(thisPhoto2(Baseline)))/std(thisPhoto2(Baseline));
    ACh_Coherence.(thisShortName).(thisTrial).Photometry_Zs{1,1}=thisPhoto1;
    ACh_Coherence.(thisShortName).(thisTrial).Photometry_Zs{1,2}=thisPhoto2;
    %rewardTime
    thisRewardTimes(1)=Analysis.AllData.Time.States{1,j}.Outcome(1);
    thisRewardTimes(2)=Analysis.AllData.Time.States{1,j}.Outcome2(1);
    thisRewardTimes(3)=Analysis.AllData.Time.States{1,j}.Outcome3(1);
    ACh_Coherence.(thisShortName).(thisTrial).RewardTimes=thisRewardTimes;
    %AVG reward response
    for k=1:3
        thisReward1=thisPhoto1(TimeVector > thisRewardTimes(k)+RewTimeWindow(1) & TimeVector < thisRewardTimes(k)+RewTimeWindow(2));
        thisReward2=thisPhoto2(TimeVector > thisRewardTimes(k)+RewTimeWindow(1) & TimeVector < thisRewardTimes(k)+RewTimeWindow(2));
        thisRewardFluo1(counterRewFluo,:)=thisReward1-thisReward1(1);
        thisRewardFluo2(counterRewFluo,:)=thisReward2-thisReward2(1);
        counterRewFluo=counterRewFluo+1;
    end
end

ACh_Coherence.(thisShortName).RewardFluoFiber1=thisRewardFluo1;
ACh_Coherence.(thisShortName).AVGRewardFluoFiber1=nanmean(thisRewardFluo1,1);
ACh_Coherence.(thisShortName).RewardFluoFiber2=thisRewardFluo2;
ACh_Coherence.(thisShortName).AVGRewardFluoFiber2=nanmean(thisRewardFluo2,1);
end

% %% BLA NAc
% [FileList,PathName]=uigetfile('*.mat','Select the BLA_NAc file','MultiSelect', 'on');
% load(FileList);
% % Catch Trials
% ACh_Coherence.BLA_VS.Param.Name=FileList;
% ACh_Coherence.Param.Fiber1='BLA';
% ACh_Coherence.Param.Fiber2='VS';
% ACh_Coherence.Param.SamplingRate='20';
% 
% CatchTrialNb=5;
% CatchTrialBinary=Analysis.AllData.TrialTypes==CatchTrialNb;
% CatchTrialIndex=find(CatchTrialBinary);
% for i=1:length(CatchTrialIndex)
%     thisTrial=sprintf('Trial%.0d',i);
%     ACh_Coherence.BLA_VS.CatchTrials.(thisTrial)=Analysis.AllData.Raw{1,CatchTrialIndex(i)};
% end
% % Uncued reward Trials
% RewardTrialNb=5;
% RewardTrialBinary=Analysis.AllData.TrialTypes==RewardTrialNb;
% RewardTrialIndex=find(RewardTrialBinary);
% for i=1:length(RewardTrialIndex)
%     thisTrial=sprintf('Trial%.0d',i);
% ACh_Coherence.BLA_VS.RewardTrials.(thisTrial)=Analysis.AllData.Raw{1,RewardTrialIndex(i)};
% ACh_Coherence.BLA_VS.RewardTrials.(thisTrial).RewardTime=Analysis.AllData.Time.States{1,RewardTrialIndex(i)}.Outcome(1);
% 
% thisPhoto1=Analysis.AllData.Raw{1,RewardTrialIndex(i)}.Photometry{1,1};
% thisPhoto2=Analysis.AllData.Raw{1,RewardTrialIndex(i)}.Photometry{1,2};
% %zscore
% thisPhoto1=(thisPhoto1-mean(thisPhoto1(Baseline)))/std(thisPhoto1(Baseline));
% thisPhoto2=(thisPhoto2-mean(thisPhoto2(Baseline)))/std(thisPhoto2(Baseline));
% % Reward Fluo
% thisRewardTime=ACh_Coherence.BLA_VS.RewardTrials.(thisTrial).RewardTime
% thisReward1=thisPhoto1(TimeVector > thisRewardTime+RewTimeWindow(1) & TimeVector < thisRewardTime+RewTimeWindow(2));
% thisReward2=thisPhoto2(TimeVector > thisRewardTime+RewTimeWindow(1) & TimeVector < thisRewardTime+RewTimeWindow(2));
% thisRewardFluo1(i,:)=thisReward1-thisReward1(1);
% thisRewardFluo2(i,:)=thisReward2-thisReward2(1);
% 
% end

thisName='VIP';


figure()
subplot(2,3,[1 2])
thisPhoto1=ACh_Coherence.ACh43_03.Trial3.Photometry_Zs{1,1};
thisPhoto2=ACh_Coherence.ACh43_03.Trial3.Photometry_Zs{1,2};
thisLicks=ACh_Coherence.ACh43_03.Trial3.Lick;
thismax1=max(thisPhoto1)+1;
thisLicksY=ones(length(thisLicks),1)*thismax1;
thisRewardTimes=ACh_Coherence.ACh43_03.Trial3.RewardTimes;
thismin1=min(thisPhoto1)-1;
thisRewardTimesY=ones(length(thisRewardTimes),1)*thismin1;
thisTime=TimeVector(1:length(thisPhoto1));
hold on
plot(thisTime(1:2000),thisPhoto1(1:2000),'-k')
plot(thisTime(1:2000),thisPhoto2(1:2000),'-r')
plot(thisLicks,thisLicksY,'vb')
plot(thisRewardTimes,thisRewardTimesY,'^b')
ylim([-10 5]);

subplot(2,3,3)
hold on
thisPhoto1=ACh_Coherence.ACh43_03.RewardFluoFiber1;
thisPhoto1AVG=ACh_Coherence.ACh43_03.AVGRewardFluoFiber1;
thisPhoto2=ACh_Coherence.ACh43_03.RewardFluoFiber2;
thisPhoto2AVG=ACh_Coherence.ACh43_03.AVGRewardFluoFiber2;
thisTime=RewTimeWindow(1):1/20:RewTimeWindow(2)-1/20;
plot(thisTime,thisPhoto1,'-k')
plot(thisTime,thisPhoto1AVG,'-b','LineWidth',2)
plot(thisTime,thisPhoto2,'-r')
plot(thisTime,thisPhoto2AVG,'-g','LineWidth',2)
