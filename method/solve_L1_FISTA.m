function [u_denoised, residuals] = solve_L1_FISTA(u_true, u_noise, lambda, tolerance)

    L = 1.0; 
    
    u_k = u_noise;  
    u_prev = u_noise;  % u^{k-1}
    v = u_k;  % Acceleration variable v
    t_k = 1;  % Initial step size
    residuals = [];  % To store residuals
    residual = tolerance + 1;  % Initial residual set above tolerance
    
    while residual > tolerance
        grad_g_v = v - u_true;
        
        t_k_new = (1 + sqrt(1 + 4*t_k^2)) / 2;
        
        beta = v - (1/L) * grad_g_v;  
        u_k = soft_threshold(beta, lambda / L);  
        
        residual = norm(u_k - u_prev);
        residuals = [residuals, residual];
        
        v = u_k + ((t_k - 1) / t_k_new) * (u_k - u_prev);
        t_k = t_k_new;
        
        u_prev = u_k;
    end

    u_denoised = u_k;
    %disp(residuals);
    
end

function result = soft_threshold(beta, thresh)
    result = sign(beta) .* max(abs(beta) - thresh, 0);
end
