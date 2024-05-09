% Define directory to save weighted distance matrices
wdDir = '/Users/lizanne/Connectome/Arla/ARLA/Lengths_connectome';

% Get list of variables in workspace
varList = who;

% Loop through variables in workspace and create weighted distance matrices
for i = 1:length(varList)
    % Check if variable starts with 'sub_*'
    if startsWith(varList{i}, 'sub_')
        % Load connectivity matrix
        W = eval(varList{i});
        % Calculate distance matrix
        L = weight_conversion(W, 'lengths');
        % Extract subject ID from variable name
        subID = extractAfter(varList{i}, 'sub_');
        % Save weighted distance matrix
        save(fullfile(wdDir, strcat('L_', subID)), 'L');
    end
end