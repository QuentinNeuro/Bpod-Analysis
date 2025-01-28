function Analysis=AP_Load_VC(Analysis)

%% New Launcher pre v2-2025
if ~isfield(Analysis.Parameters,'LauncherVer')
    oldPar=Analysis.Parameters;
    newPar.LauncherVers_old=1;    
    % keep as is
    keepField={'Animal','Name','Files','Rig','AOD','Miniscope','Spikes'};
    for kf=1:size(keepField,2)
        newPar.(keepField{kf})=oldPar.(keepField{kf});
    end
    % nested parameters
    newField_lvl1={'Behavior','Photometry','Wheel','Data','Timing'};
    newField_lvl2{1}={'nTrials','nbOfTrialTypes','Behavior','Phase','TrialNames',...
                            'TypeOfCue','StateOfCue','StateOfOutcome'};
    newField_lvl2{2}={'Photometry','Modulation','recordedMod','AmpField','FreqField','ModulData'};
    newField_lvl2{3}={'Wheel','CounterNbits','EncoderCPR','Diameter','Polarity','NidaqField'};
    newField_lvl2{4}={'NidaqDecimatedSR','NidaqBaseline','NidaqSamplingRate',...
                            'NidaqDecimateFactor','NidaqBaselinePoints'};
    newField_lvl2{5}={'CueTimeReset','OutcomeTimeReset'};

    oldField{1}=newField_lvl2{1};
    oldField{2}={'Photometry','Modulation','recordedMod','PhotoAmpField','PhotoFreqField','PhotoModulData'};
    oldField{3}={'Wheel','WheelCounterNbits','WheelEncoderCPR','WheelDiameter','WheelPolarity','WheelField'};
    oldField{4}=newField_lvl2{4};
    oldField{5}=newField_lvl2{5};

    for f1=1:size(newField_lvl1,2)
        for f2=1:size(newField_lvl2{f1},2)
            if isfield(oldPar,oldField{f1}{f2})
                newPar.(newField_lvl1{f1}).(newField_lvl2{f1}{f2})=oldPar.(oldField{f1}{f2});
            else
                newPar.(newField_lvl1{f1}).(newField_lvl2{f1}{f2})=0;
            end
        end
    end

    % manual changes
    % Licks
    newPar.Licks.Port=oldPar.LickPort;
    newPar.Licks.BinSize=oldPar.Bin;
    % Photometry
    newPar.Photometry.NidaqField={oldPar.PhotometryField oldPar.Photometry2Field};
    if isfield(oldPar,'PhotoPhase')
        newPar.Photometry.Phase=oldPar.PhotoPhase;
    else
        newPar.Photometry.Phase=0;
    end
    newPar.Photometry.Channels={};
    for c=1:size(oldPar.PhotoCh,2)
        newPar.Photometry.Channels{c}=char(oldPar.PhotoCh{c});
    end
    if ~isfield(oldPar,'Stimulation')
        newPar.Stimulation.Stimulation=0;
    else
         newPar.Stimulation.Stimulation=oldPar.Stimulation;
    end
    % Pupil
    newPar.Pupillometry.Pupillometry=oldPar.Pupillometry;
    newPar.Pupillometry.Parameters=oldPar.Pupillometry_Parameters;

    % Save new parameter structure
    Analysis.Parameters=newPar;

    %% Older version
if ~isfield(Analysis.Parameters,'nCells')
    Analysis.Parameters.nCells=0;
end
if ~isfield(Analysis.Parameters,'Stimulation')
    Analysis.Stimulation.Stimulation=0;
end

end



end