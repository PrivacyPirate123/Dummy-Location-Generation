%% This function generates k-1 dummy locations within the local map.
function [dummyLocations] = RandomDummyGeneration(userpos,k)
    %% The probability points are loaded from the mat file
    load('cells.mat','cells')
    %% The cell of the user is found
    % the cell of the user is removed from the array cells to ensure
    % that a randomly generated dummy location is not positioned at the
    % same location as the user
    for i=1:size(cells,1)
        if userpos(1,1) == cells(i,1) && userpos(1,2) == cells(i,2)
            usercell=cells(i,:);
            cells(i,:)=[];
            break
        end
    end
    %% The dummy locations are chosen at random
    % the number of cells with no minutes is found
    zeros=0;
    for i=1:size(cells,1)
        if cells(i,3)==0
            zeros=zeros+1;
        end
    end
    % the cells are ordered according to the number of minutes
    % the information corresponding to each cell must be shuffled before
    % they can be sorted to ensure that the cells are ordered only
    % according to the number of minutes and not the
    % position within the local map
    cells=cells(randperm(size(cells,1)),:);
    cells=sortrows(cells,3);
    % the first zeros rows of the array cells are then removed
    cells(1:zeros,:)=[];
    % k-1 cells are chosen at from from the array cells to represent
    % the location information of the LBS request
    dummyLocations=NaN(k-1,3);
    dummyindexes=randi([1 size(cells,1)],k-1,1);
    for i=1:size(dummyindexes,1)
        dummyLocations(i,:)=cells(dummyindexes(i,:),1:end);
    end
    %% The location information is returned
    % the position of the user is added to the array of of generated dummy
    % locations
    dummyLocations=[dummyLocations; usercell];
    % the array of locations is then shuffled to ensure that an adversary
    % cannot deduce the genuine location of the user from the location
    % information
    dummyLocations=dummyLocations(randperm(size(dummyLocations,1)),:);