%% This function returns the total time spent in the specified cell.
function [totalTime] = func(iuserData,cell)
    totalTime=0;
    for n=2:size(iuserData,1)
        if (iuserData(n,1) == cell(1,1)) && (iuserData(n,2) == cell(1,2))
            time=iuserData(n,3)-iuserData(n-1,3);
            if time < 0
                disp('Oh no')
            end
            totalTime=totalTime+time;
        end
    end
end