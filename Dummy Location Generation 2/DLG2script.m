%% This script loads the local map of the user and calls the DLGAlgorithm.
clf
% the local map of the user is loaded
load('localMap.mat','probsPoints')
format long
%% The cell of the user is chosen at random from the local map
% the cell of the user is chosen at random from the set of cells in
% which the population of users is one or more
% a random index is generated below
userindex=randi([1 size(probsPoints,1)],1,1);
% if the number of users within the chosen cell is zero, then another cell
% is chosen at random until the population of users within the chosen cell 
% is greater than zero
while probsPoints(userindex,3)==0
    % a new cell is chosen at random
    userindex=randi([1 size(probsPoints,1)],1,1);
end
% the (x,y) coordinate of the user is found
userpos=[probsPoints(userindex,1),probsPoints(userindex,2)];
%% The Dummy Location Generation Algorithm v. 5 is called
a='low';
b='medium';
c='high';
tic
dummyLocations=DummyLocationGeneration2(userpos,'low');
toc
%% The generated dummy locations are plotted below
axis equal
hold on
grid on
grid minor
% ensures that the x and y axis are centered at the origin
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
% the title of the plot
title('Generating Dummy Locations using the $\it k-anonymity$ metric and the $\it entropy$ metric','Interpreter','latex')
% the x axis label
xlabel('$\it x$ coordinate','Interpreter','latex')
% the y axis label
ylabel('$\it y$ coordinate','Interpreter','latex')
% the x axis limit
xlim([-5000 5000])
% the y axis limit
ylim([-5000 5000])
% the border of the local map of the user is plotted below
x=[-3500, 3500, 3500, -3500, -3500];
y=[3500, 3500, -3500, -3500, 3500];
plot(x,y,'m--')
% the center of the cell of the user is plotted below
plot(userpos(1,1),userpos(1,2),'bx')
% the dummy locations are plotted below
for i=1:size(dummyLocations,1)
    plot(dummyLocations(i,1),dummyLocations(i,2),'kx')
end
% the boundary of the locations are plotted below
dummyx=dummyLocations(:,1);
dummyy=dummyLocations(:,2);
q=boundary(dummyx,dummyy);
plot(dummyx(q),dummyy(q),'r')
hold off
legend({'The border of the local map of the user', ...
    'The center of the cell of the user', ...
    'The generated dummy locations'},'Interpreter','latex')
%% The area of the location information is found
% the area of the location information is found using the MATLAB function
% polyarea
area=polyarea(dummyx(q),dummyy(q));
%% The entropy of the location information is found
qprobabilities=dummyLocations(:,4);
% the query probabilities of the generated location information are
% normalised
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
areamessage = sprintf('The area of the location information is %d meters squared.',area);
disp(areamessage)
entropymessage = sprintf('The entropy of the location information is %d.',entropy);
disp(entropymessage)
maxentropymessage=sprintf('The maximum possible entropy is equal to %d.',maxentropy);
disp(maxentropymessage)