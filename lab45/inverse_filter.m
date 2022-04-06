function new_kernel = inverse_filter(kernel)
%INVER Summary of this function goes here
%   Detailed explanation goes here
new_kernel = -kernel;
new_kernel((length(kernel) - 1) / 2 + 1) = new_kernel((length(kernel) - 1) / 2 + 1) + 1;
end
