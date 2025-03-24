function Analysis=AB_Load_VC(Analysis)

%% New Launcher pre v2-2025
if ~isfield(Analysis.Parameters,'LauncherVer')
    oldPar=Analysis.Parameters;
    newPar.LauncherVers_old=1;    
%% Automatic changes
    keepField={'Animal','Name','Files','Rig','AOD','Miniscope','Spikes'};
    for kf=1:size(keepField,2)
        newPar.(keepField{kf})=oldPar.(keepField{kf});
    end
    % nested parameters
    newField_lvl1{1}='Behavior';
    newField_lvl2{1}={'nTrials','nbOfTrialTypes','Behavior','Phase','TrialNames','TypeOfCue'};
    oldField{1}=newField_lvl2{1};

    newField_lvl1{2}='Photometry';
    newField_lvl2{2}={'Modulation','recordedMod','AmpField','FreqField','ModulData','SamplingRateDecimated','SamplingRate'};
    oldField{2}={'Modulation','recordedMod','PhotoAmpField','PhotoFreqField','PhotoModulData','NidaqDecimatedSR','NidaqSamplingRate'};

    newField_lvl1{3}='Wheel';
    newField_lvl2{3}={'Wheel','CounterNbits','EncoderCPR','Diameter','Polarity','NidaqField','SamplingRateDecimated','SamplingRate'};
    oldField{3}={'Wheel','WheelCounterNbits','WheelEncoderCPR','WheelDiameter','WheelPolarity','WheelField','NidaqSamplingRate','NidaqSamplingRate'};
    
    for f1=1:size(newField_lvl1,2)
        for f2=1:size(newField_lvl2{f1},2)
            if isfield(oldPar,oldField{f1}{f2})
                newPar.(newField_lvl1{f1}).(newField_lvl2{f1}{f2})=oldPar.(oldField{f1}{f2});
            else
                newPar.(newField_lvl1{f1}).(newField_lvl2{f1}{f2})=0;
            end
        end
    end
%% manual changes
    if isfield(oldPar,'nCells')
        newPar.Data.nCells=oldPar.nCells;
    else
        newPar.Data.nCells=0;
    end
% Behavior
    newPar.Behavior.nSessions=size(newPar.Files,2);
    switch newPar.Behavior.Behavior
        case 'CuedOutcome'
            newPar.Timing.EpochNames={'Cue','Outcome','Delay'};
            newPar.Timing.EpochStates={oldPar.StateOfCue,oldPar.StateOfOutcome,'Delay'};
            newPar.Timing.EpochTimeReset=[oldPar.CueTimeReset ; oldPar.OutcomeTimeReset; 0 0];  
        otherwise
            newPar.Timing.EpochNames={'Cue'};
            newPar.Timing.EpochStates={oldPar.StateOfCue};
            newPar.Timing.EpochTimeReset=[oldPar.CueTimeReset]; 
    end
% Timing
    newPar.Timing.EpochZeroPSTH=oldPar.StateOfOutcome;
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
    newPar.Pupillometry.SamplingRate=20;
    newPar.Pupillometry.StartState='PreState';
% AOD
    if isfield(oldPar,'AOD') && isfield(oldPar.AOD,'sampRate')
        newPar.AOD.SamplingRate=oldPar.AOD.sampRate;
    end

    % Save new parameter structure
    Analysis.Parameters=newPar;

    %% Older version
if ~isfield(Analysis.Parameters,'Stimulation')
    Analysis.Stimulation.Stimulation=0;
end
    %% Data fields
if isfield(Analysis.Core,'Photometry')
    p_old=Analysis.Core.Photometry;
    Analysis.Core.Photometry=cellfun(@cell2mat,p_old,'UniformOutput',false);
end
if isfield(Analysis.Core,'AOD')
    a_old=Analysis.Core.AOD;
    Analysis.Core.AOD=cellfun(@(x) permute(x,[2 1]),a_old,'UniformOutput',false);
end
end