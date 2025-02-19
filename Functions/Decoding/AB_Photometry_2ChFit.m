function Analysis=AB_Photometry_2ChFit(Analysis)

%% Parameters
nTrials=Analysis.Core.nTrials;
nbOfChannels=size(Analysis.Parameters.Photometry.Channels,2);
if nbOfChannels==1
    disp('Error in AB_Photometry_2ChFit, only 1 channel available')
    return
end

%% Calculate the fit parameters
data=Analysis.Core.Photometry;
signal=[];
control=[];
for t=1:nTrials
    if ~isnan(data{t}{2})
    signal=[signal data{t}{1}];
    control=[control data{t}{2}];
    end
end
p=polyfit(control,signal,1);

%% ADD a channel / label and store the data there
signal=[];
signal_fit=[];
control=[];

for t=1:nTrials
    signal=data{t}{1};
    control=data{t}{2};
    control_scale=control*p(1)+p(2);
    data{t}{nbOfChannels+1}=100*(signal-control_scale)./control_scale;
end

%% Save in Analysis structure
Analysis.Parameters.Photometry.Fit=p;
Analysis.Parameters.Photometry.Channels{end+1}='Fit';
Analysis.Core.Photometry=data;

end