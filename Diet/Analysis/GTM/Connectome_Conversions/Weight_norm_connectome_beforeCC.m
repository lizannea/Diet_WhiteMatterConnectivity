% Define directory to save weighted normalized matrices
wnDir = '/Users/lizanne/Connectome/Arla/ARLA/weighted_normalized_connectome';

% Get list of variables in workspace
varList = who;

% Loop through variables in workspace and create weighted normalized matrices
for i = 1:length(varList)
    % Check if variable starts with 'sub_*'
    if startsWith(varList{i}, 'sub_')
        % Load connectivity matrix
        W = eval(varList{i});
        % Create weighted normalized matrix
        W_nrm = weight_conversion(W, 'normalize');
        % Extract subject ID from variable name
        subID = extractAfter(varList{i}, 'sub_');
        % Save weighted normalized matrix
        save(fullfile(wnDir, strcat('W_nrm_', subID)), 'W_nrm');
    end
end
