%% 405 vs 470 plot
signalChIdx=2;
ctrlChIdx=1;
trial=2;
limTime=[10 20];

signalAllProcess=0;
signalTrialProcess=0;
meanSub=1;
meanDiv=0;
zeroPlots=0;

%% Raw Data extraction and some processing
sigData=[];
ctlData=[];
tIndex=[];
nTrials=Analysis.Core.nTrials;
sr=Analysis.Parameters.NidaqDecimatedSR;
for t=1:nTrials
    thisSignal=Analysis.Core.Photometry{1,t}{signalChIdx,1}';
    thisCtrl=Analysis.Core.Photometry{1,t}{ctrlChIdx,1}';
    if signalTrialProcess
        meanSignal=mean(thisSignal(sr:sr*2));
        meanCtrl=mean(thisCtrl(sr:sr*2));
        if meanSub
            thisSignal=thisSignal-meanSignal;
            thisCtrl=thisCtrl-meanCtrl;
        end
        if meanDiv
            thisSignal=thisSignal/meanSignal;
            thisCtrl=thisCtrl/meanCtrl;
        end
    end
    sigData=[sigData thisSignal];
    ctlData=[ctlData thisCtrl];
    tIndex=[tIndex t*ones(size(Analysis.Core.Photometry{1,t}{signalChIdx,1}'))];
end
time=1/sr:1/sr:length(sigData)/sr;

if signalAllProcess
        meanSignal=mean(sigData(sr:sr*2));
        meanCtrl=mean(ctlData(sr:sr*2));
        if meanSub
            sigData=sigData-meanSignal;
            ctlData=ctlData-meanCtrl;
        end
        if meanDiv
            sigData=sigData/meanSignal;
            ctlData=ctlData/meanCtrl;
        end
end
% Trial
sigData_Trial=sigData(tIndex==trial);
ctlData_Trial=ctlData(tIndex==trial);
time_Trial=time(tIndex==trial);
thisType=Analysis.Parameters.TrialNames{Analysis.Core.TrialTypes(trial)};

%% Fit
%bls = polyfit(data.streams.(ISOS).data,data.streams.(GCAMP).data,1);
% All
model_all=fitlm(ctlData,sigData);
a1=model_all.Coefficients.Estimate(2);
b1=model_all.Coefficients.Estimate(1);
ctlData_fit=a1*ctlData+b1;
% First
model_first=fitlm(ctlData_Trial,sigData_Trial);
a2=model_first.Coefficients.Estimate(2);
b2=model_first.Coefficients.Estimate(1);
ctlData_Trial_fit=a2*ctlData_Trial+b2;

% fitDFF
sigData_fit=(sigData-ctlData_fit)./ctlData_fit;
sigData_Trial_fit=(sigData_Trial-ctlData_Trial_fit)./ctlData_Trial_fit;

%% Figure
% if zeroPlots
%     theZeros=[]
figure()
subplot(2,3,[1 2]); hold on;
plot(time,sigData,'-k');
plot(time,ctlData,'-b');
plot(time,ctlData_fit,'-c');
title('All');
xlim(limTime); ylim([0.5 1]);
ylabel('Voltage')
subplot(2,3,3);hold on;
plot(time_Trial,sigData_Trial,'-k');
plot(time_Trial,ctlData_Trial,'-b');
plot(time_Trial,ctlData_Trial_fit,'-c');
ylim([0.5 1]);
title(thisType);
legend('ACh sensor','','mutant ACh');

if ~signalAllProcess && ~signalTrialProcess
    thisSigData=(sigData-mean(sigData))/mean(sigData);
    thisSigData_Trial=(sigData_Trial-mean(sigData_Trial))/mean(sigData_Trial);
    else
    thisSigData=sigData;
    thisSigData_Trial=sigData_Trial;
end

subplot(2,3,[4 5]); hold on;
plot(time,thisSigData,'-k');
plot(time,sigData_fit,'-g');
xlim(limTime);
subplot(2,3,6);hold on;
plot(time_Trial,thisSigData_Trial,'-k');
plot(time_Trial,sigData_Trial_fit,'-g');
legend('DFF','FittedDFF');
ylabel('Norm Fluo');
xlabel('Time (s)');

