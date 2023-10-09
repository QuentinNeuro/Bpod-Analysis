function [GroupPlot,GroupCorr,GroupTest]=AP_CuedOutcome_AC_FilterGroups(Analysis)
% GroupPlot   : Group for general plotting purposing
% GroupCorr   : Group for regression
% GroupTest   : Group for testing performance using A_Performance
%function designed by Quentin 2017

GroupPlot={};
GroupCorr={};
indexp=0;
if length(Analysis.Parameters.Illustration)==2
    Analysis.Parameters.Illustration(3)=0;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
GroupTest=AP_CuedOutcome_FilterGroups_Test(Analysis);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
switch Analysis.Parameters.Phase
        case {'Habituation'}
indexp=indexp+1;
GroupPlot{indexp,1}='Reward';
GroupPlot{indexp,2}={   'Uncued_Reward'             {'Uncued','Reward','LicksOutcome','FirstLick'};... 
                        'Uncued_Reward_NotColl'     {'Uncued','Reward','LicksOutcomeInv','FirstLick'};...
                        'Uncued_Omission',          {'Omission'}};
GroupCorr{1,1}='Reward_Correlation';
GroupCorr{1,2}={        'Uncued_Reward',            {'Uncued','Reward','LicksOutcome','FirstLick'}};

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  
    case {'Habituation'}

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%         
case {'Train3C'}
    indexp=indexp+1;
GroupPlot{indexp,1}='RewardExpectation';
GroupPlot{indexp,2}={'HighValue',                   {'HVS','Reward','LicksOutcome'};...
                     'LowValue',                    {'LVS','Reward','LicksOutcome'}}; 
case {'Test3C-RewardSize'}
    indexp=indexp+1;
GroupPlot{indexp,1}='LowValueError';
GroupPlot{indexp,2}={'LV_Predicted',           	{'type_1','LicksOutcome'};...
                     'LV_Bigger',               {'type_2','LicksOutcome'};...
                     'LV_Omitted',              {'type_3'}};
    indexp=indexp+1;
GroupPlot{indexp,1}='HighValueError';
GroupPlot{indexp,2}={'HV_Predicted',           	{'type_4','LicksOutcome'};...
                     'HV_Smaller',              {'type_5','LicksOutcome'};...
                     'HV_Omitted',              {'type_6'}};
    indexp=indexp+1;
GroupPlot{indexp,1}='NoValueError';
GroupPlot{indexp,2}={'NV_Predicted',           	{'type_7','LicksOutcome'};...
                     'NV_Bigger',               {'type_8','LicksOutcome'}};
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%    

if Analysis.Parameters.Illustration(3)
GroupPlot=AP_CuedOutcome_FilterGroups_Arousal(GroupPlot,indexp,Analysis);
end

end
