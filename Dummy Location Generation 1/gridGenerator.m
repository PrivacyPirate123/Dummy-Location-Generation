%% This program generates a square grid of cells.
format long
%% The cells are generated below
% the MATLAB function meshgrid is used to generate the probability points
% located at the center of each cell
% each cell covers an area of 25m x 25m
[probsx,probsy]=meshgrid(-3487.5:25:3487.5,-3487.5:25:3487.5);
% the random values assigned to each cell are generated
% below using the MATLAB function randi
% the random values are generated within the range [a b] inclusive
a=0;
b=25;
% there are 78400 cells / probability points in total within the local map
randomValues=randi([a b],78400,1);
% each cell is assigned a random value used to represent the population of
% users within each cell
probsPoints=[probsx(:),probsy(:),randomValues];
%save('localMap.mat','probsPoints')