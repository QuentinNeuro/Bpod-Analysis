function Par=AB_Parameters_Wheel(Par,SessionData,LP)

Par.Wheel.NidaqField='NidaqWheelData';
Par.Wheel.Wheel(Par.Behavior.nSessions)=0;
if isfield(SessionData,Par.Wheel.NidaqField) || LP.P.Prime.Wheel
    Par.Wheel.Wheel(Par.Behavior.nSessions)=1;
if isfield(SessionData,'DecimatedSampRate')
    Par.Wheel.SamplingRate=SessionData.DecimatedSampRate;
else
    Par.Wheel.SamplingRate=SessionData.TrialSettings(1).GUI.NidaqSamplingRate;
end
end
Par.Wheel.CounterNbits=32;
Par.Wheel.EncoderCPR=1024;
Par.Wheel.Diameter=14; %cm
Par.Wheel.Polarity=-1;

end