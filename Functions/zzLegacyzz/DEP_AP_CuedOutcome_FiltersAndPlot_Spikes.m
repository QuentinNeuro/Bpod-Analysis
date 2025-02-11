function Analysis=AP_CuedOutcome_FiltersAndPlot_Spikes(Analysis,c)
%%
thisC_Name=Analysis.AllData.Spikes.CellNames{c};

%% Types
isPunish=0;
if contains(Analysis.Parameters.Phase,'Punish')
    isPunish=1;
end
CueType={'Cue_A','Cue_B'};%,'NoCue'};
CueColors=['-k';'-r';'-b'];
RewardType={'AnticipLick_CueA_Reward','Uncued_Reward'};%'NoAnticipLick_CueA_Reward',
RewardColors=['-k';'-r';'-g'];
PunishType={'NoAnticipLick_CueB_Punish','Uncued_Punish'};
PunishColors=['-k';'-r'];

%% Parameters
transp=Analysis.Parameters.Transparency;
% Subplot All Spikes
xLabelAll='Time Session (s)';
xTimeAll=[Analysis.Core.Spikes.BehaviorTS(1) Analysis.Core.Spikes.BehaviorTS(end)];
yLabelSpikeAll='Spikes';
ySpikeAll=[-0.1 0.1];
% Subplot Tagging Raster
xLabelTag='Time from Laser (s)';
xTimeTag=Analysis.Parameters.Spikes.tagging_timeW;
yTrialsTag1=[0 100];
yTrialsTag2=[100 200];
% Subplot Licks
xLabelBehav='Time from Outcome (s)';
xTimeLicks=Analysis.Parameters.PlotX;
yLabelLicks='Licks (Hz)';
yLicks=[0 10];
% Subplot Spikes Rate
xTimeSpikeRate=Analysis.Parameters.PlotX;
yLabelSpikeRate='Spikes (Hz)';
ySpikeRate=[0 10];
% Subplot Behavior Raster
xTimeSpikes=Analysis.Parameters.PlotX;
yLabelSpikeRaster='Trials (Spikes)';

%% Data
% Subplot All Spikes
NbOfSpikes=500;
thisSpikes_All=Analysis.Core.Spikes.SpikeTS{c};
thislength=length(thisSpikes_All);
if thislength>=NbOfSpikes
    thisSpikes_All=decimate(thisSpikes_All,ceil(thislength/NbOfSpikes));
end  

%% Figure
scrsz = get(groot,'ScreenSize');
FigureLegend=sprintf('%s_%s',Analysis.Parameters.Name,Analysis.Parameters.Rig);

figure('Name','Figure TT','Position', [200 100 1200 700], 'numbertitle','off');
Legend=uicontrol('style','text');
set(Legend,'String',FigureLegend,'Position',[10,5,500,20]); 

%% TT Timing
subplot(6,3,1); hold on;
title([thisC_Name Analysis.Core.Spikes.Label{c}]);
plot(thisSpikes_All,0,'sk',...
        'MarkerSize',2,'MarkerFaceColor','k');
set(gca,'XLim',xTimeAll,'YLim',ySpikeAll);
ylabel(yLabelSpikeAll);
xlabel(xLabelAll);

%% PhotoTagging
thisTagging_Events1=cell2mat(Analysis.AllData.Spikes.(thisC_Name).Tagging.SpikeTS(1:100)');
thisTagging_Trials1=cell2mat(Analysis.AllData.Spikes.(thisC_Name).Tagging.Trials(1:100));
subplot(6,3,2); hold on;
title('PhotoTagging - pre');
plot(thisTagging_Events1,thisTagging_Trials1,'sk','MarkerSize',2,'MarkerFaceColor','k');
plot([0 0],yTrialsTag1,'-r');
set(gca,'XLim',xTimeTag,'YDir','reverse');
xlabel(xLabelTag);

if size(Analysis.AllData.Spikes.(thisC_Name).Tagging.SpikeTS,2)>=200
thisTagging_Events2=cell2mat(Analysis.AllData.Spikes.(thisC_Name).Tagging.SpikeTS(101:200)');
thisTagging_Trials2=cell2mat(Analysis.AllData.Spikes.(thisC_Name).Tagging.Trials(101:200));
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
    thisBin=Analysis.(CueType{i}).Spikes.(thisC_Name).Bin(1,:);
    thisRateAVG=Analysis.(CueType{i}).Spikes.(thisC_Name).RateAVG;
    thisRateSEM=Analysis.(CueType{i}).Spikes.(thisC_Name).RateSEM;
    shadedErrorBar(thisBin,thisRateAVG,thisRateSEM,CueColors(i,:),transp);
end
end
plot([0 0],ySpikeRate,'-b');
plot(Analysis.(CueType{1}).Time.Cue(1,:),[ySpikeRate(2) ySpikeRate(2)],'-b','LineWidth',2);
set(gca,'XLim',xTimeSpikeRate);
ylabel(yLabelSpikeRate);
% Reward
subplot(6,3,8); hold on;
title('Reward')
for i=1:length(RewardType)
if Analysis.(RewardType{i}).nTrials>0
    thisBin=Analysis.(RewardType{i}).Spikes.(thisC_Name).Bin(1,:);
    thisRateAVG=Analysis.(RewardType{i}).Spikes.(thisC_Name).RateAVG;
    thisRateSEM=Analysis.(RewardType{i}).Spikes.(thisC_Name).RateSEM;
    shadedErrorBar(thisBin,thisRateAVG,thisRateSEM,RewardColors(i,:),transp);
end
end
plot([0 0],ySpikeRate,'-b');
plot(Analysis.(CueType{1}).Time.Cue(1,:),[ySpikeRate(2) ySpikeRate(2)],'-b','LineWidth',2);
set(gca,'XLim',xTimeSpikeRate);
% Punish
if isPunish
subplot(6,3,9); hold on;
title('Punish')
for i=1:length(PunishType)
if Analysis.(PunishType{i}).nTrials>0
    thisBin=Analysis.(PunishType{i}).Spikes.(thisC_Name).Bin(1,:);
    thisRateAVG=Analysis.(PunishType{i}).Spikes.(thisC_Name).RateAVG;
    thisRateSEM=Analysis.(PunishType{i}).Spikes.(thisC_Name).RateSEM;
    shadedErrorBar(thisBin,thisRateAVG,thisRateSEM,PunishColors(i,:),transp);
end
end
plot([0 0],ySpikeRate,'-b');
plot(Analysis.(CueType{1}).Time.Cue(1,:),[ySpikeRate(2) ySpikeRate(2)],'-b','LineWidth',2);
set(gca,'XLim',xTimeSpikeRate);
end

%% Spike Rasters
% Cue
for i=1:length(CueType)
    if Analysis.(CueType{i}).nTrials>0
    thisBehav_Events=cell2mat(Analysis.(CueType{i}).Spikes.(thisC_Name).SpikeTS');
    thisBehav_Trials=cell2mat(Analysis.(CueType{i}).Spikes.(thisC_Name).Trials);
    subplot(6,3,7+i*3); hold on;
    title(CueType{i});
    plot(thisBehav_Events,thisBehav_Trials,'sk','MarkerSize',2,'MarkerFaceColor','k');
    plot([0 0],[0 max(thisBehav_Events)],'-b');
    plot(Analysis.(CueType{1}).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
    set(gca,'XLim',xTimeSpikes,'YDir','reverse');
    ylabel(yLabelSpikeRaster)
    end
end
xlabel(xLabelBehav);
% Reward
for i=1:length(RewardType)
    if Analysis.(CueType{i}).nTrials>0
    thisBehav_Events=cell2mat(Analysis.(RewardType{i}).Spikes.(thisC_Name).SpikeTS');
    thisBehav_Trials=cell2mat(Analysis.(RewardType{i}).Spikes.(thisC_Name).Trials);
    subplot(6,3,8+i*3); hold on;
    title(RewardType{i});
    plot(thisBehav_Events,thisBehav_Trials,'sk','MarkerSize',2,'MarkerFaceColor','k');
    plot([0 0],[0 max(thisBehav_Events)],'-b');
    plot(Analysis.(RewardType{1}).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
    set(gca,'XLim',xTimeSpikes,'YDir','reverse'); 
    end
end
xlabel(xLabelBehav);
% Punish
if isPunish
for i=1:length(PunishType)
    thisBehav_Events=cell2mat(Analysis.(RewardType{i}).Spikes.(thisC_Name).SpikeTS');
    thisBehav_Trials=cell2mat(Analysis.(RewardType{i}).Spikes.(thisC_Name).Trials);
    subplot(6,3,9+i*3); hold on;
    title(PunishType{i});
    plot(thisBehav_Events,thisBehav_Trials,'sk','MarkerSize',2,'MarkerFaceColor','k');
    plot([0 0],[0 max(thisBehav_Events)],'-b');
    plot(Analysis.(RewardType{1}).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
    set(gca,'XLim',xTimeSpikes,'YDir','reverse');   
end
xlabel(xLabelBehav);
end

%% Save
if isfield(Analysis.AllData.Spikes,'TagStat')
    tagStatus=find(Analysis.AllData.Spikes.TagStat.Decision(c,:));
    if ~isempty(tagStatus)
        tagName=['-' Analysis.AllData.Spikes.TagStat.TagNames{tagStatus}];
    else tagName=[];
    end
end
FileName=[Analysis.Parameters.Name '-' thisC_Name tagName]
DirEvents=[pwd filesep ['Figure_Spikes' tagName] filesep];
if isfolder(DirEvents)==0
    mkdir(DirEvents);
end
DirFile=[DirEvents FileName];
saveas(gcf,DirFile,'png');
if Analysis.Parameters.Illustrator
	saveas(gcf,DirFile,'epsc');
end
close 'Figure TT';    
end