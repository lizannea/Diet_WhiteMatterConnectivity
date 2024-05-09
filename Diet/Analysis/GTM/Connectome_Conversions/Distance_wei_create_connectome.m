% Define directory to save weighted distance matrices
wdDir = '/Users/lizanne/Connectome/Arla/ARLA/Distance_connectome';

% Get list of variables in workspace
varList = who;

% Loop through variables in workspace and create weighted distance matrices
for i = 1:length(varList)
    % Check if variable starts with 'sub_*'
    if startsWith(varList{i}, 'L_')
        % Load connectivity matrix
        L = eval(varList{i});
        % Calculate distance matrix
        D = distance_wei(L);
        % Extract subject ID from variable name
        subID = extractAfter(varList{i}, 'L_');
        % Save weighted distance matrix
        save(fullfile(wdDir, strcat('D_', subID)), 'D');
    end
end
