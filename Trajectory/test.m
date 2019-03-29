format long
position0Data20=load('D:\Data\0data20.mat','positionData');
position0Data20=[position0Data20.positionData];
for i=2:size(positionData,1)
    if positionData(i,4)==positionData(i-1,4)
        timeDiff=positionData(i,3)-positionData(i-1,3);
        
    end
end