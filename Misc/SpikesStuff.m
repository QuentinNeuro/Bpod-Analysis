
BehavVIP.names={...
'VIP-Ai32-NNx-2_20180323a_2.32'...
'VIP-Ai32-NNx-5_20180418a_1.3'...
'VIP-Ai32-NNx-5_20180418a_2.4'...
'VIP-Ai32-NNx-6_20180413a_2.2'...
'VIP-Ai32-NNx-6_20180415a_4.6'...
'VIP-Ai32-NNx-6_20180415a_4.8'...
'VIP-Ai32-NNx-6_20180416a_4.3'...
'VIP-Ai32-NNx-7_20180420a_4.7'};

load('Times')
BehavVIP.CueA.Time=LickARew;
BehavVIP.CueB.Time=CueB-1.5;
BehavVIP.Uncued.Time=UncuedRew;
load('Times_PulseOn.mat')
BehavVIP.Tagging.Time=time;
for i=1:size(BehavVIP.names,2)
    thisTT=BehavVIP.names{i};
    load([thisTT '_LickARew.mat']);
	BehavVIP.CueA.spikes(i,:)=psth_data.spsth;
    load([thisTT '_CueB.mat']);
	BehavVIP.CueB.spikes(i,:)=psth_data.spsth;
    load([thisTT '_UncuedRew.mat']);
	BehavVIP.Uncued.spikes(i,:)=psth_data.spsth;
    load([thisTT '_PulseOn.mat']); 
    BehavVIP.Tagging.spikes(i,:)=psth_data.spsth;
    BehavVIP.Tagging.max(i)=max(psth_data.spsth);
    BehavVIP.Tagging.normspikes(i,:)=psth_data.spsth/BehavVIP.Tagging.max(i);
%     figure('Name',thisTT)
%     hold on
%     plot(BehavVIP.CueA.Time,BehavVIP.CueA.spikes(i,:),'-k')
%     plot(BehavVIP.CueB.Time,BehavVIP.CueB.spikes(i,:),'-b')
%     plot(BehavVIP.Uncued.Time,BehavVIP.Uncued.spikes(i,:),'-g')
% %     saveas(gcf,[pwd filesep thisTT '.eps'],'epsc')
% %     close gcf
end    

Time=BehavVIP.CueA.Time;
%% Baseline
BehavVIP.CueA.BaseAVGs=mean(BehavVIP.CueA.spikes(:,Time>-3.5 & Time<-3),2);
BehavVIP.CueB.BaseAVGs=mean(BehavVIP.CueB.spikes(:,Time>-3.5 & Time<-3),2);
BehavVIP.Uncued.BaseAVGs=mean(BehavVIP.Uncued.spikes(:,Time>-3.5 & Time<-3),2);
%% Cue
BehavVIP.CueA.CueAVGs=mean(BehavVIP.CueA.spikes(:,Time>-1 & Time<0),2);
BehavVIP.CueB.CueAVGs=mean(BehavVIP.CueB.spikes(:,Time>-1 & Time<0),2);
BehavVIP.Uncued.CueAVGs=mean(BehavVIP.Uncued.spikes(:,Time>-1 & Time<0),2);
% Normalize
BehavVIP.CueA.CueNormAVGs=BehavVIP.CueA.CueAVGs./BehavVIP.CueA.BaseAVGs;
BehavVIP.CueB.CueNormAVGs=BehavVIP.CueB.CueAVGs./BehavVIP.CueB.BaseAVGs;
BehavVIP.Uncued.CueNormAVGs=BehavVIP.Uncued.CueAVGs./BehavVIP.Uncued.BaseAVGs;

BehavVIP.CueA.CueNorm2AVGs=BehavVIP.CueA.CueAVGs./BehavVIP.CueB.CueAVGs;
%% Outcome
BehavVIP.CueA.OutcomeAVGs=max(BehavVIP.CueA.spikes(:,Time>0 & Time<2)');
BehavVIP.Uncued.OutcomeAVGs=max(BehavVIP.Uncued.spikes(:,Time>0 & Time<2)');
%Normalize
BehavVIP.CueA.OutcomeNormAVGs=BehavVIP.CueA.OutcomeAVGs./BehavVIP.CueA.BaseAVGs';
BehavVIP.Uncued.OutcomeNormAVGs=BehavVIP.Uncued.OutcomeAVGs./BehavVIP.Uncued.BaseAVGs';

BehavVIP.CueA.OutcomeNorm2AVGs=BehavVIP.CueA.OutcomeAVGs./BehavVIP.Uncued.OutcomeAVGs;
%% Plot
figure('Name','Some Numbers')
subplot(1,4,1)
plot([BehavVIP.CueA.CueNormAVGs BehavVIP.CueB.CueNormAVGs]','o-')
xlim([0 3])
subplot(1,4,2)
plot(1,BehavVIP.CueA.CueNorm2AVGs','o')
ylim([0 3])
subplot(1,4,3)
plot([BehavVIP.CueA.OutcomeNormAVGs' BehavVIP.Uncued.OutcomeNormAVGs']','-o')
xlim([0 3])
subplot(1,4,4)
plot(1,BehavVIP.CueA.OutcomeNorm2AVGs','o')
ylim([0 2])

figure('Name','Tagging')
plot(BehavVIP.Tagging.Time,BehavVIP.Tagging.spikes')
% saveas(gcf,[pwd filesep 'summary.eps'],'epsc')
% close gcf