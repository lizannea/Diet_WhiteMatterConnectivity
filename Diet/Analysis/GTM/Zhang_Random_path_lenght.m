% Define directory to save results
resultsDir = '/Users/lizanne/Connectome/Arla/ARLA/results';

% Initialize empty table for results
resultsTable = table();

% Get list of variables in the workspace
varList = who;

% Loop through variables in the workspace and check for subjects starting with "sub_"
for i = 1:length(varList)
    % Check if variable starts with 'sub_'
    if startsWith(varList{i}, 'D_')
        % Extract subject ID from variable name
        subID = extractAfter(varList{i}, 'D_');
        
        % Run your executable script or function to get the output (clustering coefficient in this case)
        % Replace 'executable_script' with the actual name of your executable MATLAB script or function
        RandomPathLength = chy_GetShortestPathLength(eval(varList{i}));
        
  % Extract subject ID from variable name
        subID = extractAfter(varList{i}, 'D_');
        
        % Add results to table
        resultsTable(end+1,:) = {subID, RandomPathLength};
    end
end

% Set column names
resultsTable.Properties.VariableNames = {'SubjectID', 'RandomPathLength'};

% Set row names to subject IDs
resultsTable.Properties.RowNames = strrep(resultsTable.SubjectID, '_', '');

% Remove SubjectID column
resultsTable.SubjectID = [];

% Save results table as a CSV file in the specified directory
writetable(resultsTable, fullfile(resultsDir, 'Random_PathLength_Zhang_results.csv'), 'WriteRowNames', true);        
