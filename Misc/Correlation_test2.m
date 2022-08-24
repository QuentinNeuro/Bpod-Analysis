%% Parameters
maxlag=20; %in sec
doSmooth=1;
doZsc=1;
doCrop=3; % remove this number-1 of point from trial start;
doDetrend=3; % 3 is good number of degree for polyfit
doDecFCoh=10;

showFigure=1;

winR=0.5;
fs=Analysis.Parameters.NidaqDecimatedSR;
maxlag=maxlag*fs;

legSig={'VIP','ACh'};
legCoh={'Coh','Rand'};

%% Data extract
F1=[];
F2=[];
F2rand=[];
W=[];
indexR=[];
for t=1:Analysis.Core.nTrials
    thisF1=Analysis.Core.Photometry{1,t}{1,1};
    thisF2=Analysis.Core.Photometry{1,t}{2,1};
    thisW=Analysis.Core.Wheel{1,t};
    if doCrop
        thisF1=thisF1(doCrop:end);
        thisF2=thisF2(doCrop:end);
        thisW=thisW(doCrop:end);
    end
    if doSmooth
        thisF1=smooth(thisF1);
        thisF2=smooth(thisF2);
    end
    thisF2rand=thisF2(randperm(length(thisF2)));

    if Analysis.Filters.Reward(t) && Analysis.Filters.LicksOutcome(t)
        thisR=length(F1)+floor(Analysis.Core.States{1,t}.Outcome(1)*fs)-doCrop+1;
        indexR=[indexR thisR:(thisR+winR*fs)];
    end
    F1=[F1 thisF1'];
    F2=[F2 thisF2'];
    F2rand=[F2rand thisF2rand'];
	W=[W thisW'];    
end

time=(1:length(F1))/fs;

if doDetrend
    x=1:length(F1);
    p1=polyfit(x,F1,doDetrend);
    p2=polyfit(x,F2,doDetrend);
    F1fit=polyval(p1,x);
    F2fit=polyval(p2,x);
    F1=F1-F1fit;
    F2=F2-F2fit;
    F2rand=F2rand-F2fit;
else
    F1=F1-mean(F1(fs:fs+fs));
    F2=F2-mean(F2(fs:fs+fs));
end

if doZsc
    F1=F1/std(F1(fs:fs+fs));
    F2=F2/std(F2(fs:fs+fs));
    F2rand=F2rand/std(F2rand(fs:fs+fs));
end

%% Processing
[rR,lagsR]=xcorr(F1,F2,maxlag);
maxrR=max(rR);
[rRr,lagsRr]=xcorr(F1,F2rand,maxlag);
rR=rR/maxrR;
rRr=rRr/maxrR;
[rV,lagsV]=xcov(F1,F2,maxlag);
[rVr,lagsVr]=xcorr(F1,F2rand,maxlag);
[Cxy,f] = mscohere(F1,F2,[],[],[],fs);
[CxyR,fR] = mscohere(F1,F2rand,[],[],[],fs);

if doDecFCoh
    Cxy=decimate(Cxy,doDecFCoh);
    CxyR=decimate(CxyR,doDecFCoh);
    f=decimate(f,doDecFCoh);
    fR=decimate(fR,doDecFCoh);
end

if exist('rR_AVG')
    rR_AVG=[rR_AVG ; rR];
    lagsR_AVG=[lagsR_AVG ; lagsR];
    rRr_AVG=[rRr_AVG ; rRr];
    lagsRr_AVG=[lagsRr_AVG ; lagsRr];
else
    rR_AVG=rR;
    lagsR_AVG=lagsR;
    rRr_AVG=rRr;
    lagsRr_AVG=lagsRr;
end

%% Figure
if showFigure
figure()
subplot(3,2,1); hold on;
plot(time,F1,time,F2)
plot(indexR/fs,max([max(F1) max(F2)])*ones(length(indexR),1),'sb','MarkerFaceColor','blue');
yyaxis right
plot(time,W,'-k');
legend(legSig);
subplot(3,2,2); hold on;
plot(F1,F2,'ok');
plot(F1(indexR),F2(indexR),'ob');
subplot(3,2,3); hold on
plot(lagsR/fs,rR,lagsRr/fs,rRr);
title('xCor')
subplot(3,2,4); hold on

plot(lagsR/fs,mean(rR_AVG,1),lagsRr/fs,mean(rRr_AVG,1))
plot(lagsR/fs,rR_AVG,'-k')
plot(lagsR/fs,rRr_AVG,'-g')
title('xVar')
subplot(3,2,5); hold on;
% semilogx(f,Cxy,fR,CxyR); grid on;
plot(f,Cxy);
plot(fR,CxyR);
% semilogx(f,CXy)
xlabel('Frequency');
ylabel('Coherence');
xlim([0 5]);
legend(legCoh)
end