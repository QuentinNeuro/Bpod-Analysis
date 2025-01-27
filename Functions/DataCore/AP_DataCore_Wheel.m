function Wheel=AP_DataCore_Wheel(SessionData,Analysis,thisTrial)

dataField=Analysis.Parameters.Wheel.NidaqField;
counterNBits=Analysis.Parameters.Wheel.CounterNbits;
encoderCPR=Analysis.Parameters.Wheel.EncoderCPR;
decimateFactor=Analysis.Parameters.Data.NidaqDecimateFactor;

if ~isfield(Analysis.Parameters,'Prime')
%% Wheel
if Analysis.Parameters.Wheel.Wheel==1
    if ~isfield(SessionData,'DecimatedSampRate')
% Data
signedData = SessionData.(dataField){1,thisTrial};
signedThreshold = 2^(counterNBits-1);
signedData(signedData > signedThreshold) = signedData(signedData > signedThreshold) - 2^counterNBits;
DataDeg  = signedData * 360/encoderCPR;
DataDeg  = decimate(DataDeg,decimateFactor);
    Wheel=DataDeg;
else
    Wheel=SessionData.(dataField){1,thisTrial};
end
else
    Wheel=[];
end
end
    Wheel=[];
end