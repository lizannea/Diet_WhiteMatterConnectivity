% Define directory to save results
resultsDir = '/Users/lizanne/Connectome/Arla/ARLA/results';

% Initialize empty table for results
resultsTable = table();

% Get list of variables in the workspace
varList = who;

% Loop through variables in the workspace and check for subjects starting with "sub_"
for i = 1:length(varList)
    % Check if variable starts with 'sub_'
    if startsWith(varList{i}, 'sub_')
        % Extract subject ID from variable name
        subID = extractAfter(varList{i}, 'sub_');
        
        % Run your executable script or function to get the output
        % Replace 'chy_GetNetworkSmallWorldness' with the actual function name
        [small_worldness, gamma, lambda] = chy_GetNetworkSmallWorldness(eval(varList{i}), 'zhang');
        
        % Add the results to the table
        resultsTable(end+1,:) = {subID, small_worldness, gamma, lambda};
    end
end

% Set column names
resultsTable.Properties.VariableNames = {'subID', 'small_worldness', 'gamma', 'lambda'};

% Set row names to subject IDs without underscores
resultsTable.Properties.RowNames = strrep(resultsTable.subID, '_', '');

% Remove SubjectID column
resultsTable.subID = [];

% Save results table as a CSV file in the specified directory
writetable(resultsTable, fullfile(resultsDir, 'SmallW_Zhang_results_mast.csv'), 'WriteRowNames', true);