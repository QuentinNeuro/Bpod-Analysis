clear Cue Rew Pun
figure('Name','mPFC_Values_Reversal');
%% Total
subplot(3,7,[1 2]) % Uncued
plot(DB_CuedOutcome.mPFC_Values_Rev.Uncued_Reward.Photo.Time',...
     DB_CuedOutcome.mPFC_Values_Rev.Uncued_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values_Rev.Uncued_Reward.Photo.DFF0Outcome,'-g');
xlim([-4 4]); ylim([-5 15]);
title('Uncued')
ylabel('Cue')

subplot(3,7,[3 4]) % Low Value
plot(DB_CuedOutcome.mPFC_Values_Rev.Cue_A.Photo.Time',...
     DB_CuedOutcome.mPFC_Values_Rev.Cue_A.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values_Rev.Cue_A.Photo.DFF0Cue,'-k');
xlim([-4 4]); ylim([-5 15]);
title('CueA - Low Value')

subplot(3,7,[5 6]) % High Value
plot(DB_CuedOutcome.mPFC_Values_Rev.Cue_B.Photo.Time',...
     DB_CuedOutcome.mPFC_Values_Rev.Cue_B.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values_Rev.Cue_B.Photo.DFF0Cue,'-b');
xlim([-4 4]); ylim([-5 15]);
title('Cue B - High Value')

% Cue         
Cue(1,:)=DB_CuedOutcome.mPFC_Values_Rev.NoCue.Photo.DFFDelay-...
            DB_CuedOutcome.mPFC_Values_Rev.NoCue.Photo.DFF0Cue;
Cue(2,:)=DB_CuedOutcome.mPFC_Values_Rev.Cue_A.Photo.DFFDelay-...
            DB_CuedOutcome.mPFC_Values_Rev.Cue_A.Photo.DFF0Cue;
Cue(3,:)=DB_CuedOutcome.mPFC_Values_Rev.Cue_B.Photo.DFFDelay-...
            DB_CuedOutcome.mPFC_Values_Rev.Cue_B.Photo.DFF0Cue;
subplot(3,7,7)
plot(Cue,'-o')
xlim([0 4])
ylim([-2 10])

%% Reward Only
subplot(3,7,[8 9]) % Uncued
plot(DB_CuedOutcome.mPFC_Values_Rev.Uncued_Reward.Photo.Time',...
     DB_CuedOutcome.mPFC_Values_Rev.Uncued_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values_Rev.Uncued_Reward.Photo.DFF0Outcome,'-g');
xlim([-0.1 2]); ylim([-5 10]);
ylabel('Reward')

subplot(3,7,[10 11]) % Low Value
plot(DB_CuedOutcome.mPFC_Values_Rev.CueA_Reward.Photo.Time',...
     DB_CuedOutcome.mPFC_Values_Rev.CueA_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values_Rev.CueA_Reward.Photo.DFF0Outcome,'-k');
xlim([-0.1 2]); ylim([-5 10])

subplot(3,7,[12 13]) % High Value
plot(DB_CuedOutcome.mPFC_Values_Rev.CueB_Reward.Photo.Time',...
     DB_CuedOutcome.mPFC_Values_Rev.CueB_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values_Rev.CueB_Reward.Photo.DFF0Outcome,'b');
xlim([-0.1 2]); ylim([-5 10]);
% Reward
Rew(1,:)=DB_CuedOutcome.mPFC_Values_Rev.Uncued_Reward.Photo.DFFOutcome-...
            DB_CuedOutcome.mPFC_Values_Rev.Uncued_Reward.Photo.DFF0Outcome;
Rew(2,:)=DB_CuedOutcome.mPFC_Values_Rev.CueA_Reward.Photo.DFFOutcome-...
            DB_CuedOutcome.mPFC_Values_Rev.CueA_Reward.Photo.DFF0Outcome;
Rew(3,:)=DB_CuedOutcome.mPFC_Values_Rev.CueB_Reward.Photo.DFFOutcome-...
            DB_CuedOutcome.mPFC_Values_Rev.CueB_Reward.Photo.DFF0Outcome;
subplot(3,7,14)
plot(Rew,'-o')
xlim([0 4])
ylim([-2 10])


%% Punish Only
subplot(3,7,[15 16]) % Uncued
plot(DB_CuedOutcome.mPFC_Values_Rev.Uncued_Punish.Photo.Time',...
     DB_CuedOutcome.mPFC_Values_Rev.Uncued_Punish.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values_Rev.Uncued_Punish.Photo.DFF0Outcome,'-r');
xlim([-0.1 2]); ylim([-5 20]);
ylabel('Punish')

subplot(3,7,[17 18]) % Low Value
plot(DB_CuedOutcome.mPFC_Values_Rev.NoAnticipLick_CueA_Punish.Photo.Time',...
     DB_CuedOutcome.mPFC_Values_Rev.NoAnticipLick_CueA_Punish.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values_Rev.NoAnticipLick_CueA_Punish.Photo.DFF0Outcome,'-k');
xlim([-0.1 2]); ylim([-5 20])

subplot(3,7,[19 20]) % High Value
plot(DB_CuedOutcome.mPFC_Values_Rev.AnticipLick_CueB_Punish.Photo.Time',...
     DB_CuedOutcome.mPFC_Values_Rev.AnticipLick_CueB_Punish.Photo.DFFAVG'-...
     DB_CuedOutcome.mPFC_Values_Rev.AnticipLick_CueB_Punish.Photo.DFF0Outcome,'b');
xlim([-0.1 2]); ylim([-5 20]);

% Punish
Pun(1,:)=DB_CuedOutcome.mPFC_Values_Rev.Uncued_Punish.Photo.DFFOutcome-...
            DB_CuedOutcome.mPFC_Values_Rev.Uncued_Punish.Photo.DFF0Outcome;
Pun(2,:)=DB_CuedOutcome.mPFC_Values_Rev.NoAnticipLick_CueA_Punish.Photo.DFFOutcome-...
            DB_CuedOutcome.mPFC_Values_Rev.NoAnticipLick_CueA_Punish.Photo.DFF0Outcome;
Pun(3,:)=DB_CuedOutcome.mPFC_Values_Rev.AnticipLick_CueB_Punish.Photo.DFFOutcome-...
            DB_CuedOutcome.mPFC_Values_Rev.AnticipLick_CueB_Punish.Photo.DFF0Outcome;
subplot(3,7,21)
plot(Pun,'-o')
xlim([0 4])
ylim([-2 20])
