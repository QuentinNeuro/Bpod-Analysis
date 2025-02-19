function A_FilterIgnoredTrials_StopLicks(Analysis,testrun)
%% BROKEN

if testrun
%% Looking for the filter
FilterName='Reward';
test=0;
counter=0;
while test==0 && counter<=length(Analysis.Filters.Names)
    counter=counter+1;
    if strcmp(Analysis.Filters.Names{counter},FilterName)
        test=1;
    end
end
%% Extract Data
outcometimereset=[0 2];
thisFilter      = logical(Analysis.Filters.Logicals(:,counter));
thisLicks       = Analysis.AllData.Licks.Events(thisFilter);
thisIndex       = Analysis.AllData.TrialNumbers(thisFilter);
thisOutcomeTime = Analysis.AllData.OutcomeTime(thisFilter,:)+outcometimereset;
trialsNoLicks   =[]; 

for i=1:length(thisLicks)
    counter=0;
    for j = thisLicks{i}
        if j > thisOutcomeTime(i,1)  && j < thisOutcomeTime(i,2)
            counter=counter+1;
        end
    end
    if counter==0
        trialsNoLicks=[trialsNoLicks thisIndex(i)];
    end
end

%% Plot the found limits
AllEvents=cell2mat(Analysis.AllData.Licks.Events);
AllTrials=cell2mat(Analysis.AllData.Licks.Trials);
figure()
plot(AllEvents,AllTrials,'sk','MarkerSize',2,'MarkerFaceColor','k');
set(gca,'YDir','reverse');
hold on
for i=trialsNoLicks
    plot([-4 4],[i i],'-r');
end

CutoffTrial=input('Select the cutoff trial #');

%% Save the ignoredTrials file
% ITFile=[Analysis.Parameters.Name '_ignoredTrials.mat'];
% if exist(ITFile,'file')
%   load(ITFile);  
% end



end

