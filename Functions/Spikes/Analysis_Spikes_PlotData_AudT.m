function Analysis_Spikes_PlotData_AudT(Analysis,thisTT)

%% Filters
WNtypes=A_NameToTrialNumber(Analysis,'White');
ChirpTypes=A_NameToTrialNumber(Analysis,'to');
if Analysis.Parameters.nbOfTrialTypes>3
    ToneTypes=4:1:Analysis.Parameters.nbOfTrialTypes;
else
    ToneTypes=NaN;
end

%% SoundColor
color4plot={'-k';'-b';'-r';'-g';'-c';'-m';'-y';'-r'};

%% Data
TuningYAVG=NaN(Analysis.Parameters.nbOfTrialTypes,1);
TuningYMAX=NaN(Analysis.Parameters.nbOfTrialTypes,1);
TuningYSEM=NaN(Analysis.Parameters.nbOfTrialTypes,1);
TuningX=1:1:Analysis.Parameters.nbOfTrialTypes;

%% Parameters
transp=Analysis.Parameters.Transparency;
% Subplot All Spikes
xLabelAll='Time Session (s)';
xTimeAll=[Analysis.AllData.Spikes.Time.Behavior(1) Analysis.AllData.Spikes.Time.Behavior(end)]; 
yLabelSpikeAll='Spikes';
ySpikeAll=[-0.1 0.1];
% Subplot Tagging Raster
xLabelTag='Time from Laser (s)';
xTimeTag=[-0.1 0.2];
yTrialsTag1=[0 100];
yTrialsTag2=[100 200];
% Subplot Spikes Rate
xLabelBehav='Time from Sound (s)';
xTimeSpikeRate=[-3 3];
yLabelSpikeRate='Spikes (Hz)';
ySpikeRate=[0 10];
% Subplot Behavior Raster
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
subplot(4,3,1); hold on;
title(thisTT);
plot(decimate(thisSpikes_All,decimatefactor),0,'sk',...
        'MarkerSize',2,'MarkerFaceColor','k');
set(gca,'XLim',xTimeAll,'YLim',ySpikeAll);
ylabel(yLabelSpikeAll);
xlabel(xLabelAll);

%% PhotoTagging
thisTagging_Events1=cell2mat(Analysis.AllData.Spikes.Tagging.(thisTT).Events(1:100));
thisTagging_Trials1=cell2mat(Analysis.AllData.Spikes.Tagging.(thisTT).Trials(1:100));
subplot(4,3,2); hold on;
title('PhotoTagging - pre');
plot(thisTagging_Events1,thisTagging_Trials1,'sk','MarkerSize',2,'MarkerFaceColor','k');
plot([0 0],yTrialsTag1,'-r');
set(gca,'XLim',xTimeTag,'YDir','reverse');
xlabel(xLabelTag);

if size(Analysis.AllData.Spikes.Tagging.(thisTT).Events,2)>=200
thisTagging_Events2=cell2mat(Analysis.AllData.Spikes.Tagging.(thisTT).Events(101:200));
thisTagging_Trials2=cell2mat(Analysis.AllData.Spikes.Tagging.(thisTT).Trials(101:200));
subplot(6,3,3); hold on;
title('PhotoTagging - post');
plot(thisTagging_Events2,thisTagging_Trials2,'sk','MarkerSize',2,'MarkerFaceColor','k');  
plot([0 0],yTrialsTag2,'-r');
set(gca,'XLim',xTimeTag,'YDir','reverse');    
xlabel(xLabelTag);
end

%% WhiteNoise
subplot(4,3,4); hold on;
title('White Noise');
xlabel(xLabelBehav);
ylabel(yLabelSpikeRate);
if isnan(WNtypes)==false
    counter=1;
    thislegend=cell(length(WNtypes),1);
    for i=WNtypes
        thistype=sprintf('type_%.0d',i);
        hs=shadedErrorBar(Analysis.(thistype).Spikes.Behavior.(thisTT).Bin(1,:),Analysis.(thistype).Spikes.Behavior.(thisTT).AVG2,Analysis.(thistype).Spikes.Behavior.(thisTT).SEM,color4plot(i,:),transp);
        hp(counter)=hs.mainLine;
        thislegend{counter}=Analysis.(thistype).Name;
        counter=counter+1;
%         TuningYAVG(i)=Analysis.(thistype).Spikes.Behavior.(thisTT).CueAVG_AVG;
%         TuningYMAX(i)=Analysis.(thistype).Spikes.Behavior.(thisTT).CueAVGZ_AVG; %AVG_MAXZ %AVGZ_AVG
%         TuningYSEM(i)=Analysis.(thistype).Spikes.Behavior.(thisTT).CueAVG_SEM;
    end
    legend(hp,thislegend,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
end

%% Chirps
subplot(4,3,5); hold on;
title('Chirp');
xlabel(xLabelBehav);
ylabel(yLabelSpikeRate);
if isnan(ChirpTypes)==false
    counter=1;
    thislegend=cell(length(ChirpTypes),1);
    for i=ChirpTypes
        thistype=sprintf('type_%.0d',i);
        hs=shadedErrorBar(Analysis.(thistype).Spikes.Behavior.(thisTT).Bin(1,:),Analysis.(thistype).Spikes.Behavior.(thisTT).AVG2,Analysis.(thistype).Spikes.Behavior.(thisTT).SEM,color4plot(i,:),transp);
        hp(counter)=hs.mainLine;
        thislegend{counter}=Analysis.(thistype).Name;
        counter=counter+1;
%         TuningYAVG(i)=Analysis.(thistype).Spikes.Behavior.(thisTT).CueAVG_AVG;
%         TuningYMAX(i)=Analysis.(thistype).Spikes.Behavior.(thisTT).CueAVGZ_AVG; %AVG_MAXZ %AVGZ_AVG
%         TuningYSEM(i)=Analysis.(thistype).Spikes.Behavior.(thisTT).CueAVG_SEM;
    end
    legend(hp,thislegend,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
end

%% Pure Tones
subplot(4,3,6); hold on;
title('Pure Tones');
xlabel(xLabelBehav);
ylabel(yLabelSpikeRate);
if isnan(ToneTypes)==false
    counter=1;
    thislegend=cell(length(ToneTypes),1);
    for i=ToneTypes
        thistype=sprintf('type_%.0d',i);
        hs=shadedErrorBar(Analysis.(thistype).Spikes.Behavior.(thisTT).Bin(1,:),Analysis.(thistype).Spikes.Behavior.(thisTT).AVG2,Analysis.(thistype).Spikes.Behavior.(thisTT).SEM,color4plot(i,:),transp);
        hp(counter)=hs.mainLine;
        thislegend{counter}=Analysis.(thistype).Name;
        counter=counter+1;
%         TuningYAVG(i)=Analysis.(thistype).Spikes.Behavior.(thisTT).CueAVG_AVG;
%         TuningYMAX(i)=Analysis.(thistype).Spikes.Behavior.(thisTT).CueAVGZ_AVG; %AVG_MAXZ %AVGZ_AVG
%         TuningYSEM(i)=Analysis.(thistype).Spikes.Behavior.(thisTT).CueAVG_SEM;
    end
    legend(hp,thislegend,'Location','northwest','FontSize',8);
    legend('boxoff');
    clear hp hs;
end

% %% Spike Rasters
% % Cue
% for i=1:length(CueType)
%     if Analysis.(CueType{i}).nTrials>0
%     thisBehav_Events=Analysis.(CueType{i}).Spikes.Behavior.(thisTT).Events;
%     thisBehav_Trials=Analysis.(CueType{i}).Spikes.Behavior.(thisTT).Trials;
%     subplot(6,3,7+i*3); hold on;
%     title(CueType{i});
%     plot(thisBehav_Events,thisBehav_Trials,'sk','MarkerSize',2,'MarkerFaceColor','k');
%     plot([0 0],[0 max(thisBehav_Events)],'-b');
%     plot(Analysis.(CueType{1}).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
%     set(gca,'XLim',xTimeSpikes,'YDir','reverse');
%     ylabel(yLabelSpikeRaster)
%     end
% end
% xlabel(xLabelBehav);
% % Reward
% for i=1:length(RewardType)
%     if Analysis.(CueType{i}).nTrials>0
%     thisBehav_Events=Analysis.(RewardType{i}).Spikes.Behavior.(thisTT).Events;
%     thisBehav_Trials=Analysis.(RewardType{i}).Spikes.Behavior.(thisTT).Trials;
%     subplot(6,3,8+i*3); hold on;
%     title(RewardType{i});
%     plot(thisBehav_Events,thisBehav_Trials,'sk','MarkerSize',2,'MarkerFaceColor','k');
%     plot([0 0],[0 max(thisBehav_Events)],'-b');
%     plot(Analysis.(RewardType{1}).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
%     set(gca,'XLim',xTimeSpikes,'YDir','reverse'); 
%     end
% end
% xlabel(xLabelBehav);
% % Punish
% if isPunish
% for i=1:length(PunishType)
%     thisBehav_Events=Analysis.(RewardType{i}).Spikes.Behavior.(thisTT).Events;
%     thisBehav_Trials=Analysis.(RewardType{i}).Spikes.Behavior.(thisTT).Trials;
%     subplot(6,3,9+i*3); hold on;
%     title(PunishType{i});
%     plot(thisBehav_Events,thisBehav_Trials,'sk','MarkerSize',2,'MarkerFaceColor','k');
%     plot([0 0],[0 max(thisBehav_Events)],'-b');
%     plot(Analysis.(RewardType{1}).Time.Cue(1,:),[0 0],'-b','LineWidth',2);
%     set(gca,'XLim',xTimeSpikes,'YDir','reverse');   
% end
% xlabel(xLabelBehav);
% end
% 
% %% Save
% FileName=[Analysis.Parameters.Name thisTT];
% DirEvents=[pwd filesep 'Figure_Spikes' filesep];
% if isdir(DirEvents)==0
%     mkdir(DirEvents);
% end
% DirFile=[DirEvents FileName];
% saveas(gcf,DirFile,'png');
% if Analysis.Parameters.Illustrator
% 	saveas(gcf,DirFile,'epsc');
% end
% close 'Figure TT';    
end