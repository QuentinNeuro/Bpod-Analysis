function Analysis=AP_DataProcess_Baseline(Analysis)

nTrials=Analysis.Parameters.Behavior.nTrials;
movBaseParam=Analysis.Parameters.Data.BaselineMov;
dt=1/Analysis.Parameters.Data.NidaqDecimatedSR;

timeToZero=Analysis.AllData.Time.Zero;
PSTH_TW=Analysis.Parameters.Timing.PSTH;
sampRate=Analysis.Parameters.Data.NidaqDecimatedSR;

switch Analysis.Parameters.Data.RecordingType
    case 'Photometry'
        dataStructure=Analysis.Parameters.Photometry.Channels;
    case {'AOD','Miniscope','Spikes'}
        dataStructure=['AllCells',Analysis.Parameters.Spikes.CellID];
    case {'Prime'}
end



nbOfStructure=


movBaseParam=Analysis.Parameters.Data.BaselineMov;
dt=1/Analysis.Parameters.Data.NidaqDecimatedSR;
stateToZero=Analysis.Parameters.Timing.StateToZero;
tw=Analysis.Parameters.Timing.PSTH;
nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);
nTrials=Analysis.Parameters.Behavior.nTrials;

end