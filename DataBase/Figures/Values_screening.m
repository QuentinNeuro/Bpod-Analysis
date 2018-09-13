i=4;
DB_CuedOutcome.Values.Animals{i(1)}
clear Cue Rew Pun
figure('Name','Values');
%% Total
subplot(3,7,[1 2]) % Uncued
plot(DB_CuedOutcome.Values.Uncued_Reward.Photo.Time(i(1),:)',...
     DB_CuedOutcome.Values.Uncued_Reward.Photo.DFFAVG(i(1),:)'-...
     DB_CuedOutcome.Values.Uncued_Reward.Photo.DFF0Outcome(i(1)),'-g');
xlim([-4 4]); ylim([-5 15]);
title('Uncued')
ylabel('Cue')

subplot(3,7,[3 4]) % High Value
plot(DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.Time(i(1),:)',...
     DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.DFFAVG(i(1),:)'-...
     DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.DFF0Cue(i(1)),'-k');
xlim([-4 4]); ylim([-5 15]);
title('CueA - High Value')

subplot(3,7,[5 6]) % Low Value
plot(DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.Time(i(1),:)',...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.DFFAVG(i(1),:)'-...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.DFF0Cue(i(1)),'-b');
xlim([-4 4]); ylim([-5 15]);
title('Cue B - Low Value')

% Cue
% Cue(1,:)=DB_CuedOutcome.Values.NoCue.Photo.DFFCue-...
%             DB_CuedOutcome.Values.NoCue.Photo.DFF0Cue(i(1));
% Cue(2,:)=DB_CuedOutcome.Values.AnticipLick_CueA.Photo.DFFCue-...
%             DB_CuedOutcome.Values.AnticipLick_CueA.Photo.DFF0Cue(i(1));
% Cue(3,:)=DB_CuedOutcome.Values.NoAnticipLick_CueB.Photo.DFFCue-...
%             DB_CuedOutcome.Values.NoAnticipLick_CueB.Photo.DFF0Cue(i(1));
% subplot(3,7,7)
% plot(Cue,'-o')
% xlim([0 4])
% ylim([-2 15])

%% Reward Only
subplot(3,7,[8 9]) % Uncued
plot(DB_CuedOutcome.Values.Uncued_Reward.Photo.Time(i(1),:)',...
     DB_CuedOutcome.Values.Uncued_Reward.Photo.DFFAVG(i(1),:)'-...
     DB_CuedOutcome.Values.Uncued_Reward.Photo.DFF0Outcome(i(1)),'-g');
xlim([-0.1 2]); ylim([-5 10]);
ylabel('Reward')

subplot(3,7,[10 11]) % High Value
plot(DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.Time(i(1),:)',...
     DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.DFFAVG(i(1),:)'-...
     DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.DFF0Outcome(i(1)),'-k');
xlim([-0.1 2]); ylim([-5 10])

subplot(3,7,[12 13]) % Low Value
plot(DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.Time(i(1),:)',...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.DFFAVG(i(1),:)'-...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.DFF0Outcome(i(1)),'b');
xlim([-0.1 2]); ylim([-5 10]);
% Reward
% Rew(1,:)=DB_CuedOutcome.Values.Uncued_Reward.Photo.DFFOutcome-...
%             DB_CuedOutcome.Values.Uncued_Reward.Photo.DFF0Outcome(i(1));
% Rew(2,:)=DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.DFFOutcome-...
%             DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.DFF0Outcome(i(1));
% Rew(3,:)=DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.DFFOutcome-...
%             DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.DFF0Outcome(i(1));
% subplot(3,7,14)
% plot(Rew,'-o')
% xlim([0 4])
% ylim([-2 10])


%% Punish Only
subplot(3,7,[15 16]) % Uncued
plot(DB_CuedOutcome.Values.Uncued_Punish.Photo.Time(i(1),:)',...
     DB_CuedOutcome.Values.Uncued_Punish.Photo.DFFAVG(i(1),:)'-...
     DB_CuedOutcome.Values.Uncued_Punish.Photo.DFF0Outcome(i(1)),'-r');
xlim([-0.1 2]); ylim([-5 20]);
ylabel('Punish')

subplot(3,7,[17 18]) % High Value
plot(DB_CuedOutcome.Values.AnticipLick_CueA_Punish.Photo.Time(i(1),:)',...
     DB_CuedOutcome.Values.AnticipLick_CueA_Punish.Photo.DFFAVG(i(1),:)'-...
     DB_CuedOutcome.Values.AnticipLick_CueA_Punish.Photo.DFF0Outcome(i(1)),'-k');
xlim([-0.1 2]); ylim([-5 20])

subplot(3,7,[19 20]) % Lowh Value
plot(DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.Time(i(1),:)',...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFFAVG(i(1),:)'-...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFF0Outcome(i(1)),'b');
xlim([-0.1 2]); ylim([-5 20]);

% Reward
% Pun(1,:)=DB_CuedOutcome.Values.Uncued_Punish.Photo.DFFOutcome-...
%             DB_CuedOutcome.Values.Uncued_Punish.Photo.DFF0Outcome(i(1));
% Pun(2,:)=DB_CuedOutcome.Values.AnticipLick_CueA_Punish.Photo.DFFOutcome-...
%             DB_CuedOutcome.Values.AnticipLick_CueA_Punish.Photo.DFF0Outcome(i(1));
% Pun(3,:)=DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFFOutcome-...
%             DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFF0Outcome(i(1));
% subplot(3,7,21)
% plot(Pun,'-o')
% xlim([0 4])
% ylim([-2 20])
