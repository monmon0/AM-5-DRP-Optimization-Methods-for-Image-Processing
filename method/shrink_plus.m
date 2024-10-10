function s = shrink_plus(z, ratio )
%"Positive Shrink" operator
s = zeros(size(z));
s = (z - ratio).*(z > ratio) + z.*(z < 0); 
end