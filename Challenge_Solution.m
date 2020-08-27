%% Data Wrangling Challenge Solutions
% *Ebude Yolande*
%%
% Challenge I:
%
% 1. Import iot excel file
%%
iot_xlsx=readtable('iot.xlsx');
head(iot_xlsx,3);
%%
% 2. Modify the device column by removing the colon that separate each term (for example 1c:bf:ce:15:ec:4d becomes 1cbfce15ec4d).
%%
new=[]; % create empty list
for i=1:height(iot_xlsx)
    val=strsplit(cell2mat(iot_xlsx.device(i)),':');% cell2mat get the string from the cell
    val1=join(val,'');% join all the item in the list with no space
    new=[new val1(1)]; % append to a list
end
iot_xlsx.('new_device')=new'; %'transpose list
head(iot_xlsx,3);
%%
% Challenge II
%
%  1. Remove the column 'is_disabled' from the bike share excel dataset.
%%
BShare_xlsx=readtable('bike-share.xlsx');
BShare_xlsx=removevars(BShare_xlsx,'is_disabled');
head(BShare_xlsx,3);
% use movevars(BShare_xlsx,'lon','After','lat') or
% movevars(BShare_xlsx,'lon','Before','bike_id') to move column position
%%
%  2. Merge the new bike-share.xlsx and iot.xlsx depending on time
%%
BShare_xlsx.('ts')=BShare_xlsx.('rec_update');
BShare_iot=innerjoin(BShare_xlsx,iot_xlsx,'key','ts');
head(BShare_iot,3);
%%
%  3. Create a new dataset which is the subset of the one in 2. where the co value is greater than the mean value of the iot.xlsx dataset.
%%
BShare_iot_m=BShare_iot(BShare_iot.co > mean(iot_xlsx.co),:);
head(BShare_iot_m,3);