function Analysis=AP_Photometry_2ChFit(Analysis)

nTrials=Analysis.Core.nTrials;
photoData=Analysis.Core.Photometry;

photo470r=[];
photo405r=[];
for t=1:nTrials
    if ~isnan(photoData{t}{2})
    photo470r=[photo470r photoData{t}{1}];
    photo405r=[photo405r photoData{t}{2}];
    end
end
p=polyfit(photo405r,photo470r,1);

Analysis.Parameters.PhotometryFit=p;

end