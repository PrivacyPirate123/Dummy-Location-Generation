%% This script generates k-1 dummy locations within the local map.
clf
% the radius of the earth is found
load conus
earthradius=almanac('earth','radius');
%% The local map of the user is loaded from the mat file
load('cells.mat','cells')
format long
%% The user's location is chosen at random from the local map
% the cell of the user is chosen at random from the set of cells which have
% greater then zero minutes
userindex=randi([1 size(cells,1)],1,1);
% if the number of minutes within the chosen cell is zero, another cell is 
% chosen again at random until the number of minutes within the 
% chosen cell is greater than zero
while cells(userindex,3)==0
    userindex=randi([1 size(cells,1)],1,1);
end
% the (lat,lon) coordinate of the user is found
userpos=[cells(userindex,1),cells(userindex,2)];
%% Random Dummy Generation is called
k=15;
tic
dummyLocations=RandomDummyGeneration(userpos,k);
toc
%% The generated dummy locations are plotted below
axis equal
hold on
grid on
grid minor
% ensures that the x and y axis are centered at the origin
ax = gca;
% the title of the plot
title('Generating Dummy Locations using Random Dummy Generation','Interpreter','latex')
% the x axis label
xlabel('latitude','Interpreter','latex')
% the y axis label
ylabel('longitude','Interpreter','latex')
% the x axis limit
xlim([39.95 40.00])
% the y axis limit
ylim([116.30 116.35])
% the dummy locations are plotted below
plot(dummyLocations(:,1),dummyLocations(:,2),'ko')
% the boundary of the locations are plotted below
dummyx=dummyLocations(:,1);
dummyy=dummyLocations(:,2);
q=convhull(dummyx,dummyy);
plot(dummyx(q),dummyy(q),'r','LineWidth',2)
plot(userpos(1,1),userpos(1,2),'bo')
hold off
legend({'The generated dummy locations','The $\it privacy$ $\it area$','The genuine location of the user'},'Interpreter','latex')
%% The area of the location information is found
% the area of the location information is found using the MATLAB function
% areaint
area=areaint(dummyx(q),dummyy(q))*4*pi*earthradius*earthradius;
%% The entropy of the location information is found
% the query probabilities of the location information is stored within the
% array qprobabilities
qprobabilities=NaN(size(dummyLocations,1),1);
% the total number of minutes within the local map of the user is found
totalMinutes=0;
for i=1:size(cells,1)
    totalMinutes=totalMinutes+cells(i,3);
end
% the query probabilities of the generated location information are found
for i=1:size(dummyLocations,1)
    qprobabilities(i,:)=dummyLocations(i,3)/totalMinutes;
end
% the query probabilities of the generated location information are
% then normalised
% the sum total of the query probabilities is found
totalProbs=0;
for i=1:size(qprobabilities,1)
    totalProbs=totalProbs+qprobabilities(i,1);
end
% each of the query probabilities are divided by the sum total of the query
% probabilities
for i=1:size(qprobabilities,1)
        qprobabilities(i,1)=qprobabilities(i,1)/totalProbs;
end
% each of the query probabilities are then multiplied by the logarithm of
% themselves
for i=1:size(qprobabilities,1)
    qprobabilities(i,1)=qprobabilities(i,1)*log2(qprobabilities(i,1));
end
% the entropy is then equal to the sum of the array of values
% qprobabilities
entropy=0;
for i=1:size(qprobabilities,1)
    entropy=entropy-qprobabilities(i,1);
end
%% The area and entropy of the location information is displayed
maxentropy=log2(size(dummyLocations,1));
areamessage = sprintf('The area of the location information is %d kilometers squared.',area);
disp(areamessage)
entropymessage = sprintf('The entropy of the location information is %d.',entropy);
disp(entropymessage)
maxentropymessage=sprintf('The maximum possible entropy is equal to %d.',maxentropy);
disp(maxentropymessage)