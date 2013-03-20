function [num_cities, coordinates, distance_matrix] = analyze_tsp(tsp_instance)
% [num_cities, coordinates, distance_matrix] = analyze_tsp(tsp_instance)
%
% Computes for a TSP instance, the number of cities, the city coordinates,
% and distance matrix (using Euclidean distance)
%
% Input:
% - tsp_instance  - string containing the TSP instance name
%
% Output:
% - num_cities        - number of cities in the TSP instance
% - coordinates       - matrix of city coordinates, row format: x-coordinate
%                       y-coordinate
% - distance_matrix   - symmetrical matrix of distances between cities,
%                       e.g., distance_mat(1,2) = distance_mat(2,1)
%
% Author: Johannes Kruisselbrink, Edgar Reehuis
% Last modified: February 3, 2011

	coordinates = feval(str2func(tsp_instance));
	coordinates = [coordinates(:,3) coordinates(:,2)];
	num_cities = length(coordinates);

	% Compute distance matrix
	distance_matrix = NaN(num_cities, num_cities);
	for i=1:num_cities
		distance_matrix(i,:) = sqrt(sum((coordinates(i * ones(num_cities,1),:) - coordinates).^2, 2));
	end

end
