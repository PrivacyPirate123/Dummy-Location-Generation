%% This function generates k-1 dummy locations within the local map.
function [dummyLocations] = TestDummyLocationGeneration2(userpos,k)
    %% The local map of the user is loaded from the mat file
    load('cells.mat','cells')
    %% The query probabilities of the local map are found
    % the query probabilities of the set cells within the local map of the 
    % user are calculated using the function probabilityCalculator
    [probabilities,userProbability]= ...
        probabilityCalculator(userpos,cells);
    %% The 4k candidate dummy locations are chosen from the local map
    % all of the cells within the local map are ordered according to the
    % value of the query probabilities
    % the information corresponding to each cell must be shuffled before
    % they can be sorted to ensure that the cells are ordered only
    % according to the value of the query probabilities and not the
    % position within the local map
    probabilities=probabilities(randperm(size(probabilities,1)),:);
    probabilities=sortrows(probabilities,4);
    % the index of the cell of the user within the array probabilities is
    % found
    for i=1:size(probabilities,1)
        if probabilities(i,1) == userpos(1,1) && probabilities(i,2) == ...
                userpos(1,2)
            userindex=i;
            break
        end
    end
    % the row corresponding to the cell of the user within the array
    % probabilities is stored within the vector usercell
    usercell=probabilities(userindex,:);
    % the row is then removed from the array probabilities
    probabilities(userindex,:)=[];
    % the indexes of the cells with the same query probability as the user
    % are then found and stored within the array sorting
    sorting=[];
    for i=1:size(probabilities,1)
        if probabilities(i,4)==userProbability
            sorting=[sorting, i];
        end
    end
    % the new index corresponding to the cell of the user is found
    % if the number of cells with the same query probability as the user is
    % greater than or equal to two
    if size(sorting,2) >= 2
        % the new index of the user is the index in the middle of the cells
        % with the same query probability as the user
        newindex=round((sorting(1,end)+sorting(1,1))/2);
    % if there are no cells with the same query probability as the user
    elseif size(sorting,2) == 0
        newindex=userindex;
    % if there is only one cell with the same query probability as the user
    elseif size(sorting,2) == 1
        % the new index of the user is the index of the cell with the same 
        % query probability as the user
        newindex=sorting(1,1);
    end
    if newindex > size(cells,1)-2*k
        newindex=size(cells,1)-2*k;
    end
    % the information corresponding to the cell of the user is inserted
    % into the array probabilities at the new index
    probabilities=[probabilities(1:newindex-1,:); usercell; probabilities(newindex:end,:)];
    % the 4k candidate dummy locations are stored within the array
    % candidates
    candidates4k=NaN(4*k,4);
    candidates4k(1:2*k,:)=probabilities(newindex-2*k:newindex-1,:);
    candidates4k(2*k+1:4*k,:)=probabilities(newindex+1:newindex+2*k,:);
    %% The m sets of cells are generated
    % the 4k candidate dummy locations are arranged into m sets of 2k+1
    % cells each made up of the cell of the user and 2k candidate dummy 
    % locations
    m=k;
    % each row of the array indexes holds the indexes of the the 2k 
    % candidate dummy locations that make up each set
    indexes=NaN(m,2*k);
    for i=1:m
        % the MATLAB function randperm is used to generate 2k indexes of
        % the array of 4k candidate dummy locations candidates4k
        indexes(i,:)=randperm(size(candidates4k,1),2*k);
    end
    % the MATLAB function unique is used to ensure that each row of the
    % array indexes is unique
    % that way no to sets of cells are the same
    indexes=unique(indexes,'rows');
    % the MATLAB function unique is used to ensure that each row of the 
    % array indexes is unique
    while size(indexes,1)<m
        permutation=randperm(size(candidates4k,1),2*k);
        indexes=[indexes; permutation];
        indexes=unique(indexes,'rows');
    end
    %% The query probabilities of the m sets of cells are normalised
    % the array qprobabilities holds the query probabilitlies of all m   
    % sets of 2k+1 cells
    qprobabilities=NaN(m,2*k+1);
    for i=1:m
        for j=1:2*k
            qprobabilities(i,j)=candidates4k(indexes(i,j),4);
        end
    end
    % the query probability of the user is added at the end of each row of
    % the array qprobabilities
    for i=1:m
            qprobabilities(i,2*k+1)=userProbability;
    end
    % the query probabilities of each set of cells are normalised
    for i=1:m
        total=sum(qprobabilities(i,:));
        for j=1:2*k+1
            qprobabilities(i,j)=qprobabilities(i,j)/total;
        end
    end
    %% The entropy of the m sets of cells are calculated
    % the sum of the first 2k+1 columns of each row of the array entropies
    % gives the entropy of each set of cells
    entropies=NaN(m,2*k+2);
    for i=1:m
        for j=1:2*k+1
            entropies(i,j)=qprobabilities(i,j)*log2(qprobabilities(i,j));
        end
    end
    % the value of the entropy metric corresponding to each set of cells is
    % then calculated
    for i=1:m
            entropies(i,2*k+2)=-sum(entropies(i,1:2*k+1));
    end
    %% The set with the greatest entropy is chosen
    % the 2k candidate dummy locations are stored within the array 
    % candidates2k
    candidates2k=NaN(2*k,4);
    % the value of the maximum entropy is found using the MATLAB function
    % max
    [M,~]=max(entropies(:,2*k+2));
    % the row vector maxindexes holds the indexes of the sets of cells with
    % the greatest entropy
    maxindexes=[];
    for i=1:m
        if entropies(i,2*k+2)==M
            maxindexes=[maxindexes, i];
        end
    end
    % if there is more than one set of cells that has the greatest entropy,
    % a set is chosen at random from this group
    if size(maxindexes,2)==1
        setindexes=indexes(maxindexes(1,1),:);
        for i=1:2*k
            candidates2k(i,:)=candidates4k(setindexes(1,i),:);
        end
    else
        anindex=randi([1 size(maxindexes,2)],1,1);
        setindexes=indexes(maxindexes(1,anindex),:);
        for i=1:2*k
            candidates2k(i,:)=candidates4k(setindexes(1,i),:);
        end
    end
    %% The first dummy location is chosen
    % in the first round the weight of each candidate is proportional to
    % the distance from the cell of the user
    % the weight of each candidate is stored within the array weights
    weights=NaN(2*k,5);
    % the sum of the distances of each of the 2k candidate locations from
    % the user is found
    totalDistance=0;
    for i=1:size(candidates2k,1)
        X=[userpos(1,1), userpos(1,2); candidates2k(i,1), candidates2k(i,2)];
        totalDistance=totalDistance+pdist(X,'euclidean');
    end
    % the weight of each candidate is found using the total sum of each of
    % the 2k candidates from the user
    for i=1:size(candidates2k,1)
        X=[userpos(1,1), userpos(1,2); candidates2k(i,1), candidates2k(i,2)];
        weight=pdist(X,'euclidean')/totalDistance;
        weights(i,:)=[candidates2k(i,:), weight];
    end
    % the first candidate is chosen with a probability proportional to its
    % weight
    r=rand;
    % the probabilities/weights of each of the 2k candidates are held 
    % within the row vector probs
    probs=NaN(1,2*k);
    for i=1:size(weights,1)
        probs(1,i)=weights(i,5);
    end
    % the index of the chosen candidate dummy location is found
    firstindex=sum(r >= cumsum([0, probs]));
    % the dummy location is chosen
    dummyLocations(1,:)=weights(firstindex,1:4);
    % the candidate is then removed from the array of candidates weights
    weights(firstindex,:)=[];
    %% The remaining k-2 dummy locations are chosen
    % the product of the distances of each candidate from the user 
    % and each of the already selected dummy locations is found and 
    % used to calculate the weight of each candidate
    while size(dummyLocations,1)<k-1
        for i=1:size(weights,1)
            % the distance of each candidate from each of the already 
            % selected dummy locations is found
            distances=[];
            for j=1:size(dummyLocations,1)
                X=[weights(i,1), weights(i,2); dummyLocations(j,1), dummyLocations(j,2)];
                distances=[distances, pdist(X,'euclidean')];
            end
            % the product of the distances of each of the candidate dummmy
            % locations from each of the already seletd dummy locations is
            % found
            product=prod(distances);
            % the distance of each candidate dummy location from the user 
            % is found
            X=[userpos(1,1), userpos(1,2); weights(i,1), weights(i,2)];
            userdist=pdist(X,'euclidean');
            % the product of the distances of each of the candidate dummy
            % locations from each of the already selected dummy locations
            % AND the user is found
            weights(i,5)=product*userdist;
        end
        % the sum of the product of the distances of each of the candidate
        % dummy locations from each of the already selected dummy locations
        % AND the user is found
        total=0;
        for i=1:size(weights,1)
            total=total+weights(i,5);
        end
        % the sum of the product of the distances is then used to calculate
        % the weight of each of the candidate dummy locations
        for i=1:size(weights,1)
            weights(i,5)=weights(i,5)/total;
        end
        % a candidate dummy location is chosen with a probability
        % proportinal to its weight
        r=rand;
        % the probabilities/weights of each of the remaining candidates are
        % held within the row vector probs
        probs=NaN(1,size(weights,1));
        for i=1:size(weights,1)
            probs(1,i)=weights(i,5);
        end
        % the index of the chosen candidate dummy location is found
        index=sum(r >= cumsum([0, probs]));
        % the dummy location is chosen
        dummyLocations=[dummyLocations; weights(index,1:4)];
        % the candidate is then removed from the array of candidates 
        % weights
        weights(index,:)=[];
    end
    %% The location information is returned
    % the position of the user is added to the array of of generated dummy
    % locations
    dummyLocations=[dummyLocations; usercell];
    % the array of locations is then shuffled to ensure that an adversary
    % cannot deduce the genuine location of the user from the location
    % information
    dummyLocations=dummyLocations(randperm(size(dummyLocations,1)),:);
end