% [u_denoised, residuals, (step-size tk) ] = solve_L1_IRLS(u_true, u_noising, lambda)
function [u_denoised, residuals] = solve_L1_IRLS(u_true, u_noise, lambda, tolerance)

[~,n] = size(u_noise); 

u_curr = transpose(u_noise);
u_true = transpose(u_true);

u_prev = zeros(1,n);

D = zeros(n-1,n);
epsilon = 1e-4; 
% difference matrix
for i = 1:n-1
    for j = 1:n
        if j == i
            D(i,j) = 1;
        elseif i == j - 1
            D(i,j) = -1;
        end
    end
end

D = sparse(D);
% disp(full(D)); 
residual = [];

while norm(u_curr - u_prev,2) > tolerance
    % 1D difference vector
    D_1 = D*u_curr;

    for i = 1:n-1
        %D_1(i,1) = 1/abs(D_1(i,1)); % [-1 1 -1] --> [x 1 x ]; 
        D_1(i,1) = 1./sqrt((norm(D_1(i,1), 2) + epsilon)); 
    end

    W = diag(transpose(D_1)); % [ 0 1 0] + const. 


    M_solve = ones(n,1) + 2*lambda*transpose(D)*W*D; % [ 1 ] + 2 lambda * [-1 1 -1] [0 1 0] [ -1 , 1, -1] 
    M_solve = sparse(M_solve);
    % disp(cond(M_solve));  
    u_prev = u_curr;
    u_curr = M_solve\u_true;

    residual = [residual, norm(u_curr - u_prev,2)];
    disp(norm(u_curr - u_prev, 2)); 
end

u_denoised = u_curr;
residuals = residual;
%disp(residuals)

end




