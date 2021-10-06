%% parameters
limY_licks=[0 8];
limY_fluo1=[-2 10];
limY_fluo2=[-2 10];
limX_time=[-4 4];
colorPlot='gbr';
%% to show
thisGroup='RewardABC';
thisRewTypes={'CueA_Rew','CueB_Rew','CueC_Rew'};
thisCueTypes={'CueA','CueB','CueC'};
thisPhoto='Photo_470';
lickStat='CueAVG';
cueStat='CueAVG_AVG';
rewStat='OutcomeAVGZ_AVG';

%% figure
figure()
counter1=0;
for i=1:3
subplot(3,3,[1+counter1 2+counter1]); hold on;
thisTime=DB_Stat.Group.(thisGroup).(thisPhoto).(thisRewTypes{i}).Time{1,1};
thisFluo=cell2mat(DB_Stat.Group.(thisGroup).(thisPhoto).(thisRewTypes{i}).AVG');
thisFluoAVG=nanmean(thisFluo,1);
plot(thisTime,thisFluo,'-k');
plot(thisTime,thisFluoAVG,colorPlot(i));
xlim(limX_time);ylim(limY_fluo1);
counter1=counter1+3;
end

for i=1:3
thisLickStat(i,:)=cell2mat(DB_Stat.Group.(thisGroup).Licks.(thisCueTypes{i}).(lickStat));
thisCueStat(i,:)=cell2mat(DB_Stat.Group.(thisGroup).(thisPhoto).(thisCueTypes{i}).(cueStat));
thisRewStat(i,:)=cell2mat(DB_Stat.Group.(thisGroup).(thisPhoto).(thisRewTypes{i}).(rewStat));
end

subplot(3,3,3); hold on;
plot(thisLickStat,'o-k');
subplot(3,3,6)
plot(thisCueStat,'o-k');
subplot(3,3,9)
plot(thisRewStat,'o-k');
