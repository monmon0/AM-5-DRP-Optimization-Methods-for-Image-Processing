function [u_denoised, residuals] = solve_L1_IRLS_2D(u_true, u_noise, lambda, tolerance)

    u_curr = double(u_noise);
    u_true = double(u_true);

    [n,m,l] = size(u_true);  
    disp(n,n,l)
    u_prev = zeros(n,m,l); % change 1 


    D = zeros(n,m);
    epsilon = 1e-4; 
    % difference matrix
    for i = 1:m
        for j = 1:n
            if j == i
                D(i,j) = 1;
            elseif i == j + 1
                D(i,j) = -1;
            end
        end
    end
    
    D = sparse(D);
    
    residual = [];
    
    while norm(u_curr - u_prev,2) > tolerance
        % 1D difference vector
        
        D_1 = D*u_curr;
    
        for i = 1:n-1
            D_1(i,1) = 1./sqrt((norm(D_1(i,1), 2) + epsilon)); 
        end
    
        W = diag(transpose(D_1)); 
    
    
        M_solve = ones(n,1) + 2*lambda*transpose(D)*W*D; % [ 1 ] + 2 lambda * [-1 1 -1] [0 1 0] [ -1 , 1, -1] 
        M_solve = sparse(M_solve);
     
        % update the current and previous matrix sol
        u_prev = u_curr;
        u_curr = M_solve\u_true;
    
        residual = [residual, norm(u_curr - u_prev,2)];
    end
    
    u_denoised = u_curr;
    residuals = residual;
    
    end
    
    
    
    
    