function [] = run_algorithm_comparison()
% [] = run_algorithm_comparison()
%
% Script for comparing TSP optimizers:
% generates convergence plots and TSP solution plots
%
% Naming convention (optimizers then automatically detected):
% 	lastname1_lastname2_sa.m lastname_ga.m lastname_aco.m
%	  lastname_sa() lastname_ga() lastname_aco()	
%
% Author: Johannes Kruisselbrink, Edgar Reehuis

	% Comparison setup
	runs_per_optimizer = 1; 
	eval_budget = 10000;
	problems = {
		%'Djibouti',
		%'Qatar',
		'Uruguay',
	%	'Zimbabwe', ... % optional
	%	'Italy', ...	% optional
	};

	% Initialize statistics  
	statistics([], eval_budget);  

	% Load optimizers
	sa_optimizers = eval('dir(''*sa.m'')');
	sa_optimizers = {sa_optimizers.name};
	ga_optimizers = eval('dir(''*ga.m'')');
	ga_optimizers = {ga_optimizers.name};
	aco_optimizers = eval('dir(''*aco.m'')');
	aco_optimizers = {aco_optimizers.name};
	optimizers = [sa_optimizers ga_optimizers aco_optimizers];
	optimizers = strrep(optimizers, '.m', '');
	optimizer_names = strrep(optimizers, '_', '\_');
	if length(optimizers) == 0
		disp(['No optimizers detected!'])
		return
  	else
		fprintf('%s', [num2str(length(optimizers)), ' optimizers detected: '])
		disp([optimizers])
	end

	% Output settings
	colors = {'b', 'r', 'g', 'm', 'c', 'k', '-.b', '-.r', '-.g', '-.m', '-.c', '-.k'};
	tab = '    ';
 	resolution = 400;
	filetype = '.png';
	results_dir = ['Results/'];
	if (exist(results_dir) == 0) mkdir(results_dir); end

	% For each problem run all optimizers, generate convergence plot, and plot best tour found per optimizer
	for i = 1:length(problems)
		disp(['Test problem ' num2str(i), '/', num2str(length(problems)), ' (',  cell2mat(problems(i)), ')'])
		hist_x_opt = [];
		for j = 1:length(optimizers)
			disp([tab, 'Optimizer ', num2str(j), '/', num2str(length(optimizers)), ' (', optimizers{j}, ') on (',  cell2mat(problems(i)), '):'])
			optimizer = str2func(optimizers{j});
			for k = 1:runs_per_optimizer
				run_file = [results_dir, cell2mat(problems(i)), '_', cell2mat(optimizers(j)), '_', num2str(k), '.mat'];
				if (exist(run_file,'file'))
					fprintf('%s', [tab, tab, 'Loading file ''', run_file, ''': '])
					load(run_file);
				else
					fprintf('%s', [tab, tab, 'Executing run ', num2str(k), '/', num2str(runs_per_optimizer), ': '])
					tic;
					[stat.xopt, stat.fopt] = optimizer(problems{i}, eval_budget);
					stat.elapsed = toc;
					stat.hist_best_so_far = statistics([], eval_budget);
					save(run_file, 'stat');
				end
				hist_x_opt(j,k,:) = stat.xopt;
				hist_best_so_far(i,j,k,:) = stat.hist_best_so_far(1:eval_budget);
				elapsed(i,j,k) = stat.elapsed;
				fprintf('fopt=%f, elapsed=%f\n', hist_best_so_far(i,j,k,eval_budget), stat.elapsed)
			end
			if runs_per_optimizer > 1
 				fprintf('%smedian: fopt=%f, elapsed=%f\n', [tab, tab], median(hist_best_so_far(i,j,:,eval_budget)), median(elapsed(i,j,:)));
			end
		end

		% ---------------------------------------------------------------------------
		% Convergence plot
		% ---------------------------------------------------------------------------
		fig = figure;
		for j = 1:length(optimizers)
			plot_hist_best_so_far = squeeze(hist_best_so_far(i,j,:,1:eval_budget));
			if runs_per_optimizer > 1
				plot_hist_best_so_far = median(plot_hist_best_so_far);
			end
			plot([1:eval_budget], plot_hist_best_so_far, char(colors(j)),'LineWidth', 1.5)
			hold on
		end
		legend(optimizer_names, 'Location', 'Best');
		grid on
		ylabel('fitness', 'FontWeight', 'Bold', 'FontSize', 10);
		xlabel('evaluations', 'FontWeight', 'Bold', 'FontSize', 10);
		set(gca, 'FontWeight', 'Bold', 'FontSize', 10);
		title([cell2mat(problems(i)), ': convergence'], 'FontWeight', 'Bold', 'fontsize', 12);
		savefile_plot = [results_dir, cell2mat(problems(i)), '_convergence'];
		print(fig, ['-r', num2str(resolution)], '-dpng', [savefile_plot, filetype]);

		% ---------------------------------------------------------------------------
		% Plot the best tour found per optimizer
		% ---------------------------------------------------------------------------
		[num_cities, coordinates, distance_matrix] = analyze_tsp(problems{i});
		for j = 1:length(optimizers)
			fig = figure;
			[best_tour_length, best_tour_index] = min(hist_best_so_far(i,j,:,end));
			plot_tsp_tour(coordinates, hist_x_opt(j,best_tour_index,:));
			set(gca, 'FontWeight', 'Bold', 'FontSize', 10);
			title([cell2mat(optimizer_names(j)), ' : ', cell2mat(problems(i)), ' (', num2str(best_tour_length), ')'], 'FontWeight', 'Bold', 'fontsize', 12);
			savefile_plot = [results_dir, cell2mat(problems(i)), '_', cell2mat(optimizers(j)), '_best_tour_found'];
			print(fig, ['-r', num2str(resolution)], '-dpng', [savefile_plot, filetype]);
		end


		close all

	end

end
