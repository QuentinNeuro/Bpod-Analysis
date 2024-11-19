function Wheel=AP_DataCore_Wheel(SessionData,Analysis,thisTrial)
if ~isfield(Analysis.Parameters,'Prime')
%% Wheel
if Analysis.Parameters.Wheel==1
    if ~isfield(SessionData,'DecimatedSampRate')
DecimateFactor=Analysis.Parameters.NidaqDecimateFactor;
% Data
signedData = SessionData.NidaqWheelData{1,thisTrial};
signedThreshold = 2^(Analysis.Parameters.WheelCounterNbits-1);
signedData(signedData > signedThreshold) = signedData(signedData > signedThreshold) - 2^Analysis.Parameters.WheelCounterNbits;
DataDeg  = signedData * 360/Analysis.Parameters.WheelEncoderCPR;
DataDeg  = decimate(DataDeg,DecimateFactor);
Wheel=DataDeg;
    else
        Wheel=SessionData.NidaqWheelData{1,thisTrial};
    end
else
    Wheel=[];
end
end
Wheel=[];
end