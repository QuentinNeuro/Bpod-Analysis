function Photo=AP_DataCore_Photometry(SessionData,Analysis,thisTrial)
%% Photometry
if Analysis.Parameters.Photometry.Photometry
% Parameters  
decimateFactor=Analysis.Parameters.Data.NidaqDecimateFactor;
sampRate=Analysis.Parameters.Data.NidaqSamplingRate;
duration=SessionData.TrialSettings(1).GUI.NidaqDuration;
phase=Analysis.Parameters.Photometry.Phase;
nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);

% Data
Photo=cell(nbOfChannels,1);
for thisCh=1:nbOfChannels
    thisNidaqField=Analysis.Parameters.Photometry.NidaqField{thisCh};
    if Analysis.Parameters.Photometry.Modulation 
        thisAmp=SessionData.TrialSettings(thisTrial).GUI.(Analysis.Parameters.Photometry.AmpField{thisCh});
        if thisAmp
            thisFreq=SessionData.TrialSettings(thisTrial).GUI.(Analysis.Parameters.Photometry.FreqField{thisCh});
            thisRawData=SessionData.(thisNidaqField){1,thisTrial}(:,1);
            thisData=AP_Demodulation(thisRawData,sampRate,thisFreq,15,phase);
        else    % Amplitude=0 for this channel for this trial
            thisData=NaN(1,duration*sampRate/decimateFactor);
        end
    else        % no modulation of this channel for this trial
        if ~isfield(SessionData,'DecimatedSampRate')
            thisData=SessionData.(thisNidaqField){1,thisTrial}(:,1);
        else % Archived file
            thisData=SessionData.(thisNidaqField){1,thisTrial}(:,Analysis.Parameters.Photometry.ModulData(thisCh)-1)';
            if size(thisData,2)==1
                thisData=SessionData.(thisNidaqField){1,thisTrial}(Analysis.Parameters.Photometry.ModulData(thisCh)-1,:);
            end
        end
    end
    if ~isnan(thisData)
    thisData=decimate(thisData,decimateFactor);
    end
% Output    
    Photo{thisCh}=thisData;
end  
    else
        Photo=[];
end
end