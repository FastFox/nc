function [] = plot_shortest_tour(tsp_instance)
    [num,coor,dist] = analyze_tsp(tsp_instance);
    [tour,length] = nn_shortest_tour_tsp(tsp_instance);
    TotalLength = vpa(length,8)
    %fprintf('Total distance: %d\n', length)
    plot_tsp_tour(coor,tour)
end