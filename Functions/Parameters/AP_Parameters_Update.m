function Par=AP_Parameters_Update(Par,LP)
%% Update Analysis Parameters using Launcher Parameters
FieldsLP_P=fieldnames(LP.P);
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
FieldsLP_OW=fieldnames(LP.OW);
for thisField=1:size(FieldsLP_OW,1)
    if ~isempty(LP.OW.(FieldsLP_OW{thisField})) || ~isfield(Par,FieldsLP_OW{thisField})
    Par.(FieldsLP_OW{thisField})=LP.OW.(FieldsLP_OW{thisField});
    end
end
%
Par.NidaqBaselinePoints=Par.NidaqBaseline*Par.NidaqDecimatedSR;
if Par.NidaqBaselinePoints(1)==0
    Par.NidaqBaselinePoints(1)=1;
end
if ~isfield(Par,'nCells')
    Par.nCells=0;
end
end