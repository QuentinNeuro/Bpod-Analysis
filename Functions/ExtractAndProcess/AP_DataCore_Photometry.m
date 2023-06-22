function Photo=AP_DataCore_Photometry(SessionData,Analysis,thisTrial)
%% Photometry
if Analysis.Parameters.Photometry==1
% Parameters  
decimateFactor=Analysis.Parameters.NidaqDecimateFactor;
sampRate=Analysis.Parameters.NidaqSamplingRate;
duration=SessionData.TrialSettings(1).GUI.NidaqDuration;
% Data
Photo=cell(length(Analysis.Parameters.PhotoCh),1);
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    thisNidaqField=char(Analysis.Parameters.PhotoField{thisCh});
    if Analysis.Parameters.Modulation
        thisAmp=SessionData.TrialSettings(thisTrial).GUI.(char(Analysis.Parameters.PhotoAmpField{thisCh}));
        if thisAmp
            thisFreq=SessionData.TrialSettings(thisTrial).GUI.(char(Analysis.Parameters.PhotoFreqField{thisCh}));
            thisRawData=SessionData.(thisNidaqField){1,thisTrial}(:,1);
            thisData=AP_Demodulation(thisRawData,sampRate,thisFreq,15);
        else    % Amplitude=0 for this channel for this trial
            thisData=NaN(1,duration*sampRate/decimateFactor);
        end
    else        % no modulation of this channel for this trial
        if ~isfield(SessionData,'DecimatedSampRate')
            thisData=SessionData.(thisNidaqField){1,thisTrial}(:,1);
        else % Archived file
            thisData=SessionData.(thisNidaqField){1,thisTrial}(:,Analysis.Parameters.PhotoModulData(thisCh)-1)';
            if size(thisData,2)==1
                thisData=SessionData.(thisNidaqField){1,thisTrial}(Analysis.Parameters.PhotoModulData(thisCh)-1,:);
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