function [] = plot_tsp_tour(coordinates, tour)
% [] = plot_tsp_tour(coordinates, tour)
%
% Plots the TSP tour in a map with cities
%
% Input:
% - coordinates       - a city map, which is a matrix of 2D city coordinates
% - tour              - a TSP tour
%
% Author: Johannes W. Kruisselbrink
% Last modified: January 31, 2012
	plot([coordinates(:,1); coordinates(1,1)], [coordinates(:,2); coordinates(1,2)],'kd','MarkerFaceColor','k','MarkerSize',7)
	coord_diffs = (max(coordinates)- min(coordinates));
	plot_width = 500;
	plot_height = plot_width / coord_diffs(1) * coord_diffs(2);
	hold on
	grid on
	plot([coordinates(tour,1); coordinates(tour(1),1)],[coordinates(tour,2); coordinates(tour(1),2)],'r','LineWidth', 1.5);
	hold off
end
