% Define directory to save results
resultsDir = '/Users/lizanne/Connectome/Arla/ARLA/results';

% Initialize empty table for results
resultsTable = table();

% Get list of variables in workspace
varList = who;

% Loop through variables in workspace and calculate local efficiency
for i = 1:length(varList)
    % Check if variable starts with 'sub_*'
    if startsWith(varList{i}, 'sub_')
        % Calculate local efficiency
        Eloc = efficiency_wei(eval(varList{i}), 2);
        
        % Extract subject ID from variable name
        subID = extractAfter(varList{i}, 'sub_');
        
        % Add results to table
        resultsTable(end+1,:) = {subID, Eloc};
    end
end

% Set column names
resultsTable.Properties.VariableNames = {'subID', 'Eloc'};

% Set row names to subject IDs without underscores
resultsTable.Properties.RowNames = strrep(resultsTable.subID, '_', '');

% Remove subID column
resultsTable.subID = [];

% Save results table as a CSV file in the specified directory
writetable(resultsTable, fullfile(resultsDir, 'local_efficiency_results_mast.csv'), 'WriteRowNames', true);