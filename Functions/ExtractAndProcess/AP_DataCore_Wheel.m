function Wheel=AP_DataCore_Wheel(SessionData,Analysis,thisTrial)

%% Wheel
if Analysis.Parameters.Wheel==1
DecimateFactor=Analysis.Parameters.NidaqDecimateFactor;
% Data
signedData = SessionData.NidaqWheelData{1,thisTrial};
signedThreshold = 2^(Analysis.Parameters.WheelCounterNbits-1);
signedData(signedData > signedThreshold) = signedData(signedData > signedThreshold) - 2^Analysis.Parameters.WheelCounterNbits;
DataDeg  = signedData * 360/Analysis.Parameters.WheelEncoderCPR;
DataDeg  = decimate(DataDeg,DecimateFactor);
Wheel=DataDeg;
else
    Wheel=[];
end
end