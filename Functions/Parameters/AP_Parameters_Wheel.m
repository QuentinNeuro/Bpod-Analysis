function Par=AP_Parameters_Wheel(Par,SessionData,LP)

Par.Wheel.Wheel=0;
Par.Wheel.WheelPath='WheelInput';
Par.Wheel.CounterNbits=32;
Par.Wheel.EncoderCPR=1024;
Par.Wheel.Diameter=14; %cm

if isfield(SessionData,Par.WheelField) || LP.P.Prime.Wheel
    Par.Wheel.Wheel=1;
end

switch Par.Rig
    case 'Photometry5'
        Par.WheelPolarity=1;
    otherwise
        Par.WheelPolarity=-1;
end

end