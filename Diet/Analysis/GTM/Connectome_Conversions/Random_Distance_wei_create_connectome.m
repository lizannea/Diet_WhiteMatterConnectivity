% Define directory to save weighted distance matrices
wdDir = '/Users/lizanne/Arla/DH/Random_distance_wei_connectome';

% Get list of variables in workspace
varList = who;

% Loop through variables in workspace and create weighted distance matrices
for i = 1:length(varList)
    % Check if variable starts with 'sub_*'
    if startsWith(varList{i}, 'R_')
        % Load connectivity matrix
        W = eval(varList{i});
        % Calculate distance matrix
        D = distance_wei(W);
        % Extract subject ID from variable name
        subID = extractAfter(varList{i}, 'R_');
        % Save weighted distance matrix
        save(fullfile(wdDir, strcat('D_', subID)), 'D');
    end
end