function [u_noising, u_true, noise] = image_read(im, lambda)

mean = lambda(1); 
std = lambda(2); 

u_true = double(imread(im)); 
[row, col, col_bands] = size(u_true); 
noise = mean + std*randn(size(u_true)); 
u_noising = u_true + noise; 


end 