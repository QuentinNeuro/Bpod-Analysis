i=[8 6];
DB_CuedOutcome.RewPE.Animals{i(1)}
figure();
%RewPE
subplot(1,2,1)
hold on
plot(DB_CuedOutcome.Visual.NoAnticipLick_CueB_Punish.Photo.Time(i(1),:)',...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFFAVG(i(1),:)';
plot(DB_CuedOutcome.Values.Uncued_Punish.Photo.Time(i(1),:)',...
     DB_CuedOutcome.Values.Uncued_Punish.Photo.DFFAVG(i(1),:)';
xlim([-4 4]);
%RewPE
subplot(1,3,2)
hold on
plot(DB_CuedOutcome.Values_Rev.NoAnticipLick_CueA_Punish.Photo.Time(i(2),:)',...
     DB_CuedOutcome.Values_Rev.NoAnticipLick_CueA_Punish.Photo.DFFAVG(i(2),:)'-...
     DB_CuedOutcome.Values_Rev.NoAnticipLick_CueA_Punish.Photo.DFF0Cue(i(2)));
plot(DB_CuedOutcome.Values_Rev.Uncued_Punish.Photo.Time(i(2),:)',...
     DB_CuedOutcome.Values_Rev.Uncued_Punish.Photo.DFFAVG(i(2),:)'-...
     DB_CuedOutcome.Values_Rev.Uncued_Punish.Photo.DFF0Cue(i(2)));
xlim([-4 4]);
 %RewPE_Rev
% subplot(1,3,3)
% hold on
% plot(DB_CuedOutcome.RewPE_Rev.AnticipLick_CueB_Reward.Photo.Time(i(3),:)',...
%      DB_CuedOutcome.RewPE_Rev.AnticipLick_CueB_Reward.Photo.DFFAVG(i(3),:)'-...
%      DB_CuedOutcome.RewPE_Rev.AnticipLick_CueB_Reward.Photo.DFF0Cue(i(3)));
% plot(DB_CuedOutcome.RewPE_Rev.Uncued_Reward.Photo.Time(i(3),:)',...
%      DB_CuedOutcome.RewPE_Rev.Uncued_Reward.Photo.DFFAVG(i(3),:)'-...
%      DB_CuedOutcome.RewPE_Rev.Uncued_Reward.Photo.DFF0Cue(i(3)));
% plot(DB_CuedOutcome.RewPE.NoAnticipLick_CueA.Photo.Time(i(3),:)',...
%      DB_CuedOutcome.RewPE.NoAnticipLick_CueA.Photo.DFFAVG(i(3),:)'-...
%      DB_CuedOutcome.RewPE.NoAnticipLick_CueA.Photo.DFF0Cue(i(3))); 
% xlim([-3 3]);
%  
 %% (7)-8-(10)-11
 % 31 7 5
 % 32 8 6
 % 37 10 8
 % 38 11 9