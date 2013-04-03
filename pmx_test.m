function [
	points = ceil(rand(2,1)*num_cities);
				if (points(1) > points(2))
					points = [points(2); points(1)];
				end
				
				c1 = p1(points(1):points(2));
				
				for j = 1:num_cities
					if j < points(1) || j > points(2)
						k = j
						while ismember(p2(k),c1) == 1
							k = find(p1 == p2(k));
						end
						
						c1(j) = p2(k);
					end
				end
