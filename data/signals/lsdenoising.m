function [u, u_true, noise] = lsdenoising(n, mean, std) 
% input functions: 
% - n: number of signals. 
% mean and std: parameters for Gaussian processes noise. 

%u_true = randn(n,1);

a = 0.0; 
b = 2*pi; 
x = linspace(a,b,n);
u_true = x.*sin(x); 

noise = mean + std*randn(size(u_true)); 
u = u_true + noise; % noising signal

% use sparse matrix, i.e R = sparse(R)

% defining the R matrix
D = zeros(999);

for i = 1:999
    for j = 1:999
        if (i == 1 && j == 1) || (i == 1000 && j == 1000) || (i == j + 1) || (i == j - 1)
            D(i,j) = 1;
        elseif (i == j)
             D(i,j) = 2;
        end
    end
end

R = sparse(D);

lambda = 10;

% define matrix 
M_1 = ones(999); % vector of all values 1

M_2 = 2*lambda*R + M_1;
M_2 = sparse(M_2);

u = transpose(u);
u_true = transpose(u_true);
u = M_2\u_true;

end 