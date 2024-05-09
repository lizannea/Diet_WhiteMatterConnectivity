% Define directory to save results
resultsDir = '/Users/lizanne/Connectome/Arla/ARLA/results';

% Initialize empty table for results
resultsTable = table();

% Get list of variables in workspace
varList = who;

% Loop through variables in workspace and calculate global efficiency
for i = 1:length(varList)
    % Check if variable starts with 'sub_*'
    if startsWith(varList{i}, 'sub_')
        % Calculate global efficiency
        Eglob = efficiency_wei(eval(varList{i}));
        % Extract subject ID from variable name
        subID = extractAfter(varList{i}, 'sub_');
        % Add results to table
        resultsTable(end+1,:) = {subID, Eglob};
    end
end

% Set column names
resultsTable.Properties.VariableNames = {'SubjectID', 'GlobalEfficiency'};
% Set row names to subject IDs
resultsTable.Properties.RowNames = strrep(resultsTable.SubjectID, '_', '');
% Remove SubjectID column
resultsTable.SubjectID = [];
% Save results table as a CSV file in the specified directory
writetable(resultsTable, fullfile(resultsDir, 'global_efficiency_results_mast.csv'), 'WriteRowNames', true);
