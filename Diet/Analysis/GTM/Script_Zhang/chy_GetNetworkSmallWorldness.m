function [ small_worldness, gamma, lambda ] = chy_GetNetworkSmallWorldness( cm, mode )
%chy_GetNetworkSmallWorldness Method to measure small-worldness
%   cm    : input connectivity matrix
%   *note : require Brain Connectivity Toolbox

%% Creating a random matrix based on input connectivity matrix
iteration = 50;
cm_random = randmio_und( cm, iteration );

%% Computing clustering coefficients & charateristic path length
if strcmp( mode, 'onnela' )
    C_cm = mean( clustering_coef_wu( weight_conversion( cm, 'normalize' ) ) );
    C_random = mean( clustering_coef_wu( weight_conversion( cm_random, 'normalize' ) ) );
elseif strcmp( mode, 'zhang' )
    C_cm = mean( chy_GetZhangClusteringCoefficient( cm ) );
    C_random = mean( chy_GetZhangClusteringCoefficient( cm_random ) );
else
    error( 'Unknown method for clustering coefficient' );
end
L_cm = mean( chy_GetShortestPathLength( distance_wei( weight_conversion( cm, 'lengths' ) ) ) );
L_random = mean( chy_GetShortestPathLength( distance_wei( weight_conversion( cm_random, 'lengths' ) ) ) );

%% Computing small-worldness
gamma = C_cm / C_random;
lambda = L_cm / L_random;
small_worldness = gamma / lambda;

end
