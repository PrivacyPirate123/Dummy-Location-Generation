%% The mean areas of the RDG algorithm are found
% the area data is loaded from the mat file
load('RDGTest.mat','allareas')
meanareasRDG=NaN(1,18);
for i=1:18
    total=0;
    for j=1:200
        total=total+allareas(i,j);
    end
    mean=total/200;
    meanareasRDG(1,i)=mean;
end
%% The mean areas of the DLG1 algorithm are found
% the area data is loaded from the mat file
load('DLG1Test.mat','allareas')
meanareasDLG1=NaN(1,18);
for i=1:18
    total=0;
    for j=1:50
        total=total+allareas(i,j);
    end
    mean=total/50;
    meanareasDLG1(1,i)=mean;
end
%% The mean areas of the DLG2 algorithm are found
% the area data is loaded from the mat file
load('DLG2Test.mat','allareas')
meanareasDLG2=NaN(1,18);
for i=1:18
    total=0;
    for j=1:50
        total=total+allareas(i,j);
    end
    mean=total/50;
    meanareasDLG2(1,i)=mean;
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
ylabel('$\it Privacy$ $\it area$ $(km^{2})$','Interpreter','latex')
% the x axis limit
xlim([3 20])
hold on
% the RDG areas are plotted
plot(k,meanareasRDG,'--m*','LineWidth',2)
% the DLG1 areas are plotted
plot(k,meanareasDLG1,'--rs','LineWidth',2)
% the DLG2 areas are plotted
plot(k,meanareasDLG2,'--b^','LineWidth',2)
hold off
legend({'The mean $RDG$ $\it privacy$ $\it area$ values','The mean $DLG$ 1 $\it privacy$ $\it area$ values','The mean $DLG$ 2 $\it privacy$ $\it area$ values'},'Interpreter','latex')