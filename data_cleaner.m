function newData = data_cleaner(data)
% function to preprocess and align of Sensorscope datasets

    numRows = length(data);
   
    newData = [];
     
    previousTime = datevec( datestr( unixtime_to_datenum( data(1,8) ) ) );
    for i=1:numRows  
        i
        currentTime = datevec( datestr( unixtime_to_datenum( data(i,8) ) ) );
        differenceInSecs = etime(currentTime,previousTime);
        if differenceInSecs < 180 % 2 mins = 120 secs
            newData = [newData; data(i,1:6) data(i,9)];
        else
            howDifferent = floor(differenceInSecs / 120); 
            padData = ones(howDifferent, 7) .* ...
                repmat([1 1 1 1 1 1 NaN],howDifferent,1);
            newData = [newData; padData];
        end
        previousTime = currentTime;
    end
    
    % save 'data_cleaned.txt' newData -ascii
    fid = fopen('data_cleaned.txt','wt');
    fprintf(fid,'%d %d %d %d %d %d %0.4f\n',newData.');
    fclose(fid);
end


function dn = unixtime_to_datenum( unix_time )
    dn = unix_time/86400 + 719529;
end