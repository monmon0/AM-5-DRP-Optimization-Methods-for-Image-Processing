function [u, u_true, noise] = lsdenoising(n, mean, std) 
% input functions: 
% - n: number of signals. 
% mean and std: parameters for Gaussian processes noise. 

%u_true = randn(n,1);


% delete later
n = 1000;  
mean = 0.0; 
std = 0.4; 
% delete later

a = 0.0; 
b = 2*pi; 
x = linspace(a,b,n);
u_true = x.*sin(x); 

noise = mean + std*randn(size(u_true)); 
u = u_true + noise;

end 
