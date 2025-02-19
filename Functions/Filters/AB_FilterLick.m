function Analysis=AB_FilterLick(Analysis,FilterName,Time,Threshold)
% Function to filter trials according to the number of Lick in a defined
% time window. Generates an additional inverted filter.
%
% Function designed by Quentin 2020 for Analysis_Photometry

%% Check
checkExist=FilterName;
if isfield(Analysis.Filters,checkExist)
    disp(['Filter ' checkExist ' already generated']);
return
end
%% Filter
Logicals=false(Analysis.AllData.nTrials,1);
for i=1:Analysis.AllData.nTrials
	counter = 0;
% Quentin Specific Timing
if ischar(Time)
    switch Time
        case 'Cue'
            Time=Analysis.AllData.Time.Cue(i,:);
        case 'Delay'
            Time=Analysis.AllData.Time.Delay(i,:);
        case 'Outcome'
            Time=Analysis.AllData.Time.Outcome(i,:);
    end
end
    for j = Analysis.AllData.Licks.Events{i}
        if j > Time(1)  && j < Time(2)
            counter = counter + 1;
        end
    end
    if counter > Threshold
        Logicals(i)=true;
    end
end

%% Save
Analysis.Filters.(FilterName)=Logicals;
Analysis.Filters.([FilterName 'Inv'])=~Logicals;
end