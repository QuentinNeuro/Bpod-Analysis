function [Pupil, PupSmooth, PupBlink]=AP_DataCore_Pupil(Pup,Analysis,thisTrial,thisCoreTrial)

if Analysis.Filters.Pupillometry(thisCoreTrial)
    Pupil=Pup.Pupil(:,thisTrial)';
    PupSmooth=Pup.PupilSmooth(:,thisTrial)';
    PupBlink=Pup.Blink(:,thisTrial)';
else
    Pupil=[];
    PupSmooth=[];
    PupBlink=[];
end
end