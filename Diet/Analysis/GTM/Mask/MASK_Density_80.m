% Path to save the thresholded connectomes
savePath =  '/Users/lizanne/Connectome/Arla/ARLA/30%_density_connectome';

% Get a list of all connectomes in the workspace that start with "sub_"
connectomeVars = who('sub_*');

% Loop through each connectome variable
for i = 1:numel(connectomeVars)
    % Get the current connectome variable
    connectome = eval(connectomeVars{i});
    
    % Create a thresholded connectome using the mask (replace 'good_mask' if necessary)
    thresholded_connectome = connectome .* mask30;
    
    % Save the thresholded connectome
    fileName = fullfile(savePath, [connectomeVars{i} '_30thresholded.mat']);
    save(fileName, 'thresholded_connectome');
end
