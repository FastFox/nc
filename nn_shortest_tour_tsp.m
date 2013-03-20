function [nn_tour, tour_length] = nn_shortest_tour_tsp(tsp_instance)
% [nn_tour, tour_length] = nn_shortest_tour_tsp(tsp_instance)
%
% Applies the nearest neighbor method to compute an efficient
% tour for supplied TSP instance.
%
% Input:
% - tsp_instance   - string containing the TSP instance name
%
% Output:
% - nn_tour        - a vector containing the computed tour
% - tour_length    - the length of the computed tour
%
% Author: Johannes W. Kruisselbrink
% Last modified: January 28, 2011

	% Retrieve the city coordinates, distance matrix, and number of cities
	[num_cities, coordinates, distance_matrix] = analyze_tsp(tsp_instance);

	% Initialize tabu list and tour
	tabu_list = ones(1,num_cities);
	nn_tour = zeros(1,num_cities);

	% Perform nearest neighbor tour finding loop
	current_node = ceil(rand()*num_cities);
	nn_tour(1) = current_node;
	tabu_list(current_node) = inf;
	for j = 2:num_cities
		[nearest, nearest_index] = min(tabu_list .* distance_matrix(current_node, :));
		next_node = nearest_index;
		current_node = next_node;
		nn_tour(j) = current_node;
		tabu_list(current_node) = inf;
	end

	% Compute tour length
	tour_length = evaluate_tour(distance_matrix, nn_tour);

end
