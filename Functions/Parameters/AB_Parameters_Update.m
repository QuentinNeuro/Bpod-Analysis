function Par=AB_Parameters_Update(Par,LP)
FieldsLP_P1=fieldnames(LP.P);
FieldsLP_OW1=fieldnames(LP.OW);
%% Check that LP parameter fields are in Par
for f1=1:size(FieldsLP_P1,1)
    if ~isfield(Par,(FieldsLP_P1{f1}))
        Par.(FieldsLP_P1{f1})=LP.P.(FieldsLP_P1{f1});
    elseif isstruct(LP.P.(FieldsLP_P1{f1}))
        FieldsLP_P2=fieldnames(LP.P.(FieldsLP_P1{f1}));
        for f2=1:size(FieldsLP_P2,1)
            if ~isfield(Par.(FieldsLP_P1{f1}),FieldsLP_P2{f2})
                Par.(FieldsLP_P1{f1}).(FieldsLP_P2{f2})=LP.P.(FieldsLP_P1{f1}).(FieldsLP_P2{f2});
            end
        end
    end
end
%% Update Analysis Parameters using Launcher Parameters
for f1=1:size(FieldsLP_P1,1)
    if ~isstruct(LP.P.(FieldsLP_P1{f1}))
        if ~isempty(LP.P.(FieldsLP_P1{f1}))
        Par.(FieldsLP_P1{f1})=LP.P.(FieldsLP_P1{f1});
        end
    else
        FieldsLP_P2=fieldnames(LP.P.(FieldsLP_P1{f1}));
        for f2=1:size(FieldsLP_P2,1)
            if ~isempty(LP.P.(FieldsLP_P1{f1}).(FieldsLP_P2{f2}))
                Par.(FieldsLP_P1{f1}).(FieldsLP_P2{f2})=LP.P.(FieldsLP_P1{f1}).(FieldsLP_P2{f2});
            end
        end
    end
end

%% Overwritting
for f1=1:size(FieldsLP_OW1,1)
    FieldsLP_OW2=fieldnames(LP.OW.(FieldsLP_OW1{f1}));
    for f2=1:size(FieldsLP_OW2,1)
    if ~isempty(LP.OW.(FieldsLP_OW1{f1}).(FieldsLP_OW2{f2}))
        Par.(FieldsLP_OW1{f1}).(FieldsLP_OW2{f2})=LP.OW.(FieldsLP_OW1{f1}).(FieldsLP_OW2{f2});
    end
    end
end
end