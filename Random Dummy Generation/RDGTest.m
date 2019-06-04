%% This script generates k-1 dummy locations within the local map.
clf
% the radius of the earth is found
load conus
earthradius=almanac('earth','radius');
%% The local map of the user is loaded from the mat file
load('cells.mat','cells')
format long
allentropies=NaN(48,200);
alltimes=NaN(48,200);
allareas=NaN(48,200);
for n=1:200
    for k=3:50
        %% The user's location is chosen at random from the local map
        userindex=randi([1 size(cells,1)],1,1);
        while cells(userindex,3)==0
            userindex=randi([1 size(cells,1)],1,1);
        end
        userpos=[cells(userindex,1),cells(userindex,2)];
        %% Random Dummy Generation is called
        tic
        dummyLocations=RandomDummyGeneration(userpos,k);
        et=toc;
        alltimes(k-2,n)=et;
        %% The boundary is found
        dummyx=dummyLocations(:,1);
        dummyy=dummyLocations(:,2);
        q=convhull(dummyx,dummyy);
        %% The area of the location information is found
        area=areaint(dummyx(q),dummyy(q))*4*pi*earthradius*earthradius;
        allareas(k-2,n)=area;
        %% The entropy of the location information is found
        qprobabilities=NaN(size(dummyLocations,1),1);
        totalMinutes=0;
        for i=1:size(cells,1)
            totalMinutes=totalMinutes+cells(i,3);
        end
        for i=1:size(dummyLocations,1)
            qprobabilities(i,:)=dummyLocations(i,3)/totalMinutes;
        end
        totalProbs=0;
        for i=1:size(qprobabilities,1)
            totalProbs=totalProbs+qprobabilities(i,1);
        end
        for i=1:size(qprobabilities,1)
            qprobabilities(i,1)=qprobabilities(i,1)/totalProbs;
        end
        for i=1:size(qprobabilities,1)
            qprobabilities(i,1)=qprobabilities(i,1)*log2(qprobabilities(i,1));
        end
        entropy=0;
        for i=1:size(qprobabilities,1)
            entropy=entropy-qprobabilities(i,1);
        end
        allentropies(k-2,n)=entropy;
    end
end