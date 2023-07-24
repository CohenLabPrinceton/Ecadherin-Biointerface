function [ID_sort]=CSV_trackreader(Trackname)
disp('Importing track data...');
Trackdata=readtable(Trackname);
ID_sort = sortrows(Trackdata,{'Track_ID','Frame'});
%% Remove track with no track number
nonefilter=~isnan(ID_sort.Track_ID);
ID_sort = ID_sort(nonefilter(:,1),:);
end