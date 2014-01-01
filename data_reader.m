function [numRows, dataAveraged] = data_reader(dataFile,start)
% read data in proper format

    data = load(dataFile);
    % plot(data(:,7),'b-')

    numRows = length(data);

    % bin and average data (2*5=10 min. intervals)
    dataAveraged = [];
    for i=start:5:numRows-6
       dataAveraged = [dataAveraged mean(data(i:i+4,7))];
    end
    
    numRows = length(dataAveraged);
end