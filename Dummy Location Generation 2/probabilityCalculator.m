%% This function calculates the query probability of each cell.
function [probabilities,userProbability] = ...
    probabilityCalculator(userpos,probsPoints)
    % the total sum of the user population within the local map is found
    total=0;
    for i=1:size(probsPoints,1)
        total=total+probsPoints(i,3);
    end
    % the query probabilities of each cell are stored within the array 
    % probabilities
    probabilities=NaN(size(probsPoints,1),4);
    % the total user population within the local map is used to find the 
    % query probability of each cell
    for i=1:size(probsPoints,1)
        % the query probability of the user is found
        if probsPoints(i,1) == userpos(1,1) & probsPoints(i,2) == ...
                userpos(1,2)
            userProbability=probsPoints(i,3)/total;
        end
        % the query probability of each cell is found
        probability=probsPoints(i,3)/total;
        % the information corresponding to each cell is then stored within 
        % the array probabilities
        probabilities(i,:)=[probsPoints(i,1), probsPoints(i,2), ...
            probsPoints(i,3), probability];
    end
end