% [u_denoised, residuals, (step-size tk) ] = solve_L1_IRLS(u_true, u_noising, lambda)
function [u_denoised, residuals] = solve_L1_IRLS(u_true, u_noise, lambda, tolerance)

[~,n] = size(u_noise); 

u_curr = u_noise;
u_true = u_true;

u_prev = zeros(1,n);

D = zeros(n,n-1);

% difference matrix
for i = 1:n
    for j = 1:n-1
        if j == i
            D(i,j) = 1;
        elseif i == j + 1
            D(i,j) = -1;
        end
    end
end

D = sparse(D);

residual = [];

while norm(u_curr - u_prev, 2) > tolerance
    % 1D difference vector
    disp(size(D))
    disp(size(u_curr))
    
    D_1 = D*u_curr;

    for i = 1:n-1
        abs_var = abs(D_1(i,1));
        D_1(i,1) = 1/abs_var;
    end

    W = diag(transpose(D_1));

    M_solve = ones(n,1) + 2*lambda*transpose(D)*W*D;
    M_solve = sparse(M_solve);

    u_prev = u_curr;
    u_curr = M_solve\u_true;

    disp(u_curr);

    residual = [residual, norm(u_curr - u_prev, 2)];
end

u_denoised = u_curr;
residuals = residual;
disp(residuals)

end





