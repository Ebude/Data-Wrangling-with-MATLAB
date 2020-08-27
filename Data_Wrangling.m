%% MATLAB Programing
% *Ebude Yolande*

%%
% The following datasets would be used throughout this worksheet:
% 
% * IoT sensor dataset:
% <https://drive.google.com/file/d/1xsiMGpOULuO3Ei2U4lyUpmtTLOVHaAB3/view?usp=sharing>
% * Grid bikeshare data:
% <https://drive.google.com/file/d/1mwQV2uDxRuEwULFdVKC8H9NZXRCkARkK/view?usp=sharing>
% 

%% 1.Dealing with columns in a dataset
%Manipulating data columns, making them easy to interprete and use in analysis. 
%%
iot = readtable('iot_telemetry_data.csv');
head(iot,3)

%%
%Get more information on the dataset
summary(iot);
height(iot);  %number of rows
width(iot); %number of columns
size(iot); % both number of rows and columns
%%
%Get more information from a function
%help('readtable');
%%
%Convert the character to float
for i=[1,3,4,6,8,9]
    iot.(i)=str2double(iot.(i));
end
%head(iot,3)
%%
%Convert column ts to readable datetime
iot.ts=datestr(iot.ts,31); % check datestr function using help
iot.ts(1:6);
%%
%The decimal points on the columns with type double.
for i=[3,4,6,8,9]
    iot.(i)=round(iot.(i),4);
end
head(iot,3);
%%
% Exercise 1
% We would look at the free bike dataset.

%%
% 1. Import json file
BShare=jsondecode(fileread('free-bike-status-1.json'));
%BShare is a structure, we can read the name column as
BShare.data.bikes.name;
%To bring it to the table we use struct2table function
BShare=struct2table(BShare.data.bikes);
head(BShare,3);

%%
% 2. Removing unecessary info
new=cell([1,height(BShare)]); % create empty cell
for i=1:height(BShare)
    val=strsplit(cell2mat(BShare.bike_id(i)),'_'); % cell2mat get the string from the cell
    new(i)=val(2); 
end
BShare.('id')=str2double(new');
head(BShare,3);
%%
% 3. Save in txt
BShare.('rec_update')=iot.ts(1:21,:);
writetable(BShare,'bike-share.xlsx');
writetable(iot(1:100,:),'iot.xlsx');

%%
% Challenge I:
%
% * 1. Import iot excel file
% * 2. Modify the device column by removing the colon that separate each term (for example 1c:bf:ce:15:ec:4d becomes 1cbfce15ec4d).
%% 2.	Selecting subsets and merging of datasets.
% Selecting the appropraite subset of a data to use as well as merging different datasets are very important.
iot(1:4, :); % first 4 elements in the table, you can select the columns as well
iot.('ts'); % replace 'ts' with 1 if you knew just the position
%%
% From the iot_telemery csv dataset, we would select the data of device b8:27:eb:bf:9d:51.
iot_d1=iot(strcmp(iot.device, 'b8:27:eb:bf:9d:51'), :);
head(iot_d1,3);
% we can add more conditions
iot_d2=iot(iot.co >0.005 & iot.temp > 19.0,:);
head(iot_d2,3);

%%
% We would merge the two new datasets to reconstruct the old dataset.
iot_d = [iot_d1; iot_d2];
head(iot_d, 3);

%% 
% Exercise II:
%%
% 1. Creating a vector from taking the last 30 elements in a column ts of iot_d2 and assign to first 30 elements in iot_d1, for example
% x=[2,6,4,8,1,5,8,9], new_x=[9,8,5,1]

%%
iot_d1.('ts')(1:30,:)= flip(iot.ts(height(iot)-29:height(iot),:));
head(iot_d1,3);

%%
% 2.Create a new dataset of iot data merging iot_d1 and iot_d2 based on column ts.
%%
iot_d=innerjoin(iot_d1, iot_d2,'key','ts');
head(iot_d,3);
%%
% Challenge II
%
% * 1. Remove the column 'is_disabled' from the bike share excel dataset.
% * 2. Merge the new bike-share.xlsx and iot.xlsx depending on time
% * 3. Create a new dataset which is the subset of the one in 2. where the co value is greater than the mean value of the iot.xlsx dataset.
%% 3. Reusable Code

% Functions: It is important to write codes in functions so they can be
% easily used.
% roundallcol is a function which takes a table, round the values which are
% of class double then return the modify table
%%
iot_mod=roundallcol(iot,3);
head(iot_mod,3);
%%
% Process: This is a void function, it just executes
% instructions.
% This process takes an interger and multiply to a random number, then
% ask the player to guess the random number.
%%
% uncomment and run
 % guessrand(8);
%%
% Call another script into this script.
% It is good practice to keep functions in separate script and just call
% them into your working script
%%
iot_m=rmuwinfo(BShare,'bike_id','_');
head(iot_m,3);
%%
% Functions must always be at the end of the script
%%
function tab = roundallcol(dt,num) % Function
    for i=1: width(dt)
        if (class(dt.(i))== "double") % chechs if class of column is double
            dt.(i)=round(dt.(i),num); % rounds all values
        end
    end 
    tab = dt;
end


function guessrand(a) % Process
    b=randi(50);
    disp('Result of multiplication'); % print information on command window
    disp(b*a);
    quest= 'Suggest the number: '; % Request user input
    x=input(quest);
    if (b==x) 
        disp('Good Guess!!!');
       
    else 
            disp('Wrong Guess!');
            disp(b);
    end
end 

