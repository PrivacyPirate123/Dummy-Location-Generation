%% The mean times of the RDG algorithm are found
% the time data is loaded from the mat file
load('RDGTest.mat','alltimes')
meantimesRDG=NaN(1,18);
for i=1:18
    total=0;
    for j=1:200
        total=total+alltimes(i,j);
    end
    mean=total/200;
    meantimesRDG(1,i)=mean;
end
%% The mean times of the DLG1 algorithm are found
% the time data is loaded from the mat file
load('DLG1Test.mat','alltimes')
meantimesDLG1=NaN(1,18);
for i=1:18
    total=0;
    for j=1:50
        total=total+alltimes(i,j);
    end
    mean=total/50;
    meantimesDLG1(1,i)=mean;
end
%% The mean times of the DLG2 algorithm are found
% the time data is loaded from the mat file
load('DLG2Test.mat','alltimes')
meantimesDLG2=NaN(1,18);
for i=1:18
    total=0;
    for j=1:50
        total=total+alltimes(i,j);
    end
    mean=total/50;
    meantimesDLG2(1,i)=mean;
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
ylabel('$\it Computational$ $\it complexity$ (s)','Interpreter','latex')
% the x axis limit
xlim([3 20])
hold on
% the RDG times are plotted
plot(k,meantimesRDG,'--m*','LineWidth',2)
% the DLG1 times are plotted
plot(k,meantimesDLG1,'--rs','LineWidth',2)
% the DLG2 times are plotted
plot(k,meantimesDLG2,'--b^','LineWidth',2)
hold off
legend({'The mean $RDG$ $\it computational$ $\it complexity$ values','The mean $DLG$ 1 $\it computational$ $\it complexity$ values','The mean $DLG$ 2 $\it computational$ $\it complexity$ values'},'Interpreter','latex')