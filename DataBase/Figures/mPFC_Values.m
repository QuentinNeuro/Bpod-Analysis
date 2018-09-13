clear Cue Rew Pun
limy1=[-5 15]; limy2=[-5 10]; limy3=[-5 20];
figure('Name','mPFC_Values');
%% Total
subplot(3,7,[1 2]) % Uncued
plot(DB_CuedOutcome.mPFC_Values.Uncued_Reward.Photo.Time',...
     DB_CuedOutcome.mPFC_Values.Uncued_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values.Uncued_Reward.Photo.DFF0Outcome,'-g');
xlim([-4 4]); ylim(limy1);
title('Uncued')
ylabel('Cue')

subplot(3,7,[3 4]) % High Value
plot(DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Reward.Photo.Time',...
     DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Reward.Photo.DFF0Cue,'-k');
xlim([-4 4]); ylim(limy1);
title('CueA - High Value')

subplot(3,7,[5 6]) % Low Value
plot(DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Reward.Photo.Time',...
     DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Reward.Photo.DFF0Cue,'-b');
xlim([-4 4]); ylim(limy1);
title('Cue B - Low Value')

% Cue
% Cue(1,:)=DB_CuedOutcome.mPFC_Values.NoCue.Photo.DFFCue-...
%             DB_CuedOutcome.mPFC_Values.NoCue.Photo.DFF0Cue;
Cue(1,:)=DB_CuedOutcome.mPFC_Values.AnticipLick_CueA.Photo.DFFCue-...
            DB_CuedOutcome.mPFC_Values.AnticipLick_CueA.Photo.DFF0Cue;
Cue(2,:)=DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB.Photo.DFFCue-...
            DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB.Photo.DFF0Cue;
subplot(3,7,7)
plot(Cue,'-o')
xlim([0 4])
ylim([-2 5])

%% Reward Only
subplot(3,7,[8 9]) % Uncued
plot(DB_CuedOutcome.mPFC_Values.Uncued_Reward.Photo.Time',...
     DB_CuedOutcome.mPFC_Values.Uncued_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values.Uncued_Reward.Photo.DFF0Outcome,'-g');
xlim([-0.1 2]); ylim([-2 5]);
ylabel('Reward')

subplot(3,7,[10 11]) % High Value
plot(DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Reward.Photo.Time',...
     DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Reward.Photo.DFF0Outcome,'-k');
xlim([-0.1 2]); ylim([-2 5])

subplot(3,7,[12 13]) % Low Value
plot(DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Reward.Photo.Time',...
     DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Reward.Photo.DFF0Outcome,'b');
xlim([-0.1 2]); ylim([-5 10]);
% Reward
Rew(1,:)=DB_CuedOutcome.mPFC_Values.Uncued_Reward.Photo.DFFOutcome-...
            DB_CuedOutcome.mPFC_Values.Uncued_Reward.Photo.DFF0Outcome;
Rew(2,:)=DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Reward.Photo.DFFOutcome-...
            DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Reward.Photo.DFF0Outcome;
% Rew(3,:)=DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Reward.Photo.DFFOutcome-...
%             DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Reward.Photo.DFF0Outcome;
subplot(3,7,14)
plot(Rew,'-o')
xlim([0 4])
ylim([-2 5])


%% Punish Only
subplot(3,7,[15 16]) % Uncued
plot(DB_CuedOutcome.mPFC_Values.Uncued_Punish.Photo.Time',...
     DB_CuedOutcome.mPFC_Values.Uncued_Punish.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values.Uncued_Punish.Photo.DFF0Outcome,'-r');
xlim([-0.1 2]); ylim([-5 20]);
ylabel('Punish')

subplot(3,7,[17 18]) % High Value
plot(DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Punish.Photo.Time',...
     DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Punish.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Punish.Photo.DFF0Outcome,'-k');
xlim([-0.1 2]); ylim([-5 20])

subplot(3,7,[19 20]) % Lowh Value
plot(DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Punish.Photo.Time',...
     DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Punish.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Punish.Photo.DFF0Outcome,'b');
xlim([-0.1 2]); ylim([-5 20]);

% Reward
Pun(1,:)=DB_CuedOutcome.mPFC_Values.Uncued_Punish.Photo.DFFOutcome-...
            DB_CuedOutcome.mPFC_Values.Uncued_Punish.Photo.DFF0Outcome;
Pun(2,:)=DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Punish.Photo.DFFOutcome-...
            DB_CuedOutcome.mPFC_Values.AnticipLick_CueA_Punish.Photo.DFF0Outcome;
Pun(3,:)=DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Punish.Photo.DFFOutcome-...
            DB_CuedOutcome.mPFC_Values.NoAnticipLick_CueB_Punish.Photo.DFF0Outcome;
subplot(3,7,21)
plot(Pun,'-o')
xlim([0 4])
ylim([-2 20])
