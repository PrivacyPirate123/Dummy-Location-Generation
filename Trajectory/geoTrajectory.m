%% This script reads the data stored within the .plt files for each user.
% the equatorial radius of the earth in meters
R=6357000;
% the parent directory of the user data
parentDirectory='D:\Geolife Trajectories 1.3\Geolife Trajectories 1.3\Data\';
% this array holds the GPS position data of the 182 users
positionData=[];
format long
%% The file is opened
for i=0:181
    % the number of the directory is found
    number=int2str(i);
    % the length of the string is found
    L=strlength(number);
    % the length of the string must be of length three
    if L==1
        zeros='00';
        number=strcat(zeros,number);
    elseif L==2
        zeros='0';
        number=strcat(zeros,number);
    else
    end
    number=strcat(number,'\');
    % the file path up to the directory of the user
    directory=strcat(parentDirectory,number);
    % the file path up to the Trajectory directory within the directory of
    % each user
    directory=strcat(directory,'Trajectory\');
    pltString=strcat(directory,'*.plt');
    % the names of the .plt files within the directory is found
    names=dir(pltString);
    % the names of the .plt files within each folder are stored within the
    % cell array names
    names={names.name};
    for j=1:size(names,2)
        name=names{j};
        s=strcat(directory,name);
        % the file is opened
        fid=fopen(s,'r');
        % if the file is not opened an error message is displayed
        if fid == -1
            disp('The file could not be opened.')
            fclose(fid);
        else
            % the first six lines are read
            for k=1:6
                tline=fgets(fid);
            end
            % the line is updated to the seventh line
            tline=fgets(fid);
            % the data from each time-stamp (including the first time-stamp) 
            % is read
            while ischar(tline)
                % the data is stored within the cell line
                line=textscan(tline,'%f%f%c%d%f%s%s','Delimiter',',');
                % the latitude
                lat=line{1,1};
                % the longitude
                lon=line{1,2};
                if (39.95 <= lat) && (lat <= 40) && (116.3 <= lon) && (lon <= 116.35)
                    % the number of days (with fractional part) that have
                    % passed since 12/30/1899
                    time=line{1,5};
                    % the position data is stored wihtin the array positionData
                    positionData=[positionData;lat,lon,time,i];
                end
                % the line of the file is updated
                tline=fgets(fid);
            end
            fclose(fid);
        end
    end
end