function [u_denoised, u_true] = solveL2_1Dsignal(u, u_true, lambda)
% function to solve 1D signal problem

% use sparse matrix, i.e R = sparse(R)
[n,~] = size(u); 
% defining the R matrix
D = zeros(n);

for i = 1:n
    for j = 1:n
        if (i == 1 && j == 1) || (i == n && j == n ) || (i == j + 1) || (i == j - 1)
            D(i,j) = 1;
        elseif (i == j)
             D(i,j) = 2;
        end
    end
end

R = sparse(D);

% define matrix 
M_1 = ones(n); % vector of all values 1

M_2 = 2*lambda*R + M_1;
M_2 = sparse(M_2);

u = transpose(u);
u_true = transpose(u_true);
u = M_2\u_true;

u_denoised = u; 

end 