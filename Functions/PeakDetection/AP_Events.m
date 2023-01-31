function peakStats=AP_Events(data,testMin,peakT,minT,minTW,wv,show)
% Function based on matlab findpeaks function. Uses a different way to
% calculate the prominence value by searching the minimum left of the
% detected peak. 
% data : should be trials x sample.
% peakT and minT : works fine with peakT between std(data) and std(data)/2 and peakT/2;

% test block
% testMin='miniLocal';
% data=Analysis.AllData.Photo_470b.DFF;
% stdData=std(data(:),'omitnan');
% peakT=stdData*0.5;
% minT=peakT*0.5;
% minTW='auto';
% show=1;

%% Parameters
nTrials=size(data,1);
% debugging variables
countLMerror=0;
countLMIdx=[];
counter=0;
wvStart=-floor(0.5*wv);


for t=1:nTrials
    thisData=data(t,:)';
%% run findpeaks
    [peakVal{t},peakIdx{t},peakWidths{t}]=findpeaks(thisData,'MinPeakProminence',peakT);
%% find left minimum to calculate prominences
    thisPIdx=[1 ; peakIdx{t}];                                                % pad the peak indices with a 1 to streamline the first peak min detection
    nbOfPeaks=length(peakIdx{t});
    for p=1:nbOfPeaks
% define windows to look for minimum
        if ischar(minTW)
            startTW=thisPIdx(p+1)-ceil(1.5*peakWidths{t}(p));
        elseif minTW
            startTW=thisPIdx(p+1)-minTW;
        else
            startTW=thisPIdx(p);
        end
        if startTW<1
            startTW=1;
        end
        thisPeakWindow=thisData(startTW:thisPIdx(p+1));
% Find Minimum
        switch testMin
            case 'mini'
                [thisMin,thisMinIdx]=min(thisPeakWindow);
            case 'miniLocal'
                [minIdx_bin,thisMin]=islocalmin(thisPeakWindow,'MinProminence',minT);
                thisMinIdx=find(minIdx_bin,1,'last');
                thisMin=thisPeakWindow(thisMinIdx);
                if isempty(thisMinIdx)
                    [thisMin,thisMinIdx]=min(thisPeakWindow);
                    countLMerror=countLMerror+1;
                    countLMIdx(countLMerror,:)=[t,p];
                end
        end

    minVal{t}(p)=thisMin;
    minIdx{t}(p)=thisMinIdx+startTW-1;

    promVal{t}(p)=peakVal{t}(p)-thisMin;

%% FWHM and AUC
    halfProm{t}(p)=peakVal{t}(p)-promVal{t}(p)/2;
    leftFWHM=find(thisData(1:thisPIdx(p+1))<=halfProm{t}(p),1,'last');
    rightFWHM=find(thisData(thisPIdx(p+1):end)<=halfProm{t}(p),1,'first');
    if isempty(leftFWHM) || isempty(rightFWHM) % means that we are missing the data left or right to get an accurate FWHM estimate.
        FWHMIdx{t}(p,:)=[NaN NaN];
        promFWHM{t}(p)=NaN;
        AUCProm{t}(p)=NaN;
    else
        FWHMIdx{t}(p,:)=[leftFWHM rightFWHM];
        promFWHM{t}(p)=diff(FWHMIdx{t}(p,:));
        AUCProm{t}(p)=trapz(thisData(FWHMIdx{t}(p,1):FWHMIdx{t}(p,2)))-(minVal{t}(p)+halfProm{t}(p))*diff(FWHMIdx{t}(p,:));   % cap AUC ;
%     AUCProm{t}(p)=trapz(thisData(FWHMIdx{t}(p,1):FWHMIdx{t}(p,2)))-minVal{t}(p)*diff(FWHMIdx{t}(p,:));                  % relative AUC ;
%     AUCProm{t}(p)=trapz(thisData(FWHMIdx{t}(p,1):FWHMIdx{t}(p,2)));                                                     % absolute AUC ;
    end

%% Waveforms extraction    
    if wv
        thisWV=nan(1,(wv-wvStart));
        if (minIdx{t}(p)+wvStart)<1
            lengthWV=length(thisData(1:(minIdx{t}(p)+wv)));
            thisWV(end-lengthWV+1:end)=thisData(1:(minIdx{t}(p)+wv));

        elseif (minIdx{t}(p)+wv)>length(thisData)
            lengthWV=length(thisData((minIdx{t}(p)+wvStart):end));
            thisWV(1:lengthWV)=thisData((minIdx{t}(p)+wvStart):end);
        else
            thisWV=thisData((minIdx{t}(p)+wvStart+1):(minIdx{t}(p)+wv));
        end
        waveforms{t}(p,:)=thisWV-minVal{t}(p);
    end
    counter=counter+1;

    prom4Norm(counter)=promVal{t}(p);
    end
end
%% Normalize
normFactor=median(prom4Norm,'omitnan');
for t=1:nTrials
    promValNorm{t}=promVal{t}/normFactor;
    waveformsNorm{t}=waveforms{t}/normFactor;
    AUCPromNorm{t}=AUCProm{t}/normFactor;
end

%% Save data in structure
peakStats.peakAmp=peakVal;
peakStats.peakIdx=peakIdx;
peakStats.peakWidths=peakWidths;
peakStats.peakProm=promVal;
peakStats.peakPromNorm=promValNorm;
peakStats.promFWHM=promFWHM;
peakStats.promFWHMIdx=FWHMIdx;
peakStats.AUCProm=AUCProm;
peakStats.AUCPromNorm=AUCPromNorm;
peakStats.minVal=minVal;
peakStats.minIdx=minIdx;
peakStats.waveforms=waveforms;
peakStats.waveformsNorm=waveformsNorm;
%% show a trial output
if show
fig_t=randi(nTrials);
% fig_t=78;
fig_dy=data(fig_t,:);
if smoothData
        fig_dy=smooth(fig_dy);
end
fig_dy=data(fig_t,:);
fig_py=peakVal{fig_t};
fig_px=peakIdx{fig_t};
fig_my=minVal{fig_t};
fig_mx=minIdx{fig_t};

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
plot(peakStats.waveforms{1, fig_t}','-k');

end
%end