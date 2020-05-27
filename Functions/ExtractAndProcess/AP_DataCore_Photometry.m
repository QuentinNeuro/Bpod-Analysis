function Photo=AP_DataCore_Photometry(SessionData,Analysis,thisTrial)

%% Photometry
if Analysis.Parameters.Photometry==1
% Parameters  
DecimateFactor=Analysis.Parameters.NidaqDecimateFactor;
SampRate=Analysis.Parameters.NidaqSamplingRate;
% Data
Photo=cell(length(Analysis.Parameters.PhotoCh),1);
for thisCh=1:length(Analysis.Parameters.PhotoCh)
    if Analysis.Parameters.Modulation
        thisNidaqField=char(Analysis.Parameters.PhotoField{thisCh});
        thisAmp=SessionData.TrialSettings(thisTrial).GUI.(char(Analysis.Parameters.PhotoAmpField{thisCh}));
        if thisAmp~=0
        thisFreq=SessionData.TrialSettings(thisTrial).GUI.(char(Analysis.Parameters.PhotoFreqField{thisCh}));
        thisRawData=SessionData.(thisNidaqField){1,thisTrial}(:,1);
%         if Analysis.Parameters.NewDemod
%             [thisData, thisphase] = AP_IQ_Demodulation(thisRawData, SampRate, thisFreq,'PaddingType', 'Rand','CutOff', 15);
%         else
           switch Analysis.Parameters.recordedMod
            case 0
                thisModulation=AP_Modulation(Analysis,thisAmp,thisFreq);
            case 1
                thisModulation=SessionData.(thisNidaqField){1,thisTrial}(:,Analysis.Parameters.PhotoModulData(thisCh));
            end
        thisData=AP_Demodulation(thisRawData,thisModulation,SampRate,thisAmp,thisFreq,15);
%         end
            thisData=decimate(thisData,DecimateFactor);

        else    % Amplitude=0 for this channel for this trial
            thisData=Data;
        end
    else        % no modulation of this channel for this trial
        thisData=decimate(SessionData.NidaqData{1,thisTrial}(:,1),DecimateFactor);
    end

% Output    
    Photo{thisCh}=thisData;
end  
    else
        Photo=[];
end
end