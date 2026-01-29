function AB_Continuous_FiltersAndPlot2(Analysis)

%% Parameters
switch Analysis.Parameters.Data.RecordingType
    case 'Photometry'
dataField=Analysis.Parameters.Photometry.CellID;
wheelField=[];
if Analysis.Parameters.Wheel.Wheel
    wheelField='Wheel';
    if max(Analysis.AllData.Wheel.Data)>0
        wheelField='Wheel';
        doDiffW=1;
        w={};
    end
end
    otherwise
        disp('Continuous plot only for photometry')
        return
end

% Trial Type
trialType='AllData';
nTrials=Analysis.(trialType).nTrials;
% Photometry
dataF=[];
sampRate=Analysis.Parameters.Data.SamplingRateDecimated;
% Wheel
dataW=[];
wheelThreshold=10;
% Correlation
maxlag=5;
doSmooth=0;
doDetrend=3;
maxlag=maxlag*sampRate;
% Figure
tw=[-1 4];
ySP=nTrials+1;
xSP=3; %1+wheelTest+fiber2Test;
color='kg';

%% Reward PSTH
licks=Analysis.(trialType).Licks.Events;
for c=1:size(dataField,2)
    time=Analysis.(trialType).(dataField{c}).Time;
    dataF{c}=Analysis.(trialType).(dataField{c}).Data;
    [timeRew{c},dataRew{c},licksRew{c}]=AB_Continuous_RewPSTH(Analysis,time(1,:),dataF{c},tw,sampRate);
    dataRew_AVG(c,:)=mean(dataRew{c},1,'omitnan');
    dataRew_SEM(c,:)=std(dataRew{c},[],1,'omitnan')/sqrt(size(dataRew,1));
end
if wheelField
    timeW=Analysis.(trialType).(wheelField).Time;
    dataW=Analysis.(trialType).(wheelField).Data;
    dataW=abs(diff(dataW'))';
    dataW(:,end+1)=dataW(:,end);
    [timeWRew,dataWRew,licksRew]=AB_Continuous_RewPSTH(Analysis,timeW(1,:),dataW,tw,sampRate);
    dataWRew_AVG=mean(dataWRew,1,'omitnan');
    dataWRew_SEM=std(dataWRew,[],1,'omitnan')/sqrt(size(dataWRew,1));
end

%% Cross-correlogram
ccFluo=[];
ccFluo_Lag=[];
if size(dataField,2)>1
    for t=1:nTrials
% Preprocessing
        thisData=[];
        for c=1:size(dataField,2)
            nanIdx=isnan(dataF{c}(t,:));
            thisData{c}(t,:)=dataF{c}(t,~nanIdx);
            if doDetrend
                x=1:length(thisData{c}(t,:));
                p1=polyfit(x,thisData{c}(t,:),doDetrend);
                dfit=polyval(p1,x);
                thisData{c}(t,:)=thisData{c}(t,:)-dfit;
            end
            if doSmooth
                thisData{c}(t,:)=smoothdata(thisData{c}(t,:));
            end
% Wheel cc to come
% ccFW=[];
% lagsRW=[];
% thisWheel=dataW(t,~isnan(thisData{c}));
% if doSmooth
%     thisWheel=smoothdata(thisWheel);
% end
% if sum(w{t})>wheelThreshold
%     [ccFW(:,end+1),lagsRW(end+1,:)]=xcorr(d{t},w{t},maxlag,'normalized');
% end
        end
% Correlation
        [ccFluo(t,:),ccFluo_Lag(t,:)]=xcorr(thisData{1}(t,:),thisData{2}(t,:),maxlag,'normalized');
    end
    ccFluo_AVG=mean(ccFluo,1,'omitnan');
    ccFluo_SEM=std(ccFluo,[],1,'omitnan')/sqrt(size(ccFluo,1));
end

%% Figure
figure('Name','Continuous_Analysis')
counterSP=xSP+1:xSP:ySP*xSP;
% Licks
for t=1:nTrials
    subplot(ySP,xSP,counterSP(t):counterSP(t)+xSP-1); hold on
    plot(licks{t},ones(size(licks{t}))*max(dataF{1}(t,:)),'vb');
end
% Photometry
for c=1:size(dataField,2)
    if ~isempty(dataRew_AVG)
    subplot(ySP,xSP,1); hold on;
    shadedErrorBar(timeRew{c}(1,:),dataRew_AVG(c,:),dataRew_SEM(c,:),['-' color(c)],0);
    xlabel('Time from reward (s)'); ylabel('Fluo');
    end
    for t=1:nTrials
        subplot(ySP,xSP,counterSP(t):counterSP(t)+xSP-1); hold on
        plot(time(t,:),dataF{c}(t,:),['-' color(c)]);
        ylabel('Fluo')
    end
    xlabel('Time (s)')
end
% Wheel
if ~isempty(dataW)
    for t=1:nTrials
            subplot(ySP,xSP,counterSP(t):counterSP(t)+xSP-1); hold on
            yyaxis right
            plot(timeW(t,:),dataW(t,:),'-b');
            ylabel('Run')
    end
end

% CC
if ~isempty(ccFluo)
    subplot(ySP,xSP,2); hold on;
    shadedErrorBar(ccFluo_Lag(1,:)/sampRate,ccFluo_AVG,ccFluo_SEM,'-k',0);
    xlabel('lag (s)'); ylabel('Fluo xcorr');
end

%% Save
saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name '_Continuous.png']);
if Analysis.Parameters.Plot.Illustrator
saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name '_Continuous','epsc']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Nested Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [PSTHtime,PSTHdata,PSTHlicks]=AB_Continuous_RewPSTH(Analysis,time,data,tw,sampRate)
    PSTHlicks={};
    PSTHtime=[];
    PSTHdata=[];
    for thisTrial=1:Analysis.AllData.nTrials
        zeroT=Analysis.AllData.Time.Zero(thisTrial);
        rewTS=[Analysis.Core.States{1,thisTrial}.Outcome(1) Analysis.Core.States{1,thisTrial}.Outcome2(1) Analysis.Core.States{1,thisTrial}.Outcome3(1)];
        rewTS=rewTS-zeroT;
        licksTS=Analysis.AllData.Licks.Events{thisTrial};
        for thisR=rewTS
            thisLicksTS=licksTS-thisR;
            if sum(thisLicksTS>0 & thisLicksTS<2)
                timeToZero=thisR-time(1);
                PSTHlicks{end+1}=thisLicksTS(thisLicksTS>=tw(1) & thisLicksTS<=tw(2));
                try
                [PSTHtime(end+1,:),PSTHdata(end+1,:)]=myPSTH(data(thisTrial,:),tw,timeToZero,sampRate);
                catch
                    disp('Nodata for this PSTH');
                end
            end
        end
    end
end
end