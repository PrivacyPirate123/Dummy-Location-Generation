%% The mean entropies of the RDG algorithm are found
% the entropy data is loaded from the mat file
load('RDGTest.mat','allentropies')
meanEntropiesRDG=NaN(1,18);
for i=1:18
    total=0;
    for j=1:200
        total=total+allentropies(i,j);
    end
    mean=total/200;
    meanEntropiesRDG(1,i)=mean;
end
%% The mean entropies of the DLG1 algorithm are found
% the entropy data is loaded from the mat file
load('DLG1Test.mat','allentropies')
meanEntropiesDLG1=NaN(1,18);
for i=1:18
    total=0;
    for j=1:50
        total=total+allentropies(i,j);
    end
    mean=total/50;
    meanEntropiesDLG1(1,i)=mean;
end
%% The mean entropies of the DLG2 algorithm are found
% the entropy data is loaded from the mat file
load('DLG2Test.mat','allentropies')
meanEntropiesDLG2=NaN(1,18);
for i=1:18
    total=0;
    for j=1:50
        total=total+allentropies(i,j);
    end
    mean=total/50;
    meanEntropiesDLG2(1,i)=mean;
end
%% The maximum entropies are found
% maxentropies holds the values of the maximum entropies for each value of
% the k-anonymity metric
maxentropies=NaN(1,18);
for k=3:20
    maxentropy=log2(k);
    maxentropies(1,k-2)=maxentropy;
end
%% The results are plotted
k=3:20;
clf
grid on
grid minor
ax = gca;
set(gca,'fontsize',24);
% the x axis label
xlabel('$\it k$','Interpreter','latex')
% the y axis label
ylabel('$\it Entropy$','Interpreter','latex')
% the x axis limit
xlim([3 20])
hold on
% the RDG entropies are plotted
plot(k,meanEntropiesRDG,'--m*','LineWidth',2)
% the DLG1 entropies are plotted
plot(k,meanEntropiesDLG1,'--rs','LineWidth',2)
% the DLG2 entropies are plotted
plot(k,meanEntropiesDLG2,'--b^','LineWidth',2)
% the maximum entropies are plotted
plot(k,maxentropies,'--go','LineWidth',2)
hold off
legend({'The mean $RDG$ $\it entropy$ values','The mean $DLG$ 1 $\it entropy$ values','The mean $DLG$ 2 $\it entropy$ values','The maximum possible $\it entropy$ values'},'Interpreter','latex')