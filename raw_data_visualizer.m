% visualize aligned data without anomaly detection

clear, close all, clc

numDatasets = 6;
numRows = zeros(1,numDatasets);

start = 14425; % index of start date
[numRows(1), data1] = ...
    data_reader('data/stbernard/cleaned-stbernard-meteo-11.txt', start);

start = 14401; % index of start date
[numRows(2), data2] = ...
    data_reader('data/stbernard/cleaned-stbernard-meteo-12.txt', start);

start = 10193; % index of start date
[numRows(3), data3] = ...
    data_reader('data/stbernard/cleaned-stbernard-meteo-17.txt', start);

start = 15390; % index of start date
[numRows(4), data4] = ...
    data_reader('data/stbernard/cleaned-stbernard-meteo-18.txt', start);

start = 15386; % index of start date
[numRows(5), data5] = ...
    data_reader('data/stbernard/cleaned-stbernard-meteo-19.txt', start);

start = 14400; % index of start date
[numRows(6), data6] = ...
    data_reader('data/stbernard/cleaned-stbernard-meteo-20.txt', start);


%% Visualize

dataSize = max(numRows);
figure
hFig = figure(1);
set(hFig, 'Position', [100 500 1400 1000])

ha = tight_subplot(6,1,[.01 .03],[.1 .01],[.02 .01]);
% for ii = 1:6; axes(ha(ii)); plot(randn(10,ii)); end
% set(ha(1:4),'XTickLabel',''); set(ha,'YTickLabel','')

% subplot(6,1,1)
axes(ha(1))
plot(data1(1:numRows(1)),'b-', 'LineWidth', 2)
set(gca,'xtick', 1:6*24:dataSize, 'XTickLabel', [], 'FontSize',12)
ylim([-16 16]), grid on, legend('Node 11')
% 
% subplot(6,1,2)
axes(ha(2))
plot(data2(1:numRows(2)),'b-', 'LineWidth', 2)
set(gca,'xtick',1:6*24:dataSize, 'XTickLabel', [], 'FontSize',12)
ylim([-16 16]),  grid on, legend('Node 12')
% 
% subplot(6,1,3)
axes(ha(3))
plot(data3(1:numRows(3)),'b-', 'LineWidth', 2)
set(gca,'xtick',1:6*24:dataSize, 'XTickLabel', [], 'FontSize',12)
ylim([-16 16]), grid on, legend('Node 17')
% 
% subplot(6,1,4)
axes(ha(4))
plot(data4(1:numRows(4)),'b-', 'LineWidth', 2)
set(gca,'xtick',1:6*24:dataSize, 'XTickLabel', [], 'FontSize',12)
ylim([-16 16]), grid on, legend('Node 18')
% 
% subplot(6,1,5)
axes(ha(5))
plot(data5(1:numRows(5)),'b-', 'LineWidth', 2)
set(gca,'xtick',1:6*24:dataSize, 'XTickLabel', [], 'FontSize',12)
ylim([-16 16]), grid on, legend('Node 19')
% 
% subplot(6,1,6)
axes(ha(6))
plot(data6(1:numRows(6)),'b-', 'LineWidth', 2)
set(gca,'xtick',1:6*24:dataSize, ...
    'XTickLabel', 21:20+(dataSize+(6*24))/(6*24), 'FontSize',12)
ylim([-16 16]), grid on, legend('Node 20')
xlabel('Day from start of deployment')

