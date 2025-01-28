function LP=AP_AutoLoad(LP)

%% Default Parameters
LP.P.Photometry.Photometry=LP.D.Photometry.Photometry;
LP.P.Spikes.Spikes=LP.D.Spikes.Spikes;
LP.P.AOD.AOD=LP.D.AOD.AOD;
LP.P.Prime.Prime=LP.D.Prime.Prime;
LP.P.Miniscope.Miniscope=LP.D.Miniscope.Miniscope;
LP.Load=LP.D.Load;

if LP.AutoLoad
%% load the first file
FileName=LP.FileToOpen{1,1};
cd(LP.PathName); load(FileName); 

if exist('SessionData','var')
    LP.Load=0;
    if isfield('SessionData','NidaqData')
        LP.P.Photometry.Photometry=1;
    end
    if ~isempty(ls('dff_*')) || ~isempty(ls('raw_*')) || ~isempty(ls('calcium_*'))
        LP.P.AOD.AOD=1;
    end
    if ~isempty(ls('rec_extract*'))
        LP.P.Miniscope.Miniscope=1;
    end
    if ~isempty(ls('TT_*'))
        LP.P.Spikes.Spikes=1;
    end
    if ~isempty(ls('*PMT_*')) % could also use SessionData.GUI.Prime;
        LP.P.Prime.Prime=1;
        LP.P.Wheel.Wheel=1;
    end
    test=LP.P.Photometry.Photometry+LP.P.Spikes.Spikes+LP.P.AOD.AOD+LP.P.Prime.Prime;
    if test>1
        disp('AutoLoad function has failed, will use default parameters')
        LP.P.Photometry.Photometry=LP.D.Photometry.Photometry;
        LP.P.Spikes.Spikes=LP.D.Spikes.Spikes;
        LP.P.AOD.AOD=LP.D.AOD.AOD;
        LP.P.Prime.Prime=LP.D.Prime.Prime;
    end
else
    if exist('Analysis','var')
    LP.Load=1;
    if isfield(Analysis.Parameters,'Photometry')
        if isstruct(Analysis.Parameters.Photometry)
            LP.P.Photometry.Photometry=Analysis.Parameters.Photometry.Photometry;
        else %% OLD VERSION
            LP.P.Photometry.Photometry=Analysis.Parameters.Photometry;
        end
    end
    recTypes={'Spikes','AOD','Prime'};
    for rt=1:size(recTypes,2)
        if isfield(Analysis.Parameters,recTypes{rt})
            LP.P.(recTypes{rt}).(recTypes{rt})=Analysis.Parameters.(recTypes{rt}).(recTypes{rt});
        end
    end

    else
        error('Please load a Bpod file or an Analysis file');
    end
end
end
end



