format long
%% The cells are generated below
% the MATLAB function meshgrid is used to generate the coordinates of the 
% center of each cell
% each cell covers an area of 592.2 meters squared
% the third column of the array cells holds the total time spent by all
% users within each cell
cells=zeros(40000,3);
[lat,lon]=meshgrid(39.95+0.000125:0.00025:40.0-0.000125,116.3+0.000125:0.00025:116.35-0.000125);
cells(:,1)=lat(:);
cells(:,2)=lon(:);
%% The position data is loaded from the mat file
% positiontData=load('D:\Data\oneminutefinalpositiontData.mat','positiontData');
% positiontData=[positiontData.positiontData];
users=0:1:181;
%% The total minutes are found
for i=1:size(users,2)
    iuserData=[];
    % the percentage
    percentage=(i/size(users,2))*100
    % the position data for each user is found
    for j=1:size(positiontData,1)
        if positiontData(j,4)==1
            iuserData=[iuserData; positiontData(j,:)];
        end
    end
    sortrows(iuserData,3);
    % the time each user spends within each cell is found
    for k=1:size(cells,1)
        cell=cells(k,1:2);
        % this function returns the time that each user has spent in each
        % cell
        time=func(iuserData,cell);
        cells(k,3)=cells(k,3)+time;
    end
end