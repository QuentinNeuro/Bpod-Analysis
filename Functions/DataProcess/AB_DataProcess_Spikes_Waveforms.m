% function stats=AB_DataProcess_Spikes_Waveforms(Analysis,action,cellID,wf1,wf2)
%29 is TT_380

action='FWHM';

cellNb=3;
cellID=Analysis.AllData.AllCells.CellName{cellNb};
dataTS=Analysis.Core.SpikesTS{cellNb};
wf1=Analysis.Core.SpikesWV{cellNb};
wf2=Analysis.Tagging.(cellID).Early.Waveforms;

nCh=size(wf1,1);
sampRate=Analysis.Parameters.Spikes.SamplingRate;
wfTime=(1:size(wf1,2))*1000/sampRate;

switch action
    case 'FWHM'
        wf1_AVG=-mean(wf1,3);
    for c=1:nCh
        PSF_Fit=fit(wfTime',wf1_AVG(c,:)','gauss1');
        FWHM(c) = 2*sqrt(log(2)) * PSF_Fit.c1;
        % subplot(1,nCh,c)
        % plot(PSF_Fit,wfTime,wfAVG(c,:))
    end

    case 'xcorr'
        c=1;
        thiswf1=reshape(wf1(c,:,:),size(wf1,2),size(wf1,3));
        % thiswf1=(:,)
        thiswf2=reshape(wf2(c,:,:),size(wf2,2),size(wf2,3));
        thiswf2=thiswf2(~isnan(thiswf2));
    %     wf1_AVG=mean(wf1,3);
    %     wf2_AVG=mean(wf2,3);
    % 
    % 
    % pr = corrcoef(wave_spont(1:rng),wave_evoked(1:rng));
    % R = pr(1,2);

end