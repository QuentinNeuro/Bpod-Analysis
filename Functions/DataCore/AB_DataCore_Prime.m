function Analysis=AB_DataCore_Prime(Analysis)

%% Folder directory
folderTrialList=string(ls('Trial*'));
nTL=size(folderTrialList,1);
nTrials=Analysis.Parameters.Behavior.nTrials;
if nTL~=nTrials
    disp('Trial nb does not match nfTL-nTrials:');
    disp([nTL nTrials])
    return
end

%% Load stuff
for t=1:nTL
    thisTrialName=sprintf('Trial%.0d_',t)
    thisTrialFolder=folderTrialList(contains(folderTrialList,thisTrialName));
    cd(thisTrialFolder)
    load("raw_data.mat");

    tFluo{t}=timestamps_frame;
    if Analysis.Parameters.Prime.raw
        dataDepth{t}=Sig_depth_nor';
        dataAngle{t}=Sig_angle_nor';
    else
        dataDepth{t}=dF_to_F_depth_nor';
        dataAngle{t}=dF_to_F_angle_nor';  
    end
    tWheel{t}=timestamps_wheel;
    dataWheel{t}=positionDataDist;
    cd ..
end

%% Save in Analysis structure
% Prime data
Analysis.Parameters.Prime.nDepth=length(Depth);
Analysis.Parameters.Prime.nAngle=length(Angle);
Analysis.Parameters.Prime.SamplingRate=1/mean(diff(timestamps_frame));

Analysis.Core.Prime_Depth=dataDepth;
Analysis.Core.Prime_Angle=dataAngle;

% Wheel data
Analysis.Parameters.Wheel.Wheel=1;
Analysis.Parameters.Prime.Wheel=1;
Analysis.Parameters.Prime.recRaw=Analysis.Parameters.Prime.raw;
Analysis.Parameters.Wheel.SamplingRate=1/mean(diff(timestamps_wheel));
Analysis.Parameters.Wheel.SamplingRateDecimated=Analysis.Parameters.Wheel.SamplingRate;
Analysis.Core.Wheel=dataWheel;

end