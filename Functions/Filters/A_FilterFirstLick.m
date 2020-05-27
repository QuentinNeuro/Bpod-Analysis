function Analysis=A_FilterFirstLick(Analysis,FilterName)
% Function to create a filter related to the detection of a lick during a
% given period and to zero the traces according to the timing of this lick.
% The filters is originally computed in AP_DataOrganize. This function
% moves the filter to Analysis.Filters structure
%
% Function designed by Quentin 2017 for Analysis_Photometry

disp('First lick filter function is depricated. Filter is now generated in the AP_DataProcess_Licks function')

% %% Check
% checkExist=FilterName;
% if isfield(Analysis.Filters,checkExist)
%     disp(['Filter ' checkExist ' already generated']);
% else
% 
% % Name
% FilterNb=length(Analysis.Filters.Names);
% Analysis.Filters.Names{FilterNb+1}=FilterName;
% Analysis.Filters.Names{FilterNb+2}=[FilterName 'Inv'];
% 
% %% Check whether filter is present
% if isfield(Analysis.Filters,'FirstLick')
%     Logicals=Analysis.Filters.FirstLick';
% else
%     Logicals=ones(Analysis.AllData.nTrials,1);
% end
% LogicalsInv=~Logicals;
% %% Reallocate filer
%  
% Analysis.Filters.Logicals=[Analysis.Filters.Logicals Logicals LogicalsInv];
% end
end