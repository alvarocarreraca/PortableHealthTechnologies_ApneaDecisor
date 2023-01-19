% Code created by Alvaro Carrera Cardeli, Federico Medea and Walid Khaled Hussein
% Main code that controls the machine learning training.
% The model that it is used is K-nearest neighbor and it is been used
% leaveout cross validation to look for the optimum value of K (neighbors). The range
% of K goes from 2 to 10 due to the size of the database.
close all; clear all; clc;

%% Data Loading
[X,y,attributeNames,N,M] = loadData(); % load the data from the database.

%% Prepare Models:
%K-NEAREST NEIGHBOR:
K_near = 2:10; % Number of neighbors
Distance = 'euclidean'; % Distance measure

%% Cross-validation
CV = cvpartition(N, 'Leaveout'); % leaveout
K = CV.NumTestSets;

% Initialize variables for K-NEAREST NEIGHBOR:
T = length(K_near);
prediction = nan(K,T);
y_true = nan(K,1); % Real clasiffication

% Loop to look for the optimal K value:
for k = 1 : K
    fprintf('Crossvalidation fold %d/%d\n', k, CV.NumTestSets);
    
    % Extract training and test set
    X_train = X(CV.training(k), :);
    y_train = y(CV.training(k));
    X_test = X(CV.test(k), :);
    y_test = y(CV.test(k));
    
    y_true(k,1) = y_test(1);
    
    % Standardization:
    mu = mean(X_train);
    sigma = std(X_train);
    X_train_norm = (X_train - mu) ./ sigma;
    X_test_norm = (X_test - mu) ./ sigma;
    
    % --------------- MODEL 1: K-NEAREST NEIGHBOR.--------------------
    for j = 1 : T
        knn=fitcknn(X_train_norm, y_train, 'NumNeighbors', K_near(j), 'Distance', Distance);
        prediction(k,j) = predict(knn, X_test_norm);
    end
end

accuracy = nan(T,1);
% Calculate the accuaracy of all the models (all the K):
for s = 1 : T
    num_succeed = sum(prediction(:,s) == y_true);
    accuracy(s) = num_succeed/length(y_true);
end
[accuaricy_max, ind] = max(accuracy);
% Best model:
Knn_opt = K_near(ind)

