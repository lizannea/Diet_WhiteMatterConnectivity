function values = chy_GetShortestPathLength( distanceMatrix )
%chy_GetShortestPathLength Summary of this function goes here
%   Note : Self-connections are excluded.

nodeCount = size( distanceMatrix, 1 );
lowerPart = nodeCount - 1;
values = zeros( nodeCount, 1 );
for n = 1 : nodeCount
    dm = distanceMatrix;
    dm( :, n ) = [];
    upperPart = sum( dm( n, ( dm( n, : ) ~= Inf ) ) );
    values( n ) = upperPart / lowerPart;
end

end

