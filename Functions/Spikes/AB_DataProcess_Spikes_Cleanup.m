function [filter,dataTS,dataWV]=AB_DataProcess_Spikes_Cleanup(action,dataTS,dataWV,threshold,filter)

switch action
    case 'ini'
%% Initialize
if iscell(dataTS)
    nCells=size(dataTS,2);
    for c=1:nCells
        filter{c}=true(size(dataTS{c}));
    end
else
    nCells=1;
    filter=true(size(dataTS));
end
%%  Create Filter and Adjust data
if ~isempty(dataWV) | ~isempty(threshold)
    if iscell(dataTS)
        for c=1:nCells
            thisWV=dataWV{c};
            thisWV=reshape(thisWV(1,:,:),size(thisWV,2),size(thisWV,3),1);
% Auto threshold            
            if ~isnumeric(threshold)
                thisWV_AVG=mean(thisWV,2);
                threshold=min(thisWV_AVG)*4;
            end
% Find spikes above threshold
            thisWV_Max=max(thisWV,[],1);
            thisWV_Min=min(thisWV,[],1);
            filter{c}(thisWV_Max>-threshold)=false;
            filter{c}(thisWV_Min<threshold)=false;
% Adjusting data        
            dataTS{c}=dataTS{c}(filter{c});
            dataWV{c}=dataWV{c}(:,:,filter{c});
             if sum(filter{c})<length(filter{c})
                nArtifacts=length(filter{c})-sum(filter{c});
                disp(sprintf('Removed %.d spikes for cell %.d',nArtifacts,c))
            end
        end
    else
            thisWV=dataWV;
            thisWV=reshape(thisWV(1,:,:),size(thisWV,2),size(thisWV,3),1);
%% If no mutiple cells
% Auto threshold            
            if ~isnumeric(threshold)
                thisWV_AVG=mean(thisWV,2);
                threshold=min(thisWV_AVG)*2;
            end
% Find spikes above threshold
            thisWV_Max=max(thisWV,[],1);
            thisWV_Min=min(thisWV,[],1);
            filter(thisWV_Max>-threshold)=false;
            filter(thisWV_Min<threshold)=false;
% Adjusting data        
            dataTS=dataTS(filter);
            dataWV=dataWV(:,:,filter);
    end
end

%% APPLY FILTER
    case "update"
if ~isempty(dataWV) | ~isempty(threshold)
    if iscell(dataTS)
        for c=1:size(dataTS,2)     
            dataTS{c}=dataTS{c}(filter{c});
            dataWV{c}=dataWV{c}(:,:,filter{c});
        end
    else    
        dataTS=dataTS(filter);
        dataWV=dataWV(:,:,filter);
    end
end
end
end