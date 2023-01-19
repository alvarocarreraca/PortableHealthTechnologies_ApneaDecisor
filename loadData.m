% Code created by Alvaro Carrera Cardeli, Federico Medea and Walid Khaled Hussein
% Method 'loadData'
%   Loads and prepares the data from the database 'database_new.csv' to run
%   the machine learning with it.
function [X,y,attributeNames,N,M] = loadData()
    % Get the data from a CSV file
    cdir = fileparts(mfilename('fullpath'));
    file_path = fullfile(cdir,'database_new.csv');
    % Load the data into matlab using readtable.
    SAHDS_table = readtable(file_path);

    % Extract the rows and columns (attributes) corresponding to the dimensions that are not nominal.
    X = table2array(SAHDS_table(:, [2:end-1])); 
    % Extract attribute names.
    attributeNames = SAHDS_table.Properties.VariableNames([2:end-1])';

    % Extract the nominal attribute (type) from the 12th column.
    class = table2cell(SAHDS_table(:,12)); 
    % Get unique values of the attribute (type) -> Apnea, Normal, Snor.
    class_values = unique(class);

    % Replace by numbers [1 2 3] the class labels (type) that match the class names (class_values).
    [~,class_transformation] = ismember(class, class_values);
    % Since we want to assign numerical values to the classes starting from
    % a zero and not a one.(Apnea = 0, Nomral = 1, Snor = 2)
    class_transformation = class_transformation-1;
    % Lastly, we determine the number of attributes M, the number of observations N.
    y = class_transformation;
    [N, M] = size(X);
end

