%% This program generates a square grid of cells.
format long
%% The position data is loaded from the mat files
position0Data10=load('D:\Data\0data20.mat','positionData');
positionData=[position0Data10.positionData];
%% The cells are generated below
% the MATLAB function meshgrid is used to generate the coordinates of the 
% center of each cell
% each cell covers an area of 592.2 meters squared
[lat,lon]=meshgrid(39.95+0.000125:0.00025:40.0-0.000125,116.3+0.000125:0.00025:116.35-0.000125);
cells=[lat(:),lon(:)];
%% The position data is modified
% the time-stamped data for each user is altered to ensure that each
% time-stamp is separated by at least sixty minutes
% here value is the time value of the first time-stamp of the first user
% value=position0Data20(1,3);
% positionData=position0Data20(1,:);
% for i=2:size(position0Data20,1)
%     % if the current time-stamp and the previous time-stamp correspond to
%     % the same user
%     if position0Data20(i,4)==position0Data20(i-1,4)
%         % if the difference between the time of the current time-stamp and
%         % value is less than sixty minutes the loop continues
%         if (position0Data20(i,3)-value)<(1/24)
%         % if the difference between the time of the current time-stamp and
%         % value is greater than or equal to sixty minutes then then value 
%         % is updated to the time of the current time-stamp and the current
%         % time-stamp is appended onto the end of the positionData array
%         else
%             value=position0Data20(i,3);
%             positionData=[positionData; position0Data20(i,:)];
%         end
%     % else value is set to equal the time of the first time-stamp of the
%     % new user
%     else
%         value=position0Data20(i,3);
%         positionData=[positionData; position0Data20(i,:)];
%     end
% end
%% The closest cell to each time-stamp is found
for i=1:size(positionData,1)
    percentage=(i/size(positionData,1))*100
    % the latitude of the time-stamp
    lat=positionData(i,1);
    % the longitude of the time-stamp
    lon=positionData(i,2);
    % the minimum distance is initially set to equal 8000m
    mindistance=8000;
    % indexes holds the indexes of the the closest cells
    indexes=[];
    for j=1:size(cells,1)
        % the latitude of the cell
        latcell=cells(j,1);
        % the longitude of the cell
        loncell=cells(j,2);
        X=[lat, lon; latcell, loncell];
        % the distance between the time-stamp of the cell
        distance=pdist(X,'euclidean');
        % if the distance is smaller than mindistance then mindistance is
        % updated
        if distance < mindistance
            mindistance=distance;
            indexes=[j];
        elseif distance==mindistance
            indexes=[indexes, j];
        end
    end
    index1=randi([1 size(indexes,1)],1,1);
    index2=indexes(1,index1);
    positionData(i,1:2)=cells(index2,1:2);
end
%% The total amount of time is found
% totalTime=max(positionData(:,3))-min(positionData(:,3));
%% The number of users that entered each cell is found