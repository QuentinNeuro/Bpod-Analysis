%% Parameters
thisType='type_1';
thisTrial=1;
thisCh='Photo_470';
limX=[80 100];
limY=[-5 15];
thisTrialPlot=1;
%% Data
% thisTime=Analysis.(thisType).(thisCh).Time(thisTrialPlot,:);
% thisFluoA=Analysis.(thisType).Photo_470.DFF(thisTrial,:);
% thisFluoB=Analysis.(thisType).Photo_470b.DFF(thisTrial,:);
% YMAX=10
% thisTS=Analysis.(thisType).Oddball.Odd{1,thisTrialPlot}(:,1);
% thisTSY=YMAX*ones(size(thisTS));
% % crop data
% thisTime=thisTime(20:2000);
% thisFluoA=thisFluoA(:,20:2000);
% thisFluoB=thisFluoB(:,20:2000);
% from database
thisTime=Oddball.FreqAnalysis.Time{1,1};
thisFluoA=[];
thisFluoAAVG=[];
thisFluoB=[];
thisFluoBAVG=[];
for thisA=1:size(Oddball.FreqAnalysis.Time,2)
    thisFluoA=[thisFluoA ; Oddball.FreqAnalysis.Photo_470{1,thisA}(:,1:2000)];
    thisFluoB=[thisFluoB ; Oddball.FreqAnalysis.Photo_470b{1,thisA}(:,1:2000)];
end

%% Spectral analysis
% https://www.mathworks.com/help/matlab/math/basic-spectral-analysis.html
fs=20;
n=length(thisFluoA);
% fft
thisFTA=fft(thisFluoA');
thisFTB=fft(thisFluoB');
f=(0:n-1)*(fs/n); % frequency range
powerA=abs(thisFTA).^2/n;
powerB=abs(thisFTB).^2/n;
powerA_AVG=mean(powerA,2);
powerA_SEM=std(powerA,[],2)/size(powerA,2);
powerB_AVG=mean(powerB,2);
powerB_SEM=std(powerB,[],2)/size(powerA,2);
% shift
thisFTA0=fftshift(thisFluoA);
thisFTB0=fftshift(thisFluoB);
f0 = (-n/2:n/2-1)*(fs/n); % 0-centered frequency range
powerA0 = abs(thisFTA0).^2/n;
powerB0 = abs(thisFTB0).^2/n;
% spectrogram


%% Figure
figure()
% subplot(3,2,[1 2])
% hold on
% plot(thisTime,thisFluoA(thisTrialPlot,:),'-k');
% plot(thisTime,thisFluoB(thisTrialPlot,:),'-g');
% plot(thisTS,thisTSY,'vr');
% legend({'ACx','mPFC'});
% xlim([15 35]); ylim([-5 15]);
% % fft
subplot(3,2,3)
hold on
plot(f,powerA,'-k')
plot(f,powerB,'-g')
% xlim([0 2]); ylim([0 500]);
subplot(3,2,4)
hold on
plot(f0,powerA0,'-k')
plot(f0,powerB0,'-g')
% xlim([-2 2]);
subplot(3,2,5)
hold on
shadedErrorBar(f,powerA_AVG,powerA_SEM,'k',0);
shadedErrorBar(f,powerB_AVG,powerB_SEM,'g',0);
xlim([0 2]); ylim([0 500]);