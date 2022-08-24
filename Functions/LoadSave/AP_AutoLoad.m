function LP=AP_AutoLoad(LP)

%% Default Parameters
LP.P.Photometry=LP.D.Photometry;
LP.P.Spikes.Spikes=LP.D.Spikes.Spikes;
LP.P.AOD.AOD=LP.D.AOD.AOD;
LP.Load=LP.D.Load;

if LP.AutoLoad
%% load the first file
FileName=LP.FileToOpen{1,1};
cd(LP.PathName); load(FileName); 

if exist('SessionData','var')
    LP.Load=0;
    if isfield('SessionData','NidaqData')
        LP.P.Photometry=1;
    end
    if ~isempty(ls('dff_*')) || ~isempty(ls('raw_*')) || ~isempty(ls('calcium_*'))
        LP.P.AOD.AOD=1;
    end
    if ~isempty(ls('TT_*'))
        LP.P.Spikes.Spikes=1;
    end
    test=LP.P.Photometry+LP.P.Spikes.Spikes+LP.P.AOD.AOD;
    if test>1
        disp('AutoLoad function has failed, will use default parameters')
        LP.P.Photometry=LP.D.Photometry;
        LP.P.Spikes.Spikes=LP.D.Spikes.Spikes;
        LP.P.AOD.AOD=LP.D.AOD.AOD;
    end
else
    if exist('Analysis','var')
    LP.Load=1;
    if isfield(Analysis.Parameters,'Photometry')
        LP.P.Photometry=Analysis.Parameters.Photometry;
    end
    if isfield(Analysis.Parameters,'Spikes')
        LP.P.Spikes.Spikes=Analysis.Parameters.Spikes.Spikes;
    end
    if isfield(Analysis.Parameters,'AOD')
        LP.P.AOD.AOD=Analysis.Parameters.AOD.AOD;
    end
    else
        error('Please load a Bpod file or an Analysis file');
    end
end
end
end



