function [opt_tour, opt_tour_length] = sa_skeleton(tsp_instance, eval_budget)
% [opt_tour, opt_tour_length] = sa_skeleton(tsp_instance, eval_budget)
%
% Skeleton of a Simulates Annealing algorithm for solving TSP instances
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
% Last modified: February 4, 2011

	% Set true to do online statistics plotting
	doplot = false;

	% Retrieve the city coordinates, distance matrix, and number of cities
	[num_cities, coordinates, distance_matrix] = analyze_tsp(tsp_instance);

	% Initialize static parameters
	pm = 1; % Fixed amount of mutations
	alpha = 0.95; % temperature decrease after each step
	k = 100; % amount of iterations
	
	% Set initial temperature
	T = 3200;

	%cities = [1:num_cities];

	% Statistics data
	evalcount = 0;
	gencount = 0;
	opt_tour_length = Inf;
	opt_tour = NaN(num_cities,1);
	hist_length_best_so_far = NaN(1, eval_budget);
	hist_iteration_tour_length = NaN(1, ceil(eval_budget / k));
	hist_temperature = NaN(1, ceil(eval_budget / k));

	% Generate initial solution and evaluate
	%s = cities(randperm(num_cities)); % random sequence of the cities
	s = randperm(num_cities);%[1:num_cities];
	f = evaluate_tour(distance_matrix, s);

	% Increase counter after each evaluation and update statistics
	evalcount = evalcount + 1;
	hist_length_best_so_far(evalcount) = opt_tour_length;
	if (f < opt_tour_length)
		opt_tour_length = f;
		opt_tour = s;
	end

	while evalcount < eval_budget

		for j = 1:k

			% Increase iteration counter
			gencount = gencount + 1;

			% Generate and evaluate permutation of s
			s_new = perturb(s, num_cities, pm);
			f_new = evaluate_tour(distance_matrix, s_new);

			% Increase counter after each evaluation and update statistics
			evalcount = evalcount + 1;
			hist_length_best_so_far(evalcount) = opt_tour_length;
			if (f < opt_tour_length)
				opt_tour_length = f;
				opt_tour = s;
			end

			% Choose to accept or reject the permutation
			deltaE = f_new - f;
			if (deltaE <= 0 || rand() < exp(- deltaE / T))
				s = s_new;
				f = f_new;
			end

			% Generation best statistics
			iteration_opt_tour = s;
			hist_iteration_tour_length(gencount) = f;
			hist_temperature(gencount) = T;

			if (doplot)
				% Plot statistics
				clf

			subplot(2,3,6)
			plot_tsp_tour(coordinates, s_new)
			title('New tour after mutation')

				subplot(2,3,1)
				plot(hist_length_best_so_far(1:evalcount))
				title('Length of best tour found so far')

				subplot(2,3,4)
				plot_tsp_tour(coordinates, opt_tour)
				title('Best tour found so far')

				subplot(2,3,2)
				plot(hist_iteration_tour_length(1:gencount))
				title('Length of best tour the current generation')

				subplot(2,3,5)
				plot_tsp_tour(coordinates, iteration_opt_tour)
				title('Best tour of the current generation')

				subplot(2,3,3)
				plot(hist_temperature(1:gencount))
				title('Temperature')

				drawnow()

			end

		end

		% Temperature update
		T = alpha * T; % Exponential

	end

end

function s = perturb(s, num_cities, pm)
	for i=1:pm
		a = ceil(rand() * num_cities);
		b = ceil(rand() * num_cities);
		s([a b]) = s([b a]);
	end
end
