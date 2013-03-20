function [opt_tour, opt_tour_length] = ga_skeleton(tsp_instance, eval_budget)
% [opt_tour, opt_tour_length] = ga_skeleton(tsp_instance, eval_budget)
%
% Skeleton of a Genetic Algorithm for solving TSP instances
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
	doplot = true;

	% Retrieve the city coordinates, distance matrix, and number of cities
	[num_cities, coordinates, distance_matrix] = analyze_tsp(tsp_instance);

	% Initialize static parameters
	lambda = 5; % amount of individuals
	pc = 1; % amount between 0 and 1, chance to crossover, or just copy the parent
	pm = 1; % ?
	q = 1; % amount of loops in select_tournament

	% Statistics data
	evalcount = 0;
	gencount = 0;
	opt_tour_length = Inf;
	opt_tour = NaN(num_cities,1);


	% Initialize population
	for i = 1:lambda

		% Each individual is a random permutation
		P(i,:) = ceil(rand(1, num_cities) * num_cities);

		% Evaluate the individual
		f(i) = 1;

		% Increase counter after each evaluation and update statistics
		evalcount = evalcount + 1;
		hist_length_best_so_far(evalcount) = opt_tour_length;
		if (f(i) < opt_tour_length)
			opt_tour_length = f(i);
			opt_tour = P(i,:);
		end

	end

	% Evolution loop
	%disp('evalcount')
	%disp(evalcount)
	while evalcount < eval_budget
		% disp('Hi')
		% Increase generation counter
		gencount = gencount + 1;

		% Generate new population Pnew (recombination, mutation)
		
		for i = 1:lambda

			% Select parent
			p1 = select_tournament(P, f, q);
			% disp(p1);
			if (rand() < pc)
				%Pnew(i,:) 
				% Apply crossover
				%...

			else

				% No crossover, copy parent
				%...

			end

			% Apply mutation
			% disp(p1(ceil(rand()*10),:))

			%...
			Pnew(i,:) = p1;

		end

		% Replace old population by new population
		P = Pnew;

		% Evaluate each individual
		for i = 1:lambda

			% Evaluate the tour of each individual
			f(i) = 1;

			% Increase counter after each evaluation and update statistics
			evalcount = evalcount + 1;
			hist_length_best_so_far(evalcount) = opt_tour_length;
			if (f(i) < opt_tour_length)
				opt_tour_length = f(i);
				opt_tour = P(i,:);
			end

		end

		% Generation best statistics
		[hist_generation_opt_tour_length, generation_opt_tour_index] = min(f);
		generation_opt_tour = P(generation_opt_tour_index,:);
		hist_generation_opt_tour(gencount) = hist_generation_opt_tour_length;
			
		if (doplot)
			
			% Plot statistics
			clf

			subplot(2,2,1)
			plot(hist_length_best_so_far(1:evalcount))
			title('Length of best tour found so far')

			subplot(2,2,2)
			plot_tsp_tour(coordinates, opt_tour)
			title('Best tour found so far')

			subplot(2,2,3)
			plot(hist_generation_opt_tour(1:gencount))
			title('Length of best tour the current generation')

			subplot(2,2,4)
			plot_tsp_tour(coordinates, generation_opt_tour)
			title('Best tour of the current generation')

			drawnow()
		end

	end

end

function a = select_tournament(P, f, q)
% a = select_tournament(P, f, q)
%
% Select one individual of population P with fitness
% values f using proportional selection.
%
% Author: Johannes W. Kruisselbrink
% Last modified: October 21, 2009

	mu = length(P(:,1));

	Ptournament = [];
	Ftournament = [];
	for i = 1:q
		p = ceil(rand() * mu);
		Ptournament(i,:) = P(p,:);
		Ftournament(i) = f(p);
	end
	[maxF, maxIndex] = min(Ftournament);
	a = Ptournament(maxIndex,:);

end
