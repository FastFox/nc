function [c1, c2] = pmx(p1, p2)
	points = ceil(rand(2,1)*size(p1,2));
	if (points(1) > points(2))
		points = [points(2); points(1)];
	end

	c1(points(1):points(2)) = p1(points(1):points(2));
		
	for j = 1:size(p1,2)
		if j < points(1) || j > points(2)
			k = j;
			while ismember(p2(k),c1) == 1
				k = find(p1 == p2(k));
			end					
			c1(j) = p2(k);
		end
	end

	c2(points(1):points(2)) = p2(points(1):points(2));

	for j = 1:size(p2,2)
		if j < points(1) || j > points(2)
			k = j;
			while ismember(p1(k),c2) == 1
				k = find(p2 == p1(k));
			end					
			c2(j) = p1(k);
		end
	end
end
