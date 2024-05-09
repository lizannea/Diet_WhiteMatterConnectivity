% Define directory to save weighted normalized matrices
wnDir = '/Users/lizanne/Arla/DH/Random_weighted_normalized_connectome';

% Get list of variables in workspace
varList = who;

% Loop through variables in workspace and create weighted normalized matrices
for i = 1:length(varList)
    % Check if variable starts with 'sub_*'
    if startsWith(varList{i}, 'R_')
        % Load connectivity matrix
        W = eval(varList{i});
        % Create weighted normalized matrix
        Random_W_nrm = weight_conversion(W, 'normalize');
        % Extract subject ID from variable name
        subID = extractAfter(varList{i}, 'R_');
        % Save weighted normalized matrix
        save(fullfile(wnDir, strcat('Random_W_nrm', subID)), 'Random_W_nrm');
    end
end
