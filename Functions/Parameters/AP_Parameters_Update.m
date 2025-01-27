function Par=AP_Parameters_Update(Par,LP)
FieldsLP_P=fieldnames(LP.P);
FieldsLP_OW=fieldnames(LP.OW);
%% Check that LP parameter fileds are in Par
for thisField=1:size(FieldsLP_P,1)
    if ~isfield(Par,(FieldsLP_P{thisField}))
        Par.(FieldsLP_P{thisField})=LP.P.(FieldsLP_P{thisField});
    end
end
%% Update Analysis Parameters using Launcher Parameters
for thisField=1:size(FieldsLP_P,1)
    if ~isstruct(LP.P.(FieldsLP_P{thisField}))
        if ~isempty(LP.P.(FieldsLP_P{thisField}))
        Par.(FieldsLP_P{thisField})=LP.P.(FieldsLP_P{thisField});
        end
    else
        FieldsLP_P2=fieldnames(LP.P.(FieldsLP_P{thisField}));
        for thisField2=1:size(FieldsLP_P2,1)
            if ~isempty(LP.P.(FieldsLP_P{thisField}).(FieldsLP_P2{thisField2}))
                Par.(FieldsLP_P{thisField}).(FieldsLP_P2{thisField2})=LP.P.(FieldsLP_P{thisField}).(FieldsLP_P2{thisField2});
            end
        end
    end
end
%
Par.StateToZero=Par.(LP.P.StateToZero);
%% Overwritting
for thisField=1:size(FieldsLP_OW,1)
    if ~isempty(LP.OW.(FieldsLP_OW{thisField})) || ~isfield(Par,FieldsLP_OW{thisField})
    Par.(FieldsLP_OW{thisField})=LP.OW.(FieldsLP_OW{thisField});
    end
end
%
Par.Data.NidaqBaselinePoints=Par.NidaqBaseline*Par.NidaqDecimatedSR;
if Par.Data.NidaqBaselinePoints(1)==0
    Par.Data.NidaqBaselinePoints(1)=1;
end
%% Version control
if ~isfield(Par,'nCells')
    Par.nCells=0;
end
if ~isfield(Par,'Stimulation')
    Par.Stimulation=0;
end
end