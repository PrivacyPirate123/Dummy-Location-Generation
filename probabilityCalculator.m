%% This function calculates the query probability of each cell.
function [probabilities,userProbability] = ...
    probabilityCalculator(userpos,cells)
    % the total minutes of all users within the local map of the user is
    % found
    total=0;
    for i=1:size(cells,1)
        total=total+cells(i,3);
    end
    % the query probabilities of each cell are stored within the array 
    % probabilities
    probabilities=NaN(size(cells,1),4);
    % the total minutes of all users within the local map of the user is 
    % used to find the query probability of each cell
    for i=1:size(cells,1)
        % the query probability of the user is found
        if cells(i,1) == userpos(1,1) & cells(i,2) == ...
                userpos(1,2)
            userProbability=cells(i,3)/total;
        end
        % the query probability of each cell is found
        probability=cells(i,3)/total;
        % the information corresponding to each cell is then stored within 
        % the array probabilities
        probabilities(i,:)=[cells(i,1), cells(i,2), ...
            cells(i,3), probability];
    end
end