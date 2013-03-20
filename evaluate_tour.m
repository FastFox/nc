function [tour_length] = evaluate_tour(distance_matrix, tour)
% [tour_length] = evaluate_tour(distance_matrix, tour)
%
% Given a TSP distance matrix and candidate tour, this function computes the tour length 
%
% Input:
% - distance_matrix   - a TSP distance matrix 
% - tour              - a candidate tour
%
% Output:
% - tour_length       - the calculated length of the tour
%
% Author: Johannes Kruisselbrink, Edgar Reehuis
% Last modified: January 30, 2012

	% Check that tour is permutation of all cities
	num_cities = length(distance_matrix);
	if (length(tour) ~= num_cities || sum(sort(tour) - [1:num_cities]) ~= 0)
		error('Supplied tour does not visit all cities or contains double visits!');
	end

	% Calculate length of tour using the distance matrix
	tour_length = 0;
	for i=1:num_cities
		tour_length = tour_length + distance_matrix(tour(i), tour(mod(i, num_cities) + 1));
	end

	% Update run statistics
	statistics(tour_length);

end
