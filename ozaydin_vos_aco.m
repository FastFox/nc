function [opt_tour, opt_tour_length] = aco_skeleton(tsp_instance, eval_budget)
% [opt_tour, opt_tour_length] = aco_skeleton(tsp_instance, eval_budget)
%
% Skeleton of an Ant System algorithm for TSP instances
%
% Input:
% - tsp_instance        - string containing the TSP instance name
% - eval_budget         - the number of function evaluations available
%                         for the optimization algorithm
%
% Output:
% - opt_tour            - a vector containing the best tour found
% - opt_tour_length     - the length of the best tour found
%
% Author: Johannes Kruisselbrink, Edgar Reehuis
% Last modified: June 7, 2012

	% Set true to do online statistics plotting
	doplot = false;

	% Retrieve the city coordinates, distance matrix, and number of cities
	[num_cities, coordinates, distance_matrix] = analyze_tsp(tsp_instance);

	% Initialize static parameters
	m = 50;
	rho = 0.2;
	alpha = 1;
	beta = 4;
    Q = 3;

	% Compute a reference tour using the nearest neighbor method
	[nn_tour, C_nn] = nn_shortest_tour_tsp(tsp_instance);

	% Initialize pheromone matrix to small value
	pheromones = repmat(0.0001,num_cities,num_cities);
    
	% Initialize heuristic desirability matrix
	heuristics = 1 ./ distance_matrix;
    heuristics(logical(eye(size(heuristics)))) = 0;

	% Statistics data
	evalcount = 0;
	gencount = 0;
	opt_tour_length = Inf;
	opt_tour = NaN(num_cities,1);
	hist_length_best_so_far = NaN(1, eval_budget);
	hist_generation_opt_tour_length = NaN(1, ceil(eval_budget / m));

	% Ant System Optimization Loop
	while evalcount < eval_budget

		% Increase generation counter
		gencount = gencount + 1;

		% Reset the ant tours
		tour = zeros(m, num_cities);

		% Construct new tours for the ants
		for k = 1:m
			% Administrate the cities that were already visited
			tabu_list = ones(1, num_cities);

			% Set the startnode of the tour
			curnode = ceil(rand(1,1) * num_cities); %%select random starting city for each ant
			tour(k,1) = curnode;
			tabu_list(curnode) = 0;

			% Construct the path
			for j = 2:num_cities
                % Compute probabilities
                tau = pheromones(curnode,:).^alpha;
                etha = heuristics(curnode,:).^beta;
                step_probabilities = tabu_list .* (tau .* etha)/sum(tau .* etha);

				% Select the next city based on the probabilities
				cumsum_step_probabilities = cumsum(step_probabilities);
				r = rand() * cumsum_step_probabilities(num_cities);
                indices = find(cumsum_step_probabilities > r);
                curnode = indices(1);

				% Add the selected city to the tour and update the tabu list
				tour(k,j) = curnode;
				tabu_list(curnode) = 0;

			end

		end

		% Evaluate: compute tour lengths
		for k = 1:m
			tour_length(k) = evaluate_tour(distance_matrix,tour(k,:));

			% Increase counter after each evaluation and update statistics
			evalcount = evalcount + 1;
			hist_length_best_so_far(evalcount) = opt_tour_length;
			if (tour_length(k) < opt_tour_length)
				opt_tour_length = tour_length(k);
				opt_tour = tour(k,:);
			end
		end

		% Update pheromones
		new_pheromones = zeros(num_cities,num_cities);
        for k = 1:m
            %tour(k,:)
            for i = 1:(num_cities-1)
                new_pheromones(tour(k,i),tour(k,i+1)) = new_pheromones(tour(k,i),tour(k,i+1)) + (Q / tour_length(k));
                new_pheromones(tour(k,i+1),tour(k,i)) = new_pheromones(tour(k,i),tour(k,i+1));
            end
            new_pheromones(tour(k,num_cities),tour(k,1)) = new_pheromones(tour(k,num_cities),tour(k,1)) + (Q / tour_length(k));
            new_pheromones(tour(k,1),tour(k,num_cities)) = new_pheromones(tour(k,num_cities),tour(k,1));
        end
		pheromones = (1 - rho) * pheromones + new_pheromones;

		% Generation best statistics
		[hist_generation_opt_tour_length, generation_opt_tour_index] = min(tour_length);
		generation_opt_tour = tour(generation_opt_tour_index,:);
		hist_generation_opt_tour(gencount) = hist_generation_opt_tour_length;

		if (doplot)
			% Plot statistics
			clf

			subplot(2,3,1)
			plot(hist_length_best_so_far(1:evalcount))
			grid on
			hold on
			title('Length of best tour found so far')
			plot([1:evalcount], C_nn * ones(1,evalcount), '-.r')

			subplot(2,3,4)
			plot_tsp_tour(coordinates, opt_tour)
			title('Best tour found so far')

			subplot(2,3,2)
			plot(hist_generation_opt_tour(1:gencount))
			grid on
			hold on
			title('Length of best tour found so far')
			plot([1:gencount], C_nn * ones(1,gencount), '-.r')

			subplot(2,3,5)
			plot_tsp_tour(coordinates, generation_opt_tour)
			title('Best tour found so far')

			subplot(2,3,3)
			image(256 * ((pheromones - min(min(pheromones))) / (max(max(pheromones)) - min(min(pheromones)))));
			title('Pheromone matrix')

			subplot(2,3,6)
			image(256 * ((heuristics - min(min(heuristics))) / (max(max(heuristics)) - min(min(heuristics)))));
			title('Heuristic desirability matrix')
			drawnow()

        end
    end
    opt_tour_length
end