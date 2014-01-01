% Look at non-anomalous portions of data to get a feeling of sensor covariances

clear, close all, clc

numDatasets = 5;
durations = zeros(1,numDatasets);

start = 14425; % index of start date 05.10
stop = 17363; % index of ending date 08.10
durations(1) = stop-start;
[~, data1] = ...
    data_reader('data/stbernard/cleaned-stbernard-meteo-11.txt', start);

start = 14401; % index of start date
stop = 17282; % index of ending date 08.10
durations(2) = stop-start;
[~, data2] = ...
    data_reader('data/stbernard/cleaned-stbernard-meteo-12.txt', start);

start = 15390; % index of start date
stop = 18314; % index of ending date 08.10
durations(3) = stop-start;
[~, data3] = ...
    data_reader('data/stbernard/cleaned-stbernard-meteo-18.txt', start);

start = 15386; % index of start date
stop = 18304; % index of ending date 08.10
durations(4) = stop-start;
[~, data4] = ...
    data_reader('data/stbernard/cleaned-stbernard-meteo-19.txt', start);

start = 14400; % index of start date
stop = 17309; % index of ending date 08.10
durations(5) = stop-start;
[~, data5] = ...
    data_reader('data/stbernard/cleaned-stbernard-meteo-20.txt', start);

duration = min(durations);

for i=1:duration
   if isnan(data1(i)), data1(i) = 0;, end 
   if isnan(data2(i)), data2(i) = 0;, end
   if isnan(data3(i)), data3(i) = 0;, end
   if isnan(data4(i)), data4(i) = 0;, end
   if isnan(data5(i)), data5(i) = 0;, end
end

dataAccum = [data1(1:durations)' data2(1:durations)' ...
    data3(1:durations)' data4(1:durations)' data5(1:durations)'];
S = cov(dataAccum)
R = corr(dataAccum)