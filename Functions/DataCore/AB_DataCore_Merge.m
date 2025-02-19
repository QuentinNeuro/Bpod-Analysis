function A_New=AB_DataCore_Merge(A_OG, A_ToAdd)

%% Check 1 : Parameters
FParameters='Parameters';
FStrCmp={'Animal','Phase'};
% Check that structures are for the same animal, same behavior etc
FLVL1_OG=fieldnames(A_OG);
FLVL1_ToAdd=fieldnames(A_ToAdd);
% Warning if other fields than Param, Filters and Core are presents
if size(FLVL1_OG,1)>3 || size(FLVL1_ToAdd,1)>3
    disp('Only core data will be maintained during merging')
end
% Check some basic parameter fields
for thisField=1:size(FStrCmp,2)
if ~strcmp(A_OG.(FParameters).(FStrCmp{thisField}),A_OG.(FParameters).(FStrCmp{thisField}))
    disp(['WARNING Trying to merge sessions with different parameters: ' FStrCmp{thisField}])
end
end
if size(A_OG.(FParameters).PhotoCh)~=size(A_ToAdd.(FParameters).PhotoCh)
    disp('WARNING Trying to merge different fiber counts')
end
if A_OG.(FParameters).Wheel~=A_ToAdd.(FParameters).Wheel
    disp('WARNING Trying to merge sessions with different running wheel status')
end
%% Merge Parameters and Filters
A_New.Parameters=A_OG.Parameters;
if ischar(A_New.Parameters.Files)
    temp{1}=A_New.Parameters.Files;
    A_New.Parameters.Files=temp;
end
A_New.Parameters.Files{end+1}=A_ToAdd.Parameters.Files;
A_New.Parameters.Pupillometry_Parameters{end+1}=A_ToAdd.Parameters.Pupillometry_Parameters{:};
% Filters
A_New.Filters.ignoredTrials=[A_OG.Filters.ignoredTrials,A_ToAdd.Filters.ignoredTrials];
A_New.Filters.Wheel=[A_OG.Filters.Wheel;A_ToAdd.Filters.Wheel];
A_New.Filters.Pupillometry=[A_OG.Filters.Pupillometry;A_ToAdd.Filters.Pupillometry];
%% Check 2 : Core Data
FData='Core';
FLVL2_OG=fieldnames(A_OG.(FData));
FLVL2_ToAdd=fieldnames(A_ToAdd.(FData));
% Warning if other fields than Param, Filters and Core are presents
if size(FLVL2_OG,1)~=size(FLVL2_ToAdd,1)
    disp('BREAK Cannot Merge Core Data with different number of fields');
    return
end
%% Merge CoreData
try
    NbOfSessions=max(A_OG.(FData).Session);
    SessionNb=[A_OG.(FData).Session,A_ToAdd.(FData).Session+NbOfSessions];
    nTrials=A_OG.(FData).nTrials+A_ToAdd.(FData).nTrials;
    for thisField=1:size(FLVL2_OG,1)
       A_New.(FData).(FLVL2_OG{thisField})=[A_OG.(FData).(FLVL2_OG{thisField}),A_ToAdd.(FData).(FLVL2_OG{thisField})];
    end
    % Specific subField Cases : nTrials, Session
	A_New.(FData).Session=SessionNb;
    A_New.(FData).nTrials=length(A_New.(FData).Session);
    if A_New.(FData).nTrials~=nTrials 
        disp('Nb of trials after merging is not consistent')
    end
catch
    disp('BREAK Problem in AP_DataCore_Merge')
end

end


% % https://www.mathworks.com/matlabcentral/answers/169501-merge-structures-with-subfields
% % function out = CatStructByTime(in ,timename)
% %    %in: a structure array with at least one field called 'timename'
% %      for field = fieldnames(in)'
% %         field = field{1};
% %         if strcmp(field, timename)
% %            reftime = {in(:).(timename)}';
% %            offsets = num2cell(cumsum([0; cellfun(@(tv) sum(tv([2 end])), reftime(1:end-1))]));
% %            out.(field) = cell2mat(cellfun(@(tv, o) tv+o, reftime, offsets, 'UniformOutput', false));
% %         else
% %            out.(field) = CatStructRecurse(arrayfun(@(s) s.(field), in, 'UniformOutput', false));
% %         end
% %      end
% %   end
% % function out = CatStructRecurse(sc)
% %    %sc: a cell array of scalar structures
% %    if isstruct(sc{1})
% %       for field = fieldnames(sc{1})'
% %          field = field{1};
% %          out.(field) = CatStructRecurse(cellfun(@(s) s.(field), sc, 'UniformOutput', false));
% %       end
% %    else
% %       out = vertcat(sc{:});
% %    end
% % end