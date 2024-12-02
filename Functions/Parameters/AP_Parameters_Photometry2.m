function Par=AP_Parameters_Photometry2(Par,SessionData,LP)

%% 
if isfield(SessionData.TrialSettings(1).GUI,'PhotometryVersion')
    if SessionData.TrialSettings(1).GUI.PhotometryVersion>1.5

Par.Photometry.Photometry=SessionData.TrialSettings(1).GUI.Photometry;
Par.Photometry.SampRate_Rec=100;
Par.Photometry.SampRate_Dec=20;
Par.Photometry.SampRate_DecFac=ceil(Par.Photometry.SampRate_Rec/Par.Photometry.SampRate_Dec);
Par.Photometry.BaselinePoints=

Par.Photometry.OutputRec=0;
Par.Photometry.OutputPath='PhotometryOutput';
Par.Photometry.InputPath='PhotometryInput';

Par.Photometry.Modulation=1;
Par.Photometry.ModFreq=[211 531];
Par.Photometry.ModPhase=[];

Par.Photometry.Wavelength={'470'};
Par.Photometry.Names={};

%% Old version
    else
Par=AP_Parameters_Photometry_Depricated(Par,SessionData,LP);
    end
    else
Par=AP_Parameters_Photometry_Depricated(Par,SessionData,LP);
end
end