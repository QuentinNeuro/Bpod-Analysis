function peakStats=AB_Events(time,data,testMin,peakT,minT,minTW,wvTW,show)
% Function based on matlab findpeaks function. Uses a different way to
% calculate the prominence value by searching the minimum left of the
% detected peak. 
% time and data : should be trials x sample.
% testMin : methods to find minimum. I am using 'miniLocal' by default
% peakT and minT : works fine with peakT between std(data) and std(data)/2 and peakT/2;
% wv : is the duration of the desired waveform (in sample points)
% show : shows a trial example

%% test block
% testMin='miniLocal';
% data=Analysis.AllData.Photo_470.DFF;
% time=Analysis.AllData.Photo_470.Time;
% stdData=std(data(:),'omitnan');
% peakT=stdData*0.5;
% minT=peakT*0.5;
% minTW='auto';
% show=1;
% wv=Analysis.Parameters.NidaqDecimatedSR*Analysis.Parameters.EventWV;

%% Parameters
nTrials=size(data,1);
% debugging variables
countLMerror=0;
countLMIdx=[];
% waveform time window;
wvStart=-floor(0.5*wvTW);
% initialize some variables
peakStats.trials=[];
peakStats.noPeaks=[];

for t=1:nTrials
    thisData=data(t,:)';
    thisTime=time(t,:)';
%% run findpeaks
    [thisAmp,thisIdx,thisWidth]=findpeaks(thisData,'MinPeakProminence',peakT);
    nbOfPeaks=length(thisIdx);
    thisTS=thisTime(thisIdx);
%% find left minimum to calculate prominences
    thisIdx=[1 ; thisIdx];                                                % pad the peak indices with a 1 to streamline the first peak min detection
    for p=1:nbOfPeaks
% define windows to look for minimum
        if ischar(minTW)
            startTW=thisIdx(p+1)-ceil(1.5*thisWidth(p));
        elseif minTW
            startTW=thisIdx(p+1)-minTW;
        else
            startTW=thisIdx(p);
        end
        if startTW<1
            startTW=1;
        end
        thisPeakWindow=thisData(startTW:thisIdx(p+1));
% Find Minimum
        switch testMin
            case 'mini'
                [thisMinAmp(p),minIdx]=min(thisPeakWindow);
            case 'miniLocal'
                [minIdx_bin]=islocalmin(thisPeakWindow,'MinProminence',minT);
                minIdx=find(minIdx_bin,1,'last');
                if ~isempty(minIdx)
                    thisMinAmp(p)=thisPeakWindow(minIdx);
                else
                    [thisMinAmp(p),minIdx]=min(thisPeakWindow);
                    countLMerror=countLMerror+1;
                    countLMIdx(countLMerror,:)=[t,p];
                end
        end
    thisMinIdx(p)=minIdx+startTW-1;
    thisPeakProm(p)=thisAmp(p)-thisMinAmp(p);

%% FWHM and AUC
    halfProm(p)=thisAmp(p)-thisPeakProm(p)/2;
    leftFWHM=find(thisData(1:thisIdx(p+1))<=halfProm(p),1,'last');
    rightFWHM=find(thisData(thisIdx(p+1):end)<=halfProm(p),1,'first');
    if isempty(leftFWHM) || isempty(rightFWHM) % means that we are missing the data left or right to get an accurate FWHM estimate.
        FWHMIdx(:,p)=[NaN NaN];
        promFWHM(p)=NaN;
        AUCFWHMProm(p)=NaN;
    else
        FWHMIdx(:,p)=[leftFWHM rightFWHM+thisIdx(p+1)-1];
        promFWHM(p)=diff(FWHMIdx(:,p));
        thisAUCData=thisData(FWHMIdx(1,p):FWHMIdx(2,p))-thisData(FWHMIdx(1,p));
        AUCFWHMProm(p)=trapz(thisAUCData);
    end

%% Waveforms extraction    
    thisWV=nan(1,(wvTW-wvStart));
    if (thisMinIdx(p)+wvStart)<1
        lengthWV=length(thisData(1:(thisMinIdx(p)+wvTW)));
        thisWV(end-lengthWV+1:end)=thisData(1:(thisMinIdx(p)+wvTW));

    elseif (thisMinIdx(p)+wvTW)>length(thisData)
        lengthWV=length(thisData((thisMinIdx(p)+wvStart):end));
        thisWV(1:lengthWV)=thisData((thisMinIdx(p)+wvStart):end);
    else
        thisWV=thisData((thisMinIdx(p)+wvStart+1):(thisMinIdx(p)+wvTW));
    end
    waveforms(:,p)=thisWV-thisMinAmp(p);
    end
%% Save data in structure
startStructIdx=length(peakStats.trials)+1;
if nbOfPeaks
thisStructIdx=startStructIdx:(startStructIdx+nbOfPeaks-1);

peakStats.trials(thisStructIdx)=t*ones(1,nbOfPeaks);
peakStats.amp(thisStructIdx)=thisAmp;
peakStats.peakIdx(thisStructIdx)=thisIdx(2:end);
peakStats.TS(thisStructIdx)=thisTS;
peakStats.prom(thisStructIdx)=thisPeakProm;
peakStats.FWHM(thisStructIdx)=promFWHM;
peakStats.FWHMIdx(:,thisStructIdx)=FWHMIdx;
peakStats.AUCFWHMProm(thisStructIdx)=AUCFWHMProm;

peakStats.min(thisStructIdx)=thisMinAmp;
peakStats.minIdx(thisStructIdx)=thisMinIdx;
peakStats.waveforms(:,thisStructIdx)=waveforms;
else
peakStats.trials(startStructIdx)=t;
peakStats.noPeaks=[peakStats.noPeaks t];
end

% clear variable
clear thisAmp thisIdx thisTS thisPeakProm promFWHM FWHMIdx AUCFWHMProm thisMinAmp thisMinIdx waveforms;
end
%% Normalize
noPeakIdx=ismember(peakStats.trials,peakStats.noPeaks);
normFactor=median(peakStats.prom(~noPeakIdx),'omitnan');
peakStats.promNorm=peakStats.prom/normFactor;
peakStats.waveformsNorm=peakStats.waveforms/normFactor;
peakStats.AUCFWHMPromNorm=peakStats.AUCFWHMProm/normFactor;

%% NaN missing trials
if ~isempty(peakStats.noPeaks)
    peakStats.noPeaks
    trialSave=peakStats.trials;
    noPeakIdx=ismember(peakStats.trials,peakStats.noPeaks);
    peakField=fieldnames(peakStats);
    for f=1:size(peakField,1)
        peakStats.(peakField{f})(:,noPeakIdx)=NaN;
    end
    peakStats.trials=trialSave;
end
%% Waveform timewindow
peakStats.waveformTW=time(1,1:size(peakStats.waveforms,1))'-time(1,1);
peakStats.waveformTW=peakStats.waveformTW-peakStats.waveformTW(abs(wvStart));
%% Session indexing
peakStats.session=ones(size(peakStats.trials));

%% show a trial output
if show
fig_t=18; %randi(nTrials);
fig_tIdx=peakStats.trials==fig_t;
% fig_t=78;
fig_dy=data(fig_t,:);
fig_dy=data(fig_t,:);
fig_py=peakStats.amp(fig_tIdx);
fig_px=peakStats.peakIdx(fig_tIdx);
fig_my=peakStats.min(fig_tIdx);
fig_mx=peakStats.minIdx(fig_tIdx);

figure()
subplot(1,3,1)
findpeaks(data(fig_t,:),'MinPeakProminence',peakT,'Annotate','extents')
subplot(1,3,2);hold on;
title(sprintf('trial %.0d',fig_t))
plot(fig_dy,'-b');
plot(fig_px,fig_py,'xr');
plot(fig_mx,fig_my,'xg');
for p=1:length(fig_py)
    plot([fig_px(p) fig_px(p)],[fig_my(p) fig_py(p)],'-k')
end
subplot(1,3,3)
plot(peakStats.waveforms(:,fig_tIdx),'-k');

end
end