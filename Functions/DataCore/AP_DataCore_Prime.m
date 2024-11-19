function Analysis=AP_DataCore_Prime(Analysis)

%% Folder directory
folderTrialList=string(ls('*Trial*'));
nfTL=size(folderTrialList,1);
nTrials=Analysis.Parameters.nTrials;
if nfTL~=nTrials
    disp('Trial nb does not match - going with PRIME nTrials');
end

%% Load stuff
for t=1:nfTL
    thisTrialName=sprintf('Trial%.0d_',1);
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
Analysis.Parameters.Prime.sampRate=1/mean(diff(timestamps_frame));

Analysis.Core.Prime_Depth=dataDepth;
Analysis.Core.Prime_Angle=dataAngle;

% Wheel data
Analysis.Parameters.Wheel=1;
Analysis.Parameters.NidaqDecimatedSR=1/mean(diff(timestamps_wheel));
Analysis.Core.Wheel=dataWheel;

end