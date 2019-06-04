%% This script measures the performance metrics of the DLG 2 algorithm.
% the radius of the earth is found
load conus
earthradius=almanac('earth','radius');
%% The local map of the user is loaded from the mat file
load('cells.mat','cells')
format long
allentropies=NaN(18,50);
alltimes=NaN(18,50);
allareas=NaN(18,50);
for n=1:50
    for k=3:20
        %% The cell of the user is chosen at random from the local map
        userindex=randi([1 size(cells,1)],1,1);
        while cells(userindex,3)==0
            userindex=randi([1 size(cells,1)],1,1);
        end
        userpos=[cells(userindex,1),cells(userindex,2)];
        %% Dummy Location Generation 2 is called
        tic
        dummyLocations=TestDummyLocationGeneration2(userpos,k);
        et=toc;
        alltimes(k-2,n)=et;
        %% the boundary of the location information is plotted below
        dummyx=dummyLocations(:,1);
        dummyy=dummyLocations(:,2);
        q=convhull(dummyx,dummyy);
        %% The area of the location information is found
        % the area of the location information is found using the MATLAB function
        % areaint
        area=areaint(dummyx(q),dummyy(q))*4*pi*earthradius*earthradius;
        allareas(k-2,n)=area;
        %% The entropy of the location information is found
        qprobabilities=dummyLocations(:,4);
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