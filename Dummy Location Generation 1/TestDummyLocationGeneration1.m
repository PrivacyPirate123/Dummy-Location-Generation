%% This function generates k-1 dummy locations within the local map.
function [dummyLocations] = TestDummyLocationGeneration1(userpos,k)
    %% The local map of the user is loaded from the mat file
    load('cells.mat','cells')
    %% The query probabilities of the local map are found
    % the query probabilities of the set cells within the local map of the 
    % user are calculated using the function probabilityCalculator
    [probabilities,userProbability]= ...
        probabilityCalculator(userpos,cells);
    %% The 2k candidate dummy locations are chosen from the local map
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
    if newindex > size(cells,1)-k
        newindex=size(cells,1)-k;
    end
    % the information corresponding to the cell of the user is inserted
    % into the array probabilities at the new index
    probabilities=[probabilities(1:newindex-1,:); usercell; probabilities(newindex:end,:)];
    % the 2k candidate dummy locations are stored within the array
    % candidates
    candidates2k=NaN(2*k,4);
    candidates2k(1:k,:)=probabilities(newindex-k:newindex-1,:);
    candidates2k(k+1:2*k,:)=probabilities(newindex+1:newindex+k,:);
    %% The k sets of cells are generated
    % the 2k candidate dummy locations are arranged into k sets of k cells 
    % each made up of the cell of the user and k-1 candidate dummy 
    % locations
    m=k;
    % each row of the array indexes holds the indexes of the k-1 candidate 
    % dummy locations that make up each set of cells
    indexes=NaN(m,k-1);
    for i=1:m
        % the MATLAB function randperm is used to generate k-1 indexes of
        % the array of 2k candidate dummy locations candidates2k
        indexes(i,:)=randperm(size(candidates2k,1),k-1);
    end
    % the MATLAB function unique is used to ensure that each row of the
    % array indexes is unique
    % that way no to sets of cells are the same
    indexes=unique(indexes,'rows');
    % the MATLAB function unique is used to ensure that each row of the 
    % array indexes is unique
    while size(indexes,1)<m
        permutation=randperm(size(candidates2k,1),k-1);
        indexes=[indexes; permutation];
        indexes=unique(indexes,'rows');
    end
    %% The query probabilities of the k sets of cells are normalised
    % the array qprobabilities holds the query probabilitlies of all k   
    % sets of k cells
    qprobabilities=NaN(m,k);
    for i=1:m
        for j=1:k-1
            qprobabilities(i,j)=candidates2k(indexes(i,j),4);
        end
    end
    % the query probability of the user is added at the end of each row of
    % the array qprobabilities
    for i=1:m
            qprobabilities(i,k)=userProbability;
    end
    % the query probabilities of each set of cells are normalised
    for i=1:m
        total=sum(qprobabilities(i,:));
        for j=1:k
            qprobabilities(i,j)=qprobabilities(i,j)/total;
        end
    end
    %% The entropy of the k sets of cells are calculated
    % the sum of the first k columns of each row of the array entropies
    % gives the entropy of each set of cells
    entropies=NaN(m,k+1);
    for i=1:m
        for j=1:k
            entropies(i,j)=qprobabilities(i,j)*log2(qprobabilities(i,j));
        end
    end
    % the value of the entropy metric corresponding to each set of cells is
    % then calculated
    for i=1:m
            entropies(i,k+1)=-sum(entropies(i,1:k));
    end
    %% The set with the greatest entropy is chosen
    % the location information is stored within the array dummyLocations
    dummyLocations=NaN(k-1,4);
    % the value of the maximum entropy is found using the MATLAB function
    % max
    [M,~]=max(entropies(:,k+1));
    % the row vector maxindexes holds the indexes of the sets of cells with
    % the greatest entropy
    maxindexes=[];
    for i=1:m
        if entropies(i,k+1)==M
            maxindexes=[maxindexes, i];
        end
    end
    % if there is more than one set of cells that has the greatest entropy,
    % a set is chosen at random from this group
    if size(maxindexes,2)==1
        setindexes=indexes(maxindexes(1,1),:);
        for i=1:k-1
            dummyLocations(i,:)=candidates2k(setindexes(1,i),:);
        end
    else
        anindex=randi([1 size(maxindexes,2)],1,1);
        setindexes=indexes(maxindexes(1,anindex),:);
        for i=1:k-1
            dummyLocations(i,:)=candidates2k(setindexes(1,i),:);
        end
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