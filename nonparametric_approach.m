function nonparametric_approach
% implementation and visualization of the nonparametric approach.
% produces two separate visualizations for the temporal-only and spatio-temporal approach

    clear, close all, clc
    
    figure
    hFig = figure(1);
    set(hFig, 'Position', [100 500 1400 1000])
    ha = tight_subplot(6,1,[.01 .03],[.1 .01],[.02 .01]);
    
    % Read data
    start = 14425; % index of start date
    [numRows1, dataAvg1] = ...
        data_reader('data/stbernard/cleaned-stbernard-meteo-11.txt', start);     
    
    start = 14401; % index of start date
    [numRows2, dataAvg2] = ...
        data_reader('data/stbernard/cleaned-stbernard-meteo-12.txt', start);     
    
    start = 10193; % index of start date
    [numRows3, dataAvg3] = ...
        data_reader('data/stbernard/cleaned-stbernard-meteo-17.txt', start);     
    
    start = 15390; % index of start date
    [numRows4, dataAvg4] = ...
        data_reader('data/stbernard/cleaned-stbernard-meteo-18.txt', start);     
    
    start = 15386; % index of start date
    [numRows5, dataAvg5] = ...
        data_reader('data/stbernard/cleaned-stbernard-meteo-19.txt', start);      
    
    start = 14400; % index of start date
    [numRows6, dataAvg6] = ...
        data_reader('data/stbernard/cleaned-stbernard-meteo-20.txt', start);     
    
    % anomaly detection and imputation (temporal-only)
    axes(ha(1))
    [anomalies1, imputations1] = app_logic(dataAvg1, numRows1, 'Node 11', 0);  
    axes(ha(2))
    [anomalies2, imputations2] = app_logic(dataAvg2, numRows2, 'Node 12', 0); 
    axes(ha(3))
    [anomalies3, imputations3] = app_logic(dataAvg3, numRows3, 'Node 17', 0);
    axes(ha(4))
    [anomalies4, imputations4] = app_logic(dataAvg4, numRows4, 'Node 18', 0); 
    axes(ha(5))
    [anomalies5, imputations5] = app_logic(dataAvg5, numRows5, 'Node 19', 0); 
    axes(ha(6))
    [anomalies6, imputations6] = app_logic(dataAvg6, numRows6, 'Node 20', 0);
    pause(1)
    
    
    % Spatial correction for Node11 and Node17 (Spatio-temporal approach)
    figure
    hFig = figure(2);
    set(hFig, 'Position', [100 500 1400 1000])
    ha = tight_subplot(6,1,[.01 .03],[.1 .01],[.02 .01]);
    
    axes(ha(1))
    numNewImputations = ...
        min([length(imputations1) length(imputations2) ...
        length(imputations3) length(imputations4) length(imputations5) ...
        length(imputations6)]);
    
    newImputations1 = zeros(1, numNewImputations);
    for i=1:numNewImputations
        if(anomalies1(i) == 1)
            newImputations1(i) = ...
                median([imputations2(i) imputations3(i) imputations4(i) ...
                imputations5(i) imputations6(i)]);
        else
            newImputations1(i) = imputations1(i); 
        end
    end
    diffSize = length(imputations1)-numNewImputations;
    for i=1:diffSize, newImputations1=[newImputations1 NaN]; end
    app_logic(dataAvg1, numRows1, 'Node 11', newImputations1);  
    
    axes(ha(2))
    [anomalies2, imputations2] = app_logic(dataAvg2, numRows2, 'Node 12', 0);
    
    axes(ha(3))
    newImputations3 = zeros(1, numNewImputations);
    for i=1:numNewImputations
        if(anomalies3(i) == 1)
            newImputations3(i) = ...
                median([imputations1(i) imputations2(i) imputations4(i) ...
                imputations5(i) imputations6(i)]);
        else
            newImputations3(i) = imputations3(i); 
        end
    end
    diffSize = length(imputations3)-numNewImputations;
    for i=1:diffSize, newImputations3=[newImputations3 NaN]; end
    app_logic(dataAvg3, numRows3, 'Node 17', newImputations3);
    
    axes(ha(4))
    [anomalies4, imputations4] = app_logic(dataAvg4, numRows4, 'Node 18', 0); 
    axes(ha(5))
    [anomalies5, imputations5] = app_logic(dataAvg5, numRows5, 'Node 19', 0); 
    axes(ha(6))
    [anomalies6, imputations6] = app_logic(dataAvg6, numRows6, 'Node 20', 0);
    
end


function [anomalies, imputations] = ...
    app_logic(dataAvg, numRows, nodeNo, imputationsPrior)
    % Detect anomaly if variance within a window is high or 
    % mean difference between windows is high

    % user parameters
    window=2;
    varThresh=1; % within window
    meanThresh=4; % between neighbors

    dataSize=numRows-window-1;
    anomalies = zeros(1, dataSize); % holds location of anomalous points
    imputations = zeros(1, dataSize); % holds new imputed values

    % NaN correction
    data = dataAvg;
    for i=1:numRows
        if isnan(dataAvg(i)), data(i) = 1000; end
    end

    currentMean = mean(data(1:window-1));

    for i = 1:window:dataSize
        if var(data(i:i+window-1)) > varThresh || ...
                abs(mean(data(i:i+window-1))-currentMean) > meanThresh
            anomalies(i:i+window-1) = 1;
            % use values from previous window
            imputations(i:i+window-1) = mean(imputations(i-window:i-1)); 
        else % not an anomaly
            imputations(i:i+window-1) = data(i:i+window-1);
        end
        currentMean=mean(imputations(i:i+window-1)); 
    end
    
    if length(imputationsPrior) > 1
        imputations = imputationsPrior;
    end

    % visualize
    anomaly_visualizer(dataSize, dataAvg, anomalies, imputations, nodeNo)
end
