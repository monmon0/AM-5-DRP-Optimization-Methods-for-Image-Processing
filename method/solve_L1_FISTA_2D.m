function [u_denoised, residuals] = solve_L1_FISTA_2D(u_true, u_noise, lambda, tolerance)
    % Convert inputs to double precision if they aren't already
    u_true = double(u_true);
    u_noise = double(u_noise);

    L = 1.0;  
    u_k = u_noise;  
    u_prev = u_noise;  
    v = u_k;  
    t_k = 1;  
    residuals = [];  
    residual = tolerance + 1;  
    
    while residual > tolerance
        grad_g_v = v - u_true;  % Gradient in 2D
        
        t_k_new = (1 + sqrt(1 + 4*t_k^2)) / 2;
        
        % Update with soft-thresholding
        beta = v - (1/L) * grad_g_v;  
        u_k = soft_threshold(beta, lambda / L);  
        
        residual = norm(u_k(:) - u_prev(:));  % Flatten to compare in 2D
        residuals = [residuals, residual];
        
        % Update accelerated variable and step size
        v = u_k + ((t_k - 1) / t_k_new) * (u_k - u_prev);
        t_k = t_k_new;
        
        u_prev = u_k;
    end

    u_denoised = u_k;
end

function result = soft_threshold(beta, thresh)
    result = sign(beta) .* max(abs(beta) - thresh, 0);  % Element-wise operation for 2D
end
