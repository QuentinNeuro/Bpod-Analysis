function Analysis=AP_DataSort_FieldMatch(Analysis,FilterName,thisFilter)
% Function used in AP_DataSort to filter fields found in Analysis.AllData
% according to the filter specified as an input.
%
% QC 2020

%% Filter check
FilterName=strrep(FilterName,' ','_');
thisType=FilterName;

%% Field match
Fields_AllData=fieldnames(Analysis.AllData);
for i=1:size(Fields_AllData,1)
    thisField=Fields_AllData{i};
    if ischar(Analysis.AllData.(thisField))
        Analysis.(thisType).(thisField)=Analysis.AllData.(thisField);
    elseif isstruct(Analysis.AllData.(thisField))
        Fields_Lvl2=fieldnames(Analysis.AllData.(thisField));
        for i=1:size(Fields_Lvl2,1)
            thisField2=Fields_Lvl2{i};
            if ischar(Analysis.AllData.(thisField).(thisField2))
                Analysis.(thisType).(thisField).(thisField2)=Analysis.AllData.(thisField).(thisField2);
            else
                if size(Analysis.AllData.(thisField).(thisField2),1)==size(thisFilter,1)
                    Analysis.(thisType).(thisField).(thisField2)=Analysis.AllData.(thisField).(thisField2)(thisFilter,:);
                elseif size(Analysis.AllData.(thisField).(thisField2),2)==size(thisFilter,1)
                    Analysis.(thisType).(thisField).(thisField2)=Analysis.AllData.(thisField).(thisField2)(thisFilter);
                else
                    Analysis.(thisType).(thisField).(thisField2)=Analysis.AllData.(thisField).(thisField2);
                end
            end
        end
    else
        if size(Analysis.AllData.(thisField),1)==size(thisFilter,1)
            Analysis.(thisType).(thisField)=Analysis.AllData.(thisField)(thisFilter,:);
        elseif size(Analysis.AllData.(thisField),2)==size(thisFilter,1)
            Analysis.(thisType).(thisField)=Analysis.AllData.(thisField)(thisFilter);
        else
            Analysis.(thisType).(thisField)=Analysis.AllData.(thisField);
        end
    end
end
Analysis.(thisType).nTrials                     =nnz(thisFilter);
end