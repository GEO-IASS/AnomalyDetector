%%
function probabilistic_approach
% implementation and visualization of the dynamic net approach

    clear, close all, clc
    
    figure
    hFig = figure(1);
    set(hFig, 'Position', [100 500 1500 1000])
    ha = tight_subplot(6,1,[.01 .03],[.1 .01],[.02 .01]);
    
    % -------------------------------------------------
    % Read sensor X11
    start = 14425; % index of start date for test data
    nodeNo = 'Node 11';
    [numRows, dataAvg] = ...
        data_reader('data/stbernard/cleaned-stbernard-meteo-11.txt', 1); 
    
    % train data (find P(X_t|X_{t-1}) parameters)
    trainingData= dataAvg(1:floor(start/5)-1);
    ws=train(trainingData);
    w=ws(2); 
    w_0=ws(1); 
    var_X=0.1;
    
    % test data
    range = floor(start/5):numRows;
    observations = dataAvg(range);
        
    % anomaly detection and imputation (temporal-only)
    axes(ha(1))
    [anomalies, X] = ...
        app_logic(observations, length(range), nodeNo, w, w_0, var_X); 
    
    % -------------------------------------------------
    % Read sensor X12
    start = 14401; % index of start date for test data
    nodeNo = 'Node 12';
    [numRows, dataAvg] = ...
        data_reader('data/stbernard/cleaned-stbernard-meteo-12.txt', 1); 
    
    % train data (find P(X_t|X_{t-1}) parameters)
    trainingData= dataAvg(1:floor(start/5)-1);
    ws=train(trainingData);
    w=ws(2) 
    w_0=ws(1) 
    var_X=0.1;
    
    % test data
    range = floor(start/5):numRows;
    observations = dataAvg(range);
        
    % anomaly detection and imputation (temporal-only)
    axes(ha(2))
    [anomalies, X] = ...
        app_logic(observations, length(range), nodeNo, w, w_0, var_X); 
    
    % -------------------------------------------------
    % Read sensor X17
    start = 10193; % index of start date for test data
    nodeNo = 'Node 17';
    [numRows, dataAvg] = ...
        data_reader('data/stbernard/cleaned-stbernard-meteo-17.txt', 1); 
    
    % train data (find P(X_t|X_{t-1}) parameters)
    trainingData= dataAvg(1:floor(start/5)-1);
    ws=train(trainingData);
    w=ws(2) 
    w_0=ws(1) 
    var_X=0.1;
    
    % test data
    range = floor(start/5):numRows;
    observations = dataAvg(range);
        
    % anomaly detection and imputation (temporal-only)
    axes(ha(3))
    [anomalies, X] = ...
        app_logic(observations, length(range), nodeNo, w, w_0, var_X); 
    
    % -------------------------------------------------
    % Read sensor X18
    start = 15390; % index of start date for test data
    nodeNo = 'Node 18';
    [numRows, dataAvg] = ...
        data_reader('data/stbernard/cleaned-stbernard-meteo-18.txt', 1); 
    
    % train data (find P(X_t|X_{t-1}) parameters)
    trainingData= dataAvg(1:floor(start/5)-1);
    ws=train(trainingData);
    w=ws(2) 
    w_0=ws(1) 
    var_X=0.1;
    
    % test data
    range = floor(start/5):numRows;
    observations = dataAvg(range);
        
    % anomaly detection and imputation (temporal-only)
    axes(ha(4))
    [anomalies, X] = ...
        app_logic(observations, length(range), nodeNo, w, w_0, var_X); 

    % -------------------------------------------------
    % Read sensor X19
    start = 15386; % index of start date for test data
    nodeNo = 'Node 19';
    [numRows, dataAvg] = ...
        data_reader('data/stbernard/cleaned-stbernard-meteo-19.txt', 1); 
    
    % train data (find P(X_t|X_{t-1}) parameters)
    trainingData= dataAvg(1:floor(start/5)-1);
    ws=train(trainingData);
    w=ws(2) 
    w_0=ws(1) 
    var_X=0.1;
    
    % test data
    range = floor(start/5):numRows;
    observations = dataAvg(range);
        
    % anomaly detection and imputation (temporal-only)
    axes(ha(5))
    [anomalies, X] = ...
        app_logic(observations, length(range), nodeNo, w, w_0, var_X);     
    
    % -------------------------------------------------
    % Read sensor X20
    start = 14400; % index of start date for test data
    nodeNo = 'Node 20';
    [numRows, dataAvg] = ...
        data_reader('data/stbernard/cleaned-stbernard-meteo-20.txt', 1); 
    
    % train data (find P(X_t|X_{t-1}) parameters)
    trainingData= dataAvg(1:floor(start/5)-1);
    ws=train(trainingData);
    w=ws(2) 
    w_0=ws(1) 
    var_X=0.1;
    
    % test data
    range = floor(start/5):numRows;
    observations = dataAvg(range);
        
    % anomaly detection and imputation (temporal-only)
    axes(ha(6))
    [anomalies, X] = ...
        app_logic(observations, length(range), nodeNo, w, w_0, var_X);     
    
end

%%
function [anomalies, X] = ...
    app_logic(dataAvg, numRows, nodeNo, w, w_0, var_X)
    
    anomalies = zeros(1, numRows); % holds location of anomalous points
    X = zeros(1, numRows); % holds new imputed values
    S = zeros(1, numRows); % sensor states
    
    % NaN correction
    observations = dataAvg;
    for i=1:numRows
        if isnan(dataAvg(i)), observations(i) = 1000; end
    end
    
    % Sensor settings
    workingVariance = 0.1;
    brokenVariance = 10000;
    brokenMeanScaler = 0.0001;    
    
    % 2-step Queries
    % Step 1 - MAP estimate for sensor state
    % Step 2 - True temperature estimation using Kalman Filter
    
    % P(X_{t_0}) prior belief for the time lag variable
    % assume first observation is true
    X(1) = observations(1);
    Xprev = X(1);
    var_Xprev = 0.5;
    
    for i=2:length(observations)
        
        % P(S|O) \sim P(O|S)P(S) \sim P(O|S,X) (cond. independence)
        P = P_OgivenS(observations(i), Xprev, var_Xprev, var_X, w, w_0, ...
            workingVariance, brokenVariance, brokenMeanScaler);
        [~, MAP_S] = max(P);    
        
        % P(X|O) = P(O|X)P(X)
        if MAP_S==2
            mu_p=Xprev;
            var_p = var_X + var_Xprev;
            mu_l = observations(i); 
            var_l = 0.5; 
            params = kalman_update (mu_p, var_p, mu_l, var_l); 
            X(i) = params(1);
            Xprev = X(i);
            var_Xprev = params(2);
            S(i)=1; % working
        else
            mu_p=Xprev;
            var_p = var_X + var_Xprev;
            mu_l = brokenMeanScaler*(w*Xprev+w_0); 
            var_l = brokenVariance; 
            anomalies(i) = 1;
            params = kalman_update (mu_p, var_p, mu_l, var_l); 
            X(i) = params(1);
            Xprev = X(i);
            var_Xprev = params(2);
        end
    end   
    
    % Visualize
    anomaly_visualizer(numRows, dataAvg, anomalies, X, nodeNo)
    
end

%%
function ws = train(trainingData)
    
    for i=1:length(trainingData)
        if isnan(trainingData(i))
            trainingData(i) = 0;
        end
    end

    regressionData = ones(length(trainingData)-1, 3);
    for i=1:length(trainingData)-1
        regressionData(i,:) = [1 trainingData(i) trainingData(i+1)];
    end
    ws = inv(regressionData(:,1:2)' * regressionData(:,1:2)) ...
        * regressionData(:,1:2)' * regressionData(:,3);  
    % for TESTING
    % figure, scatter(regressionData(:,2),regressionData(:,3))
    % xlabel('O_t'), ylabel('O_{t+1}')
    % cov(regressionData(:,2),regressionData(:,3))
end

%%
function P = ...
    P_OgivenS(O, Xprev, var_Xprev, var_X, w, w_0, ...    
    workingVariance, brokenVariance, brokenMeanScaler) 

    p1 = ...
    normpdf(O, brokenMeanScaler*(w*Xprev+w_0), brokenVariance+var_Xprev+var_X); % sensor broken
    p2 = ...
    normpdf(O, w*Xprev+w_0, workingVariance+var_Xprev+var_X); % sensor working    
     
    P = [p1 p2];
    S = sum(P);
    P = P/S;
end

%%
function params = kalman_update (mu_p, var_p, mu_l, var_l)
    mu_new = ( var_l * mu_p + var_p * mu_l ) / ( var_l + var_p );
    var_new = 1/(1/var_l + 1/var_p);
    params = [mu_new var_new];
end

%%
function params = kalman_predict (mu_1, var_1, mu_2, var_2)
    mu_new = mu_1+mu_2;
    var_new = var_1+var_2;
    params = [mu_new var_new];
end

