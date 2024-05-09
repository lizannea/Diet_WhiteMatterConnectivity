function Cw = chy_GetZhangClusteringCoefficient( cm )
%chy_GetClusteringCoefficientofZhang Summary of this function goes here
%   Detailed explanation goes here

%% Upper part
upperPart = diag( cm^3 );

%% Lower part
nodeCount = size( cm, 1 );
lowerPart = zeros( nodeCount, 1 );
for nodeIndex = 1 : nodeCount
    for i1 = 1 : nodeCount
        for i2 = 1 : nodeCount
            if ( i1 ~= nodeIndex && i2 ~= nodeIndex && i1 ~= i2 )
                element1 = cm( nodeIndex, i1 );
                element2 = cm( nodeIndex, i2 );
                lowerPart( nodeIndex ) = lowerPart( nodeIndex ) + element1 * element2;
            end
        end
    end
end

%% Node weighted clustering coefficient vector
Cw = upperPart ./ lowerPart;

Cw(isnan(Cw)) = 0; % OC - because 0/0 gives NaN

end
