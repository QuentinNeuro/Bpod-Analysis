function AP_Continuous_FiltersAndPlot(Analysis)

%% Parameters
trialType='AllData';
sampRate=Analysis.Parameters.NidaqDecimatedSR;
wheelTest=0;
wheelThreshold=10;
nTrials=Analysis.AllData.nTrials;
if Analysis.Parameters.Wheel
    if max(Analysis.AllData.Wheel.Distance)>0
        wheelTest=1;
        doDiffW=1;
        w={};
    end
end
    fiber2Test=0;
if size(Analysis.Parameters.PhotoCh,2)>1
    fiber2Test=1;
end
% Reward PSTH
tw=[-1 4];
lickT=Analysis.Parameters.LicksOutcome;
% Cross correlogram
maxlag=5;
doSmooth=0;
doDetrend=3;
maxlag=maxlag*sampRate;
% Figure
ySP=nTrials+1;
xSP=3; %1+wheelTest+fiber2Test;


%% Data : Reward PSTH
thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{1}));
licks=Analysis.(trialType).Licks.Events;
timeF=Analysis.(trialType).(thisChStruct).Time;
dataF=Analysis.(trialType).(thisChStruct).DFF;
[timeRewF,dataRewF,licksRew]=AP_Continuous_RewPSTH(Analysis,timeF,dataF,tw,sampRate);
dataRewF_AVG=mean(dataRewF,1,'omitnan');
dataRewF_SEM=std(dataRewF,[],1,'omitnan')/sqrt(size(dataRewF,1));

if wheelTest
    timeW=Analysis.(trialType).Wheel.Time;
    dataW=Analysis.(trialType).Wheel.Distance;
    if doDiffW
        dataW=abs(diff(dataW'))';
        dataW(:,end+1)=dataW(:,end);
    end
    [timeRewW,dataRewW]=AP_Continuous_RewPSTH(Analysis,timeW,dataW,tw,sampRate);
    dataRewW_AVG=mean(dataRewW,1,'omitnan');
    dataRewW_SEM=std(dataRewW,[],1,'omitnan')/sqrt(size(dataRewW,1));

end
if fiber2Test
    thisChStruct=sprintf('Photo_%s',char(Analysis.Parameters.PhotoCh{2}));
    timeF2=Analysis.(trialType).(thisChStruct).Time;
    dataF2=Analysis.(trialType).(thisChStruct).DFF;
    [timeRewF2,dataRewF2]=AP_Continuous_RewPSTH(Analysis,timeF2,dataF2,tw,sampRate);
    dataRewF2_AVG=mean(dataRewF2,1,'omitnan');
    dataRewF2_SEM=std(dataRewF2,[],1,'omitnan')/sqrt(size(dataRewF2,1));
end

%% Data : Cross correlogram - Assumes that NaN are the same in d,w and f2 - easy to correct eventually
d={};
tnonan={};
for t=1:nTrials
    tnonan{t}=timeF(t,~isnan(dataF(t,:)));
    d{t}=dataF(t,~isnan(dataF(t,:)));
    if doDetrend
        x=1:length(d{t});
        p1=polyfit(x,d{t},doDetrend);
        dfit=polyval(p1,x);
        d{t}=d{t}-dfit;
    end
    if doSmooth
        d{t}=smoothdata(d{t});
    end
end

if wheelTest
    ccFW=[];
    lagsRW=[];
    for t=1:nTrials
        w{t}=dataW(t,~isnan(dataF(t,:)));
    if doSmooth
        w{t}=smoothdata(w{t});
    end
    if sum(w{t})>wheelThreshold
        [ccFW(:,end+1),lagsRW(end+1,:)]=xcorr(d{t},w{t},maxlag,'normalized');
    end
    end
    ccFW_AVG=mean(ccFW,2,'omitnan');
    ccFW_SEM=std(ccFW,[],2,'omitnan')/sqrt(size(ccFW,2));
end

if fiber2Test
    ccF1F2=[];
    lagsRF2=[];
    for t=1:nTrials
        d2{t}=dataF2(t,~isnan(dataF(t,:)));
        if doDetrend
            x=1:length(d2{t});
            p1=polyfit(x,d2{t},doDetrend);
            dfit=polyval(p1,x);
            d2{t}=d2{t}-dfit;
        end
        if doSmooth
            d2{t}=smoothdata(d2{t});
        end
        [ccF1F2(:,end+1),lagsRF2(end+1,:)]=xcorr(d{t},d2{t},maxlag,'normalized');
    end
    ccF1F2_AVG=mean(ccF1F2,2,'omitnan');
    ccF1F2_SEM=std(ccF1F2,[],2,'omitnan')/sqrt(size(ccF1F2,2));
end

%% Figure
figure('Name','Continuous_Analysis')
if ~isempty(timeRewF)
subplot(ySP,xSP,2);
shadedErrorBar(timeRewF(1,:),dataRewF_AVG,dataRewF_SEM,'-k',0);
ylabel('Fluo'); xlabel('Time from reward (s)');
if wheelTest
    yyaxis("right");
    shadedErrorBar(timeRewW(1,:),dataRewW_AVG,dataRewW_SEM,'-b',0);
    ylabel('Running');
end
end
counterSPcc=1;
cpinterSPlc=3;
if wheelTest && ~isempty(lagsRW)
    subplot(ySP,xSP,counterSPcc); hold on;
    shadedErrorBar(lagsRW(1,:)/sampRate,ccFW_AVG,ccFW_SEM,'-k',0);
        xlabel('lag (s)'); ylabel('Fluo-Run');
    subplot(ySP,xSP,cpinterSPlc); hold on;
    plot(cell2mat(d),cell2mat(w),'ok');
        xlabel('Fluo'); ylabel('Run');

end
if fiber2Test
    subplot(ySP,xSP,counterSPcc)
    shadedErrorBar(lagsRF2(1,:)/sampRate,ccF1F2_AVG,ccF1F2_SEM,'-k',0);
    counterSPcc=3;
end


counterSP=xSP+1:xSP+xSP;
for t=1:nTrials
subplot(ySP,xSP,counterSP); hold on
plot(tnonan{t},d{t},'-k');
plot(licks{t},ones(size(licks{t}))*max(d{t}),'vb');
ylabel('Fluo');
if fiber2Test
    plot(tnonan{t},d2{t},'-g')
end
if wheelTest
    yyaxis("right");
    plot(tnonan{t},w{t},'-b')
    ylabel('Running');
end
counterSP=counterSP+xSP;

end

xlabel('Time (s)');


%% Save
saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name '_Continuous.png']);
if Analysis.Parameters.Illustrator
saveas(gcf,[Analysis.Parameters.DirFig Analysis.Parameters.Name '_Continuous','epsc']);
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%% Nested Functions %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
function [PSTHtime,PSTHdata,PSTHlicks]=AP_Continuous_RewPSTH(Analysis,time,data,tw,sampRate)
    PSTHlicks={};
    PSTHtime=[];
    PSTHdata=[];
    for thisTrial=1:Analysis.AllData.nTrials
        zeroT=Analysis.AllData.Time.Zero(thisTrial);
        rewTS=[Analysis.Core.States{1,thisTrial}.Outcome(1) Analysis.Core.States{1,thisTrial}.Outcome2(1) Analysis.Core.States{1,thisTrial}.Outcome3(1)];
        rewTS=rewTS-zeroT;
        licksTS=Analysis.AllData.Licks.Events{1,thisTrial};
        for thisR=rewTS
            thisLicksTS=licksTS-thisR;
            if sum(thisLicksTS>0 & thisLicksTS<2)
                timeToZero=thisR-time(1);
                PSTHlicks{end+1}=thisLicksTS(thisLicksTS>=tw(1) & thisLicksTS<=tw(2));
                try
                [PSTHtime(end+1,:),PSTHdata(end+1,:)]=AP_PSTH(data(thisTrial,:),tw,timeToZero,sampRate);
                catch
                    disp('Nodata for this PSTH');
                end
            end
        end
    end
end
end