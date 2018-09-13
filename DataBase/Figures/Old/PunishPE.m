%%
figure()
subplot(1,2,1)
plot(DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.Time',...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFFAVG'-...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFF0Outcome,'-k');
 xlim([-0.1 2]);
 ylim([-5 12]);
subplot(1,2,2)
plot(DB_CuedOutcome.Values.Uncued_Punish.Photo.Time',...
     DB_CuedOutcome.Values.Uncued_Punish.Photo.DFFAVG'-...
     DB_CuedOutcome.Values.Uncued_Punish.Photo.DFF0Outcome,'-k');
 xlim([-0.1 2]);
  ylim([-5 12]);

 
%%

PunPE(1,:)=DB_CuedOutcome.Values.Uncued_Punish.Photo.DFFOutcome-DB_CuedOutcome.Values.Uncued_Punish.Photo.DFF0Outcome;
PunPE(2,:)=DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFFOutcome-DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFF0Outcome;

PunPE_Rev(1,:)=DB_CuedOutcome.Values_Rev.Uncued_Punish.Photo.DFFOutcome-DB_CuedOutcome.Values_Rev.Uncued_Punish.Photo.DFF0Outcome;
PunPE_Rev(2,:)=DB_CuedOutcome.Values_Rev.NoAnticipLick_CueA_Punish.Photo.DFFOutcome-DB_CuedOutcome.Values_Rev.NoAnticipLick_CueA_Punish.Photo.DFF0Outcome;

figure()
subplot(2,1,1)
plot(PunPE,'-o')
xlim([0 4])
ylim([-2 20])
subplot(2,1,2)
plot(PunPE_Rev,'-o')
xlim([0 4])
ylim([-2 20])
 % plot(DB_CuedOutcome.RewPE.AnticipLick_CueA_Reward.Photo.Time',...
%      DB_CuedOutcome.RewPE.AnticipLick_CueA_Reward.Photo.DFFAVG'-...
%      DB_CuedOutcome.RewPE.AnticipLick_CueA_Reward.Photo.DFF0Outcome,'-k');