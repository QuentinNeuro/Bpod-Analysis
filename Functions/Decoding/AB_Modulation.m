function Modulated_LED=AP_Modulation(amp,freq,samplingRate,duration,phase)
%Generates a sin wave for LED amplitude modulation.
if nargin<5
    phase=0;
end
time=0:1/samplingRate:(duration-1/samplingRate);
Modulated_LED=amp*(sin(2*pi*freq*time+phase)+1)/2;
Modulated_LED=Modulated_LED';

end