function Analysis=Analysis_Spikes_PlotData(Analysis,thisTT)

%% Types
isPunish=0;
if contains(Analysis.Parameters.Phase,'Punish')
    isPunish=1;
end
CueType={'Cue_A','Cue_B','NoCue'};
CueColors=['-g';'-r';'-k'];
RewardType={'AnticipLick_CueA_Reward','NoAnticipLick_CueA_Reward','Uncued_Reward'};
RewardColors=['-g';'-b';'-k'];
PunishType={'NoAnticipLick_CueB_Punish','Uncued_Punish'};
PunishColors=['-r';'-k'];

%% Parameters
transp=Analysis.Parameters.Transparency;
% Subplot All Spikes
xLabelAll='Time Session (s)';
xTimeAll=[Analysis.AllData.Spikes.Time.Behavior(1) Analysis.AllData.Spikes.Time.Behavior(end)]; 
yLabelSpikeAll='Spikes';
ySpikeAll=[-0.1 0.1];
% Subplot Tagging Raster
xLabelTag='Time from Laser (s)';
xTimeTag=[-0.01 0.02];
yTrialsTag1=[0 100];
yTrialsTag2=[100 200];
% Subplot Licks
xLabelLicks='Time from Outcome (s)';
xTimeLicks=[-3 3];
yLabelLicks='Licks (Hz)';
yLicks=[0 15];
% Subplot Spikes Rate
xLabelSpikeRate='Time from Outcome (s)';
xTimeSpikeRate=[-3 3];
yLabelSpikeRate='Spikes (Hz)';
ySpikeRate=[0 30];
% Subplot Behavior Raster
xLabelTime='Time from Outcome(s)';
xTimeSpikes=[-3 3];
yLabelSpikeRaster='Trials (Spikes)';

%% Data
% Subplot All Spikes
NbOfSpikes=500;
thisSpikes_All=Analysis.AllData.Spikes.Raw.(thisTT);
thislength=length(thisSpikes_All);
decimatefactor=1;
if thislength>=NbOfSpikes
    decimatefactor=ceil(thislength/NbOfSpikes);
end  

%% Figure
scrsz = get(groot,'ScreenSize');
FigureLegend=sprintf('%s_%s',Analysis.Parameters.Name,Analysis.Parameters.Rig);

figure('Name','Figure TT','Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

%% TT Timing
subplot(6,3,1); hold on;
title(thisTT);
plot(decimate(thisSpikes_All,decimatefactor),0,'sk',...
        'MarkerSize',2,'MarkerFaceColor','k');
set(gca,'XLim',xTimeAll,'YLim',ySpikeAll);
ylabel(yLabelSpikeAll);
xlabel(xLabelAll);

%% PhotoTagging
thisTagging_Events1=cell2mat(Analysis.AllData.Spikes.Tagging.(thisTT).Events(1:100));
thisTagging_Trials1=cell2mat(Analysis.AllData.Spikes.Tagging.(thisTT).Trials(1:100));
subplot(6,3,2); hold on;
title('PhotoTagging - pre');
plot(thisTagging_Events1,thisTagging_Trials1,'sk','MarkerSize',2,'MarkerFaceColor','k');
plot([0 0],yTrialsTag1,'-r');
set(gca,'XLim',xTimeTag,'YDir','reverse');
xlabel(xLabelTag);

if size(Analysis.AllData.Spikes.Tagging.(thisTT).Events,2)==200
thisTagging_Events2=cell2mat(Analysis.AllData.Spikes.Tagging.(thisTT).Events(101:200));
thisTagging_Trials2=cell2mat(Analysis.AllData.Spikes.Tagging.(thisTT).Trials(101:200));
subplot(6,3,3); hold on;
title('PhotoTagging - post');
plot(thisTagging_Events2,thisTagging_Trials2,'sk','MarkerSize',2,'MarkerFaceColor','k');  
plot([0 0],yTrialsTag2,'-r');
set(gca,'XLim',xTimeTag,'YDir','reverse');    
xlabel(xLabelTag);
end

%% Licks
% Cue
subplot(6,3,4); hold on;
title('Cue')
for i=1:length(CueType)
if Analysis.(CueType{i}).nTrials>0
shadedErrorBar(Analysis.(CueType{i}).Licks.Bin, Analysis.(CueType{i}).Licks.AVG, Analysis.(CueType{i}).Licks.SEM,CueColors(i,:),transp);
end
end
plot([0 0],yLicks,'-b');
plot(Analysis.(CueType{1}).Time.Cue(1,:),[yLicks(2) yLicks(2)],'-b','LineWidth',2);
set(gca,'XLim',xTimeLicks,'YLim',yLicks);
ylabel(yLabelLicks);
% Reward
subplot(6,3,5); hold on;
title('Reward')
for i=1:length(RewardType)
if Analysis.(RewardType{i}).nTrials>0
shadedErrorBar(Analysis.(RewardType{i}).Licks.Bin, Analysis.(RewardType{i}).Licks.AVG, Analysis.(RewardType{i}).Licks.SEM,RewardColors(i,:),transp);
end
end
plot([0 0],yLicks,'-b');
plot(Analysis.(RewardType{1}).Time.Cue(1,:),[yLicks(2) yLicks(2)],'-b','LineWidth',2);
set(gca,'XLim',xTimeLicks,'YLim',yLicks);
% Punish
if isPunish
subplot(6,3,6); hold on;
title('Punish')
for i=1:length(PunishType)
if Analysis.(PunishType{i}).nTrials>0
shadedErrorBar(Analysis.(PunishType{i}).Licks.Bin, Analysis.(PunishType{i}).Licks.AVG, Analysis.(PunishType{i}).Licks.SEM,PunishColors(i,:),transp);
end
end
plot([0 0],yLicks,'-b');
plot(Analysis.(PunishType{1}).Time.Cue(1,:),[yLicks(2) yLicks(2)],'-b','LineWidth',2);
set(gca,'XLim',xTimeLicks,'YLim',yLicks);
end

%% Spike AVG
% Cue
subplot(6,3,7); hold on;
title('Cue')
for i=1:length(CueType)
if Analysis.(CueType{i}).nTrials>0
shadedErrorBar(Analysis.(CueType{i}).Spikes.Behavior.(thisTT).Bin(1,:),Analysis.(CueType{i}).Spikes.Behavior.(thisTT).AVG,Analysis.(CueType{i}).Spikes.Behavior.(thisTT).SEM,CueColors(i,:),transp);
end
end
plot([0 0],ySpikeRate,'-b');
plot(Analysis.(CueType{1}).Time.Cue(1,:),[ySpikeRate(2) ySpikeRate(2)],'-b','LineWidth',2);
set(gca,'XLim',xTimeSpikeRate,'YLim',ySpikeRate);
ylabel(yLabelSpikeRate);
% Reward
subplot(6,3,8); hold on;
title('Reward')
for i=1:length(RewardType)
if Analysis.(RewardType{i}).nTrials>0
shadedErrorBar(Analysis.(RewardType{i}).Spikes.Behavior.(thisTT).Bin(1,:),Analysis.(RewardType{i}).Spikes.Behavior.(thisTT).AVG,Analysis.(RewardType{i}).Spikes.Behavior.(thisTT).SEM,RewardColors(i,:),transp);
end
end
plot([0 0],ySpikeRate,'-b');
plot(Analysis.(CueType{1}).Time.Cue(1,:),[ySpikeRate(2) ySpikeRate(2)],'-b','LineWidth',2);
set(gca,'XLim',xTimeSpikeRate,'YLim',ySpikeRate);
% Punish
if isPunish
subplot(6,3,9); hold on;
title('Punish')
for i=1:length(PunishType)
if Analysis.(PunishType{i}).nTrials>0
shadedErrorBar(Analysis.(PunishType{i}).Spikes.Behavior.(thisTT).Bin(1,:),Analysis.(PunishType{i}).Spikes.Behavior.(thisTT).AVG,Analysis.(PunishType{i}).Spikes.Behavior.(thisTT).SEM,CueColors(i,:),transp);
end
end
plot([0 0],ySpikeRate,'-b');
plot(Analysis.(CueType{1}).Time.Cue(1,:),[ySpikeRate(2) ySpikeRate(2)],'-b','LineWidth',2);
set(gca,'XLim',xTimeSpikeRate,'YLim',ySpikeRate);
end

%% Spike Rasters
% Cue
for i=1:length(CueType)
    thisBehav_Events=Analysis.(CueType{i}).Spikes.Behavior.(thisTT).Events;
    thisBehav_Trials=Analysis.(CueType{i}).Spikes.Behavior.(thisTT).Trials;
    subplot(6,3,7+i*3); hold on;
    title(CueType{i});
    plot(thisBehav_Events,thisBehav_Trials,'sk','MarkerSize',2,'MarkerFaceColor','k');
    plot([0 0],[0 max(thisBehav_Events)],'-b');
    plot(Analysis.(CueType{1}).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
    set(gca,'XLim',xTimeSpikes,'YDir','reverse');
    ylabel(yLabelSpikeRaster)
end
xlabel(xLabelTime);
% Reward
for i=1:length(RewardType)
    thisBehav_Events=Analysis.(RewardType{i}).Spikes.Behavior.(thisTT).Events;
    thisBehav_Trials=Analysis.(RewardType{i}).Spikes.Behavior.(thisTT).Trials;
    subplot(6,3,8+i*3); hold on;
    title(RewardType{i});
    plot(thisBehav_Events,thisBehav_Trials,'sk','MarkerSize',2,'MarkerFaceColor','k');
    plot([0 0],[0 max(thisBehav_Events)],'-b');
    plot(Analysis.(RewardType{1}).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
    set(gca,'XLim',xTimeSpikes,'YDir','reverse');   
end
xlabel(xLabelTime);
% Punish
if isPunish
for i=1:length(RewardType)
    thisBehav_Events=Analysis.(RewardType{i}).Spikes.Behavior.(thisTT).Events;
    thisBehav_Trials=Analysis.(RewardType{i}).Spikes.Behavior.(thisTT).Trials;
    subplot(6,3,8+i*3); hold on;
    title(PunishType{i});
    plot(thisBehav_Events,thisBehav_Trials,'sk','MarkerSize',2,'MarkerFaceColor','k');
    plot([0 0],[0 max(thisBehav_Events)],'-b');
    plot(Analysis.(RewardType{1}).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
    set(gca,'XLim',xTimeSpikes,'YDir','reverse');   
end
xlabel(xLabelTime);
end

%% Save
FileName=[Analysis.Parameters.Name thisTT '.png'];
DirEvents=[pwd filesep 'Figure_Spikes' filesep];
if isdir(DirEvents)==0
    mkdir(DirEvents);
end
DirFile=[DirEvents FileName];
saveas(gcf,DirFile);
close 'Figure TT';    
end