clear Cue Rew Pun
limy1=[-5 15]; limy2=[-5 10]; limy3=[-5 20];
figure('Name','Visual_RewPE');
%% Total
subplot(3,7,[1 2]) % Uncued
plot(DB_CuedOutcome.Visual_RewPE.Uncued_Reward.Photo.Time',...
     DB_CuedOutcome.Visual_RewPE.Uncued_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.Visual_RewPE.Uncued_Reward.Photo.DFF0Outcome,'-g');
xlim([-4 4]); ylim(limy1);
title('Uncued')
ylabel('Cue')

subplot(3,7,[3 4]) % CS+
plot(DB_CuedOutcome.Visual_RewPE.AnticipLick_CueA_Reward.Photo.Time',...
     DB_CuedOutcome.Visual_RewPE.AnticipLick_CueA_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.Visual_RewPE.AnticipLick_CueA_Reward.Photo.DFF0Cue,'-k');
xlim([-4 4]); ylim(limy1);
title('CueA - CS+')

subplot(3,7,[5 6]) % CS-
plot(DB_CuedOutcome.Visual_RewPE.NoAnticipLick_CueB.Photo.Time',...
     DB_CuedOutcome.Visual_RewPE.NoAnticipLick_CueB.Photo.DFFAVG'-...
     DB_CuedOutcome.Visual_RewPE.NoAnticipLick_CueB.Photo.DFF0Cue,'-b');
xlim([-4 4]); ylim([-5 15]);
title('Cue B - CS-')

% Cue
Cue(1,:)=DB_CuedOutcome.Visual_RewPE.NoCue.Photo.DFFCue-...
            DB_CuedOutcome.Visual_RewPE.NoCue.Photo.DFF0Cue;
Cue(2,:)=DB_CuedOutcome.Visual_RewPE.AnticipLick_CueA.Photo.DFFCue-...
            DB_CuedOutcome.Visual_RewPE.AnticipLick_CueA.Photo.DFF0Cue;
Cue(3,:)=DB_CuedOutcome.Visual_RewPE.NoAnticipLick_CueB.Photo.DFFCue-...
            DB_CuedOutcome.Visual_RewPE.NoAnticipLick_CueB.Photo.DFF0Cue;
subplot(3,7,7)
plot(Cue,'-o')
xlim([0 4])
ylim(limy1)

%% Reward Only
subplot(3,7,[8 9]) % Uncued
plot(DB_CuedOutcome.Visual_RewPE.Uncued_Reward.Photo.Time',...
     DB_CuedOutcome.Visual_RewPE.Uncued_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.Visual_RewPE.Uncued_Reward.Photo.DFF0Outcome,'-g');
xlim([-0.1 2]); ylim(limy2);
ylabel('Reward')

subplot(3,7,[10 11]) % High Value
plot(DB_CuedOutcome.Visual_RewPE.AnticipLick_CueA_Reward.Photo.Time',...
     DB_CuedOutcome.Visual_RewPE.AnticipLick_CueA_Reward.Photo.DFFAVG'-...
     DB_CuedOutcome.Visual_RewPE.AnticipLick_CueA_Reward.Photo.DFF0Outcome,'-k');
xlim([-0.1 2]); ylim(limy2)

% Reward
Rew(1,:)=DB_CuedOutcome.Visual_RewPE.Uncued_Reward.Photo.DFFOutcome-...
            DB_CuedOutcome.Visual_RewPE.Uncued_Reward.Photo.DFF0Outcome;
Rew(2,:)=DB_CuedOutcome.Visual_RewPE.AnticipLick_CueA_Reward.Photo.DFFOutcome-...
            DB_CuedOutcome.Visual_RewPE.AnticipLick_CueA_Reward.Photo.DFF0Outcome;
subplot(3,7,14)
plot(Rew,'-o')
xlim([0 4])
ylim(limy2)
