function stats=AB_DataProcess_Spikes_Waveforms(action,wf1,wf2)
%29 is TT_380

% action='xcorr';
% sampRate=Analysis.Parameters.Spikes.SamplingRate;
% cellNb=3;
% cellID=Analysis.AllData.AllCells.CellName{cellNb};
% dataTS=Analysis.Core.SpikesTS{cellNb};
% wf1=Analysis.Core.SpikesWV{cellNb};
% wf2=Analysis.Tagging.(cellID).Early.Waveforms;

%% Parameters
nCh=size(wf1,1);

%% Data Processing
switch action
    %% Waveform statistics (eg FWHM)
    case 'Stats'
        wf1_AVGn=mean(wf1,3,'omitnan');
        wf1_STDn=std(wf1,[],3);
        wf1_max=max(max(wf1_AVGn));
        wf1_min=min(min(wf1_AVGn));
        wf1_AVGp=-wf1_AVGn;
        peakT=-mean(wf1_min)/3;
        % figure()
        for c=1:nCh
            % subplot(1,nCh,c); hold on;
            % plot(wf1_AVGn(c,:),'-k')
            % ylim([wf1_min-10 wf1_max+10])
            thisWF=wf1_AVGp(c,:);
            
            [peakAmp,peakLoc,peakWidth]=findpeaks(thisWF,'MinPeakProminence',peakT,'MinPeakDistance',length(thisWF)/2);
            nPeaks=length(peakLoc);
            if nPeaks==1
                peakX(c)=peakLoc;
                minTW=peakX(c):length(thisWF);
                wf1_minTW=thisWF(minTW);
                [minIdx_bin]=islocalmin(wf1_minTW);
                minX=find(minIdx_bin,1,'first');
                if ~isempty(minX)
                    minX=minX+peakX(c)-1;
                    minY=thisWF(minX);
                else
                    [minY,minX]=min(wf1_minTW);
                end
                peakP(c)=peakAmp-minY;

                peakP_half=peakAmp-peakP(c)/2;
                troughX(c)=minX;
                FWHMx(c,1)=find(thisWF>=peakP_half,1,'first');
                FWHMx(c,2)=find(thisWF>=peakP_half,1,'last');
                FWHMy(c)=-peakP_half;

                % plot(peakX(c),wf1_AVGn(c,peakX(c)),'or')
                % plot(troughX,wf1_AVGn(c,troughX),'or')
                % plot(FWHMx(c,:),[FWHMy(c) FWHMy(c)],'-r')
            else 
                FWHMx(c,:)=[NaN NaN];
                peakP(c)=NaN;
                peakX(c)=NaN;
                FWHMy(c)=NaN;
                troughX(c)=NaN;
            end
        end

    stats.WaveformAVG=wf1_AVGn;
    stats.WaveformSTD=wf1_STDn; 
    stats.FWHMx=FWHMx;
    stats.FWHMy=FWHMy;
    stats.peakP=peakP;
    stats.peakX=peakX;
    stats.troughX=troughX;

    %% Waveform xcorr
    case 'xcorr'
        if ~isempty(wf2)
        c=1;
        nBootStrap=[1 30];
        
        thiswf1=reshape(wf1(c,:,:),size(wf1,2),size(wf1,3));
        thiswf2=reshape(wf2(c,:,:),size(wf2,2),size(wf2,3));
        wfnan=~isnan(thiswf2);
        thiswf2=thiswf2(:,wfnan(1,:));
        nWF1=size(thiswf1,2);
        nWF2=size(thiswf2,2);
        if nBootStrap>1
        for bs=1:nBootStrap(1)
            if nBootStrap(2)<100
                wf1_idx=randi(nWF1,[nWF2*ceil(nBootStrap(2)/100),1]);
                wf2_idx=randi(nWF2,[nWF2*ceil(nBootStrap(2)/100),1]);
            else
                wf1_idx=randi(nWF1,[nWF2,1]);
                wf2_idx=1:nWF2;
            end

        end
        else
            wf1_AVG = mean(thiswf1,2);
            wf2_AVG = mean(thiswf2,2);
            [wf_corr,wf_p] = corrcoef(wf1_AVG,wf2_AVG);
            % wf_corr = wf_corr(1,2);
        end
        stats.Waveform_Corr=wf_corr(1,2);
        stats.Waveform_Pval=wf_p(1,2);
        else
        stats.Waveform_Corr=NaN;
        stats.Waveform_Pval=NaN;
        end
end
end