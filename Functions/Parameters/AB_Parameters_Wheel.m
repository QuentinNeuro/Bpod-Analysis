function Par=AB_Parameters_Wheel(Par,SessionData,LP)
Par.Wheel.Wheel(Par.Behavior.nSessions)=0;

%% Wheel parameters
Par.Wheel.CounterNbits=32;
Par.Wheel.EncoderCPR=1024;
Par.Wheel.Diameter=14; %cm
Par.Wheel.Polarity=-1;

%% Check Nidaq_Bpod version
if isfield(SessionData,'Wheel')
    Par.Wheel.Version=2;
    Par.Wheel.DataField={'Wheel','Data'};
    Par.Wheel.Wheel(Par.Behavior.nSessions)=1;
elseif isfield(SessionData,'NidaqWheelData') || LP.P.Prime.Wheel
    Par.Wheel.Version=1;
    Par.Wheel.DataField='NidaqWheelData';
    Par.Wheel.Wheel(Par.Behavior.nSessions)=1;
end

%% Check whether data were archived
if Par.Wheel.Wheel(Par.Behavior.nSessions)
    Par.Wheel.SamplingRate=SessionData.TrialSettings(1).GUI.NidaqSamplingRate;
    if isfield(SessionData,'Archive') || isfield(SessionData,'DecimatedSampRate')
        Par.Wheel.SamplingRate=SessionData.DecimatedSampRate;
        Par.Wheel.Archive=1;
    else
        Par.Wheel.Archive=0;
    end
end

end