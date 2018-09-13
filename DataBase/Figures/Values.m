clear Cue Rew Pun
ylim2=[-2 6];
figure('Name','Values');
%% Total
subplot(3,8,[1 2]) % Uncued
plot(DB_CuedOutcome.Values.Uncued_Reward.Photo.Time',...
     DB_CuedOutcome.Values.Uncued_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.Values.Uncued_Reward.Photo.DFF0Outcome,'-g');
xlim([-4 4]); ylim([-5 15]);
title('Uncued')
ylabel('Cue')

subplot(3,8,[3 4]) % High Value
plot(DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.Time',...
     DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.DFF0Cue,'-k');
xlim([-4 4]); ylim([-5 15]);
title('CueA - High Value')

subplot(3,8,[5 6]) % Low Value
plot(DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.Time',...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.DFF0Cue,'-b');
xlim([-4 4]); ylim([-5 15]);
title('Cue B - Low Value')

% Cue
Cue(3,:)=DB_CuedOutcome.Values.NoCue.Photo.DFFCue-...
            DB_CuedOutcome.Values.NoCue.Photo.DFF0Cue;
Cue(1,:)=DB_CuedOutcome.Values.AnticipLick_CueA.Photo.DFFCue-...
            DB_CuedOutcome.Values.AnticipLick_CueA.Photo.DFF0Cue;
Cue(2,:)=DB_CuedOutcome.Values.NoAnticipLick_CueB.Photo.DFFCue-...
            DB_CuedOutcome.Values.NoAnticipLick_CueB.Photo.DFF0Cue;
subplot(3,8,7)
plot(Cue,'-o')
xlim([0 4])
ylim([-2 15])
subplot(3,8,8)
boxplot(Cue');

%% Reward Only
subplot(3,8,[9 10]) % Uncued
plot(DB_CuedOutcome.Values.Uncued_Reward.Photo.Time',...
     DB_CuedOutcome.Values.Uncued_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.Values.Uncued_Reward.Photo.DFF0Outcome,'-g');
xlim([-0.1 2]); ylim(ylim2);
ylabel('Reward')

subplot(3,8,[11 12]) % High Value
plot(DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.Time',...
     DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.DFF0Outcome,'-k');
xlim([-0.1 2]); ylim(ylim2)

subplot(3,8,[13 14]) % Low Value
plot(DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.Time',...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.DFF0Outcome,'b');
xlim([-0.1 2]); ylim(ylim2);
% Reward
Rew(3,:)=DB_CuedOutcome.Values.Uncued_Reward.Photo.DFFOutcome-...
            DB_CuedOutcome.Values.Uncued_Reward.Photo.DFF0Outcome;
Rew(1,:)=DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.DFFOutcome-...
            DB_CuedOutcome.Values.AnticipLick_CueA_Reward.Photo.DFF0Outcome;
Rew(2,:)=DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.DFFOutcome-...
            DB_CuedOutcome.Values.NoAnticipLick_CueB_Reward.Photo.DFF0Outcome;
subplot(3,8,15)
plot(Rew,'-o')
xlim([0 4])
ylim(ylim2)
subplot(3,8,16)
boxplot(Rew')

%% Punish Only
subplot(3,8,[17 18]) % Uncued
plot(DB_CuedOutcome.Values.Uncued_Punish.Photo.Time',...
     DB_CuedOutcome.Values.Uncued_Punish.Photo.DFFAVG'-...
     DB_CuedOutcome.Values.Uncued_Punish.Photo.DFF0Outcome,'-r');
xlim([-0.1 2]); ylim([-5 20]);
ylabel('Punish')

subplot(3,8,[19 20]) % High Value
plot(DB_CuedOutcome.Values.AnticipLick_CueA_Punish.Photo.Time',...
     DB_CuedOutcome.Values.AnticipLick_CueA_Punish.Photo.DFFAVG'-...
     DB_CuedOutcome.Values.AnticipLick_CueA_Punish.Photo.DFF0Outcome,'-k');
xlim([-0.1 2]); ylim([-5 20])

subplot(3,8,[21 22]) % Lowh Value
plot(DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.Time',...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFFAVG'-...
     DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFF0Outcome,'b');
xlim([-0.1 2]); ylim([-5 20]);

% Reward
Pun(1,:)=DB_CuedOutcome.Values.Uncued_Punish.Photo.DFFOutcome-...
            DB_CuedOutcome.Values.Uncued_Punish.Photo.DFF0Outcome;
Pun(2,:)=DB_CuedOutcome.Values.AnticipLick_CueA_Punish.Photo.DFFOutcome-...
            DB_CuedOutcome.Values.AnticipLick_CueA_Punish.Photo.DFF0Outcome;
Pun(3,:)=DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFFOutcome-...
            DB_CuedOutcome.Values.NoAnticipLick_CueB_Punish.Photo.DFF0Outcome;
subplot(3,8,23)
plot(Pun,'-o')
xlim([0 4])
ylim([-2 20])
subplot(3,8,24)
boxplot(Pun')